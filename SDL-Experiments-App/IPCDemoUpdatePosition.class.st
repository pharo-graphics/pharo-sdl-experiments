Class {
	#name : #IPCDemoUpdatePosition,
	#superclass : #IPCDemoWindowCommand,
	#instVars : [
		'delta',
		'centerPosition'
	],
	#category : #'SDL-Experiments-App-Demo'
}

{ #category : #accessing }
IPCDemoUpdatePosition >> centerPosition [

	^ centerPosition
]

{ #category : #accessing }
IPCDemoUpdatePosition >> centerPosition: anObject [

	centerPosition := anObject
]

{ #category : #accessing }
IPCDemoUpdatePosition >> delta [

	^ delta
]

{ #category : #accessing }
IPCDemoUpdatePosition >> delta: anObject [

	delta := anObject
]

{ #category : #accessing }
IPCDemoUpdatePosition >> value: aCommandService [

	| aDemo newPosition |
	aDemo := IPCCompositor current windowAt: windowId.

	newPosition := centerPosition
		ifNotNil: [ centerPosition - (aDemo playerElement extent // 2)  ]
		ifNil: [ aDemo playerElement position + delta ].

	aDemo playerElement position: newPosition.

	^ nil 
]
