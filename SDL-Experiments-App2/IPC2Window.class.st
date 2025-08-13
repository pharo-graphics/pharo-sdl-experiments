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

{ #category : #'event firing' }
IPC2Window >> compositor: aCompositor [

	compositor := aCompositor 
]

{ #category : #deleting }
IPC2Window >> destroy [

	window destroy
]

{ #category : #'instance creation' }
IPC2Window >> id [ 

	^ self identityHash 
]

{ #category : #testing }
IPC2Window >> isValid [

	^ window isValid
]

{ #category : #'instance creation' }
IPC2Window >> open [
	| attrs |
	attrs := OSWindowAttributes new.
	attrs
		extent: 400@300;
		resizable: false;
		title: title;
		position: 100@100.

	window :=
		OSWindow
			createWithAttributes: attrs
			eventHandler: (IPC2EventHandler new window: self; yourself).
	
	renderer := window newAthensRenderer.

]

{ #category : #'event firing' }
IPC2Window >> sendEvent: anEvent [

	compositor sendEvent: anEvent
]

{ #category : #accessing }
IPC2Window >> title: aValue [

	title := aValue.
]
