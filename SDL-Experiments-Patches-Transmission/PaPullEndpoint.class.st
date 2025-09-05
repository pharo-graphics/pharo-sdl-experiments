Class {
	#name : #PaPullEndpoint,
	#superclass : #SoilMaterializer,
	#instVars : [
		'root'
	],
	#pools : [
		'PaSoilTypeCodes'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #initialization }
PaPullEndpoint >> initialize [

	super initialize.

	self externalObjectRegistry: PaSoilRegistry new
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
	"Root remains the same, but patches are applied to objects previously materialized."

	| patches |
	patches := self nextSoilObject.

	patches pairsDo: [ :patcheable :firstPatch |
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
