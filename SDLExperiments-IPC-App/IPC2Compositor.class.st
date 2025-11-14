Class {
	#name : #IPC2Compositor,
	#superclass : #Object,
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #testing }
IPC2Compositor class >> isAbstract [

	^ self == IPC2Compositor
]

{ #category : #'window API' }
IPC2Compositor >> announceEvent: anEvent windowId: aWindowId [

	self subclassResponsibility
]

{ #category : #'window API' }
IPC2Compositor >> destroyWindow: windowId [

	^ self subclassResponsibility
]

{ #category : #'window API' }
IPC2Compositor >> newWindow: aOSWindowAttributes [

	^ self subclassResponsibility
]

{ #category : #'life cycle' }
IPC2Compositor >> terminate [

	^ self subclassResponsibility
]

{ #category : #'window API' }
IPC2Compositor >> updateSceneGraph: update windowId: windowId [

	self subclassResponsibility
]
