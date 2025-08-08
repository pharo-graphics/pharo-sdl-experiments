Class {
	#name : #IPCWindowServer,
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
IPCWindowServer class >> current [

	^ current ifNil: [ current := self new ]
]

{ #category : #'class initialization' }
IPCWindowServer class >> reset [
	
	current := nil
]

{ #category : #accessing }
IPCWindowServer >> commandService [

	^ commandService
]

{ #category : #'window API' }
IPCWindowServer >> openWindow: aDemo [

	aDemo open.

	windows at: aDemo windowId put: aDemo
]

{ #category : #'life cycle' }
IPCWindowServer >> startOn: socketStream [

	commandService := IPCCommandService on: socketStream.
	commandService start.
	

	windows := Dictionary new

]

{ #category : #'window API' }
IPCWindowServer >> windowAt: aWindowId [

	^ windows at: aWindowId
]
