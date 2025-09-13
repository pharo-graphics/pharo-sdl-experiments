Class {
	#name : #IPC2App,
	#superclass : #Object,
	#instVars : [
		'compositor'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #'as yet unclassified' }
IPC2App class >> exampleDualProcess [
	"Tear down:

	app close.
	compositor terminate.
	"

	| compositor app |
	compositor := IPC2PrimaryCompositor new.
	compositor launchHeadless: true.

	app := IPC2MovingSquareApp new.
	app compositor: compositor.
	app open.
	
	app inspect.
	compositor inspect
]

{ #category : #'as yet unclassified' }
IPC2App class >> exampleSingleProcess [
	"Tear down:

	app close.
	compositor terminate.
	"

	| compositor app |
	compositor := IPC2SingleProcessCompositor new.

	app := IPC2MovingSquareApp new.
	app compositor: compositor.
	app open.
	
	app inspect.
	compositor inspect
]

{ #category : #'instance creation' }
IPC2App >> close [

	self subclassResponsibility
]

{ #category : #accessing }
IPC2App >> compositor [

	^ compositor
]

{ #category : #accessing }
IPC2App >> compositor: anIPC2Compositor [

	compositor := anIPC2Compositor
]

{ #category : #'instance creation' }
IPC2App >> open [

	self subclassResponsibility
]
