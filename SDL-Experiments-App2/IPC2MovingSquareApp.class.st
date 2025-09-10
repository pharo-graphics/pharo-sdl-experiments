Class {
	#name : #IPC2MovingSquareApp,
	#superclass : #Object,
	#instVars : [
		'compositor',
		'window'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #'as yet unclassified' }
IPC2MovingSquareApp class >> exampleDualProcess [
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
IPC2MovingSquareApp class >> exampleSingleProcess [
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
IPC2MovingSquareApp >> close [

	window ifNil: [ ^ self ].

	window destroy.
	window := nil
]

{ #category : #accessing }
IPC2MovingSquareApp >> compositor: anIPC2Compositor [

	compositor := anIPC2Compositor
]

{ #category : #'instance creation' }
IPC2MovingSquareApp >> initialExtent [

	^ 400 @ 300
]

{ #category : #'instance creation' }
IPC2MovingSquareApp >> newOSWindowAttributes [

	^ OSWindowAttributes new
		extent: self initialExtent;
		resizable: false;
		title: 'Hola ', self className;
		position: 50 @ 100;
		yourself
]

{ #category : #'instance creation' }
IPC2MovingSquareApp >> open [

	window := compositor newWindow: self newOSWindowAttributes.

	window eventAnnouncer
		when: OSWindowCloseEvent
		send: #close to: self.

	window eventAnnouncer
		when: OSMouseButtonPressEvent
		do: [ :event |
			window sceneTree addChild: 
				(IPC2TreeNode new
					shape: (event position extent: 50 @ 50);
					strokeWidth: 2;
					strokeColor: Color random;
					fillColor: Color random;
					yourself) ]
		for: self.
	
	window sceneTree
		shape: (0 @ 0 extent: self initialExtent);
		fillColor: Color blue muchDarker
]

{ #category : #accessing }
IPC2MovingSquareApp >> window [
	^ window
]
