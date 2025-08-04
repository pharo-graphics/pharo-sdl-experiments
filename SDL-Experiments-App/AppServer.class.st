Class {
	#name : #AppServer,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #private }
AppServer >> launch [

	server := RRSocketServer new.
	server
		whenMessageReceivedDo: [ :aClient :aStream |
			self processResponseOf: aClient on: aStream ];
		start
]

{ #category : #accessing }
AppServer >> pingClients [

	server clients do: [ :each | 
		each binaryOutputStreamDo: [ :aStream |
			FLSerializer
				serialize: #ping -> Time microsecondClockValue
				on: aStream ] ]
]

{ #category : #private }
AppServer >> processResponseOf: aClient on: aStream [ 

	(FLMaterializer materializeFrom: aStream) traceCr
]

{ #category : #accessing }
AppServer >> server [
	^ server
]

{ #category : #accessing }
AppServer >> stop [
	
	server ifNotNil: [ server stop. server := nil ]
]
