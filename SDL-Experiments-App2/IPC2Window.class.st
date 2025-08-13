Class {
	#name : #IPC2Window,
	#superclass : #Object,
	#instVars : [
		'title',
		'compositor',
		'window',
		'renderer',
		'attributes'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2Window >> attributes: aOSWindowAttributes [

	attributes := aOSWindowAttributes
]

{ #category : #'event firing' }
IPC2Window >> compositor: aCompositor [

	compositor := aCompositor 
]

{ #category : #'instance creation' }
IPC2Window >> create [

	window :=
		OSWindow
			createWithAttributes: attributes
			eventHandler: (IPC2OSWindowEventVisitor new window: self; yourself).
	
	renderer := window newAthensRenderer
]

{ #category : #deleting }
IPC2Window >> destroy [

	window destroy
]

{ #category : #'event firing' }
IPC2Window >> enqueueEvent: anEvent [

	compositor enqueueEvent: anEvent
]

{ #category : #'instance creation' }
IPC2Window >> id [ 

	^ self identityHash 
]

{ #category : #testing }
IPC2Window >> isValid [

	^ window isValid
]
