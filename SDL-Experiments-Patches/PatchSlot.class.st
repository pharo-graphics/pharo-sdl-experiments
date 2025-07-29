Class {
	#name : #PatchSlot,
	#superclass : #IndexedSlot,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #'meta-object-protocol' }
PatchSlot >> read: aPatcheable [
	"If there are no patches, then read as a simple instvar."
	<reflection: 'Object Inspection - State inspection'>

	^ aPatcheable nextPatch
		ifNil: [ super read: aPatcheable ]
		ifNotNil: [ :p | p read: aPatcheable instVarAt: index ]
]

{ #category : #'meta-object-protocol' }
PatchSlot >> write: aValue to: aPatcheable [
	"Write the value in a patch. In the case there is already a patch for my index, override its value. Otherwise, a new patch will be used."
	<reflection: 'Object Modification - State modification'>

	aPatcheable nextPatch
		ifNil: [ aPatcheable addPatchForInstVarAt: index put: aValue ]
		ifNotNil: [ :p | p write: aPatcheable instVarAt: index put: aValue ]

]
