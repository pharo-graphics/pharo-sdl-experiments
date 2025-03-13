"
I'm an RTree that is not mutable.

Inspired on Chrome's C++ implementation in rtree.h:
```
// The following description and most of the implementation is borrowed from
// Skia's SkRTree implementation.
//
// An R-Tree implementation. In short, it is a balanced n-ary tree containing a
// hierarchy of bounding rectangles.
//
// It only supports bulk-loading, i.e. creation from a batch of bounding
// rectangles. This performs a bottom-up bulk load using the STR
// (sort-tile-recursive) algorithm.
//
// Things to do: Experiment with other bulk-load algorithms (in particular the
// Hilbert pack variant, which groups rects by position on the Hilbert curve, is
// probably worth a look). There also exist top-down bulk load variants
// (VAMSplit, TopDownGreedy, etc).
//
// For more details see:
//
//  Beckmann, N.; Kriegel, H. P.; Schneider, R.; Seeger, B. (1990).
//  ""The R*-tree: an efficient and robust access method for points and
//  rectangles""
```

"
Class {
	#name : #CrRTree,
	#superclass : #Object,
	#instVars : [
		'root',
		'minChildren',
		'maxChildren'
	],
	#category : #'SDLExperiments-RTree-Classic'
}

{ #category : #'instance creation' }
CrRTree class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock [
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
CrRTree class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock minChildren: aMin maxChildren: aMax [
	
	^ self basicNew
		initializeWith: itemCount
			boundsBlock: boundsBlock
			valueBlock: valueBlock
			minChildren: aMin
			maxChildren: aMax;
		yourself
]

{ #category : #'instance creation' }
CrRTree class >> withAll: aCollection [

	^ self
		new: aCollection size 
		boundsBlock: [ :index | aCollection at: index ]
		valueBlock: [ :index | index ]
]

{ #category : #accessing }
CrRTree >> allNodes [

	| result |
	result := OrderedCollection new.
	root childrenDepthFirstDo: [ :each | result add: each ].
	^ result
]

{ #category : #accessing }
CrRTree >> bounds [

	^ root bounds
]

{ #category : #initialization }
CrRTree >> bulkLoad: leaves until: lastIndex [

	| remainder sourceIndex targetIndex |
	remainder := lastIndex % maxChildren.
	remainder > 0 ifTrue: [
		"If the remainder isn't enough to fill a node, we'll add
		fewer children to other nodes."
		remainder := remainder >= minChildren
			ifTrue: [ 0 ]
			ifFalse: [ minChildren - remainder ] ].

	sourceIndex := 1.
	targetIndex := 1.
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

		leaves
			at: targetIndex
			put:
				(CrNonLeafNode
					newFrom: leaves
					startAt: sourceIndex
					size: nodeSize).

		sourceIndex := sourceIndex + nodeSize.
		targetIndex := targetIndex + 1 ].
	
	^ targetIndex - 1
]

{ #category : #accessing }
CrRTree >> height [
	
	^ root height
]

{ #category : #initialization }
CrRTree >> initializeWith: itemCount boundsBlock: boundsBlock valueBlock: valueBlock minChildren: aMin maxChildren: aMax [
	"Create the structure from the leaves. Override the input
	collection with new non-leaf nodes."

	| leaves lastIndex |
	minChildren := aMin.
	maxChildren := aMax.

	leaves := Array new: itemCount.
	1 to: itemCount do: [ :index |
		leaves
			at: index
			put:
				(CrLeafNode
					bounds: (boundsBlock value: index)
					value: (valueBlock value: index)) ].

	lastIndex := itemCount.

	[ lastIndex > 1 ] whileTrue: [
	 	lastIndex := self bulkLoad: leaves until: lastIndex ].

	root := leaves first
]

{ #category : #inspector }
CrRTree >> inspectionTree: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Nodes'>

	^ aBuilder newTreeTable
		roots: { root };
		children: [ :each | each children ];
		addColumn: (SpStringTableColumn title: 'bounds' evaluated: [ :each | each bounds ]);
		addColumn: (SpStringTableColumn title: 'details' evaluated: [ :each | each detailsColumnString ]);
		expandAll;
		yourself

]

{ #category : #searching }
CrRTree >> intersectionAt: aRectangle [ 
	
	^ Array streamContents: [ :stream |
		self
			intersectionAt: aRectangle
			do: [ :each | stream nextPut: each ] ]
]

{ #category : #searching }
CrRTree >> intersectionAt: aRectangle do: aBlockClosure [

	^ root
		intersectionAt: aRectangle
		do: aBlockClosure
]

{ #category : #accessing }
CrRTree >> nodeCount [

	| count |
	count := 0.
	root childrenDepthFirstDo: [ :each | count := count + 1 ].
	^ count
]

{ #category : #printing }
CrRTree >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self nodeCount;
		nextPutAll: ' nodes; ';
		print: self height;
		nextPutAll: ' height)'
]

{ #category : #accessing }
CrRTree >> reset [

  root := nil
]

{ #category : #searching }
CrRTree >> valuesAtPoint: aPoint [
	
	^ Array streamContents: [ :stream |
		self
			valuesAtPoint: aPoint
			do: [ :each | stream nextPut: each ] ]
]

{ #category : #searching }
CrRTree >> valuesAtPoint: aPoint do: aBlock [

	^ root valuesAtX: aPoint x y: aPoint y do: aBlock
]
