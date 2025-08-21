Trait {
	#name : #TInstVarsPatcheable,
	#traits : 'TPatcheable',
	#classTraits : 'TPatcheable classTrait',
	#category : #'SDL-Experiments-Patches'
}

{ #category : #introspection }
TInstVarsPatcheable >> basicInstVarAt: index [

	^ super instVarAt: index
]

{ #category : #introspection }
TInstVarsPatcheable >> basicInstVarAt: index put: anObject [

	^ super instVarAt: index put: anObject
]

{ #category : #introspection }
TInstVarsPatcheable >> instVarAt: index [

	^ patch read: self instVarAt: index
]

{ #category : #introspection }
TInstVarsPatcheable >> instVarAt: index put: aValue [

	patch write: self instVarAt: index put: aValue
]

{ #category : #private }
TInstVarsPatcheable >> linkPatchForInstVarAt: anInteger put: aValue [
	"Add a patch assuming there wasn't a linked matching patch."

	patch :=
		InstVarAtPutPatch new
			index: anInteger;
			writtenValue: aValue;
			nextPatch: patch;
			yourself
]
