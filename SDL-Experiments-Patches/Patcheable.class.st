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
		AtPutPatch new
			index: anInteger;
			value: aValue;
			nextPatch: nextPatch;
			yourself
]

{ #category : #accessing }
Patcheable >> addPatchForInstVarAt: anInteger put: aValue [
	"This is evaluated when there wasn't a patch for this index, so create one."

	nextPatch :=
		InstVarAtPutPatch new
			index: anInteger;
			value: aValue;
			nextPatch: nextPatch;
			yourself
]

{ #category : #'as yet unclassified' }
Patcheable >> applyPatches [

	nextPatch isNullPatch ifTrue: [ ^ self ].

	self patchesDo: [ :each |
		self flag: #todo. "Return each to its pool"
		each applyPatchTo: self ].

	nextPatch := NullPatch instance
]

{ #category : #accessing }
Patcheable >> at: index [

	^ nextPatch read: self at: index
]

{ #category : #accessing }
Patcheable >> at: index put: aValue [

	nextPatch write: self at: index put: aValue
]

{ #category : #'as yet unclassified' }
Patcheable >> discardPatches [

	nextPatch isNullPatch ifTrue: [ ^ self ].

	self flag: #todo. "Return each patch to its pool"
	nextPatch := NullPatch instance
]

{ #category : #accessing }
Patcheable >> hasPatches [

	^ nextPatch isNullPatch not
]

{ #category : #initialization }
Patcheable >> initialize [

	nextPatch := NullPatch instance
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

	^ nextPatch count
]

{ #category : #debugging }
Patcheable >> patches [
	"Answer an array with all my patches."

	| stream |
	stream := WriteStream on: #().

	self patchesDo: [ :each | stream nextPut: each ].

	^ stream contents
]

{ #category : #debugging }
Patcheable >> patchesDo: aUnaryBlock [
	"Evaluate a block on each of my (not null) patches."

	| current |
	current := nextPatch.
	[ current isNullPatch ] whileFalse: [
		aUnaryBlock value: current.
		current := current nextPatch ]
]
