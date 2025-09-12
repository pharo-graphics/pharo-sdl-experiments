Class {
	#name : #PaSoilBehaviorDescription,
	#superclass : #SoilBehaviorDescription,
	#instVars : [
		'patcheableSlotIndices'
	],
	#category : #'SDLExperiments-IPC-Patches-Transmission-Soil'
}

{ #category : #initialization }
PaSoilBehaviorDescription >> initializeFromBehavior: aClass [

	super initializeFromBehavior: aClass.

	patcheableSlotIndices := aClass patcheableSlotIndices
]

{ #category : #'object creation' }
PaSoilBehaviorDescription >> newObjectWith: aMaterializer [

	^ self objectClass classLayout
		  patcheableSoilBasicMaterialize: self
		  with: aMaterializer
]

{ #category : #accessing }
PaSoilBehaviorDescription >> patcheableSlotIndices [

	^ patcheableSlotIndices
]
