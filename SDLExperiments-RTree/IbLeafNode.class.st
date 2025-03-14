"
I'm a R-Tree node that is considered a leaf in this particular implementation. 

Note: In the canonical definition of R-Tree, I shouldn't be considerer a leaf but a parent of leaves, i.e. a node with height=1, where my children are leaves, and I have at least one child.

The reason of this difference is an optimization (to avoid creation of real-leaf nodes).

"
Class {
	#name : #IbLeafNode,
	#superclass : #IbNode,
	#category : #'SDLExperiments-RTree-IndexBased'
}

{ #category : #accessing }
IbLeafNode >> childrenRectanglesAndValuesDo: aBlock [

	0 to: childrenCount - 1 do: [ :offset |
		| index |
		index := startIndex + offset.
		aBlock
			value: (tree itemRectangleAt: index)
			value: (tree itemValueAt: index) ]
]

{ #category : #private }
IbLeafNode >> childrenRectanglesDo: aBlock [

	0 to: childrenCount - 1 do: [ :offset |
		aBlock value: (tree itemRectangleAt: startIndex + offset) ]
]

{ #category : #enumerating }
IbLeafNode >> valuesAtPoint: aPoint do: aBlock [

	"Return early if my bounds don't contain the point"
	(self containsPoint: aPoint) ifFalse: [ ^ self ].

	"Evaluate block on each leaf that contains the point"
	self childrenRectanglesAndValuesDo: [ :eachBounds :eachValue |
		(eachBounds containsPoint: aPoint)
			ifTrue: [ aBlock value: eachValue ] ]
]

{ #category : #enumerating }
IbLeafNode >> valuesAtRectangle: aRectangle do: aBlock [

	"Return early if my bounds don't intersect the rectangle"
	(self intersects: aRectangle) ifFalse: [ ^ self ].

	"Evaluate the block on each leaf that intersects the rectangle"
	self childrenRectanglesAndValuesDo: [ :eachBounds :eachValue |
		(eachBounds intersects: aRectangle)
			ifTrue: [ aBlock value: eachValue ] ]
]
