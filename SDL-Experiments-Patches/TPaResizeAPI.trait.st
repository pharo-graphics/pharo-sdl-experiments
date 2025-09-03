"
I'm a trait that extends `TIndexedVarsPatcheable` with API and patches to increase and decrease size of the instance.
"
Trait {
	#name : #TPaResizeAPI,
	#traits : 'TPaIndexedVariablesAPI',
	#classTraits : 'TPaIndexedVariablesAPI classTrait',
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #adding }
TPaResizeAPI >> add: anObject [

	self addFirst: anObject
]

{ #category : #accessing }
TPaResizeAPI >> add: aValue at: index [

	self firstPatch write: self add: aValue at: index
]

{ #category : #adding }
TPaResizeAPI >> addFirst: anObject [

	self add: anObject at: 1
]

{ #category : #adding }
TPaResizeAPI >> addLast: anObject [

	self add: anObject at: self size + 1
]

{ #category : #private }
TPaResizeAPI >> addPatchForAdd: aValue at: anInteger [ 
	
	(anInteger between: 1 and: self size + 1) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	self addPatchFirst:
		(PaAddAtPatch new
			index: anInteger;
			writtenValue: aValue;
			yourself)
]

{ #category : #private }
TPaResizeAPI >> addPatchForRemoveAt: anInteger [
	
	(anInteger between: 1 and: self size) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	self addPatchFirst:
		(PaRemoveAtPatch new
			index: anInteger;
			yourself)
]

{ #category : #copying }
TPaResizeAPI >> copy [

	| class newObject newSize |
	"Optimization if class layout isn't variable"
	class := self class.
	class isVariable ifFalse: [ ^ super copy ].

	"Optimization if variable size didn't change"
	newSize := self size.
	newSize = self basicSize ifTrue: [ ^ super copy ].

	"Otherwise, copy without the specialized primitive"
	newObject := class basicNew: newSize.
	1 to: newSize do: [ :index |
		newObject basicAt: index put: (self at: index) ].

	1 to: class instSize do: [ :index |
		newObject basicInstVarAt: index put: (self instVarAt: index) ].

	newObject resetPatches.
	
	^ newObject
]

{ #category : #accessing }
TPaResizeAPI >> removeAt: index [

	self firstPatch write: self removeAt: index
]

{ #category : #accessing }
TPaResizeAPI >> size [
	"Answer the number of indexable variables in the receiver, taking into account the patches which may add or remove positions."

	^ self firstPatch sizeOf: self
]
