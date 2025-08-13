Class {
	#name : #IPC2MovingSquareApp,
	#superclass : #Object,
	#instVars : [
		'compositor',
		'window'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #'instance creation' }
IPC2MovingSquareApp >> close [

	window destroy
]

{ #category : #accessing }
IPC2MovingSquareApp >> compositor: anIPC2Compositor [

	compositor := anIPC2Compositor
]

{ #category : #'instance creation' }
IPC2MovingSquareApp >> newOSWindowAttributes [

	^ OSWindowAttributes new
		extent: 400@300;
		resizable: false;
		title: 'Hola ', self className;
		position: 100@100;
		yourself
]

{ #category : #'instance creation' }
IPC2MovingSquareApp >> open [

	window := compositor newWindow: self newOSWindowAttributes
]

{ #category : #accessing }
IPC2MovingSquareApp >> waitEvents [

	| semaphore |
	semaphore := Semaphore new.
	compositor whenEventsSignal: semaphore.
	semaphore wait.
	^ compositor pendingEvents
]
