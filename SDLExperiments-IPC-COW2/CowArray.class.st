"
I'm an array of objects (whether `CowObject` or not).
"
Class {
	#name : #CowArray,
	#superclass : #CowObject,
	#type : #variable,
	#category : #'SDLExperiments-IPC-COW2-Core'
}

{ #category : #converting }
CowArray >> asArray [

	^ self as: Array
]

{ #category : #accessing }
CowArray >> at: anIndex put: newValue [
	"See CowSlot>>#write:to:"

	| oldValue |
	oldValue := self at: anIndex.
	oldValue == newValue ifTrue: [ ^ self ].

	self basicAt: anIndex put: newValue.
	oldValue removePointerOfIndexedVariable: anIndex from: self.
	newValue addPointerOfIndexedVariable: anIndex from: self.

	self prepareToWrite.
	activeState at: anIndex put: newValue activeState
]

{ #category : #private }
CowArray >> basicReplaceFrom: start to: stop with: replacement startingAt: repStart [
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 105>

	start to: stop do: [ :i |
		self basicAt: i put: (replacement basicAt: repStart - start + i) ]
]

{ #category : #copying }
CowArray >> copyWith: anObject [

	| copy |
	copy := self class new: self size + 1.
	copy
		basicReplaceFrom: 1
		to: self size
		with: self
		startingAt: 1.

	copy at: copy size put: anObject.

	"This is required to convert outgoing pointers with me as source"
	copy postCopy.

	^ copy
]

{ #category : #copying }
CowArray >> copyWithout: anObject [

	| indexToRemove |
	indexToRemove := anObject indexInCowArray: self.
	indexToRemove > 0 ifFalse: [ NotFound signalFor: anObject ].
	
	^ self copyWithoutIndex: indexToRemove
]

{ #category : #copying }
CowArray >> copyWithoutIndex: anIndex [

	| copy |	
	copy := self class new: self size - 1.
	copy
		basicReplaceFrom: 1
		to: anIndex - 1
		with: self
		startingAt: 1.
	copy
		basicReplaceFrom: anIndex
		to: copy size
		with: self
		startingAt: anIndex + 1.

	"This is required to convert outgoing pointers with me as source"
	copy postCopy.

	^ copy
]

{ #category : #enumerating }
CowArray >> do: aBlock [

	1 to: self size do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #printing }
CowArray >> printDetailsOn: aStream [

	aStream nextPutAll: 'items: '.

	self withIndexDo: [ :element :index |
		aStream print: element.
		index = self size ifFalse: [ aStream space ] ]
]

{ #category : #enumerating }
CowArray >> withIndexDo: aBlock [

	1 to: self size do: [ :index |
		aBlock value: (self at: index) value: index ]
]
