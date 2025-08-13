Class {
	#name : #IPC2RemoteWindow,
	#superclass : #Object,
	#instVars : [
		'id',
		'remoteCompositor'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2RemoteWindow >> id [

	^ id
]

{ #category : #accessing }
IPC2RemoteWindow >> id: anId [

	id := anId
]

{ #category : #accessing }
IPC2RemoteWindow >> remoteCompositor [

	^ remoteCompositor
]

{ #category : #accessing }
IPC2RemoteWindow >> remoteCompositor: anObject [

	remoteCompositor := anObject
]
