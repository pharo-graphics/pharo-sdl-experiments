"
I'm a patch to a index-value pointer of a patcheable object.
"
Class {
	#name : #PaIndexedPatch,
	#superclass : #PaLinkPatch,
	#instVars : [
		'index',
		'writtenValue'
	],
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #accessing }
PaIndexedPatch >> index [

	^ index
]

{ #category : #accessing }
PaIndexedPatch >> index: anInteger [

	index := anInteger
]

{ #category : #accessing }
PaIndexedPatch >> writtenValue [

	^ writtenValue
]

{ #category : #accessing }
PaIndexedPatch >> writtenValue: anObject [

	writtenValue := anObject
]
