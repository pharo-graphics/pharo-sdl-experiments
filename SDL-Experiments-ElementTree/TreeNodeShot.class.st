"
I am an immutable representation a tree node.

I am a variable-layer object, to point to my children without need of a separate collection.
"
Class {
	#name : #TreeNodeShot,
	#superclass : #Object,
	#type : #variable,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #accessing }
TreeNodeShot >> children [

	^ Array
		  new: self childrenCount
		  streamContents: [ :stream |
			  self childrenDo: [ :each | stream nextPut: each ] ]
]

{ #category : #accessing }
TreeNodeShot >> childrenCount [

	^ self size
]

{ #category : #accessing }
TreeNodeShot >> childrenDo: aBlock [

	1 to: self size do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #enumerating }
TreeNodeShot >> childrenWithIndexDo: aBlock [

	1 to: self size do: [ :index |
		aBlock value: (self at: index) value: index ]
]

{ #category : #copying }
TreeNodeShot >> copyWithChild: aShot at: index [

	^ self shallowCopy
		  basicAt: index put: aShot;
		  yourself
]

{ #category : #copying }
TreeNodeShot >> copyWithChildLastt: aShot [ 
	"Answer a copy of the receiver that is 1 bigger than the receiver and has
	newElement at the last element."

	| newSize |
	newSize := self size + 1.

	^ (self privateCopyFor: newSize)
			replaceFrom: 1
				to: self size
				with: self
				startingAt: 1;
			basicAt: newSize put: aShot;
			yourself
]

{ #category : #copying }
TreeNodeShot >> copyWithoutChildAt: index [
	"We assume the child has exactly one occurrence."

	| newSize |
	newSize := self size - 1.

	^ (self privateCopyFor: newSize)
			replaceFrom: 1
				to: index - 1 
				with: self
				startingAt: 1;
			replaceFrom: index
				to: newSize
				with: self
				startingAt: index + 1;
			yourself
]

{ #category : #debugging }
TreeNodeShot >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #printing }
TreeNodeShot >> printDetailsOn: aStream [
]

{ #category : #printing }
TreeNodeShot >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self debugId;
		nextPutAll: ' size: ';
		print: self childrenCount.

	self printDetailsOn: aStream.

	aStream nextPutAll: ')'
]

{ #category : #copying }
TreeNodeShot >> privateCopyFor: newSize [
	"Answer a copy of self with the specified size. The children are not copied at all, this is a responsibility of sender."

	^ self class basicNew: newSize
]

{ #category : #private }
TreeNodeShot >> replaceFrom: start to: stop with: replacement startingAt: repStart [
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 105>

	start to: stop do: [ :i |
		self basicAt: i put: (replacement basicAt: repStart - start + i) ]
]
