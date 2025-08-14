Class {
	#name : #IPC2OSWindowEventVisitor,
	#superclass : #OSWindowEventVisitor,
	#instVars : [
		'window'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #events }
IPC2OSWindowEventVisitor >> handleEvent: anEvent [
	"We ignore the defaultAction and enqueue a copy of the event without the window (to avoid serializing it)"

	window compositor enqueueEvent: anEvent windowId: window id
]

{ #category : #accessing }
IPC2OSWindowEventVisitor >> window [

	^ window
]

{ #category : #accessing }
IPC2OSWindowEventVisitor >> window: anObject [

	window := anObject
]
