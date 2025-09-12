Class {
	#name : #PaFullPatch,
	#superclass : #PaPatch,
	#instVars : [
		'patcheableCopy'
	],
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #accessing }
PaFullPatch >> count [

	^ 1
]

{ #category : #printing }
PaFullPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: 'become: (';
				print: patcheableCopy;
				nextPut: $) ]
]

{ #category : #testing }
PaFullPatch >> hasNextPatch [

	^ false
]

{ #category : #accessing }
PaFullPatch >> nextPatch [
	
	^ PaNullPatch instance
]

{ #category : #accessing }
PaFullPatch >> nextPatch: aPatch [
	"Ignore as I replace any other patch"
]

{ #category : #accessing }
PaFullPatch >> patcheableCopy [

	^ patcheableCopy
]

{ #category : #accessing }
PaFullPatch >> patcheableCopy: anObject [

	patcheableCopy := anObject
]

{ #category : #reading }
PaFullPatch >> read: aPatcheable at: anInteger [

	^ patcheableCopy at: anInteger
]

{ #category : #reading }
PaFullPatch >> read: aPatcheable instVarAt: anInteger [

	^ patcheableCopy instVarAt: anInteger
]

{ #category : #writing }
PaFullPatch >> write: aPatcheable at: anInteger put: aValue [

	patcheableCopy at: anInteger put: aValue
]

{ #category : #writing }
PaFullPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	patcheableCopy instVarAt: anInteger put: aValue
]
