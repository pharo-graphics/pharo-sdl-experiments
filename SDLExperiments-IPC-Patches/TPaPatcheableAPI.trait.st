"
I'm an object whose mutations are written as patches. Accessors return the value from a patch, if available, or from the patcheable object, otherwise.
"
Trait {
	#name : #TPaPatcheableAPI,
	#instVars : [
		'patch'
	],
	#category : #'SDLExperiments-IPC-Patches-Core'
}

{ #category : #accessing }
TPaPatcheableAPI classSide >> patcheableSlotIndices [

	| result |
	result := OrderedCollection new.
	self patcheableSlotsDo: [ :each | result add: each index ].
	^ result
]

{ #category : #accessing }
TPaPatcheableAPI classSide >> patcheableSlotNames [

	| result |
	result := OrderedCollection new.
	self patcheableSlotsDo: [ :each | result add: each name ].
	^ result
]

{ #category : #accessing }
TPaPatcheableAPI classSide >> patcheableSlots [

	| result |
	result := OrderedCollection new.
	self patcheableSlotsDo: [ :each | result add: each ].
	^ result
]

{ #category : #accessing }
TPaPatcheableAPI classSide >> patcheableSlotsDo: aBlock [

	self classLayout allSlotsDo: [ :each |
		each class = PaSlot ifTrue: [ aBlock value: each ] ]
]

{ #category : #patching }
TPaPatcheableAPI >> addPatchFirst: aLinkPatch [
	
	aLinkPatch nextPatch: self firstPatch.
	patch := aLinkPatch
]

{ #category : #patching }
TPaPatcheableAPI >> applyPatches [

	self hasPatches ifFalse: [ ^ self ].

	self applyPatches: patch.

	self resetPatches
]

{ #category : #patching }
TPaPatcheableAPI >> applyPatches: aFirstPatch [

	aFirstPatch withAllPatchesDo: [ :each | each applyPatchTo: self ]
]

{ #category : #patching }
TPaPatcheableAPI >> condensePatches [

	self hasPatches ifFalse: [ ^ self ].

	self addPatchFirst:
		(PaFullPatch new
			patcheableCopy: self copy;
			yourself)
]

{ #category : #patching }
TPaPatcheableAPI >> firstPatch [

	^ patch ifNil: [ PaNullPatch instance ]
]

{ #category : #testing }
TPaPatcheableAPI >> hasPatches [

	^ patch notNil
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

	^ self firstPatch count
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
	patch ifNil: [ ^ self ].

	current := patch.
	[ current isNullPatch ] whileFalse: [
		aUnaryBlock value: current.
		current := current nextPatch ]
]

{ #category : #copying }
TPaPatcheableAPI >> postCopy [
	"The copy has the patches applied. Note: patches are owned by the source object."

	self applyPatches
]

{ #category : #patching }
TPaPatcheableAPI >> resetPatches [

	patch := nil
]
