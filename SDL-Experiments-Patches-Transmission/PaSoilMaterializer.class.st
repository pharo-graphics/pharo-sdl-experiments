Class {
	#name : #PaSoilMaterializer,
	#superclass : #SoilMaterializer,
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #initialization }
PaSoilMaterializer >> initialize [

	super initialize.

	self externalObjectRegistry: PaSoilRegistry new
]
