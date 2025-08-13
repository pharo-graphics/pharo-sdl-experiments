Class {
	#name : #IPC2Compositor,
	#superclass : #Object,
	#instVars : [
		'windows',
		'eventQueue',
		'eventSignalSemaphore'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #'as yet unclassified' }
IPC2Compositor >> enqueueEvent: anEvent [

	eventQueue nextPut: anEvent.
	eventSignalSemaphore ifNotNil: [ eventSignalSemaphore signal ]
]

{ #category : #initialization }
IPC2Compositor >> initialize [

	super initialize.
	windows := OrderedCollection new.
	eventQueue := WaitfreeQueue new.
]

{ #category : #'window API' }
IPC2Compositor >> newWindow: aOSWindowAttributes [ 

	| aWindow |
	aWindow := IPC2Window new.
	windows add: aWindow.
	aWindow compositor: self.
	aWindow attributes: aOSWindowAttributes.
	aWindow create.
	^ aWindow
]

{ #category : #'as yet unclassified' }
IPC2Compositor >> pendingEvents [

	| theEvents |
	theEvents := OrderedCollection new.
	eventQueue flush: [ :anEvent | theEvents add: anEvent ].
	^ theEvents 
]

{ #category : #'debugging actions' }
IPC2Compositor >> terminate [

	windows
		select: [ :each | each isValid ]
		thenDo: [ :each | each destroy ].
	windows removeAll
]

{ #category : #'as yet unclassified' }
IPC2Compositor >> whenEventsSignal: aSemaphore [

	eventSignalSemaphore := aSemaphore.
]
