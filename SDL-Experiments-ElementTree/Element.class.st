"
I am a mutable representation a scene graph element.

My children are mutable elements, too. However, I point to a shot which is an immutable object, that points to immutable element children. Both mutable and immutable children are in sync, I am responsible of keeping that invariant.

Most of my accessors redirect to my shot (immutable object). When a mutator has to change a value the shot is replaced with a copy with the new value. This breaks my invariant temporarilly, while the chain of parents is updated until the root.
"
Class {
	#name : #Element,
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
Element class >> new [

	^ self shot: ElementShot new
]

{ #category : #'instance creation' }
Element class >> shot: aShot [

	^ self shot: aShot parent: nil childIndex: nil
]

{ #category : #'instance creation' }
Element class >> shot: aShot parent: aParent childIndex: anIndex [

	^ self basicNew
		  initializeShot: aShot parent: aParent childIndex: anIndex;
		  yourself
]

{ #category : #'accessing - tree' }
Element >> addChild: anotherElement [

	self privateShot: (shot copyWithChildLastt: anotherElement shot).

	children addLast: anotherElement.
	anotherElement privateBeChildOf: self at: children size
]

{ #category : #'accessing - tree' }
Element >> addChildren: aCollection [

	aCollection do: [ :each | self addChild: each ]
]

{ #category : #enumerating }
Element >> anyLeaf [

	self withAllChildrenDo: [ :each |
		each children isEmpty ifTrue: [ ^ each ] ]
]

{ #category : #accessing }
Element >> background [

	^ shot background
]

{ #category : #accessing }
Element >> background: aColor [

	self privateShot: (shot copyWithBackground: aColor)
]

{ #category : #'accessing - tree' }
Element >> childIndex [

	^ childIndex
]

{ #category : #'accessing - tree' }
Element >> children [

	^ children
]

{ #category : #enumerating }
Element >> childrenDo: aBlock [

	children do: aBlock
]

{ #category : #private }
Element >> consolidateAfterNewChildShot: newChildShot at: aChildIndex [
	"Establish a new child shot at the specified index.
	The objective is restoring the invariant after the child element changed its shot."

	self privateShot: (shot copyWithChild: newChildShot at: aChildIndex)
]

{ #category : #debugging }
Element >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #initialization }
Element >> initializeShot: aShot parent: anElement childIndex: aIndex [

	shot := aShot.
	parent := anElement.
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
Element >> inspectionPresenterOn: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Tree'>

	^ aBuilder newTreeTable 
		roots: { self };
		children: [ :aNode | aNode children ];
		addColumn: (SpStringTableColumn 
			title: 'Element debugId'
			evaluated: [ :each | each debugId ]);
		addColumn: (SpStringTableColumn 
			title: 'State debugId'
			evaluated: [ :each | each shot debugId ]);
		addColumn: (SpStringTableColumn 
			title: 'background'
			evaluated: [ :each | each background ]);
		addColumn: (SpStringTableColumn 
			title: 'opacity'
			evaluated: [ :each | each opacity ]);
		expandAll;
		yourself
]

{ #category : #'accessing - tree' }
Element >> level [

	^ parent ifNil: [ 1 ] ifNotNil: [ 1 + parent level ]
]

{ #category : #accessing }
Element >> opacity [

	^ shot opacity
]

{ #category : #accessing }
Element >> opacity: aOpacity [

	self privateShot: (shot copyWithOpacity: aOpacity)
]

{ #category : #'accessing - tree' }
Element >> parent [

	^ parent
]

{ #category : #printing }
Element >> printOn: aStream [
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
Element >> privateAdjustChildIndexBy: anInteger [

	childIndex := childIndex + anInteger
]

{ #category : #private }
Element >> privateBeChildOf: anElement at: anIndex [

	parent := anElement.
	childIndex := anIndex
]

{ #category : #private }
Element >> privateBeRoot [

	parent := nil.
	childIndex := nil
]

{ #category : #private }
Element >> privateShot: newShot [

	shot := newShot.
	parent ifNil: [ ^ self ].

	parent consolidateAfterNewChildShot: shot at: childIndex
]

{ #category : #'accessing - tree' }
Element >> removeChild: anotherElement [

	self privateShot: (shot copyWithoutChildAt: anotherElement childIndex).

	"Mutate the collection; then, we may need to adjust children indices"
	children removeAt: anotherElement childIndex.
	children
		from: anotherElement childIndex
		to: children size
		do: [ :each | each privateAdjustChildIndexBy: -1 ].
	anotherElement privateBeRoot
]

{ #category : #private }
Element >> shot [

	^ shot
]

{ #category : #enumerating }
Element >> withAllChildrenCount [

	| count |
	count := 0.
	self withAllChildrenDo: [ :_ | count := count + 1 ].
	^ count
]

{ #category : #enumerating }
Element >> withAllChildrenDo: aBlock [

	aBlock value: self.
	children do: [ :child | child withAllChildrenDo: aBlock ]
]
