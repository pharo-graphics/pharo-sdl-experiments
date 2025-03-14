"
I am a RTree node that has one or more children nodes.
"
Class {
	#name : #CrNonLeafNode,
	#superclass : #CrNode,
	#type : #variable,
	#category : #'SDLExperiments-RTree'
}

{ #category : #'instance creation' }
CrNonLeafNode class >> newBulkLoadingFrom: aBuilder startAt: startIndex size: aSize [

	^ (self basicNew: aSize)
		bulkLoadFrom: aBuilder startAt: startIndex;
		yourself
]

{ #category : #initialization }
CrNonLeafNode >> bulkLoadFrom: sourceNodes startAt: startIndex [
		
	"First node"
	| firstNode |
	firstNode := sourceNodes nodeAt: startIndex.
	self at: 1 put: firstNode.

	left   := firstNode left.
	right  := firstNode right.
	top    := firstNode top.
	bottom := firstNode bottom.

	"Remaining nodes"
	2 to: self size do: [ :index |
		| aNode |
		aNode := sourceNodes nodeAt: startIndex + index - 1.
		self at: index put: aNode.

		aNode left < left     ifTrue: [ left := aNode left ].
		aNode right > right   ifTrue: [ right := aNode right ].
		aNode top < top       ifTrue: [ top := aNode top ].
		aNode bottom > bottom ifTrue: [ bottom := aNode bottom ] ]
]

{ #category : #accessing }
CrNonLeafNode >> childrenCount [

	^ self size
]

{ #category : #enumerating }
CrNonLeafNode >> childrenDo: aBlock [

	1 to: self size do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #printing }
CrNonLeafNode >> detailsColumnString [

	^ '({1} children)' format: { self childrenCount }
]

{ #category : #accessing }
CrNonLeafNode >> height [
	
	| maxChildrenHeight |
	maxChildrenHeight := 0.
	self childrenDo: [ :each | maxChildrenHeight := maxChildrenHeight max: each height ].
	^ 1 + maxChildrenHeight
]

{ #category : #printing }
CrNonLeafNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' children: ';
		print: self childrenCount
]

{ #category : #enumerating }
CrNonLeafNode >> valuesAtRectangle: aRectangle do: aBlock [
	
	(self intersects: aRectangle) ifFalse: [ ^self ].

	self childrenDo: [ :each |
		each valuesAtRectangle: aRectangle do: aBlock ]
]

{ #category : #enumerating }
CrNonLeafNode >> valuesAtX: x y: y do: aBlock [

	(self containsX: x y: y) ifFalse: [ ^ self ].

	self childrenDo: [ :each |
		each valuesAtX: x y: y do: aBlock ]
]
