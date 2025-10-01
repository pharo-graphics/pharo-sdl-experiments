Class {
	#name : #IPC2EnqueueEventCommand,
	#superclass : #IPC2Command,
	#instVars : [
		'windowId',
		'event'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
IPC2EnqueueEventCommand >> event [

	^ event
]

{ #category : #accessing }
IPC2EnqueueEventCommand >> event: anObject [

	event := anObject
]

{ #category : #accessing }
IPC2EnqueueEventCommand >> value: primaryCompositor [

	primaryCompositor announceEvent: event windowId: windowId
]

{ #category : #accessing }
IPC2EnqueueEventCommand >> windowId [

	^ windowId
]

{ #category : #accessing }
IPC2EnqueueEventCommand >> windowId: anObject [

	windowId := anObject
]
