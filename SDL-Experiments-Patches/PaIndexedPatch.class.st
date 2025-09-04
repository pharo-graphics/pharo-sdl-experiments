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
PaIndexedPatch class >> index: anInteger value: anObject [

	^ self basicNew
		initializeIndex: anInteger value: anObject;
		yourself
]

{ #category : #accessing }
PaIndexedPatch class >> index: anInteger value: anObject nextPatch: anotherPatch [

	^ self basicNew
		initializeIndex: anInteger value: anObject;
		nextPatch: anotherPatch;
		yourself
]

{ #category : #accessing }
PaIndexedPatch >> index [

	^ index
]

{ #category : #accessing }
PaIndexedPatch >> index: anInteger [

	index := anInteger
]

{ #category : #accessing }
PaIndexedPatch >> initializeIndex: anInteger value: anObject [

	self initialize.

	index := anInteger.
	writtenValue := anObject
]

{ #category : #accessing }
PaIndexedPatch >> writtenValue [

	^ writtenValue
]

{ #category : #accessing }
PaIndexedPatch >> writtenValue: anObject [

	writtenValue := anObject
]
