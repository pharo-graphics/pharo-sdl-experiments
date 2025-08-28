Class {
	#name : #IPCDemoWindowCommand,
	#superclass : #IPCCommand,
	#instVars : [
		'windowId'
	],
	#category : #'SDL-Experiments-App-Demo'
}

{ #category : #accessing }
IPCDemoWindowCommand >> windowId [

	^ windowId
]

{ #category : #accessing }
IPCDemoWindowCommand >> windowId: anObject [

	windowId := anObject
]
