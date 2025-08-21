"
I'm an object whose mutations are written as patches. Accessors return the value from a patch, if available, or from the patcheable object, otherwise.
"
Class {
	#name : #Patcheable,
	#superclass : #Object,
	#instVars : [
		'patch'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #'as yet unclassified' }
Patcheable >> applyPatches [

	patch isNullPatch ifTrue: [ ^ self ].

	self patchesDo: [ :each | each applyPatchTo: self ].

	self privateResetPatch
]

{ #category : #converting }
Patcheable >> asCollection [

	| array |
	array := Array new: self size.

	1 to: array size do: [ :index |
		array at: index put: (self at: index) ].

	^ array
]

{ #category : #accessing }
Patcheable >> at: index [

	^ patch read: self at: index
]

{ #category : #accessing }
Patcheable >> at: index put: aValue [

	patch write: self at: index put: aValue
]

{ #category : #introspection }
Patcheable >> basicInstVarAt: index [

	^ super instVarAt: index
]

{ #category : #introspection }
Patcheable >> basicInstVarAt: index put: anObject [

	^ super instVarAt: index put: anObject
]

{ #category : #'as yet unclassified' }
Patcheable >> discardPatches [

	patch isNullPatch ifTrue: [ ^ self ].

	self privateResetPatch
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

	self privateResetPatch
]

{ #category : #debugging }
Patcheable >> inspectionOfPatches: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Patches'>

	^ aBuilder newList
		items: self patches;
		display: [ :each | each descriptionFor: self ]
		yourself
]

{ #category : #introspection }
Patcheable >> instVarAt: index [

	^ patch read: self instVarAt: index
]

{ #category : #introspection }
Patcheable >> instVarAt: index put: aValue [

	patch write: self instVarAt: index put: aValue
]

{ #category : #private }
Patcheable >> linkPatchForAt: anInteger put: aValue [
	"Add a patch assuming there wasn't a linked matching patch."

	(anInteger between: 1 and: self size) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	patch :=
		AtPutPatch new
			index: anInteger;
			writtenValue: aValue;
			nextPatch: patch;
			yourself
]

{ #category : #private }
Patcheable >> linkPatchForInstVarAt: anInteger put: aValue [
	"Add a patch assuming there wasn't a linked matching patch."

	patch :=
		InstVarAtPutPatch new
			index: anInteger;
			writtenValue: aValue;
			nextPatch: patch;
			yourself
]

{ #category : #accessing }
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

{ #category : #copying }
Patcheable >> postCopy [
	"The copy has the patches applied. Do not return patches to pool since we assume they are owned by the source object."

	patch isNullPatch ifTrue: [ ^ self ].

	self patchesDo: [ :each | each applyPatchTo: self ].

	self privateResetPatch
]

{ #category : #private }
Patcheable >> privateResetPatch [

	self flag: #todo. "Return each to its pool"

	patch := NullPatch instance
]
