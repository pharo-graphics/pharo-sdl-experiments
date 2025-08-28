Class {
	#name : #IPCCompositor,
	#superclass : #Object,
	#instVars : [
		'commandService',
		'windows'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SDL-Experiments-App-Core'
}

{ #category : #accessing }
IPCCompositor class >> current [

	^ current ifNil: [ current := self new ]
]

{ #category : #'class initialization' }
IPCCompositor class >> reset [
	
	current := nil
]

{ #category : #accessing }
IPCCompositor >> commandService [

	^ commandService
]

{ #category : #'window API' }
IPCCompositor >> openWindow: aDemo [

	aDemo open.

	windows at: aDemo windowId put: aDemo
]

{ #category : #'life cycle' }
IPCCompositor >> startOn: socketStream [

	commandService := IPCCommandService on: socketStream.
	commandService start.
	

	windows := Dictionary new

]

{ #category : #'window API' }
IPCCompositor >> windowAt: aWindowId [

	^ windows at: aWindowId
]
