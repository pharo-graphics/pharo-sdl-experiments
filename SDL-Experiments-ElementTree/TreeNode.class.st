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
		'shot',
		'childIndex'
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

	self privateShot: (shot copyWithChildLastt: aTreeNode shot).

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
TreeNode >> consolidateAfterNewChildShot: newChildShot at: aChildIndex [
	"Establish a new child shot at the specified index.
	The objective is to restore the invariant after the child node changed its shot."

	self privateShot: (shot copyWithChild: newChildShot at: aChildIndex)
]

{ #category : #debugging }
TreeNode >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #initialization }
TreeNode >> initializeShot: aShot parent: aTreeNode childIndex: aIndex [

	shot := aShot.
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
		nextPutAll: self debugId;
		nextPutAll: ' shot: ';
		nextPutAll: shot debugId;
		nextPutAll: ' size: ';
		print: children size.

	parent ifNil: [
		aStream nextPutAll: ' ROOT' ].

	shot printDetailsOn: aStream.

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
TreeNode >> privateShot: newShot [

	shot := newShot.
	parent ifNil: [ ^ self ].

	parent consolidateAfterNewChildShot: shot at: childIndex
]

{ #category : #accessing }
TreeNode >> removeChild: aTreeNode [

	self privateShot: (shot copyWithoutChildAt: aTreeNode childIndex).

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

{ #category : #private }
TreeNode >> shot [

	^ shot
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
