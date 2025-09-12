Class {
	#name : #CowSceneNode,
	#superclass : #CowObject,
	#instVars : [
		'#opacity => CowSlot',
		'#children => CowSlot'
	],
	#category : #'SDLExperiments-IPC-COW2-Core'
}

{ #category : #accessing }
CowSceneNode >> addChild: aNode [

	self prepareChildren.
	children := children copyWith: aNode
]

{ #category : #accessing }
CowSceneNode >> children [

	^ children ifNil: [ #() ]
]

{ #category : #accessing }
CowSceneNode >> childrenArray [

	^ children
		ifNotNil: [ children asArray ]
		ifNil: [ #() ]
]

{ #category : #accessing }
CowSceneNode >> childrenCount [

	^ children
		ifNil: [ 0 ]
		ifNotNil: [ children size ]
]

{ #category : #debugging }
CowSceneNode >> inspectionPresenterOn: aBuilder [
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
CowSceneNode >> opacity [

	^ opacity
]

{ #category : #accessing }
CowSceneNode >> opacity: anObject [

	opacity := anObject
]

{ #category : #accessing }
CowSceneNode >> prepareChildren [

	children ifNil: [ children := CowArray new ]
]

{ #category : #printing }
CowSceneNode >> printDetailsOn: aStream [

	aStream
		nextPutAll: 'opacity: ';
		print: opacity.
	aStream
		nextPutAll: ' children: ';
		print: self childrenCount
]

{ #category : #accessing }
CowSceneNode >> removeChild: aNode [

	self prepareChildren.
	children := children copyWithout: aNode
]
