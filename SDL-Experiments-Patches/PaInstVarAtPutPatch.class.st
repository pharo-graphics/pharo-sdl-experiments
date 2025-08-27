"
I'm a patch to an instance variable of a patcheable object.
"
Class {
	#name : #PaInstVarAtPutPatch,
	#superclass : #PaIndexedPatch,
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #applying }
PaInstVarAtPutPatch >> applyPatchTo: aPatcheable [

	aPatcheable basicInstVarAt: index put: writtenValue
]

{ #category : #printing }
PaInstVarAtPutPatch >> descriptionFor: aPatcheable [

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
PaInstVarAtPutPatch >> read: aPatcheable instVarAt: anInteger [

	^ index = anInteger
		ifTrue: [ writtenValue ]
		ifFalse: [ super read: aPatcheable instVarAt: anInteger ]
]

{ #category : #writing }
PaInstVarAtPutPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	index = anInteger
		ifTrue: [ writtenValue := aValue ]
		ifFalse: [ super write: aPatcheable instVarAt: anInteger put: aValue ]
]
