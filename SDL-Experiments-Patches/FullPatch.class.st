Class {
	#name : #FullPatch,
	#superclass : #Patch,
	#instVars : [
		'patcheableCopy'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
FullPatch >> count [

	^ 1
]

{ #category : #printing }
FullPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: 'become: (';
				print: patcheableCopy;
				nextPut: $) ]
]

{ #category : #testing }
FullPatch >> hasNextPatch [

	^ false
]

{ #category : #accessing }
FullPatch >> nextPatch [
	
	^ NullPatch instance
]

{ #category : #accessing }
FullPatch >> patcheableCopy [

	^ patcheableCopy
]

{ #category : #accessing }
FullPatch >> patcheableCopy: anObject [

	patcheableCopy := anObject
]

{ #category : #reading }
FullPatch >> read: aPatcheable at: anInteger [

	^ patcheableCopy at: anInteger
]

{ #category : #reading }
FullPatch >> read: aPatcheable instVarAt: anInteger [

	^ patcheableCopy instVarAt: anInteger
]

{ #category : #public }
FullPatch >> sizeOf: aPatcheable [

	^ patcheableCopy size
]

{ #category : #writing }
FullPatch >> write: aPatcheable add: aValue at: anInteger [

	patcheableCopy add: aValue at: anInteger
]

{ #category : #writing }
FullPatch >> write: aPatcheable at: anInteger put: aValue [

	patcheableCopy at: anInteger put: aValue
]

{ #category : #writing }
FullPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	patcheableCopy instVarAt: anInteger put: aValue
]

{ #category : #writing }
FullPatch >> write: aPatcheable removeAt: anInteger [

	patcheableCopy removeAt: anInteger
]
