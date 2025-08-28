"
I'm a patch to remove certain indexed position of a variable patcheable object.
"
Class {
	#name : #PaRemoveAtPatch,
	#superclass : #PaResizingPatch,
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #printing }
PaRemoveAtPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: 'removeAt: ';
				print: index ]
]

{ #category : #reading }
PaRemoveAtPatch >> read: aPatcheable at: anInteger [

	^ nextPatch
		read: aPatcheable
		at: (anInteger < index
			   ifTrue: [ anInteger ]
			   ifFalse: [ anInteger + 1 ])
]

{ #category : #public }
PaRemoveAtPatch >> sizeOf: aPatcheable [

	^ (super sizeOf: aPatcheable) - 1
]
