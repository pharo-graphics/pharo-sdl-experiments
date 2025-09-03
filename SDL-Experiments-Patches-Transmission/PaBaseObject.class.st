Class {
	#name : #PaBaseObject,
	#superclass : #Object,
	#traits : 'TPaPatcheableAPI',
	#classTraits : 'TPaPatcheableAPI classTrait',
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #accessing }
PaBaseObject class >> soilPersistentInstVars [

	^ self patcheableSlotNames
]

{ #category : #serialization }
PaBaseObject >> soilBasicSerialize: serializer [
	"Delegate serialization to the class layout"

	self class classLayout patcheableSoilBasicSerialize: self with: serializer
]
