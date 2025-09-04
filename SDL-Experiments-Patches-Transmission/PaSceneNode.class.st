Class {
	#name : #PaSceneNode,
	#superclass : #PaBaseObject,
	#traits : 'TPaInstanceVariablesAPI - {#addPatchFirst:} + TPaSubscribableAPI',
	#classTraits : 'TPaInstanceVariablesAPI classTrait + TPaSubscribableAPI classTrait',
	#instVars : [
		'#opacity => PaSlot',
		'#children => PaSlot',
		'#parent => PaSlot'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Core'
}

{ #category : #adding }
PaSceneNode >> addChild: aChild [

	aChild parent: self.

	children :=
		children
			ifNil: [ PaArray with: aChild ]
			ifNotNil: [ children copyWith: aChild ]
]

{ #category : #adding }
PaSceneNode >> addChildren: aCollection [

	aCollection do: [ :each | each parent: self ].

	children :=
		children
			ifNil: [ PaArray withAll: aCollection ]
			ifNotNil: [ children copyWithAll: aCollection ]
]

{ #category : #accessing }
PaSceneNode >> children [

	^ children
]

{ #category : #accessing }
PaSceneNode >> childrenArray [

	^ children
		ifNotNil: [ children asCollection ]
		ifNil: [ #() ]
]

{ #category : #accessing }
PaSceneNode >> childrenCount [

	^ children
		ifNil: [ 0 ]
		ifNotNil: [ children size ]
]

{ #category : #enumerating }
PaSceneNode >> childrenDo: aBlock [

	children ifNil: [ ^ self ].
	children do: aBlock
]

{ #category : #debugging }
PaSceneNode >> inspectionPresenterOn: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Tree'>

	| treeTable |
	treeTable := aBuilder newTreeTable.

	treeTable
		addColumn: (SpStringTableColumn 
			title: 'Details'
			evaluated: [ :each | String streamContents: [ :stream | each printDetailsOn: stream ] ]);
		addColumn: (SpStringTableColumn 
			title: 'Basic'
			evaluated: [ :each | String streamContents: [ :stream | each printBasicOn: stream ] ]).

	^ treeTable
		roots: { self };
		children: [ :aNode | aNode childrenArray ];
		expandAll;
		yourself
]

{ #category : #accessing }
PaSceneNode >> opacity [

	^ opacity
]

{ #category : #accessing }
PaSceneNode >> opacity: aNumber [

	opacity := aNumber
]

{ #category : #accessing }
PaSceneNode >> parent [

	^ parent
]

{ #category : #accessing }
PaSceneNode >> parent: aNode [

	parent ifNotNil: [ self error: 'Cannot have multiple parents' ].

	parent := aNode
]

{ #category : #printing }
PaSceneNode >> printDetailsOn: aStream [

	aStream
		nextPutAll: 'opacity: ';
		print: opacity.
	aStream
		nextPutAll: ' #children: ';
		print: self childrenCount
]

{ #category : #enumerating }
PaSceneNode >> withAllChildrenCount [

	| count |
	count := 0.
	self withAllChildrenDo: [ :_ | count := count + 1 ].
	^ count
]

{ #category : #enumerating }
PaSceneNode >> withAllChildrenDo: aBlock [

	aBlock value: self.
	self childrenDo: [ :child | child withAllChildrenDo: aBlock ]
]
