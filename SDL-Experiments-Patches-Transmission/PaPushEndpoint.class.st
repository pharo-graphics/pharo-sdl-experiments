Class {
	#name : #PaPushEndpoint,
	#superclass : #SoilSerializer,
	#instVars : [
		'dirtyPatcheables',
		'subscriptions',
		'needsFull',
		'root'
	],
	#pools : [
		'PaSoilTypeCodes'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #accessing }
PaPushEndpoint >> dirtyPatcheables [

	^ dirtyPatcheables
]

{ #category : #initialization }
PaPushEndpoint >> initialize [

	super initialize.
	
	dirtyPatcheables := WeakOrderedCollection new.
	subscriptions := WeakSet new.
	needsFull := true.
	self externalObjectRegistry: PaSoilRegistry new
]

{ #category : #writing }
PaPushEndpoint >> nextPutFloat: aFloat [
	"Encode a 64-bits float. Override Soil v3 encoding with Fuel, which is more performant."

	aFloat == 0.0 ifTrue: [
		^ self nextPutByte: TypeCodeFloatZero ].

	aFloat == 1.0 ifTrue: [
		^ self nextPutByte: TypeCodeFloatOne ].

	super nextPutFloat: aFloat
]

{ #category : #writing }
PaPushEndpoint >> nextPutNullPatch [

	self nextPutByte: TypeCodeNullPatch
]

{ #category : #writing }
PaPushEndpoint >> nextPutPaAtPutPatch: aPatch [

	self
		nextPutByte: TypeCodeAtPutPatch;
		nextPutByte: aPatch index.

	aPatch writtenValue soilSerialize: self.
	aPatch nextPatch soilSerialize: self
]

{ #category : #writing }
PaPushEndpoint >> nextPutPaInstVarAtPutPatch: aPatch [

	"Small indices can be directly embedded in the typecode"
	aPatch index > NumberOfEmbeddedIndexInstVarAtPutPatchTypeCode
		ifTrue: [
			self
				nextPutByte: TypeCodeInstVarAtPutPatch;
				nextPutByte: aPatch index ]
		ifFalse: [
			self nextPutByte: TypeCodeInstVarAtPutPatch + aPatch index ].

	aPatch writtenValue soilSerialize: self.
	aPatch nextPatch soilSerialize: self
]

{ #category : #subscription }
PaPushEndpoint >> notifyDirty: aPatcheable [
	
	dirtyPatcheables add: aPatcheable
]

{ #category : #subscription }
PaPushEndpoint >> notifyFullySerialized: aPatcheable [
	"After a patcheable is serialized, only the new patches will be encoded."

	aPatcheable addSubscriber: self.
	subscriptions add: aPatcheable
]

{ #category : #synchronization }
PaPushEndpoint >> push [

	^ needsFull ifTrue: [ self pushFull ] ifFalse: [ self pushPatches ]
]

{ #category : #synchronization }
PaPushEndpoint >> pushFull [

	self nextPutByte: TypeCodeRoot.
	
	root soilSerialize: self.
	needsFull := false
]

{ #category : #synchronization }
PaPushEndpoint >> pushPatches [

	| patches |
	"Encode the patcheables that are dirty
	(i.e. patches were added after last serialization)"

	self nextPutByte: TypeCodePatches.

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

	patches soilSerialize: self
]

{ #category : #initialization }
PaPushEndpoint >> registerObject: anObject [
	"Useful to preset well-known objects. But these objects MUST match in position with materializer."

	objectIdTable add: anObject
]

{ #category : #dependencies }
PaPushEndpoint >> release [

	subscriptions do: [ :each | each removeSubscription: self ].
	subscriptions removeAll
]

{ #category : #synchronization }
PaPushEndpoint >> reset [

	self release.
	self initialize "resets the objects table"
]

{ #category : #accessing }
PaPushEndpoint >> root [

	^ root
]

{ #category : #accessing }
PaPushEndpoint >> root: aPatcheable [

	root ifNotNil: [ self release ].
	self reset.

	root := aPatcheable
]
