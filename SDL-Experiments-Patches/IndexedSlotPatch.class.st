Class {
	#name : #IndexedSlotPatch,
	#superclass : #Patch,
	#instVars : [
		'index',
		'value'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
IndexedSlotPatch >> index [

	^ index
]

{ #category : #accessing }
IndexedSlotPatch >> index: anInteger [

	index := anInteger
]

{ #category : #reading }
IndexedSlotPatch >> read: aPatcheable at: anInteger [

	^ nextPatch
		ifNotNil: [ :p | p read: aPatcheable at: anInteger ]
		ifNil: [ aPatcheable basicAt: anInteger ]
]

{ #category : #reading }
IndexedSlotPatch >> read: aPatcheable instVarAt: anInteger [

	^ nextPatch
		ifNotNil: [ :p | p read: aPatcheable instVarAt: anInteger ]
		ifNil: [ aPatcheable instVarAt: anInteger ]
]

{ #category : #accessing }
IndexedSlotPatch >> value [

	^ value
]

{ #category : #accessing }
IndexedSlotPatch >> value: anObject [

	value := anObject
]

{ #category : #writing }
IndexedSlotPatch >> write: aPatcheable at: anInteger put: aValue [

	nextPatch
		ifNotNil: [ :p | p write: aPatcheable at: anInteger put: aValue ]
		ifNil: [ aPatcheable addPatchForAt: anInteger put: aValue ]
]

{ #category : #writing }
IndexedSlotPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	nextPatch
		ifNotNil: [ :p | p write: aPatcheable instVarAt: anInteger put: aValue ]
		ifNil: [ aPatcheable addPatchForInstVarAt: anInteger put: aValue ]
]
