Class {
	#name : #IPC2AbstractWindow,
	#superclass : #Object,
	#instVars : [
		'compositor'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #'event firing' }
IPC2AbstractWindow >> compositor [

	^ compositor
]

{ #category : #'event firing' }
IPC2AbstractWindow >> compositor: aCompositor [

	compositor := aCompositor 
]

{ #category : #'as yet unclassified' }
IPC2AbstractWindow >> destroy [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
IPC2AbstractWindow >> id [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
IPC2AbstractWindow >> sceneTree: anObject [ 
	^ self subclassResponsibility
]
