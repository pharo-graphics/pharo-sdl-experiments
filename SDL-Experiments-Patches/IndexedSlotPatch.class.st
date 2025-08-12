Class {
	#name : #IndexedSlotPatch,
	#superclass : #Patch,
	#instVars : [
		'index',
		'value'
	],
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #accessing }
IndexedSlotPatch >> index [

	^ index
]

{ #category : #accessing }
IndexedSlotPatch >> index: anInteger [

	index := anInteger
]

{ #category : #writing }
IndexedSlotPatch >> switchPredecessorAt: aPatcheable from: oldValue to: newValue [

	oldValue == newValue ifTrue: [ ^ self ].
	oldValue detachPredecessor: aPatcheable.
	newValue attachPredecessor: aPatcheable
]

{ #category : #accessing }
IndexedSlotPatch >> value [

	^ value
]

{ #category : #accessing }
IndexedSlotPatch >> value: anObject [

	value := anObject
]
