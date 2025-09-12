Class {
	#name : #IPC2TreeNode,
	#superclass : #PaSceneNode,
	#instVars : [
		'#strokeWidth => PaSlot',
		'#shape => PaSlot',
		'#fillColorHexString => PaSlot',
		'#strokeColorHexString => PaSlot'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #drawing }
IPC2TreeNode >> drawOnAthensCanvas: anAthensCanvas [

	self hasFillColor ifTrue: [
		anAthensCanvas setPaint: self fillColor.
		anAthensCanvas drawShape: shape ].
	self hasStroke ifTrue: [
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
IPC2TreeNode >> hasStroke [

	^ strokeColorHexString isNotNil and: [ strokeWidth notNil ]
]

{ #category : #printing }
IPC2TreeNode >> printDetailsOn: aStream [

	aStream
		nextPutAll: 'opacity: ';
		print: opacity
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
