Class {
	#name : #IPC2SecondaryCompositor,
	#superclass : #IPC2DualProcessCompositor,
	#instVars : [
		'singleProcessCompositor'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2SecondaryCompositor class >> current [

	^ current ifNil: [ current := self new ]
]

{ #category : #'class initialization' }
IPC2SecondaryCompositor class >> reset [
	
	current := nil
]

{ #category : #'window API' }
IPC2SecondaryCompositor >> destroyWindow: windowId [

	^ singleProcessCompositor destroyWindow: windowId
]

{ #category : #'window API' }
IPC2SecondaryCompositor >> enqueueEvent: anEvent windowId: aWindowId [

	| eventCopy |
	eventCopy := anEvent copy.
	eventCopy window: nil.

	commandService sendCommandIgnoringResult:
		(IPC2EnqueueEventCommand new
			 windowId: aWindowId;
			 event: eventCopy;
			 yourself)
]

{ #category : #initialization }
IPC2SecondaryCompositor >> initialize [

	super initialize.

	singleProcessCompositor := IPC2SingleProcessCompositor new
]

{ #category : #'window API' }
IPC2SecondaryCompositor >> newWindow: attributes [

	^ (singleProcessCompositor newWindow: attributes)
		compositor: self;
		yourself
]
