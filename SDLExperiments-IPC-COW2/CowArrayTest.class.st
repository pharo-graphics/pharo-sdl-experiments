Class {
	#name : #CowArrayTest,
	#superclass : #TestCase,
	#category : #'SDLExperiments-IPC-COW2-Tests'
}

{ #category : #tests }
CowArrayTest >> test01ArrayWithLiterals [

	| array copy |
	array := CowArray new: 2.
	self deny: array hasDraftState.

	array at: 1 put: $a.
	self assert: array hasDraftState.
	self assert: (array at: 1) equals: $a.
	self assert: array asArray equals: { $a. nil }.

	copy := array copyWith: $c.
	self assert: copy asArray equals: { $a. nil. $c }.
	self deny: copy hasDraftState.
	self assert: array asArray equals: { $a. nil }.
	self assert: array hasDraftState.

	copy := array copyWithout: $a.
	self assert: copy asArray equals: { nil }.
	self deny: copy hasDraftState.
	self assert: array asArray equals: { $a. nil }.
	self assert: array hasDraftState.
]

{ #category : #tests }
CowArrayTest >> test02ArrayWithArrays [

	| a b c bCopy aCopy |
	a := CowArray new: 1.
	self assert: a asArray equals: { nil }.

	b := CowArray new: 0.
	a at: 1 put: b.
	self assert: a asArray equals: { b }.
	self assert: b asArray equals: { }.

	c := CowArray new: 0.
	bCopy := b copyWith: c.
	self assert: bCopy asArray equals: { c }.
	self assert: b asArray equals: { }.

	self assert: a asArray equals: { b }.
	a at: 1 put: bCopy.
	self assert: a asArray equals: { bCopy }.

	aCopy := a copyWithout: bCopy.
	self assert: aCopy asArray equals: { }.
	
	self should: [ aCopy copyWithout: bCopy ] raise: NotFound
]

{ #category : #tests }
CowArrayTest >> test03CopyArrayWithDraftItem [

	| a b copy |
	a := CowArray new: 1.
	b := CowArray new: 1.
	a at: 1 put: b.
	b at: 1 put: 'hola'.
	self assert: b hasDraftState.
	self assert: a hasDraftState.

	copy := a copy.
	a outgoingPointersWithDraftState
		with: copy outgoingPointersWithDraftState
		do: [ :x :y |
			self deny: x identicalTo: y.
			self assert: x source equals: a.
			self assert: y source equals: copy.
			self assert: x target identicalTo: y target.
			self assert: x index identicalTo: y index ].

	self flag: #todo. "test next and nextDraft"
]
