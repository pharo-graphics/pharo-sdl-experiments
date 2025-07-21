"
I am a mutable representation a tree node.

My children are mutable elements, too. However, I point to a shot which is an immutable object, that points to immutable element children. Both mutable and immutable children are in sync, I am responsible of consolidating updates to ensure consistency.

Most of my accessors redirect to my shot (immutable object). When a mutator has to change a value the shot is replaced with a copy with the new value. This breaks my invariant temporarilly, while the chain of parents is updated until the root.
"
Class {
	#name : #TreeNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'parent',
		'childIndex',
		'commitShot',
		'freshShot'
	],
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #'instance creation' }
TreeNode class >> shot: aShot [

	^ self shot: aShot parent: nil childIndex: nil
]

{ #category : #'instance creation' }
TreeNode class >> shot: aShot parent: aParent childIndex: anIndex [

	^ self basicNew
		  initializeShot: aShot parent: aParent childIndex: anIndex;
		  yourself
]

{ #category : #accessing }
TreeNode >> addChild: aTreeNode [

	self
		privateResizeShotTo: freshShot size + 1
		with: [ :old :new |
			new
				replaceFrom: 1
				to: old size
				with: old
				startingAt: 1.
			new at: new size put: aTreeNode freshShot ].

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

{ #category : #private }
TreeNode >> commitShot [

	^ commitShot
]

{ #category : #accessing }
TreeNode >> commitWithAllChildren [

	"We know if any child hasLiveShot then its parent too"
	self hasDraftShot ifFalse: [ ^ self ].
	
	commitShot := freshShot.

	children do: [ :each | each commitWithAllChildren ] 
]

{ #category : #accessing }
TreeNode >> commitWithAllParents [

	self hasDraftShot ifFalse: [ ^ self ].
	
	commitShot := freshShot.

	parent ifNotNil: [ :p | p commitWithAllParents ]
]

{ #category : #debugging }
TreeNode >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #accessing }
TreeNode >> ensureDraftShot [

	self hasDraftShot ifTrue: [ ^self ].

	freshShot := freshShot copy.

	parent ifNotNil: [
		parent privateSetDraftChildShot: freshShot at: childIndex ]
]

{ #category : #private }
TreeNode >> freshShot [

	^ freshShot
]

{ #category : #testing }
TreeNode >> hasDraftShot [

	^ commitShot ~~ freshShot
]

{ #category : #initialization }
TreeNode >> initializeShot: aShot parent: aTreeNode childIndex: aIndex [

	freshShot := commitShot := aShot.

	parent := aTreeNode.
	childIndex := aIndex.

	"IMPORTANT: this is the only place where we propagate our shot
	down to the leaves. After initialization we only propagate shot
	up to the root."
	children := OrderedCollection new: aShot childrenCount.
	aShot childrenWithIndexDo: [ :childShot :index |
		children addLast:
			(self class
				shot: childShot
				parent: self
				childIndex: index) ]
]

{ #category : #debugging }
TreeNode >> inspectionPresenterForCommitTreeOn: aBuilder [
	<inspectorPresentationOrder: 3 title: 'Commit Tree'>

	^ commitShot inspectionPresenterOn: aBuilder
]

{ #category : #debugging }
TreeNode >> inspectionPresenterForFreshTreeOn: aBuilder [
	<inspectorPresentationOrder: 2 title: 'Fresh Tree'>

	^ freshShot inspectionPresenterOn: aBuilder
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
			evaluated: [ :each | each hasDraftShot ]).

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
		nextPutAll: ' commit: ';
		nextPutAll: commitShot debugId.

	self hasDraftShot ifTrue: [
		aStream
			nextPutAll: ' draft: ';
			nextPutAll: freshShot debugId ].

	aStream
		nextPutAll: ' children: ';
		print: children size.

	commitShot printDetailsOn: aStream.

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
	freshShot :=
		freshShot
			copyResized: newSize
			with: aChildrenInitializationBlock.

	parent ifNotNil: [
		parent privateSetDraftChildShot: freshShot at: childIndex ]
]

{ #category : #private }
TreeNode >> privateSetDraftChildShot: newChildShot at: aChildIndex [
	"Establish a new child shot at the specified index.
	The objective is to restore the invariant after the child node changed its shot."

	"Stop early if I already knew it"
	(self hasDraftShot and: [ (freshShot at: aChildIndex) == newChildShot ])
		ifTrue: [ ^ self ].

	self ensureDraftShot.
	freshShot at: aChildIndex put: newChildShot
]

{ #category : #private }
TreeNode >> readShot [

	^ freshShot
]

{ #category : #accessing }
TreeNode >> removeChild: aTreeNode [

	| index |
	index := aTreeNode childIndex.

	self
		privateResizeShotTo: freshShot size - 1
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

{ #category : #private }
TreeNode >> writeShot: aBlock [

	self ensureDraftShot.
	aBlock value: freshShot
]
