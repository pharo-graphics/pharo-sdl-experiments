Class {
	#name : #IPC2EventHandler,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'window'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #visiting }
IPC2EventHandler >> visitWindowCloseEvent: anEvent [

	anEvent suppressDefaultAction.
	window sendEvent: IPC2WindowCloseEvent new

]

{ #category : #accessing }
IPC2EventHandler >> window [

	^ window
]

{ #category : #accessing }
IPC2EventHandler >> window: anObject [

	window := anObject
]
