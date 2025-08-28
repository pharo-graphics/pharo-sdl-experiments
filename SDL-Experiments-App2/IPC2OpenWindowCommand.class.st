Class {
	#name : #IPC2OpenWindowCommand,
	#superclass : #IPC2Command,
	#instVars : [
		'attributes'
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
IPC2OpenWindowCommand >> value: _ [

	^ (IPC2SecondaryCompositor current newWindow: attributes) id
]
