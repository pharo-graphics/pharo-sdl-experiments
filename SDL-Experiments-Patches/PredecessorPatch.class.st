Class {
	#name : #PredecessorPatch,
	#superclass : #Patch,
	#instVars : [
		'value'
	],
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #applying }
PredecessorPatch >> applyPatchTo: aPatcheable [

	aPatcheable instVarAt: Patcheable indexOfPredecessorSlot put: value
]

{ #category : #printing }
PredecessorPatch >> descriptionFor: aPatcheable [

	^ String streamContents: [ :stream |
			stream
				nextPutAll: 'predecessor: (';
				print: value;
				nextPut: $) ]
]

{ #category : #reading }
PredecessorPatch >> readPredecessor: aPatcheable [

	^ value
]

{ #category : #accessing }
PredecessorPatch >> value: aPatcheable [

	value := aPatcheable
]

{ #category : #writing }
PredecessorPatch >> writePredecessor: aPatcheable put: aValue [

	value := aValue
]
