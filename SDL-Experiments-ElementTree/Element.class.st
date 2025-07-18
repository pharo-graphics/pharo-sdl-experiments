"
I am a mutable representation a scene graph element.

We can consider my state as distributed between my instance variables (mutable) and my shot (immutable). Each time state in a shot needs to change, a new shot with the updated value is created and replaces the old shot. A change in a shot needs to be propagated until root element, and that's done by notifying my parent chain.
"
Class {
	#name : #Element,
	#superclass : #Object,
	#instVars : [
		'children',
		'parent',
		'shot'
	],
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #'instance creation' }
Element class >> new [

	^ self shot: ElementShot new parent: nil
]

{ #category : #'instance creation' }
Element class >> shot: aShot parent: aParent [

	^ self basicNew
		  initializeShot: aShot parent: aParent;
		  yourself
]

{ #category : #adding }
Element >> addChild: anotherElement [

	anotherElement basicParent: self.
	children := children copyWith: anotherElement.
	self shot:
		(shot withChildren:
			(shot children copyWith: anotherElement shot))
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

	^ shot background
]

{ #category : #accessing }
Element >> background: aColor [

	self shot: (shot withBackground: aColor)
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
Element >> initializeShot: aShot parent: anotherElement [

	shot := aShot.
	parent := anotherElement.
	children := aShot children collect: [ :childState |
		self class shot: childState parent: self ]
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

{ #category : #accessing }
Element >> level [

	^ parent ifNil: [ 1 ] ifNotNil: [ 1 + parent level ]
]

{ #category : #accessing }
Element >> opacity [

	^ shot opacity
]

{ #category : #accessing }
Element >> opacity: aOpacity [

	self shot: (shot withOpacity: aOpacity)
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
		print: shot.
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
	newChildrenStates := shot children copy.
	newChildrenStates at: childIndex put: aChildElement shot.

	self shot: (shot withChildren: newChildrenStates)
]

{ #category : #adding }
Element >> removeChild: anotherElement [

	anotherElement basicParent: nil.
	children := children copyWithout: anotherElement.
	self shot:
		(shot withChildren:
			(shot children copyWithout: anotherElement shot))
]

{ #category : #accessing }
Element >> shot [

	^ shot
]

{ #category : #accessing }
Element >> shot: aElementState [

	shot := aElementState.
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
