"
I'm a patch to insert a value at certain indexed position of a variable patcheable object.
"
Class {
	#name : #PaAddAtPatch,
	#superclass : #PaResizingPatch,
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #printing }
PaAddAtPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: ' add: (';
				print: writtenValue;
				nextPutAll: ') at: ';
				print: index ]
]

{ #category : #reading }
PaAddAtPatch >> read: aPatcheable at: anInteger [

	anInteger = index ifTrue: [ ^ writtenValue ].

	^ nextPatch
		read: aPatcheable
		at: (anInteger < index
			   ifTrue: [ anInteger ]
			   ifFalse: [ anInteger - 1 ])
]

{ #category : #public }
PaAddAtPatch >> sizeOf: aPatcheable [

	^ (super sizeOf: aPatcheable) + 1
]
