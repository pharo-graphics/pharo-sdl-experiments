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
	OSWindowDriver current startUp: true.
	"to visually differenciate"
	World color: Color random.
	
	portNumber := self arguments first asInteger.
	socketStream :=
		ZdcSocketStream
			openConnectionToHost: #[127 0 0 1]
			port: portNumber.

	IPC2SecondaryCompositor current
		startCommandServiceOn: socketStream
		onSuccess: []
]
