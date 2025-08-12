Class {
	#name : #IPCWindowClient,
	#superclass : #Object,
	#instVars : [
		'osSubprocess',
		'listenerSocket',
		'commandService'
	],
	#category : #'SDL-Experiments-App-Core'
}

{ #category : #accessing }
IPCWindowClient >> commandService [

	^ commandService
]

{ #category : #private }
IPCWindowClient >> forkOSSubprocessRun: isHeadless [

	[	osSubprocess := OSSUnixSubprocess new.

		osSubprocess command: Smalltalk vm binary fullPath pathString.

		osSubprocess arguments: (Array streamContents: [ :aStream |
			isHeadless ifTrue: [ aStream nextPut: '--headless' ].
			aStream
				nextPut: Smalltalk imageFile fullName;
				nextPut: IPCWindowServerStartCommandLineHandler commandName;
				nextPut: listenerSocket localPort printString ]).

		osSubprocess runAndWaitOnExitDo: [ :process :outString  | self terminate ]]
			forkAt: Processor lowIOPriority.

]

{ #category : #private }
IPCWindowClient >> forkSocketListeningProcessThenSignal: launchDoneSemaphore [

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

{ #category : #'life cycle' }
IPCWindowClient >> launch [
	"Subprocess isn't headless by default, to ease debugging."

	self launch: false
]

{ #category : #'life cycle' }
IPCWindowClient >> launch: isHeadless [

	| launchDoneSemaphore |
	launchDoneSemaphore := Semaphore new.

	self forkSocketListeningProcessThenSignal: launchDoneSemaphore.
	self forkOSSubprocessRun: isHeadless.
	
	launchDoneSemaphore waitTimeoutSeconds: self maxSecondsToLaunch
]

{ #category : #'life cycle' }
IPCWindowClient >> maxSecondsToLaunch [

	^ 5
]

{ #category : #'life cycle' }
IPCWindowClient >> terminate [

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
