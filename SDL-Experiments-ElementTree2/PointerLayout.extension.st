Extension { #name : #PointerLayout }

{ #category : #'*SDL-Experiments-ElementTree2' }
PointerLayout >> cowStateSizeFor: aCowObject [

	| count |
	count := 0.
	self allSlotsDo: [ :each |
		each class = CowSlot ifTrue: [ count := count + 1 ] ].
	^ count
]
