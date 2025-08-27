"
I'm a patch to insert a value at certain indexed position of a variable patcheable object.
"
Class {
	#name : #AddAtPatch,
	#superclass : #ResizingPatch,
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #printing }
AddAtPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: ' add: (';
				print: writtenValue;
				nextPutAll: ') at: ';
				print: index ]
]

{ #category : #reading }
AddAtPatch >> read: aPatcheable at: anInteger [

	anInteger = index ifTrue: [ ^ writtenValue ].

	^ nextPatch
		read: aPatcheable
		at: (anInteger < index
			   ifTrue: [ anInteger ]
			   ifFalse: [ anInteger - 1 ])
]

{ #category : #public }
AddAtPatch >> sizeOf: aPatcheable [

	^ (super sizeOf: aPatcheable) + 1
]
