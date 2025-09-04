Class {
	#name : #PaSoilMaterializer,
	#superclass : #SoilMaterializer,
	#pools : [
		'PaSoilTypeCodes'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #initialization }
PaSoilMaterializer >> initialize [

	super initialize.

	self externalObjectRegistry: PaSoilRegistry new
]

{ #category : #reading }
PaSoilMaterializer >> nextSoilObject [ 
	"Hacky: Override this key Soil method. Ignore #soilMaterializationReplacement."

	^ (PaTypeCodeMapping at: self nextByte ifAbsent: [
		Error signal: 'cannot find type code']) 
			soilMaterialize: self
]
