"
I'm a patch to a position in a variable-layout patcheable object.
"
Class {
	#name : #AtPutPatch,
	#superclass : #IndexedPatch,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #applying }
AtPutPatch >> applyPatchTo: aPatcheable [

	aPatcheable basicAt: index put: writtenValue
]

{ #category : #printing }
AtPutPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: 'at: ';
				print: index;
				nextPutAll: ' put: (';
				print: writtenValue;
				nextPut: $) ]
]

{ #category : #reading }
AtPutPatch >> read: aPatcheable at: anInteger [

	^ index = anInteger
		ifTrue: [ writtenValue ]
		ifFalse: [ super read: aPatcheable at: anInteger ]
]

{ #category : #writing }
AtPutPatch >> write: aPatcheable at: anInteger put: aValue [

	index = anInteger
		ifTrue: [ writtenValue := aValue ]
		ifFalse: [ super write: aPatcheable at: anInteger put: aValue ]
]
