Class {
	#name : #AppServer,
	#superclass : #Object,
	#instVars : [
		'server',
		'process'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #private }
AppServer >> launch [

	server := RRSocketServer new.
	server
		whenMessageReceivedDo: [ :aClient :aStream |
			self processResponseOf: aClient on: aStream ];
"		whenNewClientDo: [ :aClient | client := aClient ];
		whenClientDisconnectDo: [ :aClient | client := nil ];"
		start.

	self launchProcess
]

{ #category : #'as yet unclassified' }
AppServer >> launchProcess [

	process :=
		OSSUnixSubprocess new
			command: Smalltalk vm binary fullPath pathString;
			arguments: {
				"'--headless'."
				Smalltalk imageFile fullName.
				'appServer'.
				'paint'.
				server localPort printString };
			yourself.

	process run
]

{ #category : #accessing }
AppServer >> pingClients [

	server clients do: [ :each | 
		each binaryOutputStreamDo: [ :aStream |
			FLSerializer serialize: #ping on: aStream ] ]
]

{ #category : #private }
AppServer >> processResponseOf: aClient on: aStream [ 

	(FLMaterializer materializeFrom: aStream) traceCr
]

{ #category : #accessing }
AppServer >> stop [
	
	server ifNotNil: [ server stop. server := nil ].
"	client ifNotNil: [ client stop. client := nil ]."
	process ifNotNil: [ process terminate. process := nil ]
]
