Class {
	#name : #PaSoilBehaviorDescription,
	#superclass : #SoilBehaviorDescription,
	#instVars : [
		'patcheableSlotIndices'
	],
	#category : #'SDL-Experiments-Patches-Transmission'
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
