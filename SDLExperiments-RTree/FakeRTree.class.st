"
I am polymorphic with `CrRTree` but iterate all items to answer the queries.
"
Class {
	#name : #FakeRTree,
	#superclass : #RectangleKeyDictionary,
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

{ #category : #accessing }
FakeRTree >> itemCount [

	^ itemCount
]

{ #category : #enumerating }
FakeRTree >> valuesAtPoint: aPoint do: aBlock [

	1 to: itemCount do: [ :index |
		((boundsBlock value: index) containsPoint: aPoint)
			ifTrue: [ aBlock value: (valueBlock value: index) ] ]
]

{ #category : #enumerating }
FakeRTree >> valuesAtRectangle: aRectangle do: aBlock [

	1 to: itemCount do: [ :index |
		((boundsBlock value: index) intersects: aRectangle)
			ifTrue: [ aBlock value: (valueBlock value: index) ] ]
]
