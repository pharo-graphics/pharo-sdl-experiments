Class {
	#name : #IPC2CompositorListener,
	#superclass : #Object,
	#instVars : [
		'commandService',
		'compositor'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2CompositorListener class >> current [

	^ current ifNil: [ current := self new ]
]

{ #category : #'class initialization' }
IPC2CompositorListener class >> reset [
	
	current := nil
]

{ #category : #accessing }
IPC2CompositorListener >> commandService [

	^ commandService
]

{ #category : #'window API' }
IPC2CompositorListener >> openWindow: aTitle [

	| w | 
	w := compositor openWindow: aTitle.
	^ w id
]

{ #category : #'life cycle' }
IPC2CompositorListener >> startOn: socketStream [

	commandService := IPCCommandService on: socketStream.
	commandService start.
	compositor := IPC2Compositor new.	


]
