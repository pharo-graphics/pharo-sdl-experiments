Class {
	#name : #IPC2CompositorCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2CompositorCommandLineHandler class >> commandName [

	^ 'compositor'
]

{ #category : #activation }
IPC2CompositorCommandLineHandler >> activate [

	| socketStream portNumber |
	Smalltalk isHeadless
		ifTrue: [
			OSWindowDriver current startUp: true ]
		ifFalse: [
			"to visually differenciate"
			World color: Color random ].
	
	portNumber := self arguments first asInteger.
	socketStream :=
		ZdcSocketStream
			openConnectionToHost: #[127 0 0 1]
			port: portNumber.

	IPC2CompositorListener current startOn: socketStream
]
