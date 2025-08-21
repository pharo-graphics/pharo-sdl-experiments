Trait {
	#name : #TPatcheable,
	#instVars : [
		'patch'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #dispatching }
TPatcheable >> applyPatches [

	patch isNullPatch ifTrue: [ ^ self ].

	self patchesDo: [ :each | each applyPatchTo: self ].

	self privateResetPatch
]

{ #category : #dispatching }
TPatcheable >> discardPatches [

	patch isNullPatch ifTrue: [ ^ self ].

	self privateResetPatch
]

{ #category : #'private - patching' }
TPatcheable >> firstPatch [

	^ patch
]

{ #category : #testing }
TPatcheable >> hasPatches [

	^ patch isNullPatch not
]

{ #category : #initialization }
TPatcheable >> initializePatch [

	self privateResetPatch
]

{ #category : #debugging }
TPatcheable >> inspectionOfPatches: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Patches'>

	^ aBuilder newList
		items: self patches;
		display: [ :each | each descriptionFor: self ]
		yourself
]

{ #category : #'private - patching' }
TPatcheable >> patchCount [

	^ patch count
]

{ #category : #'private - patching' }
TPatcheable >> patches [
	"Answer an array with all my patches."

	| stream |
	stream := WriteStream on: #().

	self patchesDo: [ :each | stream nextPut: each ].

	^ stream contents
]

{ #category : #'private - patching' }
TPatcheable >> patchesDo: aUnaryBlock [
	"Evaluate a block on each of my (not null) patches."

	| current |
	current := patch.
	[ current isNullPatch ] whileFalse: [
		aUnaryBlock value: current.
		current := current nextPatch ]
]

{ #category : #copying }
TPatcheable >> postCopy [
	"The copy has the patches applied. Do not return patches to pool since we assume they are owned by the source object."

	patch isNullPatch ifTrue: [ ^ self ].

	self patchesDo: [ :each | each applyPatchTo: self ].

	self privateResetPatch
]

{ #category : #'private - patching' }
TPatcheable >> privateResetPatch [

	self flag: #todo. "Return each to its pool"

	patch := NullPatch instance
]
