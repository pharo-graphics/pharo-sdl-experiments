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

	self basicChildren:
		(children
			ifEmpty: [ PaArray with: aChild ]
			ifNotEmpty: [ children copyWith: aChild ])
]

{ #category : #adding }
PaSceneNode >> addChildren: aCollection [

	aCollection do: [ :each | each basicParent: self ].

	self basicChildren:
		(children
			ifEmpty: [ PaArray withAll: aCollection ]
			ifNotEmpty: [ children copyWithAll: aCollection ])
]

{ #category : #private }
PaSceneNode >> basicChildren: aCollection [
	"Set the children collection. Use the singleton empty array when possible."

	children := aCollection ifEmpty: [ PaArray empty ]
]

{ #category : #private }
PaSceneNode >> basicParent: aNode [

	parent ifNotNil: [ self error: 'Cannot have multiple parents' ].

	parent := aNode
]

{ #category : #private }
PaSceneNode >> basicRemoveParent [

	parent := nil
]

{ #category : #accessing }
PaSceneNode >> childAt: anIndex [

	^ children at: anIndex
]

{ #category : #'children accessing' }
PaSceneNode >> childIndexOf: aNode [
	"Answer the index of the first occurrence of aNode within the  
	receiver. If the receiver does not contain aNode, answer 0."

	^ children indexOf: aNode
]

{ #category : #accessing }
PaSceneNode >> children [

	^ children
]

{ #category : #accessing }
PaSceneNode >> childrenArray [

	^ children asArray
]

{ #category : #accessing }
PaSceneNode >> childrenCount [

	^ children size
]

{ #category : #enumerating }
PaSceneNode >> childrenDo: aBlock [

	children do: aBlock
]

{ #category : #testing }
PaSceneNode >> hasParent [

	^ parent isNotNil
]

{ #category : #initialization }
PaSceneNode >> initialize [

	super initialize.
	
	children := PaArray empty
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
		nextPutAll: ' #children: ';
		print: self childrenCount.
	aStream
		nextPutAll: 'opacity: ';
		print: opacity
]

{ #category : #removing }
PaSceneNode >> removeChild: aNode [

	self basicChildren: (children copyWithout: aNode).

	aNode basicRemoveParent
]

{ #category : #accessing }
PaSceneNode >> removeChildAt: anIndex [

	| aNode |
	aNode := children at: anIndex.

	self basicChildren: (children copyWithoutIndex: anIndex).

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
	oldNode := children at: anIndex.

	oldNode basicRemoveParent.
	newNode basicParent: self.

	children at: anIndex put: newNode
]

{ #category : #serialization }
PaSceneNode >> soilBasicSerialize: serializer [
	"Optimization over inherited generic implementation, to reduce
	the number of stack contexts in Soil serialization of a tree."

	serializer nextPutFixedLayoutPatcheable: self
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
