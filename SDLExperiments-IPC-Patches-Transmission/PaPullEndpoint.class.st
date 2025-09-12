Class {
	#name : #PaPullEndpoint,
	#superclass : #SoilMaterializer,
	#instVars : [
		'root'
	],
	#pools : [
		'PaSoilTypeCodes'
	],
	#category : #'SDLExperiments-IPC-Patches-Transmission-Soil'
}

{ #category : #initialization }
PaPullEndpoint >> initialize [

	externalObjectRegistry := PaSoilRegistry new.

	objects := WeakOrderedCollection new.
	WellKnownObjects do: [ :each | self registerObject: each ]
]

{ #category : #reading }
PaPullEndpoint >> nextFixedLayoutPatcheable: description [
	"When materializing, we update the base patcheable (avoid patches)."

	| patcheable |
	patcheable := description basicNew.
	self registerObject: patcheable.

	description patcheableSlotIndices do: [ :index | 
		patcheable basicInstVarAt: index put: (self nextSoilObject) ].

	^ patcheable
]

{ #category : #reading }
PaPullEndpoint >> nextPaAtPutPatch [

	^ PaAtPutPatch
		index: self nextByte
		value: self nextSoilObject
		nextPatch: self nextSoilObject
]

{ #category : #reading }
PaPullEndpoint >> nextPaInstVarAtPutPatchAt: anIndex [

	^ PaInstVarAtPutPatch
		index: anIndex
		value: self nextSoilObject
		nextPatch: self nextSoilObject
]

{ #category : #reading }
PaPullEndpoint >> nextSoilObject [ 
	"Hacky: Override this key Soil method. Ignore #soilMaterializationReplacement."

	^ (PaTypeCodeMapping at: self nextByte) soilMaterialize: self
]

{ #category : #reading }
PaPullEndpoint >> nextVariableLayoutPatcheable: description [
	"When materializing, we update the base patcheable (avoid patches)."

	| patcheable basicSize |
	basicSize := self nextLengthEncodedInteger.
	patcheable := description basicNew: basicSize.
	self registerObject: patcheable.

	description patcheableSlotIndices do: [ :index | 
		patcheable basicInstVarAt: index put: (self nextSoilObject) ].

	1 to: basicSize do: [ :index |
		patcheable basicAt: index put: self nextSoilObject ].

	^ patcheable
]

{ #category : #synchronization }
PaPullEndpoint >> pull [

	| pullType |
	pullType := self nextByte.
	pullType = TypeCodePatches ifTrue: [ ^ self pullPatches ].
	pullType = TypeCodeRoot ifTrue: [ ^ self pullFull ].
	self error
]

{ #category : #synchronization }
PaPullEndpoint >> pullFull [
	"Materialize a new root. Reset index table (via initialize)"

	self initialize.
	root := self nextSoilObject
]

{ #category : #synchronization }
PaPullEndpoint >> pullPatches [
	"Root remains the same. Apply incoming patches to objects materialized in a previous pull"

	| indexOfPatcheable |
	[ (indexOfPatcheable := self nextLengthEncodedInteger) > 0 ] whileTrue: [
		| patcheable firstPatch |
		patcheable := objects at: indexOfPatcheable.
		firstPatch := self nextSoilObject.
		patcheable applyPatches: firstPatch ]
]

{ #category : #synchronization }
PaPullEndpoint >> pullUntilEnd [

	[ stream atEnd ] whileFalse: [ self pull ]
]

{ #category : #accessing }
PaPullEndpoint >> root [

	^ root
]
