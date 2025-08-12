Class {
	#name : #PredecessorPatchSlot,
	#superclass : #IndexedSlot,
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #'meta-object-protocol' }
PredecessorPatchSlot >> read: aPatcheable [
	"If there are no patches, then read as a simple instvar."
	<reflection: 'Object Inspection - State inspection'>

	^ aPatcheable firstPatch readPredecessor: aPatcheable
]

{ #category : #'meta-object-protocol' }
PredecessorPatchSlot >> write: aValue to: aPatcheable [
	"Write the value in a patch. In the case there is already a patch for my index, override its value. Otherwise, a new patch will be used."
	<reflection: 'Object Modification - State modification'>

	aPatcheable firstPatch writePredecessor: aPatcheable put: aValue
]
