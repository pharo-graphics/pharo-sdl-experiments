Class {
	#name : #IPC2SingleProcessCompositor,
	#superclass : #IPC2Compositor,
	#instVars : [
		'windows',
		'eventQueue',
		'eventSignalSemaphore'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #'window API' }
IPC2SingleProcessCompositor >> destroyWindow: id [

	| aWindow |
	aWindow := windows detect: [ :each | each id = id ].

	windows remove: aWindow.
	aWindow basicDestroy
]

{ #category : #'as yet unclassified' }
IPC2SingleProcessCompositor >> enqueueEvent: anEvent windowId: aWindowId [

	self flag: #todo. "do not ignore aWindowId?"
	eventQueue nextPut: anEvent.
	eventSignalSemaphore ifNotNil: [ eventSignalSemaphore signal ]
]

{ #category : #initialization }
IPC2SingleProcessCompositor >> initialize [

	super initialize.
	windows := OrderedCollection new.
	eventQueue := WaitfreeQueue new.
]

{ #category : #'window API' }
IPC2SingleProcessCompositor >> newWindow: aOSWindowAttributes [ 

	| aWindow |
	aWindow := IPC2Window new.
	windows add: aWindow.
	aWindow compositor: self.
	aWindow attributes: aOSWindowAttributes.
	aWindow create.
	^ aWindow
]

{ #category : #'as yet unclassified' }
IPC2SingleProcessCompositor >> pendingEvents [

	| theEvents |
	theEvents := OrderedCollection new.
	eventQueue flush: [ :anEvent | theEvents add: anEvent ].
	^ theEvents 
]

{ #category : #'debugging actions' }
IPC2SingleProcessCompositor >> terminate [

	windows
		select: [ :each | each isValid ]
		thenDo: [ :each | each destroy ].
	windows removeAll
]

{ #category : #'as yet unclassified' }
IPC2SingleProcessCompositor >> whenEventsSignal: aSemaphore [

	eventSignalSemaphore := aSemaphore
]
