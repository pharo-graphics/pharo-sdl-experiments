Class {
	#name : #IPC2Log,
	#superclass : #Object,
	#instVars : [
		'currentLineStream'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #nil }
IPC2Log class >> current [

	^ current ifNil: [ current := self new ]
]

{ #category : #accessing }
IPC2Log class >> initialize [

	SessionManager default registerGuiClassNamed: self name
]

{ #category : #accessing }
IPC2Log class >> resetCurrent [
	<script>

	current := nil
]

{ #category : #accessing }
IPC2Log class >> startUp: isResuming [

	isResuming ifTrue: [ self resetCurrent ]
]

{ #category : #private }
IPC2Log >> beginRow: typeString [

	currentLineStream
		reset;
		nextPutAll: typeString.

	self nextPutColumnSeparator
]

{ #category : #'private - ffi - syslog' }
IPC2Log >> closeLog [

	 self ffiCall: #(void closelog()) module: LibC
]

{ #category : #private }
IPC2Log >> endRow [

	self syslogNotice: currentLineStream contents
]

{ #category : #initialization }
IPC2Log >> initialize [

	super initialize.
	
	self openSystemLog.
	
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
IPC2Log >> logPull: bytes with: aBlock [

	self
		beginRow: 'pull';

		nextPutColumnHeader: 'duration';
		nextPutMillisecondsToRun: aBlock;
		nextPutColumnSeparator;

		nextPutColumnHeader: 'size';
		nextPutByteCount: bytes size;

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
IPC2Log >> nextPutByteCount: aNumber [

"	stream nextPutAll: aNumber humanReadableByteSizeString"
	currentLineStream print: aNumber; nextPutAll: ' B'
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

{ #category : #'private - ffi - syslog' }
IPC2Log >> openLog: identifier optionFlags: logopt facility: facility [

	 self ffiCall: #(void openlog(char * identifier, int logopt, int facility)) module: LibC
]

{ #category : #initialization }
IPC2Log >> openSystemLog [

	| optionPid optionCons optionNDelay optionNoWait optionPError |
	optionPid := 1. "Include the caller's PID with each message."
	optionCons := 2. "Write directly to the system console if there is
		an error while sending to the system logger."
	optionNDelay := 8. "Open the connection immediately"
	optionNoWait := 16. "Don't wait for child processes that may have been created
              while logging the message."
	optionPError := 32. "Also log the message to stderr."

	self
		openLog: self className
		optionFlags: optionPid | optionCons | optionNDelay | optionNoWait | optionPError
		facility: 0.

]

{ #category : #accessing }
IPC2Log >> stream: aWriteStream [

	currentLineStream := aWriteStream
]

{ #category : #'private - ffi - syslog' }
IPC2Log >> syslogNotice: aString [

	 self ffiCall: #(void syslog(int 5, String aString)) module: LibC
]
