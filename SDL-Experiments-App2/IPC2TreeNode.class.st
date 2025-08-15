Class {
	#name : #IPC2TreeNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'strokeWidth',
		'shape',
		'fillColorHexString',
		'strokeColorHexString'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #adding }
IPC2TreeNode >> addChild: anotherTreeNode [

	children := children copyWith: anotherTreeNode
]

{ #category : #accessing }
IPC2TreeNode >> children [

	^ children
]

{ #category : #accessing }
IPC2TreeNode >> children: anObject [

	children := anObject
]

{ #category : #drawing }
IPC2TreeNode >> drawOnAthensCanvas: anAthensCanvas [

	self hasFillColor ifTrue: [
		anAthensCanvas setPaint: self fillColor.
		anAthensCanvas drawShape: shape ].
	self hasStrokeColor ifTrue: [
		(anAthensCanvas setStrokePaint: self strokeColor) width: strokeWidth.
		anAthensCanvas drawShape: shape ].
	
	children do: [ :each | each drawOnAthensCanvas: anAthensCanvas ]
]

{ #category : #accessing }
IPC2TreeNode >> fillColor [

	^ Color fromHexString: fillColorHexString
]

{ #category : #accessing }
IPC2TreeNode >> fillColor: aColor [

	fillColorHexString := aColor asHexString
]

{ #category : #accessing }
IPC2TreeNode >> fillColorHexString [

	^ fillColorHexString
]

{ #category : #accessing }
IPC2TreeNode >> fillColorHexString: anObject [

	fillColorHexString := anObject
]

{ #category : #testing }
IPC2TreeNode >> hasFillColor [

	^ fillColorHexString isNotNil
]

{ #category : #testing }
IPC2TreeNode >> hasStrokeColor [

	^ strokeColorHexString isNotNil
]

{ #category : #initialization }
IPC2TreeNode >> initialize [

	super initialize.

	children := #()
]

{ #category : #adding }
IPC2TreeNode >> removeChild: childTreeNode [

	children := children copyWithout: childTreeNode
]

{ #category : #accessing }
IPC2TreeNode >> shape [

	^ shape
]

{ #category : #accessing }
IPC2TreeNode >> shape: anObject [

	shape := anObject
]

{ #category : #accessing }
IPC2TreeNode >> strokeColor [

	^ Color fromHexString: strokeColorHexString
]

{ #category : #accessing }
IPC2TreeNode >> strokeColor: aColor [

	strokeColorHexString := aColor asHexString
]

{ #category : #accessing }
IPC2TreeNode >> strokeColorHexString [

	^ strokeColorHexString
]

{ #category : #accessing }
IPC2TreeNode >> strokeColorHexString: anObject [

	strokeColorHexString := anObject
]

{ #category : #accessing }
IPC2TreeNode >> strokeWidth [

	^ strokeWidth
]

{ #category : #accessing }
IPC2TreeNode >> strokeWidth: anObject [

	strokeWidth := anObject
]
