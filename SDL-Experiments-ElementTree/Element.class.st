Class {
	#name : #Element,
	#superclass : #Object,
	#instVars : [
		'state',
		'children',
		'parent'
	],
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #'instance creation' }
Element class >> new [

	^ self state: ElementState new parent: nil
]

{ #category : #'instance creation' }
Element class >> state: aState parent: aParent [

	^ self basicNew
		  initializeState: aState parent: aParent;
		  yourself
]

{ #category : #adding }
Element >> addChild: anotherElement [

	anotherElement basicParent: self.
	children := children copyWith: anotherElement.
	self state:
		(state withChildren:
			(state children copyWith: anotherElement state))
]

{ #category : #adding }
Element >> addChildren: aCollection [

	aCollection do: [ :each | self addChild: each ]
]

{ #category : #accessing }
Element >> anyLeaf [

	self withAllChildrenDo: [ :each |
		each children isEmpty ifTrue: [ ^ each ] ]
]

{ #category : #accessing }
Element >> background [

	^ state background
]

{ #category : #accessing }
Element >> background: aColor [

	self state: (state withBackground: aColor)
]

{ #category : #'private - synchronization' }
Element >> basicParent: anotherElement [

	parent := anotherElement
]

{ #category : #accessing }
Element >> children [

	^ children
]

{ #category : #accessing }
Element >> childrenDo: aBlock [

	children do: aBlock
]

{ #category : #debugging }
Element >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #initialization }
Element >> initializeState: aState parent: aParent [

	state := aState.
	parent := aParent.
	children := aState children collect: [ :childState |
		self class state: childState parent: self ]
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
			evaluated: [ :each | each state debugId ]);
		addColumn: (SpStringTableColumn 
			title: 'background'
			evaluated: [ :each | each background ]);
		addColumn: (SpStringTableColumn 
			title: 'opacity'
			evaluated: [ :each | each opacity ]);
		expandAll;
		yourself
]

{ #category : #accessing }
Element >> level [

	^ parent ifNil: [ 1 ] ifNotNil: [ 1 + parent level ]
]

{ #category : #accessing }
Element >> opacity [

	^ state opacity
]

{ #category : #accessing }
Element >> opacity: aOpacity [

	self state: (state withOpacity: aOpacity)
]

{ #category : #accessing }
Element >> parent [

	^ parent
]

{ #category : #printing }
Element >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '#';
		print: self identityHash hex.
	aStream
		nextPutAll: ' state: ';
		print: state.
	aStream
		nextPutAll: ' #children: ';
		print: children size.
	parent ifNil: [
		aStream
			nextPutAll: ' ROOT ' ]
]

{ #category : #'private - synchronization' }
Element >> propagateChangedChild: aChildElement [

	| newChildrenStates childIndex |
	childIndex := children indexOf: aChildElement.
	newChildrenStates := state children copy.
	newChildrenStates at: childIndex put: aChildElement state.

	self state: (state withChildren: newChildrenStates)
]

{ #category : #adding }
Element >> removeChild: anotherElement [

	anotherElement basicParent: nil.
	children := children copyWithout: anotherElement.
	self state:
		(state withChildren:
			(state children copyWithout: anotherElement state))
]

{ #category : #accessing }
Element >> state [

	^ state
]

{ #category : #accessing }
Element >> state: aElementState [

	state := aElementState.
	parent ifNil: [ ^ self ].

	parent propagateChangedChild: self
]

{ #category : #enumerating }
Element >> withAllChildrenCount [

	| count |
	count := 0.
	self withAllChildrenDo: [ :_ | count := count + 1 ].
	^ count
]

{ #category : #accessing }
Element >> withAllChildrenDo: aBlock [

	aBlock value: self.
	children do: [ :child | child withAllChildrenDo: aBlock ]
]
