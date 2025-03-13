"
I'm an RTree that is created with all required information, and then stays not mutable.

I don't implement add/remove after creation, since that would require a mechanism to re-balance.
"
Class {
	#name : #IbRTree,
	#superclass : #Object,
	#instVars : [
		'root',
		'minChildren',
		'maxChildren',
		'itemCount',
		'boundsBlock',
		'valueBlock',
		'nodes'
	],
	#category : #'SDLExperiments-RTree-IndexBased'
}

{ #category : #'instance creation' }
IbRTree class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock [
	"Answer a new instance with the default min and max children sizes for nodes. 
	These values were empirically determined to produce reasonable performance in most cases."

	^ self
		new: itemCount
		boundsBlock: boundsBlock
		valueBlock: valueBlock
		minChildren: 6
		maxChildren: 11
]

{ #category : #'instance creation' }
IbRTree class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock minChildren: aMin maxChildren: aMax [
	
	^ self basicNew
		initializeWith: itemCount
			boundsBlock: boundsBlock
			valueBlock: valueBlock
			minChildren: aMin
			maxChildren: aMax;
		yourself
]

{ #category : #'instance creation' }
IbRTree class >> withAll: aCollection [

	^ self
		new: aCollection size 
		boundsBlock: [ :index | aCollection at: index ]
		valueBlock: [ :index | index ]
]

{ #category : #accessing }
IbRTree >> bounds [

	^ root bounds
]

{ #category : #initialization }
IbRTree >> bulkLoadFrom: sourceStartIndex until: lastIndex do: aBlock [

	| remainder sourceIndex |
	remainder := lastIndex % maxChildren.
	remainder > 0 ifTrue: [
		"If the remainder isn't enough to fill a node, we'll add
		fewer children to other nodes."
		remainder := remainder >= minChildren
			ifTrue: [ 0 ]
			ifFalse: [ minChildren - remainder ] ].

	sourceIndex := sourceStartIndex.
	[ sourceIndex <= lastIndex ] whileTrue: [ 
		| nodeSize |

		"If need be, omit some nodes to make up for remainder"
		remainder = 0
			ifTrue: [ nodeSize := maxChildren ]
			ifFalse: [
				(remainder <= (maxChildren - minChildren))
					ifTrue: [
						nodeSize := maxChildren - remainder.
						remainder := 0 ]
					ifFalse: [
						nodeSize := minChildren.
						remainder := remainder - (maxChildren - minChildren) ] ].
		nodeSize := nodeSize min: (lastIndex - sourceIndex + 1).

		aBlock value: sourceIndex value: nodeSize.

		sourceIndex := sourceIndex + nodeSize ]
]

{ #category : #initialization }
IbRTree >> initializeWith: anItemCount boundsBlock: aBoundsBlock valueBlock: aValueBlock minChildren: aMin maxChildren: aMax [

	| startIndex endIndex |
	itemCount := anItemCount.
	boundsBlock := aBoundsBlock.
	valueBlock := aValueBlock.
	minChildren := aMin.
	maxChildren := aMax.

	nodes := OrderedCollection new.

	self bulkLoadFrom: 1 until: itemCount do: [  :sourceIndex :nodeSize |
		nodes addLast:
			(IbLeafNode
				newIn: self
				startIndex: sourceIndex
				childrenCount: nodeSize) ].

	startIndex := 1.
	endIndex := nodes size.
	[ startIndex < endIndex ] whileTrue: [

		self bulkLoadFrom: startIndex until: endIndex do: [  :sourceIndex :nodeSize |
			nodes addLast:
				(IbNonLeafNode
					newIn: self
					startIndex: sourceIndex
					childrenCount: nodeSize) ].
		
		startIndex := endIndex + 1.
		endIndex := nodes size.
"		1halt." ].
		
	root := nodes last
]

{ #category : #accessing }
IbRTree >> itemCount [

	^ itemCount
]

{ #category : #private }
IbRTree >> itemRectangleAt: itemIndex [

	^ boundsBlock value: itemIndex
]

{ #category : #private }
IbRTree >> itemValueAt: itemIndex [

	^ valueBlock value: itemIndex
]

{ #category : #accessing }
IbRTree >> nodeAt: index [
	
	^ nodes at: index
]

{ #category : #printing }
IbRTree >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: itemCount;
		nextPutAll: ' items)'
]

{ #category : #accessing }
IbRTree >> reset [

  root := nil
]

{ #category : #enumerating }
IbRTree >> valuesAtPoint: aPoint [
	
	^ Array streamContents: [ :stream |
		self
			valuesAtPoint: aPoint
			do: [ :each | stream nextPut: each ] ]
]

{ #category : #enumerating }
IbRTree >> valuesAtPoint: aPoint do: aBlock [

	^ root valuesAtPoint: aPoint do: aBlock
]

{ #category : #enumerating }
IbRTree >> valuesIntersecting: aRectangle [ 
	
	^ Array streamContents: [ :stream |
		self
			valuesIntersecting: aRectangle
			do: [ :eachValue | stream nextPut: eachValue ] ]
]

{ #category : #enumerating }
IbRTree >> valuesIntersecting: aRectangle do: aBlockClosure [

	^ root
		valuesIntersecting: aRectangle
		do: aBlockClosure
]
