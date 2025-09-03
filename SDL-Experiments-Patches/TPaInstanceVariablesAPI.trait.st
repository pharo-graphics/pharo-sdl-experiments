"
I'm a trait for objects whose mutations to instance variables are written as patches. Accessors return the value from a patch, if available, or from the patcheable object, otherwise.
"
Trait {
	#name : #TPaInstanceVariablesAPI,
	#traits : 'TPaPatcheableAPI',
	#classTraits : 'TPaPatcheableAPI classTrait',
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #private }
TPaInstanceVariablesAPI >> addPatchForInstVarAt: anInteger put: aValue [
	"Add a patch assuming there wasn't a linked matching patch."

	self addPatchFirst:
		(PaInstVarAtPutPatch new
			index: anInteger;
			writtenValue: aValue;
			yourself)
]

{ #category : #introspection }
TPaInstanceVariablesAPI >> basicInstVarAt: index [

	^ super instVarAt: index
]

{ #category : #introspection }
TPaInstanceVariablesAPI >> basicInstVarAt: index put: anObject [

	^ super instVarAt: index put: anObject
]

{ #category : #introspection }
TPaInstanceVariablesAPI >> instVarAt: index [

	^ self firstPatch read: self instVarAt: index
]

{ #category : #introspection }
TPaInstanceVariablesAPI >> instVarAt: index put: aValue [

	self firstPatch write: self instVarAt: index put: aValue
]
