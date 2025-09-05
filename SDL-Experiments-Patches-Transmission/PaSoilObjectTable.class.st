Class {
	#name : #PaSoilObjectTable,
	#superclass : #SoilObjectTable,
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #initialization }
PaSoilObjectTable >> initialize [

	table := WeakIdentityKeyDictionary new
]
