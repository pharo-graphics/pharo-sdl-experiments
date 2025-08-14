Class {
	#name : #IPC2Window,
	#superclass : #Object,
	#instVars : [
		'compositor',
		'renderer',
		'osWindow',
		'osWindowAttributes'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2Window >> attributes: aOSWindowAttributes [

	osWindowAttributes := aOSWindowAttributes
]

{ #category : #deleting }
IPC2Window >> basicDestroy [

	osWindow destroy
]

{ #category : #'event firing' }
IPC2Window >> compositor [

	^ compositor
]

{ #category : #'event firing' }
IPC2Window >> compositor: aCompositor [

	compositor := aCompositor 
]

{ #category : #'instance creation' }
IPC2Window >> create [

	osWindow :=
		OSWindow
			createWithAttributes: osWindowAttributes
			eventHandler: self. "See #handleEvent:"
	
	renderer := osWindow newAthensRenderer
]

{ #category : #deleting }
IPC2Window >> destroy [
	
	compositor destroyWindow: self id
]

{ #category : #'api - event managing' }
IPC2Window >> handleEvent: anEvent [
	"We ignore the defaultAction and enqueue a copy of the event without the window (to avoid serializing it)"

	compositor enqueueEvent: anEvent windowId: self id
]

{ #category : #'instance creation' }
IPC2Window >> id [ 

	^ self identityHash 
]

{ #category : #testing }
IPC2Window >> isValid [

	^ osWindow isValid
]
