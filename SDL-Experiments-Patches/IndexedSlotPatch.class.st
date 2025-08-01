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

	^ nextPatch read: aPatcheable at: anInteger
]

{ #category : #reading }
IndexedSlotPatch >> read: aPatcheable instVarAt: anInteger [

	^ nextPatch read: aPatcheable instVarAt: anInteger
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

	nextPatch write: aPatcheable at: anInteger put: aValue
]

{ #category : #writing }
IndexedSlotPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	nextPatch write: aPatcheable instVarAt: anInteger put: aValue
]
