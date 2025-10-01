Class {
	#name : #IPC2CommandService,
	#superclass : #TKTService,
	#instVars : [
		'socketStream',
		'pendingResults',
		'mutexToRead',
		'mutexToWrite',
		'lastCommandId',
		'runningStartBlock',
		'owner'
	],
	#classVars : [
		'CommandByte',
		'CommandIgnoringResultByte',
		'ReturnByte'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #'class initialization' }
IPC2CommandService class >> initialize [

	CommandIgnoringResultByte := 6.
	CommandByte := 7.
	ReturnByte := 8
]

{ #category : #'instance creation' }
IPC2CommandService class >> on: aSocketStream [

	^ self basicNew
		initializeWith: aSocketStream;
		yourself
]

{ #category : #initialization }
IPC2CommandService >> initializeWith: aSocketStream [

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
IPC2CommandService >> name [

	^ self className, self hash printString
]

{ #category : #accessing }
IPC2CommandService >> owner [

	^ owner
]

{ #category : #accessing }
IPC2CommandService >> owner: anObject [

	owner := anObject
]

{ #category : #private }
IPC2CommandService >> pingStatsTraceCrSamples: collectionOfMilliseconds on: stream [

	stream tab; << '- mean: '.
	MeanConfidenceIntervalPrinter new
		unitString: 'ms';
		print: collectionOfMilliseconds on: stream.
	stream cr.
	stream tab; << '- max: '; print: collectionOfMilliseconds max; << 'ms'; cr.
	stream tab; << '- min: '; print: collectionOfMilliseconds min; << 'ms'; cr
]

{ #category : #stepping }
IPC2CommandService >> receive [

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
		payload := FLMaterializer materializeFrom: socketStream  ].

	mark = CommandIgnoringResultByte ifTrue: [
		^ payload value: owner ].
	mark = CommandByte ifTrue: [
		^ self sendResult: (payload value: owner) of: id ].
	mark = ReturnByte ifTrue: [
		^ self valueSuccess: payload of: id ].
	self error: 'Corrupt command header'
]

{ #category : #accessing }
IPC2CommandService >> runningStartBlock: aUnaryBlock [

	runningStartBlock := aUnaryBlock
]

{ #category : #API }
IPC2CommandService >> sendCommand: aCommand onSuccess: successBlock [

	mutexToWrite critical: [
		lastCommandId := lastCommandId + 1.
		lastCommandId >= 256 ifTrue: [ lastCommandId := 0 ].

		(pendingResults includesKey: lastCommandId)
			ifTrue: [ self error: 'Not yet implemented' ].
		pendingResults at: lastCommandId put: successBlock.

		socketStream nextPut: CommandByte.
		socketStream nextPut: lastCommandId.
		FLSerializer serialize: aCommand on: socketStream ].

	socketStream flush
]

{ #category : #API }
IPC2CommandService >> sendCommandIgnoringResult: aCommand [

	mutexToWrite critical: [
		socketStream nextPut: CommandIgnoringResultByte.
		socketStream nextPut: 0. "id is ignored in the other side"
		FLSerializer serialize: aCommand on: socketStream ].

	socketStream flush
]

{ #category : #API }
IPC2CommandService >> sendCommandSync: aCommand [

	| semaphore result |
	semaphore := Semaphore new.

	self sendCommand: aCommand onSuccess: [ :anObject |
		result := anObject.
		semaphore signal ].

	semaphore wait.
	^ result
]

{ #category : #private }
IPC2CommandService >> sendResult: anObject of: id [

	mutexToWrite critical: [
		socketStream nextPut: ReturnByte.
		socketStream nextPut: id.
		FLSerializer serialize: anObject on: socketStream ].

	socketStream flush
]

{ #category : #initialization }
IPC2CommandService >> setServerSocketOptions: socket [

	socket
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: self socketBufferSize;
		setOption: 'SO_RCVBUF' value: self socketBufferSize
]

{ #category : #initialization }
IPC2CommandService >> setSocketStreamParameters: stream [

	stream
		binary;
		shouldSignal: true;
		autoFlush: false;
		bufferSize: self socketBufferSize;
		timeout: self socketTimeoutInSeconds
]

{ #category : #stepping }
IPC2CommandService >> setUp [

	super setUp.
	runningStartBlock cull: self
]

{ #category : #initialization }
IPC2CommandService >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096 * 4
]

{ #category : #initialization }
IPC2CommandService >> socketTimeoutInSeconds [

	^ 2
]

{ #category : #stepping }
IPC2CommandService >> stepService [

	[ self receive ] onErrorDo: [ :error |
			error debug.
			self stop ]
]

{ #category : #stepping }
IPC2CommandService >> tearDown [

	socketStream ifNotNil: [
		socketStream close.
		socketStream := nil ]
]

{ #category : #stepping }
IPC2CommandService >> valueSuccess: payload of: id [

	| successValuable |
	successValuable := pendingResults removeKey: id ifAbsent: [ ^ self ].
	successValuable value: payload
]
