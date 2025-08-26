"
I'm a trait for object whose mutations to indexed variables are written as patches. Accessors return the value from a patch, if available, or from the patcheable object, otherwise.
"
Trait {
	#name : #TIndexedVarsPatcheable,
	#traits : 'TInstVarsPatcheable',
	#classTraits : 'TInstVarsPatcheable classTrait',
	#category : #'SDL-Experiments-Patches'
}

{ #category : #adding }
TIndexedVarsPatcheable >> add: anObject [

	self addFirst: anObject
]

{ #category : #accessing }
TIndexedVarsPatcheable >> add: aValue at: index [

	patch write: self add: aValue at: index
]

{ #category : #adding }
TIndexedVarsPatcheable >> addFirst: anObject [

	self add: anObject at: 1
]

{ #category : #adding }
TIndexedVarsPatcheable >> addLast: anObject [

	self add: anObject at: self size + 1
]

{ #category : #converting }
TIndexedVarsPatcheable >> asCollection [

	| array |
	array := Array new: self size.

	1 to: array size do: [ :index |
		array at: index put: (self at: index) ].

	^ array
]

{ #category : #accessing }
TIndexedVarsPatcheable >> at: index [

	^ patch read: self at: index
]

{ #category : #accessing }
TIndexedVarsPatcheable >> at: index put: aValue [

	patch write: self at: index put: aValue
]

{ #category : #copying }
TIndexedVarsPatcheable >> copy [

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
TIndexedVarsPatcheable >> linkPatchForAdd: aValue at: anInteger [ 
	
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

{ #category : #private }
TIndexedVarsPatcheable >> linkPatchForRemoveAt: anInteger [
	
	(anInteger between: 1 and: self size) ifFalse: [
		^ self errorSubscriptBounds: anInteger ].

	patch :=
		RemoveAtPatch new
			index: anInteger;
			nextPatch: patch;
			yourself
]

{ #category : #accessing }
TIndexedVarsPatcheable >> removeAt: index [

	patch write: self removeAt: index
]

{ #category : #accessing }
TIndexedVarsPatcheable >> size [
	"Answer the number of indexable variables in the receiver, taking into account the patches which may add or remove positions."

	^ patch sizeOf: self
]
