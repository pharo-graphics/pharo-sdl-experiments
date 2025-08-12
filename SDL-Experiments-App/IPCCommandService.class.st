Class {
	#name : #IPCCommandService,
	#superclass : #TKTService,
	#instVars : [
		'socketStream',
		'pendingResults',
		'mutexToRead',
		'mutexToWrite',
		'lastCommandId',
		'runningStartBlock'
	],
	#classVars : [
		'CommandByte',
		'ReturnByte'
	],
	#category : #'SDL-Experiments-App-Core'
}

{ #category : #'class initialization' }
IPCCommandService class >> initialize [

	CommandByte := 7.
	ReturnByte := 8
]

{ #category : #'instance creation' }
IPCCommandService class >> on: aSocketStream [

	^ self basicNew
		initializeWith: aSocketStream;
		yourself
]

{ #category : #initialization }
IPCCommandService >> initializeWith: aSocketStream [

	self initialize.

	self
		setServerSocketOptions: aSocketStream socket;
		setSocketStreamParameters: aSocketStream.
	
	runningStartBlock := [ :commandService | ].
	socketStream := aSocketStream.
	lastCommandId := -1.
	pendingResults := Dictionary new.
	mutexToWrite := Semaphore forMutualExclusion.
	mutexToRead := Semaphore forMutualExclusion.

	self stepDelay: 0 seconds.
	self priority: Processor userSchedulingPriority
]

{ #category : #accessing }
IPCCommandService >> name [

	^ self className, self hash printString
]

{ #category : #API }
IPCCommandService >> pingTraceCr [

	self
		sendCommand: IPCPing new
		onSuccess: [ :data |
			| t3 |
			t3 := Time microsecondClockValue.
			({ data second - data first. t3 - data second } / 1000.0) traceCr ]
]

{ #category : #stepping }
IPCCommandService >> receive [

	| mark id payload |
	socketStream socket
		waitForDataFor: 1
		ifClosed: [ ^ self stop ]
		ifTimedOut: [ ^ self "Let's step again" ].

	"The mark determines either we are receiving a new command to
	execute or an old commnad's result"
	mutexToRead critical: [
		mark := socketStream next.
		id := socketStream next.
		payload := FLMaterializer materializeFrom: socketStream ].

	mark = CommandByte
		ifTrue: [
			self sendResult: (payload value: self) of: id ]
		ifFalse: [
			self valueSuccess: payload of: id ]
]

{ #category : #accessing }
IPCCommandService >> runningStartBlock: aUnaryBlock [

	runningStartBlock := aUnaryBlock
]

{ #category : #private }
IPCCommandService >> sendCommand: aCommand onSuccess: successBlock [

	lastCommandId := lastCommandId + 1.
	lastCommandId >= 256 ifTrue: [
		lastCommandId := 0 ].

"	(pendingResults includesKey: lastCommandId) ifTrue: [ 1halt ]."
	pendingResults at: lastCommandId put: successBlock.

	mutexToWrite critical: [
		socketStream nextPut: CommandByte; nextPut: lastCommandId.
		FLSerializer serialize: aCommand on: socketStream ].
	socketStream flush
]

{ #category : #private }
IPCCommandService >> sendResult: anObject of: id [

	mutexToWrite critical: [
		socketStream nextPut: ReturnByte; nextPut: id.
		FLSerializer serialize: anObject on: socketStream ].
	socketStream flush
]

{ #category : #initialization }
IPCCommandService >> setServerSocketOptions: socket [

	socket
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: self socketBufferSize;
		setOption: 'SO_RCVBUF' value: self socketBufferSize
]

{ #category : #initialization }
IPCCommandService >> setSocketStreamParameters: stream [

	stream
		binary;
		shouldSignal: true;
		autoFlush: false;
		bufferSize: self socketBufferSize;
		timeout: self socketTimeoutInSeconds
]

{ #category : #stepping }
IPCCommandService >> setUp [

	super setUp.
	runningStartBlock cull: self
]

{ #category : #initialization }
IPCCommandService >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096 * 4
]

{ #category : #initialization }
IPCCommandService >> socketTimeoutInSeconds [

	^ 2
]

{ #category : #stepping }
IPCCommandService >> stepService [

	[ self receive ] onErrorDo: [ :error |
			error debug.
			self stop ]
]

{ #category : #stepping }
IPCCommandService >> tearDown [

	socketStream ifNotNil: [
		socketStream close.
		socketStream := nil ]
]

{ #category : #stepping }
IPCCommandService >> valueSuccess: payload of: id [

	| successValuable |
	successValuable := pendingResults removeKey: id ifAbsent: [ ^ self ].
	successValuable value: payload
]
