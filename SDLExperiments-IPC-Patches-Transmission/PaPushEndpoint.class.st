Class {
	#name : #PaPushEndpoint,
	#superclass : #SoilSerializer,
	#instVars : [
		'dirtyPatcheables',
		'subscriptions',
		'needsFull',
		'root',
		'dirtyPatcheablesSubscription'
	],
	#pools : [
		'PaSoilTypeCodes'
	],
	#category : #'SDLExperiments-IPC-Patches-Transmission-Soil'
}

{ #category : #accessing }
PaPushEndpoint >> dirtyPatcheables [

	^ dirtyPatcheables
]

{ #category : #subscription }
PaPushEndpoint >> dirtyPatcheablesSubscription: aMessageSend [

	Halt if: [ dirtyPatcheablesSubscription notNil ].

	dirtyPatcheablesSubscription := aMessageSend
]

{ #category : #initialization }
PaPushEndpoint >> initialize [

	externalObjectRegistry := PaSoilRegistry new.

	objectIdTable := PaSoilObjectTable new.
	WellKnownObjects do: [ :each | self registerObject: each ].
		
	dirtyPatcheables := WeakOrderedCollection new.
	subscriptions := WeakSet new.
	needsFull := true
]

{ #category : #writing }
PaPushEndpoint >> nextPutFixedLayoutPatcheable: patcheable [
	"Encode the patcheable. Prepare it by applying any available patch."

	| description |
	patcheable applyPatches.

	description := self serializeBehaviorDescriptionFor: patcheable.

	description patcheableSlotIndices do: [ :index |
		(patcheable basicInstVarAt: index) soilSerialize: self ].

	self subscribeToNewPatchesOf: patcheable
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

{ #category : #private }
PaPushEndpoint >> nextPutIndexOfInternalObject: anObject [
	"Encode the index of the argument in the objectIdTable, without a TypeCode (low-level optimization)."

	| index |
	index := objectIdTable identityIndexOf: anObject.
	index < 1 ifTrue: [ NotFound signalFor: anObject ].

	self nextPutLengthEncodedInteger: index
]

{ #category : #writing }
PaPushEndpoint >> nextPutNullPatch [

	self nextPutByte: TypeCodeNullPatch
]

{ #category : #writing }
PaPushEndpoint >> nextPutOpaqueColor: aColor [

	self
		nextPutByte: TypeCodeOpaqueColor;
		nextPutByte: (aColor red * 255.0) asInteger;
		nextPutByte: (aColor green * 255.0) asInteger;
		nextPutByte: (aColor blue * 255.0) asInteger
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

{ #category : #writing }
PaPushEndpoint >> nextPutPatcheableOrInternalReference: patcheable [

	| index |
	(objectIdTable isEmpty or: [
	(index := objectIdTable identityIndexOf: patcheable) = 0 ])
		ifTrue: [
			objectIdTable add: patcheable.
			patcheable soilBasicSerialize: self ]
		ifFalse: [
			self nextPutInternalReference: index ]
]

{ #category : #writing }
PaPushEndpoint >> nextPutTranslucentColor: aColor [

	self
		nextPutByte: TypeCodeTranslucentColor;
		nextPutByte: (aColor red * 255.0) asInteger;
		nextPutByte: (aColor green * 255.0) asInteger;
		nextPutByte: (aColor blue * 255.0) asInteger;
		nextPutByte: aColor privateAlpha "Internally, already alpha <= 255"
]

{ #category : #writing }
PaPushEndpoint >> nextPutVariableLayoutPatcheable: patcheable [
	"Encode the patcheable. Prepare it by applying any available patch."

	| description basicSize |
	patcheable applyPatches.

	description := self serializeBehaviorDescriptionFor: patcheable.
	basicSize := patcheable basicSize.
	self nextPutLengthEncodedInteger: basicSize.

	description patcheableSlotIndices do: [ :index |
		(patcheable basicInstVarAt: index) soilSerialize: self ].

	1 to: basicSize do: [ :index |
		(patcheable basicAt: index) soilSerialize: self ].

	self subscribeToNewPatchesOf: patcheable
]

{ #category : #subscription }
PaPushEndpoint >> notifyDirty: aPatcheable [
	
	dirtyPatcheables add: aPatcheable.
	
	dirtyPatcheablesSubscription value
]

{ #category : #synchronization }
PaPushEndpoint >> push [
	"Only do full serialization when it was required. Else, only serialize the patches of the dirty patcheables i.e. that notified mutations."

	needsFull
		ifTrue: [
			self nextPutByte: TypeCodeRoot.
			self pushFull ]
		ifFalse: [
			dirtyPatcheables ifEmpty: [ ^ self ].
			self nextPutByte: TypeCodePatches.
			self pushPatches ]
]

{ #category : #synchronization }
PaPushEndpoint >> pushFull [

	root soilSerialize: self.
	needsFull := false
]

{ #category : #synchronization }
PaPushEndpoint >> pushPatches [
	"Encode the patcheables that are dirty (i.e. patches were added after last serialization)"

	[ dirtyPatcheables isEmpty ] whileFalse: [
		| each |
		each := dirtyPatcheables removeFirst.
		"If patchceable was GCed, then we will get nil"
		each ifNotNil: [
			"Only patcheables that were serialized in a previous push should 
			be in this collection, so encode its internal index."
			self nextPutIndexOfInternalObject: each.
			"Serialize patch chain (they have a special encoding)"
			each firstPatch soilSerialize: self.
			"Apply patches of this patcheable"
			each applyPatches ] ].

	"Mark the end of the patches"
	self nextPutByte: 0
]

{ #category : #initialization }
PaPushEndpoint >> registerClass: aClass [
	"Useful to preset well-known classes. The sequence of classes MUST match in both endpoints."

	externalObjectRegistry add: aClass
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

{ #category : #subscription }
PaPushEndpoint >> subscribeToNewPatchesOf: aPatcheable [
	"After a patcheable is serialized, only the new patches will be encoded."

	aPatcheable addSubscriber: self.
	subscriptions add: aPatcheable
]

{ #category : #accessing }
PaPushEndpoint >> subscriptions [

	^ subscriptions
]
