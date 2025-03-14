"
I am polymorphic with `CrRTree` but iterate all items to answer the queries.
"
Class {
	#name : #FakeRTree,
	#superclass : #Object,
	#instVars : [
		'itemCount',
		'boundsBlock',
		'valueBlock'
	],
	#category : #'SDLExperiments-RTree-FakeRTree'
}

{ #category : #'instance creation' }
FakeRTree class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock [ 

	^ self basicNew
		initializeWith: itemCount
			boundsBlock: boundsBlock
			valueBlock: valueBlock;
		yourself
]

{ #category : #'instance creation' }
FakeRTree class >> withAll: aCollection [

	^ self
		new: aCollection size 
		boundsBlock: [ :index | aCollection at: index ]
		valueBlock: [ :index | index ]
]

{ #category : #'instance creation' }
FakeRTree class >> withAllAssociations: aCollection [

	^ self
		new: aCollection size 
		boundsBlock: [ :index | (aCollection at: index) key ]
		valueBlock: [ :index | (aCollection at: index) value ]
]

{ #category : #accessing }
FakeRTree >> bounds [

	| result |
	result := boundsBlock value: 1.
	
	2 to: itemCount do: [ :index |
		result := result merge: (boundsBlock value: index) ].
	
	^ result
]

{ #category : #initialization }
FakeRTree >> initializeWith: anItemCount boundsBlock: aBoundsBlock valueBlock: aValueBlock [

	itemCount := anItemCount.
	boundsBlock := aBoundsBlock.
	valueBlock := aValueBlock
]

{ #category : #searching }
FakeRTree >> valuesAtPoint: aPoint [
	
	^ Array streamContents: [ :stream |
		self
			valuesAtPoint: aPoint
			do: [ :each | stream nextPut: each ] ]
]

{ #category : #enumerating }
FakeRTree >> valuesAtPoint: aPoint do: aBlock [

	1 to: itemCount do: [ :index |
		((boundsBlock value: index) containsPoint: aPoint)
			ifTrue: [ aBlock value: (valueBlock value: index) ] ]
]

{ #category : #searching }
FakeRTree >> valuesAtRectangle: aRectangle [ 
	
	^ Array streamContents: [ :stream |
		self
			valuesAtRectangle: aRectangle
			do: [ :eachValue | stream nextPut: eachValue ] ]
]

{ #category : #enumerating }
FakeRTree >> valuesAtRectangle: aRectangle do: aBlock [

	1 to: itemCount do: [ :index |
		((boundsBlock value: index) intersects: aRectangle)
			ifTrue: [ aBlock value: (valueBlock value: index) ] ]
]
