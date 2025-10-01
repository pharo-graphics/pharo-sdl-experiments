Class {
	#name : #IPC2DestroyWindowCommand,
	#superclass : #IPC2SecondaryCompositorCommand,
	#instVars : [
		'windowId'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
IPC2DestroyWindowCommand >> value: secondaryCompositor [

	^ secondaryCompositor destroyWindow: windowId
]

{ #category : #accessing }
IPC2DestroyWindowCommand >> windowId [

	^ windowId
]

{ #category : #accessing }
IPC2DestroyWindowCommand >> windowId: anObject [

	windowId := anObject
]
