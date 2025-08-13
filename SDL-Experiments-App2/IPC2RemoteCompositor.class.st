Class {
	#name : #IPC2RemoteCompositor,
	#superclass : #Object,
	#instVars : [
		'osSubprocess',
		'listenerSocket',
		'commandService'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #private }
IPC2RemoteCompositor >> commandService [

	^ commandService
]

{ #category : #private }
IPC2RemoteCompositor >> forkOSSubprocessRun: isHeadless [

	[	osSubprocess := OSSUnixSubprocess new.

		osSubprocess command: Smalltalk vm binary fullPath pathString.

		osSubprocess arguments: (Array streamContents: [ :aStream |
			isHeadless ifTrue: [ aStream nextPut: '--headless' ].
			aStream
				nextPut: Smalltalk imageFile fullName;
				nextPut: IPC2CompositorHandler commandName;
				nextPut: listenerSocket localPort printString ]).

		osSubprocess runAndWaitOnExitDo: [ :process :outString  | self terminate ]]
			forkAt: Processor lowIOPriority.

]

{ #category : #private }
IPC2RemoteCompositor >> forkSocketListeningProcessThenSignal: launchDoneSemaphore [

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
					| aSocketStream |
					aSocketStream := ZdcSocketStream on: aSocket.
					commandService := IPCCommandService on: aSocketStream.
					commandService runningStartBlock: [ launchDoneSemaphore signal ].
					commandService start ] 
		] ensure: [
			listenerSocket ifNotNil: [
				listenerSocket destroy.
				listenerSocket := nil ] ].

	]	forkAt: Processor lowIOPriority
		named: 'Wait connection from subprocess'
]

{ #category : #private }
IPC2RemoteCompositor >> launch: isHeadless [

	| launchDoneSemaphore |
	launchDoneSemaphore := Semaphore new.

	self forkSocketListeningProcessThenSignal: launchDoneSemaphore.
	self forkOSSubprocessRun: isHeadless.
	
	launchDoneSemaphore waitTimeoutSeconds: self maxSecondsToLaunch
]

{ #category : #private }
IPC2RemoteCompositor >> maxSecondsToLaunch [

	^ 5
]

{ #category : #'window API' }
IPC2RemoteCompositor >> openWindow: aTitle [

	| finishSem newId |
	finishSem := Semaphore new.

	commandService
		sendCommand: (IPC2OpenWindow new
				 title: aTitle;
				 yourself)
		onSuccess: [ :id |
			newId := id.
			finishSem signal.
			 ].
	
	finishSem wait.
	
	^ IPC2RemoteWindow new
		remoteCompositor: self; 
		id: newId; yourself 
]

{ #category : #private }
IPC2RemoteCompositor >> terminate [

	listenerSocket ifNotNil: [
		listenerSocket destroy.
		listenerSocket := nil ].

	commandService ifNotNil: [
		commandService stop.
		commandService := nil ].

	osSubprocess ifNotNil: [
		osSubprocess isRunning ifTrue: [ osSubprocess terminate ].
		osSubprocess := nil ]
]
