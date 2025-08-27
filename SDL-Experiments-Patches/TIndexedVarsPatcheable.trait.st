"
I'm a trait for objects whose mutations to indexed variables are written as patches. Accessors return the value from a patch, if available, or from the patcheable object, otherwise.
"
Trait {
	#name : #TIndexedVarsPatcheable,
	#traits : 'TInstVarsPatcheable',
	#classTraits : 'TInstVarsPatcheable classTrait',
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #converting }
TIndexedVarsPatcheable >> asCollection [

	^ self as: Array
]

{ #category : #accessing }
TIndexedVarsPatcheable >> at: index [

	^ patch read: self at: index
]

{ #category : #accessing }
TIndexedVarsPatcheable >> at: index put: aValue [

	patch write: self at: index put: aValue
]

{ #category : #newtools }
TIndexedVarsPatcheable >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'> 

	^ self asCollection inspectionItems: aBuilder
]

{ #category : #private }
TIndexedVarsPatcheable >> linkPatchForAt: anInteger put: aValue [
	"Add a patch assuming there wasn't a linked matching patch."

	(anInteger between: 1 and: self size) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	patch :=
		AtPutPatch new
			index: anInteger;
			writtenValue: aValue;
			nextPatch: patch;
			yourself
]
