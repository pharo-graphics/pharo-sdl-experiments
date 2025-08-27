"
I'm a patch to a position in a variable-layout patcheable object.
"
Class {
	#name : #AtPutPatch,
	#superclass : #IndexedPatch,
	#category : #'SDL-Experiments-Patches-Core'
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
AtPutPatch >> write: aPatcheable add: aValue at: anInteger [

	"Prevent conflicts"
	index >= anInteger
		ifTrue: [
			aPatcheable
				condensePatches;
				add: aValue at: anInteger ]
		ifFalse: [
			super write: aPatcheable add: aValue at: anInteger ]
]

{ #category : #writing }
AtPutPatch >> write: aPatcheable at: anInteger put: aValue [

	index = anInteger
		ifTrue: [ writtenValue := aValue ]
		ifFalse: [ super write: aPatcheable at: anInteger put: aValue ]
]

{ #category : #writing }
AtPutPatch >> write: aPatcheable removeAt: anInteger [

	"Prevent conflicts"
	index <= anInteger
		ifTrue: [
			aPatcheable
				condensePatches;
				removeAt: anInteger ]
		ifFalse: [
			super write: aPatcheable removeAt: anInteger ]
]
