"
I'm an object whose mutations are written as patches. Accessors return the value from a patch, if available, or from the patcheable object, otherwise.
"
Trait {
	#name : #TPaPatcheableAPI,
	#instVars : [
		'patch'
	],
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #patching }
TPaPatcheableAPI >> applyPatches [

	patch isNullPatch ifTrue: [ ^ self ].

	self patchesDo: [ :each | each applyPatchTo: self ].

	self resetPatches
]

{ #category : #patching }
TPaPatcheableAPI >> condensePatches [

	patch isNullPatch ifTrue: [ ^self ].

	patch :=
		PaFullPatch new
			patcheableCopy: self copy;
			yourself
]

{ #category : #patching }
TPaPatcheableAPI >> firstPatch [

	^ patch
]

{ #category : #testing }
TPaPatcheableAPI >> hasPatches [

	^ patch isNullPatch not
]

{ #category : #initialization }
TPaPatcheableAPI >> initialize [

	super initialize.
	self initializePatch.
]

{ #category : #initialization }
TPaPatcheableAPI >> initializePatch [

	self resetPatches
]

{ #category : #debugging }
TPaPatcheableAPI >> inspectionOfPatches: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Patches'>

	^ aBuilder newList
		items: self patches;
		display: [ :each | each descriptionFor: self ]
		yourself
]

{ #category : #patching }
TPaPatcheableAPI >> patchCount [

	^ patch count
]

{ #category : #patching }
TPaPatcheableAPI >> patches [
	"Answer an array with all my patches."

	| stream |
	stream := WriteStream on: #().

	self patchesDo: [ :each | stream nextPut: each ].

	^ stream contents
]

{ #category : #patching }
TPaPatcheableAPI >> patchesDo: aUnaryBlock [
	"Evaluate a block on each of my (not null) patches."

	| current |
	current := patch.
	[ current isNullPatch ] whileFalse: [
		aUnaryBlock value: current.
		current := current nextPatch ]
]

{ #category : #copying }
TPaPatcheableAPI >> postCopy [
	"The copy has the patches applied. Do not return patches to pool since we assume they are owned by the source object."

	patch isNullPatch ifTrue: [ ^ self ].

	self patchesDo: [ :each | each applyPatchTo: self ].

	self resetPatches
]

{ #category : #patching }
TPaPatcheableAPI >> resetPatches [

	patch := PaNullPatch instance
]
