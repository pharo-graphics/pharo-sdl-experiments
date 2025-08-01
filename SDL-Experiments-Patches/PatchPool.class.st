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
PatchPool >> initialize [

	self reset
]

{ #category : #'instance creation' }
PatchPool >> nextPatch [

	| result |
	first isNullPatch
		"Answer a new instance if there aren't available patches"
		ifTrue: [ result := patchClass new ]
		"Unplug the first available patch"
		ifFalse: [
			result := first.
			first := result nextPatch.
			first ifNil: [ self error ]. ].

	result nextPatch: NullPatch instance.

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

	first := NullPatch instance
]

{ #category : #'instance creation' }
PatchPool >> returnPatch: aPatch [

	aPatch class = patchClass ifFalse: [ self error ].

	aPatch nextPatch: first.
	first := aPatch
]

{ #category : #'instance creation' }
PatchPool >> size [

	^ first count
]
