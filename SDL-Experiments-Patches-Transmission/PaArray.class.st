Class {
	#name : #PaArray,
	#superclass : #PaBaseObject,
	#type : #variable,
	#traits : 'TPaIndexedVariablesAPI - {#addPatchFirst:} + TPaSubscribableAPI',
	#classTraits : 'TPaIndexedVariablesAPI classTrait + TPaSubscribableAPI classTrait',
	#category : #'SDL-Experiments-Patches-Transmission-Core'
}

{ #category : #'instance creation' }
PaArray class >> with: anObject [
	"Answer a new instance without patches"

	| newCollection |
	newCollection := self new: 1.
	newCollection basicAt: 1 put: anObject.
	^ newCollection
]

{ #category : #'instance creation' }
PaArray class >> withAll: aCollection [
	"Create a new collection containing all the elements from aCollection."

	^ (self new: aCollection size)
			replaceFrom: 1
			to: aCollection size
			with: aCollection
			startingAt: 1;
			yourself
]

{ #category : #copying }
PaArray >> , otherCollection [
	"Answer a copy of myself concatenated with another collection."

	^ self copyReplaceFrom: self size + 1
		  to: self size
		  with: otherCollection
]

{ #category : #copying }
PaArray >> copyReplaceFrom: start to: stop with: replacementCollection [
	"Answer a copy of the receiver satisfying the following conditions: If
	stop is less than start, then this is an insertion; stop should be exactly
	start-1, start = 1 means insert before the first character, start = size+1
	means append after last character. Otherwise, this is a replacement; start
	and stop have to be within the receiver's bounds."

	| newSequenceableCollection newSize endReplacement |
	newSize := self size - (stop - start + 1)
	           + replacementCollection size.
	endReplacement := start - 1 + replacementCollection size.
	newSequenceableCollection := self species new: newSize.
	start > 1 ifTrue: [
			newSequenceableCollection
				replaceFrom: 1
				to: start - 1
				with: self
				startingAt: 1 ].
	start <= endReplacement ifTrue: [
			newSequenceableCollection
				replaceFrom: start
				to: endReplacement
				with: replacementCollection
				startingAt: 1 ].
	endReplacement < newSize ifTrue: [
			newSequenceableCollection
				replaceFrom: endReplacement + 1
				to: newSize
				with: self
				startingAt: stop + 1 ].
	^ newSequenceableCollection
]

{ #category : #copying }
PaArray >> copyWith: anObject [
	"Answer a copy of myself with the received object at last position. The copy has no patches."

	| copy |
	copy := self class new: self size + 1.
	1 to: self size do: [ :i |
		copy basicAt: i put: (self at: i) ].

	copy basicAt: copy size put: anObject.

	^ copy
]

{ #category : #copying }
PaArray >> copyWithAll: aCollection [

	^ self, aCollection
]

{ #category : #enumerating }
PaArray >> do: aBlock [

	1 to: self size do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #printing }
PaArray >> printDetailsOn: aStream [

	aStream nextPutAll: 'items: '.

	self withIndexDo: [ :element :index |
		aStream print: element.
		index = self size ifFalse: [ aStream space ] ]
]

{ #category : #accessing }
PaArray >> replaceFrom: start to: stop with: replacement startingAt: repStart [
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 105>

	start to: stop do: [ :i |
		self basicAt: i put: (replacement at: repStart - start + i) ]
]

{ #category : #enumerating }
PaArray >> withIndexDo: aBlock [

	1 to: self size do: [ :index |
		aBlock value: (self at: index) value: index ]
]
