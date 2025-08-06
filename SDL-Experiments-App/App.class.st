Class {
	#name : #App,
	#superclass : #Object,
	#instVars : [
		'process',
		'socketClient',
		'enginePort'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #accessing }
App class >> atName: aString [

	self allSubclassesDo: [ :each |
		each name = aString ifTrue: [ ^ each new ] ].

	NotFound signalFor: aString
]

{ #category : #'instance creation' }
App >> connect [

	socketClient := RRSocketClient new.
	socketClient connectTo: SocketAddress zero port: enginePort.
	socketClient start.

	socketClient binaryOutputStreamDo: [ :aStream |
		FLSerializer serialize: 'Connected' on: aStream ].
	
	socketClient whenMessageReceivedDo: [ :aClient :requestStream |
		self receiveMessageFrom: requestStream ]
]

{ #category : #accessing }
App >> enginePort: anInteger [

	enginePort := anInteger
]

{ #category : #private }
App >> launchProcess: isHeadless [

	process := OSSUnixSubprocess new.
	process command: Smalltalk vm binary fullPath pathString.
	process arguments: (Array streamContents: [ :aStream |
		isHeadless ifTrue: [
			aStream nextPut: '--headless' ].
		aStream
			nextPut: Smalltalk imageFile fullName;
			nextPut: AppCommandLineHandler commandName;
			nextPut: self className;
			nextPut: enginePort printString
		]).

	process run
]

{ #category : #'as yet unclassified' }
App >> receiveMessageFrom: requestStream [

	| size selector argument response |
	size := requestStream next.
	selector := requestStream next: size.

	argument := FLMaterializer materializeFrom: requestStream.

	response := self receive: selector with: argument.

	response ifNil: [ ^ self ].
	socketClient binaryOutputStreamDo: [ :responseStream |
		FLSerializer serialize: response on: responseStream ]
]

{ #category : #accessing }
App >> send: aByteString with: anObject [

	self assert: aByteString size < 256.

	socketClient binaryOutputStreamDo: [ :aStream |
		aStream
			nextPut: aByteString size;
			nextPutAll: aByteString.
		FLSerializer
			serialize: anObject
			on: aStream ]
]

{ #category : #private }
App >> terminateProcess [

	process ifNil: [ ^ self ].
	process isRunning ifTrue: [ process terminate ].
	process := nil
]
