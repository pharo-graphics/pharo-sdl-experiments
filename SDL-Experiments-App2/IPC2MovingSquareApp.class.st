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
					fillColor: Color random;
					yourself).
			window sceneTree: window sceneTree ]
		for: self.
	
	window sceneTree:
		(IPC2TreeNode new
			shape: (0 @ 0 extent: self initialExtent);
			strokeWidth: 5;
			strokeColor: Color green;
			fillColor: Color blue;
			yourself)
]

{ #category : #accessing }
IPC2MovingSquareApp >> window [
	^ window
]
