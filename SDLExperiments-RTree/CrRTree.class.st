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

{ #category : #'instance creation' }
CrRTree class >> withAll: aCollection [

	^ (CrRTreeBulkLoadBuilder withAll: aCollection) rtree
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
