Class {
	#name : #IPCWindowClient,
	#superclass : #Object,
	#instVars : [
		'osSubprocess',
		'listenerSocket',
		'commandService',
		'listeningProcess'
	],
	#category : #'SDL-Experiments-App-Core'
}

{ #category : #accessing }
IPCWindowClient >> commandService [

	^ commandService
]

{ #category : #'life cycle' }
IPCWindowClient >> launch [
	"Subprocess isn't headless by default"

	self launch: false
]

{ #category : #'life cycle' }
IPCWindowClient >> launch: isHeadless [

	listenerSocket := Socket newTCP.
	"Listen will determine the port to be used. We only want one connection."
	listenerSocket
		bindToPort: Socket wildcardPort;
		listenWithBacklog: 4.
	listeningProcess := [
		[| aSocket |
		aSocket := listenerSocket waitForAcceptFor: 20.
		aSocket
			ifNil: [ self terminate ]
			ifNotNil: [ self startCommandServiceOn: aSocket ]]
				ensure: [
			 		listenerSocket destroy.
					listenerSocket := nil ] ]
						forkAt: Processor lowIOPriority
						named: 'Wait connection from subprocess'.
	
[	osSubprocess := OSSUnixSubprocess new.
	osSubprocess command: Smalltalk vm binary fullPath pathString.
	osSubprocess arguments: (Array streamContents: [ :aStream |
		isHeadless ifTrue: [
			aStream nextPut: '--headless' ].
		aStream
			nextPut: Smalltalk imageFile fullName;
			nextPut: IPCWindowServerStartCommandLineHandler commandName;
			nextPut: listenerSocket localPort printString ]).
	osSubprocess runAndWaitOnExitDo: [ :process :outString  | self terminate ]] forkAt: Processor lowIOPriority
]

{ #category : #private }
IPCWindowClient >> startCommandServiceOn: aSocket [

	commandService := IPCCommandService on: (ZdcSocketStream on: aSocket).
	commandService start
]

{ #category : #'life cycle' }
IPCWindowClient >> terminate [

	listeningProcess ifNotNil: [
		listeningProcess terminate.
		listeningProcess := nil ].

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
