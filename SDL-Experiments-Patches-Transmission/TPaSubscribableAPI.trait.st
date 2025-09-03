Trait {
	#name : #TPaSubscribableAPI,
	#instVars : [
		'subscriber'
	],
	#traits : 'TPaPatcheableAPI',
	#classTraits : 'TPaPatcheableAPI classTrait',
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #adding }
TPaSubscribableAPI >> addPatchFirst: aLinkPatch [

	(subscriber isNotNil and: [ patch isNil or: [ patch isNullPatch ]])
		ifTrue: [ subscriber firstPatchWasAddedTo: self ].
		
	aLinkPatch nextPatch: self firstPatch.
	patch := aLinkPatch
]

{ #category : #'as yet unclassified' }
TPaSubscribableAPI >> addSubscriber: aSubscriber [

	subscriber ifNotNil: [ self error: 'only single subscriber is implemented' ].
	subscriber := aSubscriber
]

{ #category : #'as yet unclassified' }
TPaSubscribableAPI >> hasSubscriber: aSubscriber [

	^ subscriber == aSubscriber
]
