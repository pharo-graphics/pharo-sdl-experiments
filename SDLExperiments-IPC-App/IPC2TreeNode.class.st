Class {
	#name : #IPC2TreeNode,
	#superclass : #PaSceneNode,
	#instVars : [
		'#strokeWidth => PaSlot',
		'#shape => PaSlot',
		'#fillColor => PaSlot',
		'#strokeColor => PaSlot'
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

	^ fillColor
]

{ #category : #accessing }
IPC2TreeNode >> fillColor: aColor [

	fillColor := aColor
]

{ #category : #testing }
IPC2TreeNode >> hasFillColor [

	^ fillColor isNotNil
]

{ #category : #testing }
IPC2TreeNode >> hasStroke [

	^ strokeColor isNotNil and: [ strokeWidth notNil ]
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

	^ strokeColor
]

{ #category : #accessing }
IPC2TreeNode >> strokeColor: aColor [

	strokeColor := aColor
]

{ #category : #accessing }
IPC2TreeNode >> strokeWidth [

	^ strokeWidth
]

{ #category : #accessing }
IPC2TreeNode >> strokeWidth: anObject [

	strokeWidth := anObject
]
