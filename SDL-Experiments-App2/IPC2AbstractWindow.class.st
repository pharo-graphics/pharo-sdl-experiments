Class {
	#name : #IPC2AbstractWindow,
	#superclass : #Object,
	#instVars : [
		'compositor',
		'eventAnnouncer',
		'sceneTree'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2AbstractWindow >> announceEvent: anEvent [

	eventAnnouncer announce: anEvent
]

{ #category : #accessing }
IPC2AbstractWindow >> compositor [

	^ compositor
]

{ #category : #accessing }
IPC2AbstractWindow >> compositor: aCompositor [

	compositor := aCompositor 
]

{ #category : #deleting }
IPC2AbstractWindow >> destroy [
	
	compositor destroyWindow: self id
]

{ #category : #accessing }
IPC2AbstractWindow >> eventAnnouncer [

	^ eventAnnouncer
]

{ #category : #accessing }
IPC2AbstractWindow >> id [
	^ self subclassResponsibility
]

{ #category : #initialization }
IPC2AbstractWindow >> initialize [

	eventAnnouncer := Announcer new
]

{ #category : #accessing }
IPC2AbstractWindow >> sceneTree [

	^ sceneTree
]

{ #category : #accessing }
IPC2AbstractWindow >> sceneTree: anObject [

	sceneTree := anObject
]
