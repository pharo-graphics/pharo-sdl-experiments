"
I implement FFI bindings to Unix syslog

See: https://sourceware.org/glibc/manual/latest/html_mono/libc.html#Syslog-Example-1
"
Class {
	#name : #UnixSyslog,
	#superclass : #Object,
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #'ffi methods' }
UnixSyslog class >> closeLog [
	"closelog closes the current Syslog connection, if there is one.
	
	See: https://sourceware.org/glibc/manual/latest/html_mono/libc.html#closelog"

	 self ffiCall: #(void closelog()) module: LibC
]

{ #category : #convenience }
UnixSyslog class >> openLog: aString [

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
UnixSyslog class >> openLog: identifier optionFlags: logopt facility: facility [
	"openlog — open a connection to the logging facility
	
	See: https://sourceware.org/glibc/manual/latest/html_mono/libc.html#openlog"

	 self ffiCall: #(void openlog(String identifier, int logopt, int facility)) module: LibC
]

{ #category : #'ffi methods' }
UnixSyslog class >> syslogNotice: aString [

	 self ffiCall: #(void syslog(int 5, String aString)) module: LibC
]
