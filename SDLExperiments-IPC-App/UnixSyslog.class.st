"
I implement FFI bindings to Unix syslog.

See: https://sourceware.org/glibc/manual/latest/html_mono/libc.html#Syslog-Example-1
"
Class {
	#name : #UnixSyslog,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
UnixSyslog class >> current [

	^ current ifNil: [ current := self new ]
]

{ #category : #accessing }
UnixSyslog class >> initialize [

	SessionManager default registerToolClassNamed: self name
]

{ #category : #accessing }
UnixSyslog class >> resetCurrent [
	<script>

	current := nil
]

{ #category : #accessing }
UnixSyslog class >> startUp: isResuming [

	isResuming ifTrue: [ self resetCurrent ]
]

{ #category : #'ffi methods' }
UnixSyslog >> closeLog [
	"closelog closes the current Syslog connection, if there is one.
	
	See: https://sourceware.org/glibc/manual/latest/html_mono/libc.html#closelog"

	self ffiCall: #(void closelog()) module: LibC
]

{ #category : #initialization }
UnixSyslog >> initialize [

	super initialize.

	self
		openLog: 'IPC2';
		setlogmaskUpToInfo
]

{ #category : #convenience }
UnixSyslog >> openLog: aString [
	"Open a connection to the logging facility"

	| optionPid optionCons optionNDelay optionNoWait optionPError |
	optionPid := 1. "Include the caller's PID with each message."
	optionCons := 2. "Write directly to the system console if there is
		an error while sending to the system logger."
	optionNDelay := 8. "Open the connection immediately"
	optionNoWait := 16. "Don't wait for child processes that may have been created
              while logging the message."
	optionPError := 32. "Also log the message to stderr."

	self
		openLog: aString
		optionFlags: optionPid | optionCons | optionNDelay | optionNoWait | optionPError
		facility: 0
]

{ #category : #'ffi methods' }
UnixSyslog >> openLog: identifier optionFlags: logopt facility: facility [
	"Open a connection to the logging facility.
	
	See: https://sourceware.org/glibc/manual/latest/html_mono/libc.html#openlog"

	self
		ffiCall: #(void openlog(String identifier, int logopt, int facility))
		module: LibC
]

{ #category : #'ffi methods' }
UnixSyslog >> setlogmask: maskpri [

	self ffiCall: #(int setlogmask(int maskpri)) module: LibC
]

{ #category : #'ffi methods' }
UnixSyslog >> setlogmaskUpTo: pri [
	"all priorities through pri"

	self setlogmask: ((1 << ((pri)+1)) - 1)
]

{ #category : #'ffi methods' }
UnixSyslog >> setlogmaskUpToInfo [
	"#define LOG_INFO        6       /* informational */"

	self setlogmaskUpTo: 6
]

{ #category : #'ffi methods' }
UnixSyslog >> syslog: aString priority: pri [
	"
	Priorities:
	#define LOG_EMERG       0       /* system is unusable */
	#define LOG_ALERT       1       /* action must be taken immediately */
	#define LOG_CRIT        2       /* critical conditions */
	#define LOG_ERR         3       /* error conditions */
	#define LOG_WARNING     4       /* warning conditions */
	#define LOG_NOTICE      5       /* normal but significant condition */
	#define LOG_INFO        6       /* informational */
	#define LOG_DEBUG       7       /* debug-level messages */
	"
	self ffiCall: #(void syslog(int pri, String aString)) module: LibC
]

{ #category : #'ffi methods' }
UnixSyslog >> syslogInfo: aString [

	self syslog: aString priority: 6
]

{ #category : #'ffi methods' }
UnixSyslog >> syslogNotice: aString [

	self syslog: aString priority: 5
]
