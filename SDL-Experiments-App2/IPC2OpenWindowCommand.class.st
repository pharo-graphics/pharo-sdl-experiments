Class {
	#name : #IPC2OpenWindowCommand,
	#superclass : #Object,
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
IPC2OpenWindowCommand >> value: commandService [

	^ IPC2CompositorListener current newWindow: attributes
]
