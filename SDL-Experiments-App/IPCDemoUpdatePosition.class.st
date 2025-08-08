Class {
	#name : #IPCDemoUpdatePosition,
	#superclass : #IPCCommand,
	#instVars : [
		'windowId',
		'delta'
	],
	#category : #'SDL-Experiments-App-Demo'
}

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

	| aDemo |
	aDemo := IPCWindowServer current windowAt: windowId.
	aDemo playerElement position: aDemo playerElement position + delta.

	^ nil 
]

{ #category : #accessing }
IPCDemoUpdatePosition >> windowId [

	^ windowId
]

{ #category : #accessing }
IPCDemoUpdatePosition >> windowId: anObject [

	windowId := anObject
]
