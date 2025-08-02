Class {
	#name : #AppPaint,
	#superclass : #AppClient,
	#instVars : [
		'serverAddress',
		'serverPort',
		'client'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #'as yet unclassified' }
AppPaint class >> appName [
	
	^ 'paint'
]

{ #category : #accessing }
AppPaint >> address: aAddress [

	serverAddress := aAddress
]

{ #category : #'instance creation' }
AppPaint >> open [
	
	client :=
		RRSocketClient new
			connectTo: serverAddress
			port: serverPort.
	client start.
	client binaryOutputStreamDo: [ :s | FLSerializer serialize: 'Connected' on: s ].
	client whenMessageReceivedDo: [ :aClient :requestStream |
		| request |
		request := FLMaterializer materializeFrom: requestStream.

		"just echo"
		aClient binaryOutputStreamDo: [ :responseStream |
			FLSerializer
				serialize: request -> DateAndTime now 
				on: responseStream ].
		
		 ]
]

{ #category : #accessing }
AppPaint >> port: anInteger [ 
	
	serverPort := anInteger
]
