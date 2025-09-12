Class {
	#name : #IPC2UpdateSceneGraphCommand,
	#superclass : #IPC2SecondaryCompositorCommand,
	#instVars : [
		'windowId',
		'content'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
IPC2UpdateSceneGraphCommand >> content [

	^ content
]

{ #category : #accessing }
IPC2UpdateSceneGraphCommand >> content: anObject [

	content := anObject
]

{ #category : #accessing }
IPC2UpdateSceneGraphCommand >> value: aCommandService [

	| secondaryCompositor |
	secondaryCompositor := aCommandService owner.
	secondaryCompositor updateSceneGraph: content windowId: windowId
]

{ #category : #accessing }
IPC2UpdateSceneGraphCommand >> windowId [

	^ windowId
]

{ #category : #accessing }
IPC2UpdateSceneGraphCommand >> windowId: anObject [

	windowId := anObject
]
