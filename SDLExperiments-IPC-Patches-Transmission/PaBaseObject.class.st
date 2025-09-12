Class {
	#name : #PaBaseObject,
	#superclass : #Object,
	#traits : 'TPaPatcheableAPI',
	#classTraits : 'TPaPatcheableAPI classTrait',
	#category : #'SDLExperiments-IPC-Patches-Transmission-Core'
}

{ #category : #accessing }
PaBaseObject class >> soilPersistentInstVars [

	^ self patcheableSlotNames
]

{ #category : #printing }
PaBaseObject >> printBasicOn: aStream [

	aStream
		nextPutAll: '#patches: ';
		print: self patchCount
]

{ #category : #printing }
PaBaseObject >> printDetailsOn: aStream [
]

{ #category : #printing }
PaBaseObject >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	self printBasicOn: aStream.
	aStream space.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : #serialization }
PaBaseObject >> soilBasicSerialize: serializer [
	"Delegate serialization to the class layout"

	self class classLayout patcheableSoilBasicSerialize: self with: serializer
]

{ #category : #soil }
PaBaseObject >> soilSerialize: serializer [ 
	"Override to optimize"

	serializer nextPutPatcheableOrInternalReference: self
]
