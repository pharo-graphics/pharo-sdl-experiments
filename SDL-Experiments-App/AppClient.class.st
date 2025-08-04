Class {
	#name : #AppClient,
	#superclass : #Object,
	#instVars : [
		'serverAddress',
		'serverPort',
		'client',
		'process',
		'server'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #accessing }
AppClient class >> atName: aString [

	self allSubclassesDo: [ :each |
		each appName = aString ifTrue: [ ^ each new ] ].

	NotFound signalFor: aString
]

{ #category : #accessing }
AppClient >> address: aAddress [

	serverAddress := aAddress
]

{ #category : #accessing }
AppClient >> client [

	^ client
]

{ #category : #accessing }
AppClient >> client: anObject [

	client := anObject
]

{ #category : #private }
AppClient >> launch [

	process :=
		OSSUnixSubprocess new
			command: Smalltalk vm binary fullPath pathString;
			arguments: {
				"'--headless'."
				Smalltalk imageFile fullName.
				'appServer'.
				self class appName.
				server server localPort printString };
			yourself.

	process run
]

{ #category : #'instance creation' }
AppClient >> open [
	
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
				serialize: request -> Time microsecondClockValue 
				on: responseStream ].
		
		 ]
]

{ #category : #accessing }
AppClient >> port: anInteger [ 
	
	serverPort := anInteger
]

{ #category : #accessing }
AppClient >> process [

	^ process
]

{ #category : #accessing }
AppClient >> process: anObject [

	process := anObject
]

{ #category : #accessing }
AppClient >> server [

	^ server
]

{ #category : #accessing }
AppClient >> server: anObject [

	server := anObject
]

{ #category : #accessing }
AppClient >> serverAddress [

	^ serverAddress
]

{ #category : #accessing }
AppClient >> serverPort [

	^ serverPort
]

{ #category : #private }
AppClient >> stop [

	process ifNotNil: [
		process isRunning ifTrue: #terminate.
		process := nil ]
]
