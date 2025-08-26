"
I'm a patch to remove certain indexed position of a variable patcheable object.
"
Class {
	#name : #RemoveAtPatch,
	#superclass : #ResizingPatch,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #printing }
RemoveAtPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: 'removeAt: ';
				print: index ]
]

{ #category : #reading }
RemoveAtPatch >> read: aPatcheable at: anInteger [

	^ nextPatch
		read: aPatcheable
		at: (anInteger < index
			   ifTrue: [ anInteger ]
			   ifFalse: [ anInteger + 1 ])
]

{ #category : #public }
RemoveAtPatch >> sizeOf: aPatcheable [

	^ (super sizeOf: aPatcheable) - 1
]
