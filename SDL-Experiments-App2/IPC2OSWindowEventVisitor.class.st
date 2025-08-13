Class {
	#name : #IPC2OSWindowEventVisitor,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'window'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #visiting }
IPC2OSWindowEventVisitor >> visitWindowCloseEvent: anEvent [

	anEvent suppressDefaultAction.
	window enqueueEvent: IPC2WindowCloseEvent new

]

{ #category : #accessing }
IPC2OSWindowEventVisitor >> window [

	^ window
]

{ #category : #accessing }
IPC2OSWindowEventVisitor >> window: anObject [

	window := anObject
]
