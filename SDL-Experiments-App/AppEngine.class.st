Class {
	#name : #AppEngine,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #private }
AppEngine >> runProcess [

	server := RRSocketServer new.
	server
		whenMessageReceivedDo: [ :aClient :aStream |
			self traceMessageOf: aClient from: aStream ];
		start
]

{ #category : #accessing }
AppEngine >> stop [
	
	server ifNotNil: [ server stop. server := nil ]
]

{ #category : #private }
AppEngine >> traceMessageOf: aClient from: aStream [ 

	(FLMaterializer materializeFrom: aStream) traceCr
]
