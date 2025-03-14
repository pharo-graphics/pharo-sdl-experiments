"
I'm a R-Tree node.
"
Class {
	#name : #IbNonLeafNode,
	#superclass : #IbNode,
	#category : #'SDLExperiments-RTree-IndexBased'
}

{ #category : #private }
IbNonLeafNode >> childrenDo: aBlock [

	0 to: childrenCount - 1 do: [ :offset |
		aBlock value: (tree nodeAt: startIndex + offset) ]
]

{ #category : #enumerating }
IbNonLeafNode >> childrenRectanglesDo: aBlock [

	"NOTE: For optimization purposes, we evaluate directly on nodes, as
	they are polymorphic with Rectangle (we avoid creation of a Rectangle)"
	self childrenDo: [ :each | aBlock value: each "bounds" ]
]

{ #category : #enumerating }
IbNonLeafNode >> valuesAtPoint: aPoint do: aBlock [

	"Return early if my bounds don't contain the point"
	(self containsPoint: aPoint) ifFalse: [ ^ self ].

	"Send recursively on each child"
	self childrenDo: [ :each |
		each valuesAtPoint: aPoint do: aBlock ]
]

{ #category : #enumerating }
IbNonLeafNode >> valuesAtRectangle: aRectangle do: aBlock [

	"Return early if my bounds don't intersect the rectangle"
	(self intersects: aRectangle) ifFalse: [ ^ self ].

	"Send recursively on each child"
	self childrenDo: [ :each |
		each valuesAtRectangle: aRectangle do: aBlock ]
]
