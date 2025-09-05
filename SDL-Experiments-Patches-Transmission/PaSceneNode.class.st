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

	aChild basicParent: self.

	children :=
		children
			ifNil: [ PaArray with: aChild ]
			ifNotNil: [ children copyWith: aChild ]
]

{ #category : #adding }
PaSceneNode >> addChildren: aCollection [

	aCollection do: [ :each | each basicParent: self ].

	children :=
		children
			ifNil: [ PaArray withAll: aCollection ]
			ifNotNil: [ children copyWithAll: aCollection ]
]

{ #category : #private }
PaSceneNode >> basicParent: aNode [

	parent ifNotNil: [ self error: 'Cannot have multiple parents' ].

	parent := aNode
]

{ #category : #'as yet unclassified' }
PaSceneNode >> basicRemoveParent [

	parent := nil
]

{ #category : #accessing }
PaSceneNode >> childAt: anIndex [

	children ifNil: [ SubscriptOutOfBounds signalFor: anIndex ].
	^ children at: anIndex
]

{ #category : #'children accessing' }
PaSceneNode >> childIndexOf: aNode [
	"Answer the index of the first occurrence of aNode within the  
	receiver. If the receiver does not contain aNode, answer 0."

	children ifNil: [ ^ 0 ].

	^ children indexOf: aNode
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

{ #category : #testing }
PaSceneNode >> hasParent [

	^ parent isNotNil
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
PaSceneNode >> level [
	"Answer the number of edges between self and the root."

	^ parent ifNil: [ 0 ] ifNotNil: [ 1 + parent level ]
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

{ #category : #printing }
PaSceneNode >> printDetailsOn: aStream [

	aStream
		nextPutAll: 'opacity: ';
		print: opacity.
	aStream
		nextPutAll: ' #children: ';
		print: self childrenCount
]

{ #category : #removing }
PaSceneNode >> removeChild: aNode [

	children ifNil: [ NotFound signalFor: aNode ].
	children := children copyWithout: aNode.

	aNode basicRemoveParent
]

{ #category : #accessing }
PaSceneNode >> removeChildAt: anIndex [

	| aNode |
	aNode := children at: anIndex.
	children := children copyWithoutIndex: anIndex.
	aNode basicRemoveParent
]

{ #category : #'children accessing' }
PaSceneNode >> replaceChild: oldNode with: newNode [

	| anIndex |
	anIndex := self childIndexOf: oldNode.
	anIndex > 0 ifFalse: [ NotFound signalFor: oldNode ].

	oldNode basicRemoveParent.
	newNode basicParent: self.

	children at: anIndex put: newNode
]

{ #category : #'children accessing' }
PaSceneNode >> replaceChildAt: anIndex with: newNode [

	| oldNode |
	children ifNil: [ SubscriptOutOfBounds signalFor: anIndex ].
	oldNode := children at: anIndex.

	oldNode basicRemoveParent.
	newNode basicParent: self.

	children at: anIndex put: newNode
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
