Class {
	#name : #NullPatch,
	#superclass : #Patch,
	#classInstVars : [
		'instance'
	],
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #accessing }
NullPatch class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : #accessing }
NullPatch >> count [

	^ 0
]

{ #category : #testing }
NullPatch >> isNullPatch [

	^ true
]

{ #category : #accessing }
NullPatch >> last [

	^ self errorSubscriptBounds: 0
]

{ #category : #printing }
NullPatch >> printOn: aStream [

	aStream
		nextPutAll: 'a ';
		nextPutAll: self className
]

{ #category : #reading }
NullPatch >> read: aPatcheable at: anInteger [ 
	
	^ aPatcheable basicAt: anInteger
]

{ #category : #reading }
NullPatch >> read: aPatcheable instVarAt: anInteger [ 
	
	^ aPatcheable instVarAt: anInteger
]

{ #category : #reading }
NullPatch >> readPredecessor: aPatcheable [

	^ aPatcheable instVarAt: Patcheable indexOfPredecessorSlot
]

{ #category : #writing }
NullPatch >> switchPredecessorAt: aPatcheable from: oldValue to: newValue ifDifferentDo: aBlock [

	oldValue == newValue ifTrue: [ ^ self ].
	oldValue detachPredecessor: aPatcheable.
	newValue attachPredecessor: aPatcheable.
	aBlock value
]

{ #category : #writing }
NullPatch >> write: aPatcheable at: anInteger put: aValue [ 

	self
		switchPredecessorAt: aPatcheable
		from: (self read: aPatcheable at: anInteger)
		to: aValue
		ifDifferentDo: [
			aPatcheable addPatchForAt: anInteger put: aValue ]
]

{ #category : #writing }
NullPatch >> write: aPatcheable instVarAt: anInteger put: aValue [ 

	self
		switchPredecessorAt: aPatcheable
		from: (self read: aPatcheable instVarAt: anInteger)
		to: aValue
		ifDifferentDo: [
			aPatcheable addPatchForInstVarAt: anInteger put: aValue ]
]

{ #category : #writing }
NullPatch >> writePredecessor: aPatcheable put: aValue [

	| oldValue |
	oldValue := self readPredecessor: aPatcheable.
	oldValue == aValue ifTrue: [ ^self ].
	aPatcheable addPatchForPredecessorPut: aValue
]
