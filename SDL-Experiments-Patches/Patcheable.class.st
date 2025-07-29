Class {
	#name : #Patcheable,
	#superclass : #Object,
	#instVars : [
		'nextPatch'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
Patcheable >> addPatchForAt: anInteger put: aValue [
	"Initialize the first patch, for this operation."

	(anInteger between: 1 and: self size) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	nextPatch :=
		AtPutPatch pool nextPatch
			index: anInteger;
			value: aValue;
			nextPatch: nextPatch;
			yourself
]

{ #category : #accessing }
Patcheable >> addPatchForInstVarAt: anInteger put: aValue [
	"This is evaluated when there wasn't a patch for this index, so create one."

	nextPatch :=
		InstVarAtPutPatch pool nextPatch
			index: anInteger;
			value: aValue;
			nextPatch: nextPatch;
			yourself
]

{ #category : #'as yet unclassified' }
Patcheable >> applyPatches [

	| current |
	nextPatch ifNil: [ ^ self ].

	current := nextPatch.
	[ current isNil ] whileFalse: [
		current applyPatchTo: self.
		current := current nextPatch ].

	self flag: #todo. "patches can have different classes! 
	InstVarAtPutPatch pool returnPatch: nextPatch."
	nextPatch := nil
]

{ #category : #accessing }
Patcheable >> at: index [

	^ nextPatch
		ifNil: [ super at: index ]
		ifNotNil: [ :p | p read: self at: index ]
]

{ #category : #accessing }
Patcheable >> at: index put: aValue [

	nextPatch
		ifNil: [ self addPatchForAt: index put: aValue ]
		ifNotNil: [ :p | p write: self at: index put: aValue ]
]

{ #category : #'as yet unclassified' }
Patcheable >> discardPatches [

	nextPatch ifNil: [ ^ self ].

	self flag: #todo. "IndexedSlotPatch pool returnPatch: nextPatch."
	nextPatch := nil
]

{ #category : #accessing }
Patcheable >> hasPatches [

	^ nextPatch isNotNil
]

{ #category : #debugging }
Patcheable >> inspectionOfPatches: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Patches'>

	^ aBuilder newList
		items: self patches;
		display: [ :each | each descriptionFor: self ]
		yourself
]

{ #category : #accessing }
Patcheable >> nextPatch [

	^ nextPatch
]

{ #category : #'as yet unclassified' }
Patcheable >> patchCount [

	^ nextPatch
		ifNil: [ 0 ]
		ifNotNil: [ nextPatch count ]
]

{ #category : #debugging }
Patcheable >> patches [
	"Answer an array with all my patches."

	| stream current |
	stream := WriteStream on: #().

	current := nextPatch.
	[ current isNil ] whileFalse: [
		stream nextPut: current.
		current := current nextPatch ].

	^ stream contents
]
