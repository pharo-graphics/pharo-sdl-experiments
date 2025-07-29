Class {
	#name : #PatchPool,
	#superclass : #Object,
	#instVars : [
		'patchClass',
		'first'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #'instance creation' }
PatchPool >> nextPatch [

	| result |
	"Answer a new instance if there aren't available patches"
	first ifNil: [ ^ patchClass new ].

	"Unplug the first available patch"
	result := first.
	first := result nextPatch.
	result nextPatch: nil.

	^ result
]

{ #category : #accessing }
PatchPool >> patchClass [

	^ patchClass
]

{ #category : #accessing }
PatchPool >> patchClass: aClass [

	patchClass := aClass
]

{ #category : #'instance creation' }
PatchPool >> reset [

	first := nil
]

{ #category : #'instance creation' }
PatchPool >> returnPatch: unusedPatch [

	unusedPatch last nextPatch: first.
	first := unusedPatch
]

{ #category : #'instance creation' }
PatchPool >> size [

	^ first ifNil: [ 0 ] ifNotNil: [ first count ]
]
