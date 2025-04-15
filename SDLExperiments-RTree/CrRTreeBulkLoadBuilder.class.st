"
I build R-Tree instances using a bulk-load algorithm.

This is inspired on Chrome's C++ implementation in rtree.h:
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
	#name : #CrRTreeBulkLoadBuilder,
	#superclass : #Object,
	#instVars : [
		'itemCount',
		'boundsBlock',
		'valueBlock',
		'nodesBuffer',
		'minChildren',
		'maxChildren',
		'rtree'
	],
	#category : #'SDLExperiments-RTree-Classic'
}

{ #category : #'instance creation' }
CrRTreeBulkLoadBuilder class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock [
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
CrRTreeBulkLoadBuilder class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock minChildren: aMin maxChildren: aMax [
	
	^ self basicNew
		initializeWith: itemCount
			boundsBlock: boundsBlock
			valueBlock: valueBlock
			minChildren: aMin
			maxChildren: aMax;
		yourself
]

{ #category : #initialization }
CrRTreeBulkLoadBuilder >> bulkLoadUntil: lastIndex [

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

		nodesBuffer
			at: targetIndex
			put:
				(CrNonLeafNode
					newBulkLoadingFrom: self
					startAt: sourceIndex
					size: nodeSize).

		sourceIndex := sourceIndex + nodeSize.
		targetIndex := targetIndex + 1 ].
	
	^ targetIndex - 1
]

{ #category : #initialization }
CrRTreeBulkLoadBuilder >> initializeWith: anItemCount boundsBlock: aBoundsBlock valueBlock: aValueBlock minChildren: aMin maxChildren: aMax [
	"Create the structure from the leaves. Override the input
	collection with new non-leaf nodes."

	| lastIndex |
	"Prepare a buffer that is as large as it could be needed"
	nodesBuffer := Array new: (anItemCount / aMin) ceiling.
	
	itemCount := anItemCount.
	boundsBlock := aBoundsBlock.
	valueBlock := aValueBlock.
	minChildren := aMin.
	maxChildren := aMax.

	"Iterate until all items are loaded"
	lastIndex := itemCount.
	[ lastIndex > 1 ] whileTrue: [
	 	lastIndex := self bulkLoadUntil: lastIndex ].

	"DONE"
	rtree := CrRTree root: (self nodeAt: 1)
]

{ #category : #accessing }
CrRTreeBulkLoadBuilder >> nodeAt: index [

	| node |
	^ (index > nodesBuffer size or: [ (node := nodesBuffer at: index) isNil ])
		ifTrue: [ 
			"You can change by the alternative"
			self flag: #CrLightLeafNode.
			CrLeafNode
				bounds: (boundsBlock value: index)
				value: (valueBlock value: index) ]
		ifFalse: [ node ]
]

{ #category : #accessing }
CrRTreeBulkLoadBuilder >> rtree [

	^ rtree
]
