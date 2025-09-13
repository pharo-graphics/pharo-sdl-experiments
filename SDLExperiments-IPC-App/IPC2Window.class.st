Class {
	#name : #IPC2Window,
	#superclass : #IPC2AbstractWindow,
	#instVars : [
		'renderer',
		'osWindow',
		'osWindowAttributes',
		'renderingLoopProcess',
		'sceneTree',
		'sceneTreeMutex'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
IPC2Window >> attributes: aOSWindowAttributes [

	osWindowAttributes := aOSWindowAttributes
]

{ #category : #deleting }
IPC2Window >> basicDestroy [

	osWindow destroy.
	osWindow := nil
]

{ #category : #'instance creation' }
IPC2Window >> create [

	osWindow :=
		OSWindow
			createWithAttributes: osWindowAttributes
			eventHandler: self. "See #handleEvent:"
	osWindow focus. "Raise on top"
	
	renderer := osWindow newAthensRenderer.
	
	sceneTree := IPC2TreeNode new.
	sceneTreeMutex := Semaphore forMutualExclusion.
]

{ #category : #'api - event managing' }
IPC2Window >> handleEvent: anEvent [
	"We ignore the defaultAction and enqueue a copy of the event without the window (to avoid serializing it)"

	compositor announceEvent: anEvent windowId: self id
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

	renderer drawDuring: [ :canvas |
		self sceneTreeCritical: [
			sceneTree drawOnAthensCanvas: canvas ] ].

	renderer
		updateAll;
		present
]

{ #category : #'instance creation' }
IPC2Window >> renderAndWait [

	| startMS usedMS targetMS delayMS |
	targetMS := 100.
	startMS := Time millisecondClockValue.
	self render.
	usedMS := Time millisecondClockValue - startMS.
	
	delayMS := (targetMS - usedMS) max: 0.

	#renderAndWait trace. ' (ms): ' trace. usedMS traceCr.

	delayMS > 0 ifTrue: [
		(Delay forMilliseconds: delayMS) wait ]
]

{ #category : #accessing }
IPC2Window >> sceneTree [

	^ sceneTree
]

{ #category : #accessing }
IPC2Window >> sceneTree: aTreeNode [

	sceneTree := aTreeNode
]

{ #category : #drawing }
IPC2Window >> sceneTreeCritical: aBlock [

	sceneTreeMutex critical: aBlock
]

{ #category : #'instance creation' }
IPC2Window >> startRenderingLoop [

	renderingLoopProcess := [
		[ self renderAndWait ] doWhileTrue: [ osWindow notNil ]
		] forkAt: 41 named: 'Rendering loop ', self id asString
]
