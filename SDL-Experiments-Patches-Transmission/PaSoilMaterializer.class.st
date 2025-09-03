Class {
	#name : #PaSoilMaterializer,
	#superclass : #SoilMaterializer,
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #initialization }
PaSoilMaterializer >> initialize [

	super initialize.

	self externalObjectRegistry: PaSoilRegistry new
]
