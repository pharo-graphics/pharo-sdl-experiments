Class {
	#name : #IPC2Window,
	#superclass : #IPC2AbstractWindow,
	#instVars : [
		'renderer',
		'osWindow',
		'osWindowAttributes',
		'sceneTree',
		'renderDeferrer'
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

{ #category : #'instance creation' }
IPC2Window >> create [

	osWindow :=
		OSWindow
			createWithAttributes: osWindowAttributes
			eventHandler: self. "See #handleEvent:"
	
	renderer := osWindow newAthensRenderer.
	
	renderDeferrer := MinMaxDeferrer
		value: (MessageSend receiver: self selector: #render)
		minMSDeferral: 5
		maxMSDeferral: 25
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

{ #category : #drawing }
IPC2Window >> render [

	sceneTree ifNotNil: [
		renderer drawDuring: [ :canvas |
			sceneTree drawOnAthensCanvas: canvas ] ].

	renderer
		updateAll;
		present
]

{ #category : #accessing }
IPC2Window >> sceneTree [
	^ sceneTree
]

{ #category : #rendering }
IPC2Window >> sceneTree: anObject [

	sceneTree := anObject.
	renderDeferrer schedule
]
