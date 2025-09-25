Class {
	#name : #IPC2Log,
	#superclass : #Object,
	#instVars : [
		'currentLineStream',
		'lineIdentifier'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
IPC2Log class >> current [

	^ current ifNil: [ current := self new ]
]

{ #category : #accessing }
IPC2Log class >> initialize [

	self openSyslog.
	
	SessionManager default registerGuiClassNamed: self name
]

{ #category : #accessing }
IPC2Log class >> openSyslog [
	"Open a connection to the system logging facility, and affect this OS process"
	<script>

	UnixSyslog
		openLog: self name;
		setlogmaskUpToInfo
]

{ #category : #accessing }
IPC2Log class >> resetCurrent [
	<script>

	current := nil
]

{ #category : #accessing }
IPC2Log class >> startUp: isResuming [

	isResuming ifTrue: [
		self
			openSyslog;
			resetCurrent ]
]

{ #category : #private }
IPC2Log >> beginRow: typeString [

	currentLineStream
		reset;
		nextPutAll: lineIdentifier;
		space;
		nextPutAll: typeString.

	self nextPutColumnSeparator
]

{ #category : #private }
IPC2Log >> endRow [

	UnixSyslog syslogInfo: currentLineStream contents
]

{ #category : #initialization }
IPC2Log >> initialize [

	super initialize.

	"identifier to ease filtering"
	lineIdentifier := 'PharoIPC(', (self identityHash printStringBase: 36), ')'.

	currentLineStream := String new writeStream
]

{ #category : #logging }
IPC2Log >> logCreateWindow: aBlock [

	self
		beginRow: 'create window';

		nextPutColumnHeader: 'duration';
		nextPutMillisecondsToRun: aBlock;

		endRow
]

{ #category : #logging }
IPC2Log >> logPingSendMicroseconds: sendMicroseconds answerMicroseconds: answerMicroseconds [

	self
		beginRow: 'ping';

		nextPutColumnHeader: 'send';
		nextPutMicroseconds: sendMicroseconds;
		nextPutColumnSeparator;

		nextPutColumnHeader: 'answer';
		nextPutMicroseconds: answerMicroseconds;

		endRow
]

{ #category : #logging }
IPC2Log >> logPull: bytes with: aBlock [

	self
		beginRow: 'pull';

		nextPutColumnHeader: 'duration';
		nextPutMillisecondsToRun: aBlock;
		nextPutColumnSeparator;

		nextPutColumnHeader: 'size';
		nextPutByteSize: bytes size;

		endRow
]

{ #category : #logging }
IPC2Log >> logPush: aBlock [

	self
		beginRow: 'push';

		nextPutColumnHeader: 'duration';
		nextPutMillisecondsToRun: aBlock;

		endRow
]

{ #category : #logging }
IPC2Log >> logRender: usedMS [

	self
		beginRow: 'render';

		nextPutColumnHeader: 'duration';
		nextPutMilliseconds: usedMS;

		endRow
]

{ #category : #logging }
IPC2Log >> logSecondaryProcessActivateOnPort: portNumber [

	self beginRow: 'launch secondary process'.

	self nextPutColumnHeader: 'port'.
	currentLineStream print: portNumber.

	self endRow
]

{ #category : #private }
IPC2Log >> nextPutByteSize: aNumber [

"	stream nextPutAll: aNumber humanReadableByteSizeString"
	currentLineStream print: aNumber; nextPutAll: ' b'
]

{ #category : #logging }
IPC2Log >> nextPutColumnHeader: aString [

	currentLineStream
		nextPutAll: aString;
		nextPutAll: ': '
]

{ #category : #private }
IPC2Log >> nextPutColumnSeparator [

	currentLineStream nextPutAll: '; '
]

{ #category : #private }
IPC2Log >> nextPutMicroseconds: aNumber [

	(aNumber / 1e3) printOn: currentLineStream showingDecimalPlaces: 2.

	currentLineStream nextPutAll: ' ms'
]

{ #category : #private }
IPC2Log >> nextPutMilliseconds: aNumber [

	aNumber printOn: currentLineStream showingDecimalPlaces: 2.

	currentLineStream nextPutAll: ' ms'
]

{ #category : #private }
IPC2Log >> nextPutMillisecondsToRun: aBlock [

	self nextPutMilliseconds: aBlock microsecondsToRun / 1e3
]

{ #category : #accessing }
IPC2Log >> stream: aWriteStream [

	currentLineStream := aWriteStream
]
