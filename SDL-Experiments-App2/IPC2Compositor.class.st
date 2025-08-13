Class {
	#name : #IPC2Compositor,
	#superclass : #Object,
	#instVars : [
		'windows',
		'whenEventDo',
		'eventQueue',
		'eventSignalSemaphore'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #initialization }
IPC2Compositor >> initialize [

	super initialize.
	windows := OrderedCollection new.
	eventQueue := WaitfreeQueue new.
]

{ #category : #'window API' }
IPC2Compositor >> openWindow: aString [ 
	
	| w |
	w := IPC2Window new.
	w compositor: self.
	windows add: w.
	w title: aString.
	w open.
	^ w
]

{ #category : #'as yet unclassified' }
IPC2Compositor >> pendingEvents [

	| theEvents |
	theEvents := OrderedCollection new.
	eventQueue flush: [ :anEvent | theEvents add: anEvent ].
	^ theEvents 
]

{ #category : #'as yet unclassified' }
IPC2Compositor >> sendEvent: anEvent [

	eventQueue nextPut: anEvent.
	eventSignalSemaphore ifNotNil: [ eventSignalSemaphore signal ]
]

{ #category : #'debugging actions' }
IPC2Compositor >> terminate [
	
	windows do: #destroy.
]

{ #category : #'as yet unclassified' }
IPC2Compositor >> whenEventsSignal: aSemaphore [

	eventSignalSemaphore := aSemaphore.
]
