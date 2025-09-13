Class {
	#name : #IPC2SimpleApp,
	#superclass : #IPC2App,
	#instVars : [
		'window'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #'instance creation' }
IPC2SimpleApp >> close [

	window ifNil: [ ^ self ].

	window destroy.
	window := nil
]

{ #category : #'instance creation' }
IPC2SimpleApp >> initialExtent [

	^ 400 @ 300
]

{ #category : #'instance creation' }
IPC2SimpleApp >> initializeWindow [

	self subclassResponsibility
]

{ #category : #'instance creation' }
IPC2SimpleApp >> newOSWindowAttributes [

	^ OSWindowAttributes new
		extent: self initialExtent;
		resizable: false;
		title: self className;
		position: 50 @ 100;
		yourself
]

{ #category : #'instance creation' }
IPC2SimpleApp >> open [

	window := compositor newWindow: self newOSWindowAttributes.

	window eventAnnouncer
		when: OSWindowCloseEvent
		send: #close to: self.

	self initializeWindow
]

{ #category : #accessing }
IPC2SimpleApp >> window [
	^ window
]
