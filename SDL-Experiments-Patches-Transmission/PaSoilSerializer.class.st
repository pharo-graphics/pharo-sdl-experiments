Class {
	#name : #PaSoilSerializer,
	#superclass : #SoilSerializer,
	#instVars : [
		'dirtyPatcheables',
		'subscriptions'
	],
	#pools : [
		'PaSoilTypeCodes'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #accessing }
PaSoilSerializer >> dirtyPatcheables [
	^ dirtyPatcheables
]

{ #category : #initialization }
PaSoilSerializer >> initialize [

	super initialize.

	self externalObjectRegistry: PaSoilRegistry new.

	subscriptions := WeakSet new.
	dirtyPatcheables := IdentitySet new
]

{ #category : #writing }
PaSoilSerializer >> nextPutFloat: aFloat [
	"Encode a 64-bits float. Override Soil v3 encoding with Fuel, which is more performant."

	aFloat == 0.0 ifTrue: [
		^ self nextPutByte: TypeCodeFloatZero ].

	aFloat == 1.0 ifTrue: [
		^ self nextPutByte: TypeCodeFloatOne ].

	super nextPutFloat: aFloat
]

{ #category : #writing }
PaSoilSerializer >> nextPutNullPatch [

	self nextPutByte: TypeCodeNullPatch
]

{ #category : #writing }
PaSoilSerializer >> nextPutPaAtPutPatch: aPatch [

	self
		nextPutByte: TypeCodeAtPutPatch;
		nextPutByte: aPatch index.
	aPatch writtenValue soilSerialize: self.
	aPatch nextPatch soilSerialize: self
]

{ #category : #writing }
PaSoilSerializer >> nextPutPaInstVarAtPutPatch: aPatch [

	self
		nextPutByte: TypeCodeInstVarAtPutPatch;
		nextPutByte: aPatch index.
	aPatch writtenValue soilSerialize: self.
	aPatch nextPatch soilSerialize: self
]

{ #category : #subscription }
PaSoilSerializer >> notifyDirty: aPatcheable [
	
	dirtyPatcheables add: aPatcheable
]

{ #category : #subscription }
PaSoilSerializer >> notifyFullySerialized: aPatcheable [
	"After a patcheable is serialized, only the new patches will be encoded."

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

	subscriptions do: [ :each | each removeSubscription: self ]
]

{ #category : #private }
PaSoilSerializer >> serialize: anObject [
	"Optimization: We ignore #soilSerializationReplacement and don't create a byteArray from the stream"

	clusterRoot := anObject.
	clusterRoot soilSerialize: self
]

{ #category : #serialization }
PaSoilSerializer >> serializePatches [

	| patches |
	"Encode the patcheables that are dirty
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
