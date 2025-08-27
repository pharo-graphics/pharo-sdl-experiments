"
I'm a trait that extends `TIndexedVarsPatcheable` with API and patches to increase and decrease size of the instance.
"
Trait {
	#name : #TResizingPatcheable,
	#traits : 'TIndexedVarsPatcheable',
	#classTraits : 'TIndexedVarsPatcheable classTrait',
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #adding }
TResizingPatcheable >> add: anObject [

	self addFirst: anObject
]

{ #category : #accessing }
TResizingPatcheable >> add: aValue at: index [

	patch write: self add: aValue at: index
]

{ #category : #adding }
TResizingPatcheable >> addFirst: anObject [

	self add: anObject at: 1
]

{ #category : #adding }
TResizingPatcheable >> addLast: anObject [

	self add: anObject at: self size + 1
]

{ #category : #copying }
TResizingPatcheable >> copy [

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

	newObject privateResetPatch.
	
	^ newObject
]

{ #category : #private }
TResizingPatcheable >> linkPatchForAdd: aValue at: anInteger [ 
	
	(anInteger between: 1 and: self size + 1) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	patch :=
		AddAtPatch new
			index: anInteger;
			writtenValue: aValue;
			nextPatch: patch;
			yourself
]

{ #category : #private }
TResizingPatcheable >> linkPatchForRemoveAt: anInteger [
	
	(anInteger between: 1 and: self size) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	patch :=
		RemoveAtPatch new
			index: anInteger;
			nextPatch: patch;
			yourself
]

{ #category : #accessing }
TResizingPatcheable >> removeAt: index [

	patch write: self removeAt: index
]

{ #category : #accessing }
TResizingPatcheable >> size [
	"Answer the number of indexable variables in the receiver, taking into account the patches which may add or remove positions."

	^ patch sizeOf: self
]
