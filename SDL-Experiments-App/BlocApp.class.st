Class {
	#name : #BlocApp,
	#superclass : #Object,
	#instVars : [
		'server',
		'process',
		'client'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #accessing }
BlocApp >> factorialOf: anInteger [

	client binaryOutputStreamDo: [ :aStream |
		FLSerializer serialize: anInteger on: aStream ]
]

{ #category : #private }
BlocApp >> launch [

	server := RRSocketServer new.
	server
		whenMessageReceivedDo: [ :aClient :aStream |
			self processResponseOf: aClient on: aStream ];
		whenNewClientDo: [ :aClient | client := aClient ];
		whenClientDisconnectDo: [ :aClient | client := nil ];
		start.

	self launchProcess
]

{ #category : #'as yet unclassified' }
BlocApp >> launchProcess [

	process :=
		OSSUnixSubprocess new
			command: Smalltalk vm binary fullPath pathString;
			arguments: {
				'--headless'.
				Smalltalk imageFile fullName.
				'blocApp'.
				server localPort printString };
			yourself.

	process run
]

{ #category : #private }
BlocApp >> processResponseOf: aClient on: aStream [ 

	(FLMaterializer materializeFrom: aStream) traceCr
]

{ #category : #accessing }
BlocApp >> stop [
	
	server ifNotNil: [ server stop. server := nil ].
	client ifNotNil: [ client stop. client := nil ].
	process ifNotNil: [ process terminate. process := nil ]
]
