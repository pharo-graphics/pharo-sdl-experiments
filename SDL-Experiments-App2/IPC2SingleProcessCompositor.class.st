Class {
	#name : #IPC2SingleProcessCompositor,
	#superclass : #IPC2Compositor,
	#instVars : [
		'windows',
		'eventQueue'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #'as yet unclassified' }
IPC2SingleProcessCompositor >> announceEvent: anEvent windowId: aWindowId [

	| aWindow |
	aWindow := windows at: aWindowId.
	aWindow announceEvent: anEvent
]

{ #category : #'window API' }
IPC2SingleProcessCompositor >> destroyWindow: id [

	| aWindow |
	aWindow := windows removeKey: id ifAbsent: [ ^ self ].
	aWindow basicDestroy
]

{ #category : #initialization }
IPC2SingleProcessCompositor >> initialize [

	super initialize.
	windows := Dictionary new
]

{ #category : #'window API' }
IPC2SingleProcessCompositor >> newWindow: aOSWindowAttributes [ 

	| aWindow |
	aWindow := IPC2Window new.
	windows at: aWindow id put: aWindow.
	aWindow compositor: self.
	aWindow attributes: aOSWindowAttributes.
	aWindow create.
	aWindow startRenderingLoop.
	^ aWindow
]

{ #category : #'debugging actions' }
IPC2SingleProcessCompositor >> terminate [

	windows valuesDo: [ :each | each isValid ifTrue: [ each destroy ] ].
	windows removeAll
]

{ #category : #'as yet unclassified' }
IPC2SingleProcessCompositor >> windowAtId: id [

	^ windows at: id
]
