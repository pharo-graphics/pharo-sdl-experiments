Class {
	#name : #PaFullPatch,
	#superclass : #PaPatch,
	#instVars : [
		'patcheableCopy'
	],
	#category : #'SDLExperiments-IPC-Patches-Core'
}

{ #category : #applying }
PaFullPatch >> applyPatchTo: aPatcheable [

	"Copy the variable part of the patcheable"
	1 to: aPatcheable basicSize do: [ :index |
		aPatcheable
			basicAt: index
			put: (patcheableCopy at: index) ].

	"Copy only the values in patched instance variables"
	aPatcheable class patcheableSlotsDo: [ :slot |
		aPatcheable
			basicInstVarAt: slot index
			put: (patcheableCopy instVarAt: slot index) ]
]

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

{ #category : #enumerating }
PaFullPatch >> do: aCleanBlockClosure [ 
	
	patcheableCopy do: aCleanBlockClosure
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
