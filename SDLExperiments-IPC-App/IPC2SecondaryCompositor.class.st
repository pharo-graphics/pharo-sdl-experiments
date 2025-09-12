Class {
	#name : #IPC2SecondaryCompositor,
	#superclass : #IPC2DualProcessCompositor,
	#instVars : [
		'singleProcessCompositor',
		'pullEndpointByWindowId'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SDLExperiments-IPC-App'
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
IPC2SecondaryCompositor >> announceEvent: anEvent windowId: aWindowId [

	| eventCopy |
	eventCopy := anEvent copy.
	eventCopy window: nil.

	commandService sendCommandIgnoringResult:
		(IPC2EnqueueEventCommand new
			 windowId: aWindowId;
			 event: eventCopy;
			 yourself)
]

{ #category : #'window API' }
IPC2SecondaryCompositor >> destroyWindow: windowId [

	^ singleProcessCompositor destroyWindow: windowId
]

{ #category : #initialization }
IPC2SecondaryCompositor >> initialize [

	super initialize.

	singleProcessCompositor := IPC2SingleProcessCompositor new.
	
	pullEndpointByWindowId := Dictionary new
]

{ #category : #'window API' }
IPC2SecondaryCompositor >> newWindow: attributes [

	^ (singleProcessCompositor newWindow: attributes)
		compositor: self;
		yourself
]

{ #category : #'window API' }
IPC2SecondaryCompositor >> newWindow: attributes sceneTreeBytes: sceneTreeBytes [

	| pullEndpoint window |
	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: sceneTreeBytes readStream.
	pullEndpoint pull.

	window := (singleProcessCompositor newWindow: attributes)
		compositor: self;
		yourself.
	
	pullEndpointByWindowId at: window id put: pullEndpoint.
	
	^ window
]

{ #category : #'window API' }
IPC2SecondaryCompositor >> updateSceneGraph: bytes windowId: windowId [

	| aWindow pullEndpoint |
	aWindow := singleProcessCompositor windowAtId: windowId.
	pullEndpoint := pullEndpointByWindowId at: windowId.

	aWindow sceneTreeCritical: [
		| root |
		root := pullEndpoint
			stream: bytes readStream;
			pull;
			root.
		aWindow sceneTree: root ]
]
