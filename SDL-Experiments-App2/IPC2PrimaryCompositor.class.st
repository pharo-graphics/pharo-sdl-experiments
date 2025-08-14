Class {
	#name : #IPC2PrimaryCompositor,
	#superclass : #IPC2DualProcessCompositor,
	#instVars : [
		'osSubprocess',
		'listenerSocket',
		'windows',
		'eventQueue',
		'eventSignalSemaphore'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #'window API' }
IPC2PrimaryCompositor >> destroyWindow: id [

	commandService ifNil: [ ^ self ]. "Already destroyed"
	commandService sendCommandIgnoringResult:
		(IPC2DestroyWindowCommand new
			 windowId: id;
			 yourself)
]

{ #category : #'window API' }
IPC2PrimaryCompositor >> enqueueEvent: anEvent windowId: aWindowId [

	self flag: #todo. "Duplicated from SingleProcess"
	self flag: #todo. "do not ignore aWindowId?"
	eventQueue nextPut: anEvent.
	eventSignalSemaphore ifNotNil: [ eventSignalSemaphore signal ]
]

{ #category : #private }
IPC2PrimaryCompositor >> forkOSSubprocessRun: isHeadless [

	[	osSubprocess := OSSUnixSubprocess new.

		osSubprocess command: Smalltalk vm binary fullPath pathString.

		osSubprocess arguments: (Array streamContents: [ :aStream |
			isHeadless ifTrue: [ aStream nextPut: '--headless' ].
			aStream
				nextPut: Smalltalk imageFile fullName;
				nextPut: IPC2CompositorCommandLineHandler commandName;
				nextPut: listenerSocket localPort printString ]).

		osSubprocess runAndWaitOnExitDo: [ :process :outString  | self terminate ]]
			forkAt: Processor lowIOPriority.

]

{ #category : #private }
IPC2PrimaryCompositor >> forkSocketListeningProcessThenSignal: launchDoneSemaphore [

	"Listener socket determines the port to be used by the subprocess."
	listenerSocket := Socket newTCP.
	listenerSocket
		bindToPort: Socket wildcardPort;
		listenWithBacklog: 2.

	[	[ 	| aSocket |
			aSocket := listenerSocket waitForAcceptFor: self maxSecondsToLaunch.
			aSocket
				ifNil: [ self terminate ]
				ifNotNil: [
					self
						startCommandServiceOn: (ZdcSocketStream on: aSocket)
						onSuccess: [ launchDoneSemaphore signal ] ] 
		] ensure: [
			listenerSocket ifNotNil: [
				listenerSocket destroy.
				listenerSocket := nil ] ].

	]	forkAt: Processor lowIOPriority
		named: 'Wait connection from subprocess'
]

{ #category : #initialization }
IPC2PrimaryCompositor >> initialize [

	self flag: #todo. "Duplicated from SingleProcess"
	super initialize.
	windows := OrderedCollection new.
	eventQueue := WaitfreeQueue new
]

{ #category : #private }
IPC2PrimaryCompositor >> launch: isHeadless [

	| launchDoneSemaphore |
	launchDoneSemaphore := Semaphore new.

	self forkSocketListeningProcessThenSignal: launchDoneSemaphore.
	self forkOSSubprocessRun: isHeadless.
	
	launchDoneSemaphore waitTimeoutSeconds: self maxSecondsToLaunch
]

{ #category : #private }
IPC2PrimaryCompositor >> maxSecondsToLaunch [

	^ 5
]

{ #category : #'window API' }
IPC2PrimaryCompositor >> newWindow: osWindowAttributes [

	| windowId aWindow |
	windowId := commandService sendCommandSync:
		(IPC2OpenWindowCommand new
			attributes: osWindowAttributes;
			yourself).
	
	aWindow :=
		IPC2RemoteWindow new
			remoteCompositor: self; 
			id: windowId;
			yourself.
			
	windows add: aWindow.
	^ aWindow
]

{ #category : #'as yet unclassified' }
IPC2PrimaryCompositor >> pendingEvents [

	| theEvents |
	self flag: #todo. "Duplicated from SingleProcess"
	theEvents := OrderedCollection new.
	eventQueue flush: [ :anEvent | theEvents add: anEvent ].
	^ theEvents 
]

{ #category : #private }
IPC2PrimaryCompositor >> terminate [

	super terminate.
	
	listenerSocket ifNotNil: [
		listenerSocket destroy.
		listenerSocket := nil ].

	osSubprocess ifNotNil: [
		osSubprocess isRunning ifTrue: [ osSubprocess terminate ].
		osSubprocess := nil ]
]

{ #category : #initialization }
IPC2PrimaryCompositor >> whenEventsSignal: aSemaphore [

	self flag: #todo. "Duplicated from SingleProcess"
	eventSignalSemaphore := aSemaphore
]
