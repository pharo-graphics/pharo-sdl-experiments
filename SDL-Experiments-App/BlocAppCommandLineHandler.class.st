Class {
	#name : #BlocAppCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'server',
		'process'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #accessing }
BlocAppCommandLineHandler class >> commandName [

	^ 'blocApp'
]

{ #category : #activation }
BlocAppCommandLineHandler >> activate [

	| client |
	World color: Color red.
	client :=
		RRSocketClient new
			connectTo: #[0 0 0 0]
			port: (self argumentAt: 1 ) asInteger.
	client whenMessageReceivedDo: [ :aClient :aStream |
		| r |
		r := FLMaterializer materializeFrom: aStream.
		aClient binaryOutputStreamDo: [ :s2 |
			FLSerializer serialize: r factorial on: s2 ]. ].
	client start.
	client binaryOutputStreamDo: [ :s | FLSerializer serialize: 'Connected' on: s ]
]
