Class {
	#name : #CowObject,
	#superclass : #Object,
	#instVars : [
		'completedState',
		'activeState',
		'outgoingPointerWithDraft',
		'incomingPointer'
	],
	#category : #'SDLExperiments-IPC-COW2-Core'
}

{ #category : #'as yet unclassified' }
CowObject class >> cowInstanceVariableSlots [

	| result |
	result := OrderedCollection new.
	self classLayout allSlotsDo: [ :each |
		each class = CowSlot ifTrue: [ result add: each ] ].
	^ result
]

{ #category : #'as yet unclassified' }
CowObject class >> cowInstanceVariableSlotsCount [

	| count |
	count := 0.
	self classLayout allSlotsDo: [ :each |
		each class = CowSlot ifTrue: [ count := count + 1 ] ].
	^ count
]

{ #category : #accessing }
CowObject >> activeState [

	^ activeState
]

{ #category : #private }
CowObject >> addPointerOfIndexedVariable: anInteger from: sourceCowObject [

	incomingPointer :=
		incomingPointer
			addPointerOfIndexedVariable: anInteger
			from: sourceCowObject
			to: self
]

{ #category : #private }
CowObject >> addPointerOfInstanceVariable: anIndex from: sourceCowObject [

	incomingPointer
		addPointerOfInstanceVariable: anIndex
		from: sourceCowObject
		to: self
]

{ #category : #completion }
CowObject >> complete [

	activeState complete.
	completedState := activeState
]

{ #category : #completion }
CowObject >> completeDepthFirst [

	"Commit recursively depth-first"
	[ outgoingPointerWithDraft isNull ] whileFalse: [
		outgoingPointerWithDraft target completeDepthFirst.
		outgoingPointerWithDraft := outgoingPointerWithDraft popNextDraft ].

	self complete
]

{ #category : #accessing }
CowObject >> cowStateSize [

	^ self class classLayout cowStateSizeFor: self
]

{ #category : #testing }
CowObject >> hasDraftState [

	^ activeState isDraft
]

{ #category : #accessing }
CowObject >> incomingPointers [

	^ Array streamContents: [ :stream |
		self incomingPointersDo: [ :each | stream nextPut: each ] ]
]

{ #category : #accessing }
CowObject >> incomingPointersCount [

	| count |
	count := 0.
	self incomingPointersDo: [ :_ | count := count + 1 ].
	^ count
]

{ #category : #enumerating }
CowObject >> incomingPointersDo: aUnaryBlock [

	| current |
	current := incomingPointer.
	[ current isNull ] whileFalse: [
		aUnaryBlock value: current.
		current := current next ]
]

{ #category : #private }
CowObject >> indexInCowArray: aCowArray [

	^ incomingPointer indexIn: aCowArray
]

{ #category : #initialization }
CowObject >> initialize [

	incomingPointer := CowNullPointer instance.
	outgoingPointerWithDraft := CowNullPointer instance.
	
	activeState := CowState new: self cowStateSize.
	self complete
]

{ #category : #accessing }
CowObject >> outgoingPointersWithDraftState [

	| result |
	result := OrderedCollection new.
	self outgoingPointersWithDraftStateDo: [ :each | result add: each ].
	^ result

]

{ #category : #accessing }
CowObject >> outgoingPointersWithDraftStateCount [

	| count |
	count := 0.
	self outgoingPointersWithDraftStateDo: [ :_ | count := count + 1 ].
	^ count
]

{ #category : #enumerating }
CowObject >> outgoingPointersWithDraftStateDo: aUnaryBlock [
	"Evaluate a block on each object I references and is draft."

	| current |
	current := outgoingPointerWithDraft.
	[ current isNull ] whileFalse: [
		aUnaryBlock value: current.
		current := current nextDraft ]
]

{ #category : #copying }
CowObject >> postCopy [
	"Since I was copied, I don't have incoming pointers. My active state must be copied too, and if I have draft outgoing pointers then it's draft. If I don't have draft outgoing pointers, we will have to copy them but me as source."

	activeState := activeState copy.
	incomingPointer := CowNullPointer instance.
	outgoingPointerWithDraft isNull
		ifTrue: [ self complete ]
		ifFalse: [ outgoingPointerWithDraft := outgoingPointerWithDraft copyWithSource: self ]
]

{ #category : #private }
CowObject >> prepareToWrite [

	activeState isDraft ifTrue: [ ^ self ].

	activeState := completedState copy.

 	incomingPointer propagateDraftTarget
]

{ #category : #printing }
CowObject >> printBasicOn: aStream [

	self hasDraftState
		ifTrue: [ aStream nextPutAll: 'hasDraftState ' ].
	aStream
		nextPutAll: '#incoming: ';
		print: self incomingPointersCount.
	aStream
		nextPutAll: ' #outgoingDraft: ';
		print: self outgoingPointersWithDraftStateCount
]

{ #category : #printing }
CowObject >> printDetailsOn: aStream [
]

{ #category : #printing }
CowObject >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	self printBasicOn: aStream.
	aStream space.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : #private }
CowObject >> propagateDraftTargetAtIndexedVariablePointer: aCowPointer [

	self prepareToWrite.
	activeState at: aCowPointer index put: aCowPointer target activeState.

	"Remember it, for an optimized complete"
	aCowPointer nextDraft: outgoingPointerWithDraft.
	outgoingPointerWithDraft := aCowPointer
]

{ #category : #private }
CowObject >> propagateDraftTargetAtInstanceVariablePointer: aCowPointer [

	self prepareToWrite.
	activeState at: aCowPointer index put: aCowPointer target activeState.

	"Remember it, for an optimized complete"
	aCowPointer nextDraft: outgoingPointerWithDraft.
	outgoingPointerWithDraft := aCowPointer
]

{ #category : #private }
CowObject >> removePointerOfIndexedVariable: anIndex from: aCowObject [

	incomingPointer :=
		incomingPointer
			removePointerOfIndexedVariable: anIndex
			from: aCowObject
]

{ #category : #private }
CowObject >> removePointerOfInstanceVariable: anIndex from: aCowObject [

	incomingPointer :=
		incomingPointer
			removePointerOfInstanceVariable: anIndex
			from: aCowObject
]
