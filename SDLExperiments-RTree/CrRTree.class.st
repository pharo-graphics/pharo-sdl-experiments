"
I'm a collection where each item is composed of an Object (the value) associated with a Rectangle (the key).
"
Class {
	#name : #CrRTree,
	#superclass : #Object,
	#instVars : [
		'root'
	],
	#category : #'SDLExperiments-RTree'
}

{ #category : #accessing }
CrRTree class >> root: aNode [

	^ self basicNew
		initializeWith: aNode;
		yourself
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
CrRTree >> initializeWith: aRootNode [

	self initialize.
	
	root := aRootNode
]

{ #category : #initialization }
CrRTree >> initializeWith: anItemCount boundsBlock: boundsBlock valueBlock: valueBlock minChildren: aMin maxChildren: aMax [
	"Create the structure from the leaves. Override the input
	collection with new non-leaf nodes."

	| leaves lastIndex |
	minChildren := aMin.
	maxChildren := aMax.
	itemCount := anItemCount.

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

{ #category : #accessing }
CrRTree >> itemCount [

	^ itemCount
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

{ #category : #searching }
CrRTree >> valuesAtPoint: aPoint do: aBlock [

	^ root valuesAtX: aPoint x y: aPoint y do: aBlock
]

{ #category : #searching }
CrRTree >> valuesAtRectangle: aRectangle do: aBlockClosure [

	^ root
		valuesAtRectangle: aRectangle
		do: aBlockClosure
]
