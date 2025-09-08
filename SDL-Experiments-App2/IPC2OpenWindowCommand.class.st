Class {
	#name : #IPC2OpenWindowCommand,
	#superclass : #IPC2SecondaryCompositorCommand,
	#instVars : [
		'attributes',
		'sceneTreeBytes'
	],
	#category : #'SDL-Experiments-App2'
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
IPC2OpenWindowCommand >> value: aCommandService [
	"Sender needs the window's id for further commands"

	^ (aCommandService owner
		   newWindow: attributes
		   sceneTreeBytes: sceneTreeBytes) id
]
