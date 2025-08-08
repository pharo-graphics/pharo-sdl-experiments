Class {
	#name : #Patcheable,
	#superclass : #Object,
	#instVars : [
		'patch'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
Patcheable >> addPatchForAt: anInteger put: aValue [
	"Initialize the first patch, for this operation."

	(anInteger between: 1 and: self size) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	patch :=
		AtPutPatch new
			index: anInteger;
			value: aValue;
			nextPatch: patch;
			yourself
]

{ #category : #accessing }
Patcheable >> addPatchForInstVarAt: anInteger put: aValue [
	"This is evaluated when there wasn't a patch for this index, so create one."

	patch :=
		InstVarAtPutPatch new
			index: anInteger;
			value: aValue;
			nextPatch: patch;
			yourself
]

{ #category : #'as yet unclassified' }
Patcheable >> applyPatches [

	patch isNullPatch ifTrue: [ ^ self ].

	self patchesDo: [ :each |
		self flag: #todo. "Return each to its pool"
		each applyPatchTo: self ].

	patch := NullPatch instance
]

{ #category : #accessing }
Patcheable >> at: index [

	^ patch read: self at: index
]

{ #category : #accessing }
Patcheable >> at: index put: aValue [

	patch write: self at: index put: aValue
]

{ #category : #'as yet unclassified' }
Patcheable >> discardPatches [

	patch isNullPatch ifTrue: [ ^ self ].

	self flag: #todo. "Return each patch to its pool"
	patch := NullPatch instance
]

{ #category : #accessing }
Patcheable >> firstPatch [

	^ patch
]

{ #category : #accessing }
Patcheable >> hasPatches [

	^ patch isNullPatch not
]

{ #category : #initialization }
Patcheable >> initialize [

	patch := NullPatch instance
]

{ #category : #debugging }
Patcheable >> inspectionOfPatches: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Patches'>

	^ aBuilder newList
		items: self patches;
		display: [ :each | each descriptionFor: self ]
		yourself
]

{ #category : #'as yet unclassified' }
Patcheable >> patchCount [

	^ patch count
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
	current := patch.
	[ current isNullPatch ] whileFalse: [
		aUnaryBlock value: current.
		current := current nextPatch ]
]
