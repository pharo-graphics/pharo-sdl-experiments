Class {
	#name : #IPC2MovingSquareApp,
	#superclass : #IPC2SimpleApp,
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #'instance creation' }
IPC2MovingSquareApp >> initializeWindow [

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
