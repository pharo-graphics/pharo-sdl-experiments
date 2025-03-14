"
I'm a substitute of `CrLeafNode` that holds the original `Rectangle` instead of embedding its 4 values.
"
Class {
	#name : #CrLightLeafNode,
	#superclass : #Object,
	#instVars : [
		'rectangle',
		'value'
	],
	#category : #'SDLExperiments-RTree-Classic'
}

{ #category : #'instance creation' }
CrLightLeafNode class >> bounds: aBounds value: anObject [

	^ self basicNew
		initializeWith: anObject bounds: aBounds;
		yourself
]

{ #category : #accessing }
CrLightLeafNode >> bottom [

	^ rectangle bottom
]

{ #category : #accessing }
CrLightLeafNode >> bounds [
	
	^ rectangle
]

{ #category : #accessing }
CrLightLeafNode >> childrenCount [

	^ 0
]

{ #category : #enumerating }
CrLightLeafNode >> childrenDepthFirstDo: aBlock [

	aBlock value: self
]

{ #category : #testing }
CrLightLeafNode >> containsX: x y: y [
	"Answer whether a point is within the receiver. Pay attention the self origin is considered less than but the corner is strict"

	x < rectangle left   ifTrue: [ ^ false ].
	y < rectangle top    ifTrue: [ ^ false ].
	x >= rectangle right  ifTrue: [ ^ false ].
	y >= rectangle bottom ifTrue: [ ^ false ].
	^ true
]

{ #category : #initialization }
CrLightLeafNode >> initializeWith: anObject bounds: aBounds [

	value := anObject.
	rectangle := aBounds
]

{ #category : #accessing }
CrLightLeafNode >> left [

	^ rectangle left
]

{ #category : #accessing }
CrLightLeafNode >> right [

	^ rectangle right
]

{ #category : #accessing }
CrLightLeafNode >> top [

	^ rectangle top
]

{ #category : #enumerating }
CrLightLeafNode >> valuesAtPoint: aPoint do: aBlock [

	self valuesAtX: aPoint x y: aPoint y do: aBlock
]

{ #category : #enumerating }
CrLightLeafNode >> valuesAtRectangle: aRectangle do: aBlock [ 

	(rectangle intersects: aRectangle) ifFalse: [ ^ self ].

	aBlock value: value
]

{ #category : #enumerating }
CrLightLeafNode >> valuesAtX: x y: y do: aBlock [

	(self containsX: x y: y) ifFalse: [ ^ self ].

	aBlock value: value
]
