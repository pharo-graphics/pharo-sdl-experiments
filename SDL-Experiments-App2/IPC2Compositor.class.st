Class {
	#name : #IPC2Compositor,
	#superclass : #Object,
	#category : #'SDL-Experiments-App2'
}

{ #category : #testing }
IPC2Compositor class >> isAbstract [

	^ self == IPC2Compositor
]

{ #category : #'window API' }
IPC2Compositor >> destroyWindow: windowId [

	^ self subclassResponsibility
]

{ #category : #'window API' }
IPC2Compositor >> enqueueEvent: anEvent windowId: aWindowId [

	self subclassResponsibility
]

{ #category : #'window API' }
IPC2Compositor >> newWindow: aOSWindowAttributes [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
IPC2Compositor >> terminate [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
IPC2Compositor >> updateSceneGraph: update windowId: windowId [

	self subclassResponsibility
]
