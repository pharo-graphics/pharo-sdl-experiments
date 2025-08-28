Class {
	#name : #IPC2UpdateSceneGraphCommand,
	#superclass : #IPC2Command,
	#instVars : [
		'windowId',
		'content'
	],
	#category : #'SDL-Experiments-App2'
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

	| compositor |
	compositor := aCommandService owner.
	compositor updateSceneGraph: content windowId: windowId
]

{ #category : #accessing }
IPC2UpdateSceneGraphCommand >> windowId [

	^ windowId
]

{ #category : #accessing }
IPC2UpdateSceneGraphCommand >> windowId: anObject [

	windowId := anObject
]
