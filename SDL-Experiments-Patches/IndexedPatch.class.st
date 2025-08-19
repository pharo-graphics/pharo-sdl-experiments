"
I'm a patch to a index-value pointer of a patcheable object.
"
Class {
	#name : #IndexedPatch,
	#superclass : #LinkPatch,
	#instVars : [
		'index',
		'writtenValue'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
IndexedPatch >> index [

	^ index
]

{ #category : #accessing }
IndexedPatch >> index: anInteger [

	index := anInteger
]

{ #category : #accessing }
IndexedPatch >> writtenValue [

	^ writtenValue
]

{ #category : #accessing }
IndexedPatch >> writtenValue: anObject [

	writtenValue := anObject
]
