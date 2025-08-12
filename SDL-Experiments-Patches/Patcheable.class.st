Class {
	#name : #Patcheable,
	#superclass : #Object,
	#instVars : [
		'#patch',
		'#predecessor => PredecessorPatchSlot'
	],
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #accessing }
Patcheable class >> indexOfPredecessorSlot [

	self flag: #todo.
	^ 2
]

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

{ #category : #accessing }
Patcheable >> addPatchForPredecessorPut: aValue [
	"This is evaluated when there wasn't a patch for predecessor, so create one."

	patch :=
		PredecessorPatch new
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

{ #category : #'as yet unclassified' }
Patcheable >> applyPatchesRecursively [

	self withAllPatcheablesDo: [ :each | each applyPatches ]
]

{ #category : #accessing }
Patcheable >> at: index [

	^ patch read: self at: index
]

{ #category : #accessing }
Patcheable >> at: index put: aValue [

	patch write: self at: index put: aValue
]

{ #category : #prodecessors }
Patcheable >> attachPredecessor: aPatcheable [

	predecessor ifNotNil: [ self error ].
	predecessor := aPatcheable
]

{ #category : #prodecessors }
Patcheable >> detachPredecessor: aPatcheable [

	predecessor == aPatcheable ifFalse: [ self error ].
	predecessor := nil
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

{ #category : #testing }
Patcheable >> isPatcheable [

	^ true
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

{ #category : #prodecessors }
Patcheable >> predecessor [

	^ predecessor
]

{ #category : #enumerating }
Patcheable >> withAllPatcheablesDo: aBlock [
	"Evaluate the block depth-first. WARNING: we do not take care of loops!"

	self class classLayout allSlotsDo: [ :each |
		each class = PatchSlot ifTrue: [
			| successor |
			successor := each read: self.
			successor isPatcheable ifTrue: [
				successor withAllPatcheablesDo: aBlock.
				aBlock value: successor ] ] ].

	1 to: self size do: [ :each |
		| successor |
		successor := aBlock value: each.
		aBlock value: successor ].

	aBlock value: self
]
