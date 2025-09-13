Class {
	#name : #IPC2PaintApp,
	#superclass : #IPC2SimpleApp,
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #initialization }
IPC2PaintApp >> initialExtent [

	^ 300 asPoint
]

{ #category : #initialization }
IPC2PaintApp >> initializeWindow [

	| n extent aRTree |
	n := 30.
	extent := self initialExtent / n.
	
	0 to: n - 1 do: [ :x |
		0 to: n - 1 do: [ :y |
			| position leaf |
			position := (x * extent x) @ (y * extent y).
			leaf := IPC2TreeNode new
					shape: (position extent: extent);
					yourself.
			window sceneTree addChild: leaf ] ].

	aRTree := CrRTree
		new: window sceneTree childrenCount
		boundsBlock: [ :index | (window sceneTree childAt: index) shape ]
		valueBlock:  [ :index | window sceneTree childAt: index ].

	window eventAnnouncer
		when: OSMouseMoveEvent
		do: [ :event |
			aRTree
				valuesAtPoint: event position
				do: [ :node | node fillColor: Color random ] ]
		for: self
]
