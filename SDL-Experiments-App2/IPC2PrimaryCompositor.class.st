Class {
	#name : #IPC2PrimaryCompositor,
	#superclass : #IPC2DualProcessCompositor,
	#instVars : [
		'osSubprocess',
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
IPC2PrimaryCompositor >> forkOSSubprocessRun: isHeadless port: port [


	[	OSPlatform current isWindows
			ifTrue: [ self runWindowsSubprocess: isHeadless port: port ]
			ifFalse: [ self runUnixSubprocess: isHeadless port: port ].
		self terminate
		]
			forkAt: Processor lowIOPriority
			named: 'Wait subprocess to connect'
]

{ #category : #private }
IPC2PrimaryCompositor >> forkSocketListeningProcess: listenerSocket thenSignal: launchDoneSemaphore [

	"Listener socket determines the port to be used by the subprocess."
	[	| aSocket |
		aSocket := listenerSocket waitForAcceptFor: self maxSecondsToLaunch.
		aSocket
			ifNotNil: [
				self
					startCommandServiceOn: (ZdcSocketStream on: aSocket)
					onSuccess: [ launchDoneSemaphore signal ] ] 
			ifNil: [ self terminate ]

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
IPC2PrimaryCompositor >> launchHeadless: isHeadless [

	| launchDoneSemaphore listenerSocket |
	launchDoneSemaphore := Semaphore new.

	listenerSocket := Socket newTCP.
	listenerSocket
		bindToPort: Socket wildcardPort;
		listenWithBacklog: 2.

	self
		forkSocketListeningProcess: listenerSocket
		thenSignal: launchDoneSemaphore.
	self forkOSSubprocessRun: isHeadless port: listenerSocket localPort.

	launchDoneSemaphore waitTimeoutSeconds: self maxSecondsToLaunch.

	listenerSocket ifNotNil: [
			listenerSocket destroy.
			listenerSocket := nil ]
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
IPC2PrimaryCompositor >> runUnixSubprocess: isHeadless port: port [

	osSubprocess := OSSUnixSubprocess new.

	osSubprocess command: Smalltalk vm binary fullPath pathString.

	osSubprocess arguments: (Array streamContents: [ :aStream |
		isHeadless ifTrue: [ aStream nextPut: '--headless' ].
		aStream
			nextPut: Smalltalk imageFile fullName;
			nextPut: IPC2CompositorCommandLineHandler commandName;
			nextPut: port printString ]).

	osSubprocess runAndWait
]

{ #category : #private }
IPC2PrimaryCompositor >> runWindowsSubprocess: isHeadless port: port [

	osSubprocess := OSWSWinProcess new.

	osSubprocess command: Smalltalk vm binary fullPath pathString.

	osSubprocess arguments: (Array streamContents: [ :aStream |
		isHeadless ifTrue: [ aStream nextPut: '--headless' ].
		aStream
			nextPut: Smalltalk imageFile fullName;
			nextPut: IPC2CompositorCommandLineHandler commandName;
			nextPut: port printString ]).

	osSubprocess runAndWait
]

{ #category : #private }
IPC2PrimaryCompositor >> terminate [

	super terminate.
	
	osSubprocess ifNotNil: [
		osSubprocess isRunning ifTrue: [ osSubprocess terminate ].
		osSubprocess := nil ]
]

{ #category : #initialization }
IPC2PrimaryCompositor >> whenEventsSignal: aSemaphore [

	self flag: #todo. "Duplicated from SingleProcess"
	eventSignalSemaphore := aSemaphore
]
