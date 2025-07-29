Class {
	#name : #AtPutPatch,
	#superclass : #IndexedSlotPatch,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #applying }
AtPutPatch >> applyPatchTo: aPatcheable [

	aPatcheable basicAt: index put: value
]

{ #category : #printing }
AtPutPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: 'at: ';
				print: index;
				nextPutAll: ' put: (';
				print: value;
				nextPut: $) ]
]

{ #category : #reading }
AtPutPatch >> read: aPatcheable at: anInteger [

	^ index = anInteger
		ifTrue: [ value ]
		ifFalse: [ super read: aPatcheable at: anInteger ]
]

{ #category : #writing }
AtPutPatch >> write: aPatcheable at: anInteger put: aValue [

	index = anInteger
		ifTrue: [ value := aValue ]
		ifFalse: [ super write: aPatcheable at: anInteger put: aValue ]
]
