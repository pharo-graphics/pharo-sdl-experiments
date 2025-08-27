"
I'm a patch to an instance variable of a patcheable object.
"
Class {
	#name : #InstVarAtPutPatch,
	#superclass : #IndexedPatch,
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #applying }
InstVarAtPutPatch >> applyPatchTo: aPatcheable [

	aPatcheable basicInstVarAt: index put: writtenValue
]

{ #category : #printing }
InstVarAtPutPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			| slotName |
			slotName := (aPatcheable class allSlots at: index) name.
			stream
				nextPutAll: slotName;
				nextPutAll: ': (';
				print: writtenValue;
				nextPut: $) ]
]

{ #category : #reading }
InstVarAtPutPatch >> read: aPatcheable instVarAt: anInteger [

	^ index = anInteger
		ifTrue: [ writtenValue ]
		ifFalse: [ super read: aPatcheable instVarAt: anInteger ]
]

{ #category : #writing }
InstVarAtPutPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	index = anInteger
		ifTrue: [ writtenValue := aValue ]
		ifFalse: [ super write: aPatcheable instVarAt: anInteger put: aValue ]
]
