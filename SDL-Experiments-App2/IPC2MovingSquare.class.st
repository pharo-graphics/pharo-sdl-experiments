Class {
	#name : #IPC2MovingSquare,
	#superclass : #Object,
	#instVars : [
		'compositor',
		'window'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #'instance creation' }
IPC2MovingSquare >> close [

	window destroy
]

{ #category : #accessing }
IPC2MovingSquare >> compositor: anIPC2Compositor [ 

	compositor := anIPC2Compositor.

]

{ #category : #'instance creation' }
IPC2MovingSquare >> open [
	window := compositor openWindow: 'Hola'.
]

{ #category : #accessing }
IPC2MovingSquare >> waitEvents [

	| sem | 
	sem := Semaphore new.
	compositor whenEventsSignal: sem.
	sem wait.
	^ compositor pendingEvents.
]
