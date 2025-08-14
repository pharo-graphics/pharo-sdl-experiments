Class {
	#name : #IPC2DualProcessCompositor,
	#superclass : #IPC2Compositor,
	#instVars : [
		'commandService'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #testing }
IPC2DualProcessCompositor class >> isAbstract [

	^ self == IPC2DualProcessCompositor
]

{ #category : #accessing }
IPC2DualProcessCompositor >> commandService [

	^ commandService
]

{ #category : #initialization }
IPC2DualProcessCompositor >> startCommandServiceOn: socketStream onSuccess: aBlock [

	commandService := IPCCommandService on: socketStream.
	commandService owner: self.
	commandService runningStartBlock: aBlock.
	commandService start
]

{ #category : #'as yet unclassified' }
IPC2DualProcessCompositor >> terminate [

	commandService ifNotNil: [
		commandService stop.
		commandService := nil ].

]
