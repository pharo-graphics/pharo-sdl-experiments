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
		'CommandIgnoringResultByte',
		'ReturnByte'
	],
	#category : #'SDL-Experiments-App-Core'
}

{ #category : #'class initialization' }
IPCCommandService class >> initialize [

	CommandIgnoringResultByte := 6.
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
IPCCommandService >> pingStatsTraceCr [

	| n delay samples semaphore |
	n := 100.
	delay := Delay forMilliseconds: 100.
	samples := OrderedCollection new.
	semaphore := Semaphore new.

	('Ping ', n asString, ' times:') traceCr.
	
	[ (1 to: n) do: [ :_ |
		self
			sendCommand: IPCPing new
			onSuccess: [ :data |
				| t1 t2 t3 |
				t1 := data first.
				t2 := data second.
				t3 := Time microsecondClockValue.
				samples add: { t3 - t1. t2 - t1. t3 - t2 } / 1000.0 ].
		semaphore signal.
		delay wait ] ]
			forkAt: Processor userSchedulingPriority + 1.

	n timesRepeat: [ semaphore wait ].
	
	(String streamContents: [ :stream |
		stream << '* total:'; cr.
		self pingStatsTraceCrSamples: (samples collect: #first) on: stream.

		stream << '* command:'; cr.
		self pingStatsTraceCrSamples: (samples collect: #second) on: stream.

		stream << '* return:'; cr.
		self pingStatsTraceCrSamples: (samples collect: #third) on: stream.
		]) traceCr
]

{ #category : #private }
IPCCommandService >> pingStatsTraceCrSamples: collectionOfMilliseconds on: stream [

	stream tab; << '- mean: '.
	MeanConfidenceIntervalPrinter new
		unitString: 'ms';
		print: collectionOfMilliseconds on: stream.
	stream cr.
	stream tab; << '- max: '; print: collectionOfMilliseconds max; << 'ms'; cr.
	stream tab; << '- min: '; print: collectionOfMilliseconds min; << 'ms'; cr
]

{ #category : #API }
IPCCommandService >> pingTraceCr [

	self
		sendCommand: IPCPing new
		onSuccess: [ :data |
			| t1 t2 t3 |
			t1 := data first.
			t2 := data second.
			t3 := Time microsecondClockValue.
			('total: {1} ms;	command: {2} ms;	return: {3} ms'
				format: { t3 - t1. t2 - t1. t3 - t2 } / 1000.0) traceCr ]
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
		payload := FLMaterializer materializeFrom: socketStream  ].

	mark = CommandIgnoringResultByte ifTrue: [
		^ payload value: self ].
	mark = CommandByte ifTrue: [
		^ self sendResult: (payload value: self) of: id ].
	mark = ReturnByte ifTrue: [
		^ self valueSuccess: payload of: id ].
	self error: 'Corrupt command header'
]

{ #category : #accessing }
IPCCommandService >> runningStartBlock: aUnaryBlock [

	runningStartBlock := aUnaryBlock
]

{ #category : #API }
IPCCommandService >> sendCommand: aCommand onSuccess: successBlock [

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
IPCCommandService >> sendCommandIgnoringResult: aCommand [

	mutexToWrite critical: [
		socketStream nextPut: CommandIgnoringResultByte.
		socketStream nextPut: 0. "id is ignored in the other side"
		FLSerializer serialize: aCommand on: socketStream ].

	socketStream flush
]

{ #category : #API }
IPCCommandService >> sendCommandSync: aCommand [

	| semaphore result |
	semaphore := Semaphore new.

	self sendCommand: aCommand onSuccess: [ :anObject |
		result := anObject.
		semaphore signal ].

	semaphore wait.
	^ result
]

{ #category : #private }
IPCCommandService >> sendResult: anObject of: id [

	mutexToWrite critical: [
		socketStream nextPut: ReturnByte.
		socketStream nextPut: id.
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
