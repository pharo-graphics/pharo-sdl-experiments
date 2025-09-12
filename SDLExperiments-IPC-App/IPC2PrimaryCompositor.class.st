Class {
	#name : #IPC2PrimaryCompositor,
	#superclass : #IPC2DualProcessCompositor,
	#instVars : [
		'osSubprocess',
		'windows'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #'window API' }
IPC2PrimaryCompositor >> announceEvent: anEvent windowId: aWindowId [

	| aWindow |
	self flag: #todo. "Duplicated from SingleProcess"
	aWindow := windows at: aWindowId.
	aWindow announceEvent: anEvent
]

{ #category : #'window API' }
IPC2PrimaryCompositor >> destroyWindow: id [

	commandService ifNil: [ ^ self ]. "Already destroyed"
	commandService sendCommandIgnoringResult:
		(IPC2DestroyWindowCommand new
			 windowId: id;
			 yourself)
]

{ #category : #initialization }
IPC2PrimaryCompositor >> initialize [

	self flag: #todo. "Duplicated from SingleProcess"
	super initialize.
	windows := Dictionary new
]

{ #category : #private }
IPC2PrimaryCompositor >> launchHeadless: isHeadless [

	| launchDoneSemaphore listenerSocket |
	launchDoneSemaphore := Semaphore new.

	listenerSocket := Socket newTCP.
	listenerSocket
		bindToPort: Socket wildcardPort;
		listenWithBacklog: 2.

	[	self
			startCommandServiceIfAccept: listenerSocket
			thenSignal: launchDoneSemaphore
	]	forkAt: Processor lowIOPriority
		named: 'Wait connection from subprocess'.

	[	self
			runAndWaitSubprocess: isHeadless
			port: listenerSocket localPort.
		self terminate
	]	forkAt: Processor lowIOPriority - 1
		named: 'Wait subprocess to connect (and quit)'.

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

	| windowId aWindow bytes pushEndpoint |

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint root: IPC2TreeNode new.
	pushEndpoint root
		shape: (0 @ 0 extent: osWindowAttributes extent);
		strokeColor: Color black.
		
	bytes := ByteArray streamContents: [ :stream |
		pushEndpoint stream: stream.
		pushEndpoint push ].

	windowId := commandService sendCommandSync:
		(IPC2OpenWindowCommand new
			attributes: osWindowAttributes;
			sceneTreeBytes: bytes;
			yourself).
	
	aWindow :=
		IPC2RemoteWindow new
			compositor: self; 
			id: windowId;
			pushEndpoint: pushEndpoint;
			yourself.
			
	windows at: aWindow id put: aWindow.
	^ aWindow
]

{ #category : #private }
IPC2PrimaryCompositor >> runAndWaitSubprocess: isHeadless port: port [

	osSubprocess := OSPlatform current isWindows
			ifTrue: [ OSWSWinProcess new ]
			ifFalse: [ OSSUnixSubprocess new ].

	osSubprocess command: Smalltalk vm binary fullName.

	osSubprocess arguments: (Array streamContents: [ :aStream |
		isHeadless ifTrue: [ aStream nextPut: '--headless' ].
		aStream
			nextPut: Smalltalk imageFile fullName;
			nextPut: IPC2CompositorCommandLineHandler commandName;
			nextPut: port printString ]).

	osSubprocess runAndWait
]

{ #category : #private }
IPC2PrimaryCompositor >> startCommandServiceIfAccept: listenerSocket thenSignal: launchDoneSemaphore [

	"Listener socket determines the port to be used by the subprocess."
	| aSocket |
	aSocket := listenerSocket waitForAcceptFor: self maxSecondsToLaunch.
	aSocket ifNil: [ ^ self terminate ].

	self
		startCommandServiceOn: (ZdcSocketStream on: aSocket)
		onSuccess: [ launchDoneSemaphore signal ]
]

{ #category : #private }
IPC2PrimaryCompositor >> terminate [

	super terminate.
	
	osSubprocess ifNotNil: [
		osSubprocess isRunning ifTrue: [ osSubprocess terminate ].
		osSubprocess := nil ]
]

{ #category : #'as yet unclassified' }
IPC2PrimaryCompositor >> updateSceneGraph: bytes windowId: windowId [

	commandService sendCommandIgnoringResult:
		(IPC2UpdateSceneGraphCommand new
			windowId: windowId;
			content: bytes;
			yourself)
]
