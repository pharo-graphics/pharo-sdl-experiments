"
I'm a trait for objects whose mutations to indexed variables are written as patches. Accessors return the value from a patch, if available, or from the patcheable object, otherwise.
"
Trait {
	#name : #TPaIndexedVariablesAPI,
	#traits : 'TPaInstanceVariablesAPI',
	#classTraits : 'TPaInstanceVariablesAPI classTrait',
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #private }
TPaIndexedVariablesAPI >> addPatchForAt: anInteger put: aValue [
	"Add a patch assuming there wasn't a linked matching patch."

	(anInteger between: 1 and: self size) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	self addPatchFirst: (PaAtPutPatch index: anInteger value: aValue)
]

{ #category : #converting }
TPaIndexedVariablesAPI >> asArray [

	^ self as: Array
]

{ #category : #accessing }
TPaIndexedVariablesAPI >> at: index [

	^ self firstPatch read: self at: index
]

{ #category : #accessing }
TPaIndexedVariablesAPI >> at: index put: aValue [

	self firstPatch write: self at: index put: aValue
]

{ #category : #debugging }
TPaIndexedVariablesAPI >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'> 

	^ self asArray inspectionItems: aBuilder
]
