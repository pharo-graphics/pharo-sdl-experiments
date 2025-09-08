Class {
	#name : #IPC2DestroyWindowCommand,
	#superclass : #IPC2SecondaryCompositorCommand,
	#instVars : [
		'windowId'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2DestroyWindowCommand >> value: _ [

	^ IPC2SecondaryCompositor current destroyWindow: windowId
]

{ #category : #accessing }
IPC2DestroyWindowCommand >> windowId [

	^ windowId
]

{ #category : #accessing }
IPC2DestroyWindowCommand >> windowId: anObject [

	windowId := anObject
]
