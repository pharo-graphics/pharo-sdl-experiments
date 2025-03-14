"
I'm an abstract R-Tree node that has rectangular bounds. 

My subclasses represent specific nodes that either have children nodes (non-leaf nodes) or an associated value (leaf nodes).
"
Class {
	#name : #IbNode,
	#superclass : #Object,
	#instVars : [
		'left',
		'top',
		'right',
		'bottom',
		'tree',
		'startIndex',
		'childrenCount'
	],
	#category : #'SDLExperiments-RTree-IndexBased'
}

{ #category : #'instance creation' }
IbNode class >> newIn: aTree startIndex: anIndex childrenCount: aChildrenCount [

	^ self basicNew
		initializeIn: aTree startIndex: anIndex childrenCount: aChildrenCount;
		yourself
]

{ #category : #accessing }
IbNode >> bottom [

	^ bottom
]

{ #category : #accessing }
IbNode >> bounds [

	^ Rectangle left: left right: right top: top bottom: bottom
]

{ #category : #accessing }
IbNode >> childrenCount [

	^ childrenCount
]

{ #category : #accessing }
IbNode >> childrenRectanglesDo: aBlock [

	self subclassResponsibility
]

{ #category : #testing }
IbNode >> containsPoint: aPoint [
	"Answer whether aPoint is within the receiver. Pay attention the self origin is considered less than but the corner is strict"

	^ self containsX: aPoint x y: aPoint y
]

{ #category : #testing }
IbNode >> containsX: x y: y [
	"Answer whether a point is within the receiver. Pay attention the self origin is considered less than but the corner is strict"

	x < left   ifTrue: [ ^ false ].
	y < top    ifTrue: [ ^ false ].
	x >= right  ifTrue: [ ^ false ].
	y >= bottom ifTrue: [ ^ false ].
	^ true
]

{ #category : #initialization }
IbNode >> initializeBounds [

	self childrenRectanglesDo: [ :each |
		left
			ifNil: [
				"First node"
				left   := each left.
				right  := each right.
				top    := each top.
				bottom := each bottom ]
			ifNotNil: [
				"Remaining nodes"
				each left < left     ifTrue: [ left := each left ].
				each right > right   ifTrue: [ right := each right ].
				each top < top       ifTrue: [ top := each top ].
				each bottom > bottom ifTrue: [ bottom := each bottom ] ] ]

]

{ #category : #initialization }
IbNode >> initializeIn: aTree startIndex: anIndex childrenCount: aChildrenCount [

	tree := aTree.
	startIndex := anIndex.
	childrenCount := aChildrenCount.
	
	self initializeBounds
]

{ #category : #testing }
IbNode >> intersects: aRectangle [
	"Answer whether aRectangle intersects the receiver anywhere."

	^ self
		intersectsLeft: aRectangle left
		top: aRectangle top
		right: aRectangle right
		bottom: aRectangle bottom
]

{ #category : #testing }
IbNode >> intersectsLeft: aLeft top: aTop right: aRight bottom: aBottom [

	aRight  <= left   ifTrue: [ ^ false ].
	aBottom <= top    ifTrue: [ ^ false ].
	aLeft   >= right  ifTrue: [ ^ false ].
	aTop    >= bottom ifTrue: [ ^ false ].
	^ true
]

{ #category : #accessing }
IbNode >> left [

	^ left
]

{ #category : #printing }
IbNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' bounds: ';
		print: self bounds.
	aStream
		nextPutAll: ' children: ';
		print: self childrenCount
]

{ #category : #accessing }
IbNode >> right [

	^ right
]

{ #category : #accessing }
IbNode >> top [

	^ top
]

{ #category : #enumerating }
IbNode >> valuesAtPoint: aPoint do: aBlock [

	self subclassResponsibility
]

{ #category : #enumerating }
IbNode >> valuesAtRectangle: aRectangle do: aBlock [

	self subclassResponsibility
]
