"
I'm a slot for instance variables of patcheable objects.
"
Class {
	#name : #PaSlot,
	#superclass : #IndexedSlot,
	#category : #'SDLExperiments-IPC-Patches-Core'
}

{ #category : #'meta-object-protocol' }
PaSlot >> read: aPatcheable [
	"If there are no patches, then read as a simple instvar."
	<reflection: 'Object Inspection - State inspection'>

	^ aPatcheable firstPatch read: aPatcheable instVarAt: index
]

{ #category : #'meta-object-protocol' }
PaSlot >> write: aValue to: aPatcheable [
	"Write the value in a patch. In the case there is already a patch for my index, override its value. Otherwise, a new patch will be used."
	<reflection: 'Object Modification - State modification'>

	aPatcheable firstPatch
		write: aPatcheable
		instVarAt: index
		put: aValue
]
