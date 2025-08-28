"
I am a tree node that's initially draft: My mutator API can be used to set values until `#complete`.

I am a variable-layer object, to point to my children without need of a separate collection.
"
Class {
	#name : #TreeNodeShot,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'complete'
	],
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #accessing }
TreeNodeShot class >> accessingSelectorsDo: aUnaryBlock [

	^ (self slots sort: [ :a :b | a name <= b name ])
			do: [ :each | aUnaryBlock value: each name ]
]

{ #category : #testing }
TreeNodeShot class >> isAbstract [

	^ self == TreeNodeShot
]

{ #category : #asserting }
TreeNodeShot >> assertDraft [

	complete ifNotNil: [ UnexpectedCompleteShotError signal ]
]

{ #category : #accessing }
TreeNodeShot >> at: index put: value [

	self assertDraft.
	^ super at: index put: value
]

{ #category : #accessing }
TreeNodeShot >> children [

	^ Array
		  new: self childrenCount
		  streamContents: [ :stream |
			  self childrenDo: [ :each | stream nextPut: each ] ]
]

{ #category : #accessing }
TreeNodeShot >> childrenCount [

	^ self size
]

{ #category : #accessing }
TreeNodeShot >> childrenDo: aBlock [

	1 to: self size do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #enumerating }
TreeNodeShot >> childrenWithIndexDo: aBlock [

	1 to: self size do: [ :index |
		aBlock value: (self at: index) value: index ]
]

{ #category : #accessing }
TreeNodeShot >> complete [
	"From now on, my mutator API signal `CannotWriteShot`.
	IMPORTANT: this is NOT recursive, so a child can be still draft."

	complete := true
]

{ #category : #initialization }
TreeNodeShot >> copyInstanceVariablesFrom: sourceObject [
]

{ #category : #copying }
TreeNodeShot >> copyResized: newSize with: aChildrenInitializationBlock [
	"Answer a copy of self with the specified size. The children must be copied in the block."

	| copy |
	copy := self class new: newSize.

	copy copyInstanceVariablesFrom: self.
	aChildrenInitializationBlock value: self value: copy.

	^ copy
]

{ #category : #debugging }
TreeNodeShot >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #debugging }
TreeNodeShot >> inspectionPresenterOn: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Tree'>

	| treeTable |
	treeTable := aBuilder newTreeTable.

	treeTable
		addColumn: (SpStringTableColumn 
			title: 'debugId'
			evaluated: [ :each | each debugId ]).

	self class accessingSelectorsDo: [ :eachSelector |
		treeTable addColumn:
			(SpStringTableColumn 
				title: eachSelector
				evaluated: [ :each | each perform: eachSelector ]) ].

	^ treeTable
		roots: { self };
		children: [ :aNode | aNode children ];
		expandAll;
		yourself
]

{ #category : #testing }
TreeNodeShot >> isDraft [

	^ complete isNil
]

{ #category : #copying }
TreeNodeShot >> postCopy [
	"Copies are draft"

	complete := nil
]

{ #category : #printing }
TreeNodeShot >> printDetailsOn: aStream [

	self class accessingSelectorsDo: [ :each |
		(self perform: each) ifNotNil: [ :v |
			aStream
				nextPut: Character space;
				nextPutAll: each;
				nextPutAll: ': ';
				print: v ] ]
]

{ #category : #printing }
TreeNodeShot >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self debugId.

	self isDraft ifTrue: [ 
		aStream nextPutAll: ' DRAFT' ].

	aStream
		nextPutAll: ' size: ';
		print: self childrenCount.

	self printDetailsOn: aStream.

	aStream nextPutAll: ')'
]

{ #category : #private }
TreeNodeShot >> replaceFrom: start to: stop with: replacement startingAt: repStart [
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 105>

	start to: stop do: [ :i |
		self basicAt: i put: (replacement basicAt: repStart - start + i) ]
]
