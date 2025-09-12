"
I'm a patch to a position in a variable-layout patcheable object.
"
Class {
	#name : #PaAtPutPatch,
	#superclass : #PaIndexedPatch,
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #applying }
PaAtPutPatch >> applyPatchTo: aPatcheable [

	aPatcheable basicAt: index put: writtenValue
]

{ #category : #printing }
PaAtPutPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: 'at: ';
				print: index;
				nextPutAll: ' put: (';
				print: writtenValue;
				nextPut: $) ]
]

{ #category : #reading }
PaAtPutPatch >> read: aPatcheable at: anInteger [

	^ index = anInteger
		ifTrue: [ writtenValue ]
		ifFalse: [ super read: aPatcheable at: anInteger ]
]

{ #category : #writing }
PaAtPutPatch >> write: aPatcheable at: anInteger put: aValue [

	index = anInteger
		ifTrue: [ writtenValue := aValue ]
		ifFalse: [ super write: aPatcheable at: anInteger put: aValue ]
]
