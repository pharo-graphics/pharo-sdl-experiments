Class {
	#name : #IPC2EnqueueEventCommand,
	#superclass : #IPC2Command,
	#instVars : [
		'windowId',
		'event'
	],
	#category : #'SDL-Experiments-App2'
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
IPC2EnqueueEventCommand >> value: aCommandService [

	| compositor |
	compositor := aCommandService owner.
	compositor announceEvent: event windowId: windowId
]

{ #category : #accessing }
IPC2EnqueueEventCommand >> windowId [

	^ windowId
]

{ #category : #accessing }
IPC2EnqueueEventCommand >> windowId: anObject [

	windowId := anObject
]
