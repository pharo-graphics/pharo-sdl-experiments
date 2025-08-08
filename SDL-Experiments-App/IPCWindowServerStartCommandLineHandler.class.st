Class {
	#name : #IPCWindowServerStartCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'SDL-Experiments-App-Core'
}

{ #category : #accessing }
IPCWindowServerStartCommandLineHandler class >> commandName [

	^ 'launchApp'
]

{ #category : #activation }
IPCWindowServerStartCommandLineHandler >> activate [

	| socketStream portNumber |
	World color: Color random. "to visually differenciate"
	
	portNumber := self arguments first asInteger.
	socketStream :=
		ZdcSocketStream
			openConnectionToHost: #[127 0 0 1]
			port: portNumber.

	IPCWindowServer current startOn: socketStream
]
