Class {
	#name : #PaArray,
	#superclass : #PaBaseObject,
	#type : #variable,
	#traits : 'TPaIndexedVariablesAPI - {#addPatchFirst:} + TPaSubscribableAPI',
	#classTraits : 'TPaIndexedVariablesAPI classTrait + TPaSubscribableAPI classTrait',
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #'instance creation' }
PaArray class >> with: anObject [
	"Answer a new instance without patches"

	| newCollection |
	newCollection := self new: 1.
	newCollection basicAt: 1 put: anObject.
	^ newCollection
]

{ #category : #copying }
PaArray >> copyWith: anObject [
	"Answer a copy of myself with the received object at last position. The copy has no patches."

	| copy |
	copy := self class new: self size + 1.
	1 to: self size do: [ :i |
		copy basicAt: i put: (self at: i) ].

	copy basicAt: copy size put: anObject.

	^ copy
]
