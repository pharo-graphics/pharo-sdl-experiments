"
I am a mutable representation a tree node.

My children are also mutable nodes. However, I point to a completed shot which is an immutable object, that points to immutable children nodes.

Most of my accessors redirect to the activeShot variable. When a mutator has to change a value, the completed shot is replaced with a draft copy that has the new value and parents until the root are notified to act in consequence. I provide commit* API to consolidate mutations and recover the mentioned invariant.
"
Class {
	#name : #TreeNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'parent',
		'childIndex',
		'completedShot',
		'activeShot'
	],
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #testing }
TreeNode class >> isAbstract [

	^ self == TreeNode
]

{ #category : #private }
TreeNode >> activeShot [

	^ activeShot
]

{ #category : #accessing }
TreeNode >> addChild: aTreeNode [

	self
		privateResizeShotTo: activeShot size + 1
		with: [ :old :new |
			new
				replaceFrom: 1
				to: old size
				with: old
				startingAt: 1.
			new at: new size put: aTreeNode activeShot ].

	children addLast: aTreeNode.
	aTreeNode privateBeChildOf: self at: children size
]

{ #category : #accessing }
TreeNode >> addChildren: aCollection [

	aCollection do: [ :each | self addChild: each ]
]

{ #category : #enumerating }
TreeNode >> anyLeaf [

	self withAllChildrenDo: [ :each |
		each children isEmpty ifTrue: [ ^ each ] ]
]

{ #category : #accessing }
TreeNode >> childIndex [

	^ childIndex
]

{ #category : #accessing }
TreeNode >> children [

	^ children
]

{ #category : #enumerating }
TreeNode >> childrenDo: aBlock [

	children do: aBlock
]

{ #category : #accessing }
TreeNode >> commitWithAllChildren [

	"If our shot is not draft then no children can be draft"
	activeShot isDraft ifFalse: [ ^ self ].
	
	completedShot := activeShot.
	completedShot complete.

	"Commit recursively"
	children do: [ :each | each commitWithAllChildren ]
]

{ #category : #accessing }
TreeNode >> commitWithAllParents [

	activeShot isDraft ifFalse: [ ^ self ].
	
	completedShot := activeShot.
	completedShot complete.

	"Commit up to root"
	parent ifNotNil: [ :p | p commitWithAllParents ]
]

{ #category : #private }
TreeNode >> completedShot [

	^ completedShot
]

{ #category : #debugging }
TreeNode >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #accessing }
TreeNode >> ensureActiveShotIsDraft [

	activeShot isDraft ifTrue: [ ^ self ].

	activeShot := activeShot copy.

	parent ifNotNil: [
		parent privateSetDraftChildShot: activeShot at: childIndex ]
]

{ #category : #initialization }
TreeNode >> initialize [

	super initialize.
	self initializeShot
]

{ #category : #initialization }
TreeNode >> initializeShot [

	self initializeWithShot: self newDefaultShot
]

{ #category : #initialization }
TreeNode >> initializeWithShot: aShot [

	activeShot := completedShot := aShot.
	completedShot complete.

	children := OrderedCollection new
]

{ #category : #debugging }
TreeNode >> inspectionPresenterForCommitTreeOn: aBuilder [
	<inspectorPresentationOrder: 3 title: 'Commit Tree'>

	^ completedShot inspectionPresenterOn: aBuilder
]

{ #category : #debugging }
TreeNode >> inspectionPresenterForFreshTreeOn: aBuilder [
	<inspectorPresentationOrder: 2 title: 'Active Tree'>

	^ activeShot inspectionPresenterOn: aBuilder
]

{ #category : #debugging }
TreeNode >> inspectionPresenterOn: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Tree'>

	| treeTable |
	treeTable := aBuilder newTreeTable.

	treeTable
		addColumn: (SpStringTableColumn 
			title: 'debugId'
			evaluated: [ :each | each debugId ]);
		addColumn: (SpStringTableColumn 
			title: 'draft?'
			evaluated: [ :each | each activeShot isDraft ]).

	^ treeTable
		roots: { self };
		children: [ :aNode | aNode children ];
		expandAll;
		yourself
]

{ #category : #accessing }
TreeNode >> level [
	"Answer the number of edges between self and the root."

	^ parent ifNil: [ 0 ] ifNotNil: [ 1 + parent level ]
]

{ #category : #'instance creation' }
TreeNode >> newDefaultShot [

	^ self subclassResponsibility
]

{ #category : #accessing }
TreeNode >> parent [

	^ parent
]

{ #category : #printing }
TreeNode >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self debugId.

	parent ifNil: [
		aStream nextPutAll: ' ROOT' ].

	aStream
		nextPutAll: ' completed: ';
		nextPutAll: completedShot debugId.

	activeShot isDraft ifTrue: [
		aStream
			nextPutAll: ' draft: ';
			nextPutAll: activeShot debugId ].

	aStream
		nextPutAll: ' children: ';
		print: children size.

	completedShot printDetailsOn: aStream.

	aStream nextPutAll: ')'
]

{ #category : #private }
TreeNode >> privateAdjustChildIndexBy: anInteger [

	childIndex := childIndex + anInteger
]

{ #category : #private }
TreeNode >> privateBeChildOf: aTreeNode at: anIndex [

	parent := aTreeNode.
	childIndex := anIndex
]

{ #category : #private }
TreeNode >> privateBeRoot [

	parent := nil.
	childIndex := nil
]

{ #category : #private }
TreeNode >> privateResizeShotTo: newSize with: aChildrenInitializationBlock [

	"ATTENTION: This shot may have modifications already"
	activeShot :=
		activeShot
			copyResized: newSize
			with: aChildrenInitializationBlock.

	parent ifNotNil: [
		parent privateSetDraftChildShot: activeShot at: childIndex ]
]

{ #category : #private }
TreeNode >> privateSetDraftChildShot: newChildShot at: aChildIndex [
	"Establish a new child shot at the specified index.
	The objective is to restore the invariant after the child node changed its shot."

	"Stop early if I already knew it"
	(activeShot isDraft and: [ (activeShot at: aChildIndex) == newChildShot ])
		ifTrue: [ ^ self ].

	self ensureActiveShotIsDraft.
	activeShot at: aChildIndex put: newChildShot
]

{ #category : #accessing }
TreeNode >> removeChild: aTreeNode [

	| index |
	index := aTreeNode childIndex.

	self
		privateResizeShotTo: activeShot size - 1
		with: [ :old :new |
			new	
				replaceFrom: 1
					to: index - 1 
					with: old
					startingAt: 1;
				replaceFrom: index
					to: new size
					with: old
					startingAt: index + 1 ].
				
	"Mutate the collection; then, we may need to adjust children indices"
	children removeAt: aTreeNode childIndex.
	children
		from: aTreeNode childIndex
		to: children size
		do: [ :each | each privateAdjustChildIndexBy: -1 ].
	aTreeNode privateBeRoot
]

{ #category : #removing }
TreeNode >> removeChildren: aCollection [ 

	aCollection do: [ :each | self removeChild: each ]
]

{ #category : #enumerating }
TreeNode >> withAllChildrenCount [

	| count |
	count := 0.
	self withAllChildrenDo: [ :_ | count := count + 1 ].
	^ count
]

{ #category : #enumerating }
TreeNode >> withAllChildrenDo: aBlock [

	aBlock value: self.
	children do: [ :child | child withAllChildrenDo: aBlock ]
]
