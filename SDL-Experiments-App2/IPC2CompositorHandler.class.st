Class {
	#name : #IPC2CompositorHandler,
	#superclass : #CommandLineHandler,
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2CompositorHandler class >> commandName [

	^ 'compositor'
]

{ #category : #activation }
IPC2CompositorHandler >> activate [

	| socketStream portNumber |
	World color: Color random. "to visually differenciate"
	
	OSWindowDriver current startUp: true.
	
	portNumber := self arguments first asInteger.
	socketStream :=
		ZdcSocketStream
			openConnectionToHost: #[127 0 0 1]
			port: portNumber.

	IPC2CompositorListener current startOn: socketStream
]
