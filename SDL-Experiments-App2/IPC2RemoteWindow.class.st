Class {
	#name : #IPC2RemoteWindow,
	#superclass : #IPC2AbstractWindow,
	#instVars : [
		'id'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #deleting }
IPC2RemoteWindow >> destroy [
	
	compositor destroyWindow: id
]

{ #category : #accessing }
IPC2RemoteWindow >> id [

	^ id
]

{ #category : #accessing }
IPC2RemoteWindow >> id: anId [

	id := anId
]

{ #category : #rendering }
IPC2RemoteWindow >> sceneTree: anObject [

	compositor updateSceneGraph: anObject windowId: id
]
