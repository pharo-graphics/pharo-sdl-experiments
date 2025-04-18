"
I'm an abstract R-Tree node that has rectangular bounds. 

My subclasses represent specific nodes that either have children nodes (non-leaf nodes) or an associated value (leaf nodes).
"
Class {
	#name : #CrNode,
	#superclass : #Object,
	#instVars : [
		'left',
		'top',
		'right',
		'bottom'
	],
	#category : #'SDLExperiments-RTree-Classic'
}

{ #category : #accessing }
CrNode >> bottom [

	^ bottom
]

{ #category : #accessing }
CrNode >> bounds [

	^ Rectangle left: left right: right top: top bottom: bottom
]

{ #category : #enumerating }
CrNode >> children [

	^ Array new: self childrenCount streamContents: [ :stream |
		self childrenDo: [ :each | stream nextPut: each ]]
]

{ #category : #accessing }
CrNode >> childrenCount [

	^ self subclassResponsibility
]

{ #category : #enumerating }
CrNode >> childrenDepthFirstDo: aBlock [

	self childrenDo: [ :each |
		each childrenDepthFirstDo: aBlock ].
	aBlock value: self
]

{ #category : #enumerating }
CrNode >> childrenDo: aBlock [

	self subclassResponsibility
]

{ #category : #testing }
CrNode >> containsPoint: aPoint [
	"Answer whether aPoint is within the receiver. Pay attention the self origin is considered less than but the corner is strict"

	^ self containsX: aPoint x y: aPoint y
]

{ #category : #testing }
CrNode >> containsX: x y: y [
	"Answer whether a point is within the receiver. Pay attention the self origin is considered less than but the corner is strict"

	x < left   ifTrue: [ ^ false ].
	y < top    ifTrue: [ ^ false ].
	x >= right  ifTrue: [ ^ false ].
	y >= bottom ifTrue: [ ^ false ].
	^ true
]

{ #category : #printing }
CrNode >> detailsColumnString [

	^ self subclassResponsibility
]

{ #category : #accessing }
CrNode >> height [

	^ self subclassResponsibility
]

{ #category : #testing }
CrNode >> intersects: aRectangle [
	"Answer whether aRectangle intersects the receiver anywhere."

	^ self
		intersectsLeft: aRectangle left
		top: aRectangle top
		right: aRectangle right
		bottom: aRectangle bottom
]

{ #category : #testing }
CrNode >> intersectsLeft: aLeft top: aTop right: aRight bottom: aBottom [

	aRight  <= left   ifTrue: [ ^ false ].
	aBottom <= top    ifTrue: [ ^ false ].
	aLeft   >= right  ifTrue: [ ^ false ].
	aTop    >= bottom ifTrue: [ ^ false ].
	^ true
]

{ #category : #accessing }
CrNode >> left [

	^ left
]

{ #category : #printing }
CrNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' bounds: ';
		print: self bounds
]

{ #category : #accessing }
CrNode >> right [

	^ right
]

{ #category : #accessing }
CrNode >> top [

	^ top
]

{ #category : #enumerating }
CrNode >> valuesAtPoint: aPoint do: aBlock [

	self valuesAtX: aPoint x y: aPoint y do: aBlock
]

{ #category : #enumerating }
CrNode >> valuesAtRectangle: aRectangle do: aBlock [

	self subclassResponsibility
]

{ #category : #enumerating }
CrNode >> valuesAtX: x y: y do: aBlock [

	self subclassResponsibility
]
