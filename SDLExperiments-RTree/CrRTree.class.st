"
I'm a collection where each item is composed of an Object (the value) associated with a Rectangle (the key).
"
Class {
	#name : #CrRTree,
	#superclass : #RectangleKeyDictionary,
	#instVars : [
		'root'
	],
	#category : #'SDLExperiments-RTree-Classic'
}

{ #category : #'instance creation' }
CrRTree class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock [

	^ (CrRTreeBulkLoadBuilder
		   new: itemCount
		   boundsBlock: boundsBlock
		   valueBlock: valueBlock) rtree
]

{ #category : #'instance creation' }
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

{ #category : #accessing }
CrRTree >> height [
	
	^ root height
]

{ #category : #initialization }
CrRTree >> initializeWith: aRootNode [

	self initialize.
	
	root := aRootNode
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
	"Inefficient"

	| result |
	result := 0.
	root childrenDepthFirstDo: [ :each |
		each childrenCount = 0 ifTrue: [ result := result + 1 ] ].
	^ result
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

	^ root valuesAtPoint: aPoint do: aBlock
]

{ #category : #searching }
CrRTree >> valuesAtRectangle: aRectangle do: aBlockClosure [

	^ root
		valuesAtRectangle: aRectangle
		do: aBlockClosure
]
