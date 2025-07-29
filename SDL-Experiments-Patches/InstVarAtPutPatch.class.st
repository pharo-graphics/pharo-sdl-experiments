Class {
	#name : #InstVarAtPutPatch,
	#superclass : #IndexedSlotPatch,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #applying }
InstVarAtPutPatch >> applyPatchTo: aPatcheable [

	aPatcheable instVarAt: index put: value
]

{ #category : #printing }
InstVarAtPutPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: (aPatcheable class allSlots at: index) name;
				nextPutAll: ': ';
				print: value ]
]

{ #category : #reading }
InstVarAtPutPatch >> read: aPatcheable instVarAt: anInteger [

	^ index = anInteger
		ifTrue: [ value ]
		ifFalse: [ super read: aPatcheable instVarAt: anInteger ]
]

{ #category : #writing }
InstVarAtPutPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	index = anInteger
		ifTrue: [ value := aValue ]
		ifFalse: [ super write: aPatcheable instVarAt: anInteger put: aValue ]
]
