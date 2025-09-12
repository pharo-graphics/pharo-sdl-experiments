Class {
	#name : #IPC2AbstractWindow,
	#superclass : #Object,
	#instVars : [
		'compositor',
		'eventAnnouncer'
	],
	#category : #'SDLExperiments-IPC'
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
