"
I'm a Soil object table that avoids strong pointers to do not prevent garbage collection.
"
Class {
	#name : #PaSoilObjectTable,
	#superclass : #SoilObjectTable,
	#instVars : [
		'lastId'
	],
	#category : #'SDLExperiments-IPC-Patches-Transmission-Soil'
}

{ #category : #api }
PaSoilObjectTable >> add: anObject [

	table
		at: anObject
		ifAbsentPut: [ lastId := lastId + 1 ]
]

{ #category : #initialization }
PaSoilObjectTable >> initialize [

	lastId := 0.
	table := WeakIdentityKeyDictionary new
]
