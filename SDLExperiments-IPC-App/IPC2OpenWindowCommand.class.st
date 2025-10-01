Class {
	#name : #IPC2OpenWindowCommand,
	#superclass : #IPC2SecondaryCompositorCommand,
	#instVars : [
		'attributes',
		'sceneTreeBytes'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
IPC2OpenWindowCommand >> attributes [

	^ attributes
]

{ #category : #accessing }
IPC2OpenWindowCommand >> attributes: anObject [

	attributes := anObject
]

{ #category : #accessing }
IPC2OpenWindowCommand >> sceneTreeBytes: aByteArray [

	sceneTreeBytes := aByteArray
]

{ #category : #accessing }
IPC2OpenWindowCommand >> value: secondaryCompositor [
	"Sender needs the window's id for further commands"

	^ (secondaryCompositor
		   newWindow: attributes
		   sceneTreeBytes: sceneTreeBytes) id
]
