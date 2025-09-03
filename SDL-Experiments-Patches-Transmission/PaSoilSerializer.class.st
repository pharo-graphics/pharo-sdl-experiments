Class {
	#name : #PaSoilSerializer,
	#superclass : #SoilSerializer,
	#instVars : [
		'dirtyPatcheables',
		'subscriptions'
	],
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #subscription }
PaSoilSerializer >> firstPatchWasAddedTo: aPatcheable [
	
	dirtyPatcheables add: aPatcheable
]

{ #category : #initialization }
PaSoilSerializer >> initialize [

	super initialize.

	self externalObjectRegistry: PaSoilRegistry new.

	subscriptions := WeakSet new.
	dirtyPatcheables := IdentitySet new
]

{ #category : #subscription }
PaSoilSerializer >> patcheableWasFullySerialized: aPatcheable [.
	"This is only executed on full serialization. After this object is registered,
	only patches will be serialized."

	aPatcheable applyPatches.
	aPatcheable addSubscriber: self.
	subscriptions add: aPatcheable
]

{ #category : #initialization }
PaSoilSerializer >> registerObject: anObject [
	"Useful to preset well-known objects. But these objects MUST match in position with materializer."

	objectIdTable add: anObject
]

{ #category : #dependencies }
PaSoilSerializer >> release [

	subscriptions do: [ :each |
		each removeSubscription: self ]
]

{ #category : #serialization }
PaSoilSerializer >> serializePatches [

	| patches |
	"Encode the patcheablees that are dirty
	(i.e. patches were added after last serialization)"

	patches := Array streamContents: [ :str |
		dirtyPatcheables do: [ :each |
			"If the patcheable was previously serialized,
				then only an index will be encoded,
				otherwise, it will be fully encoded."
			str
				nextPut: each;
				nextPut: each firstPatch.
			each applyPatches ].
		dirtyPatcheables removeAll ].

	self serialize: patches
]
