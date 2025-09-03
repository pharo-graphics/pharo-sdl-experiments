Trait {
	#name : #TPaSubscribableAPI,
	#instVars : [
		'subscriber'
	],
	#traits : 'TPaPatcheableAPI',
	#classTraits : 'TPaPatcheableAPI classTrait',
	#category : #'SDL-Experiments-Patches-Transmission-Core'
}

{ #category : #adding }
TPaSubscribableAPI >> addPatchFirst: aLinkPatch [

	(subscriber isNotNil and: [ patch isNil or: [ patch isNullPatch ]])
		ifTrue: [ subscriber notifyDirty: self ].
		
	aLinkPatch nextPatch: self firstPatch.
	patch := aLinkPatch
]

{ #category : #subscription }
TPaSubscribableAPI >> addSubscriber: aSubscriber [

	subscriber ifNotNil: [ self error: 'only single subscriber is implemented' ].
	subscriber := aSubscriber
]

{ #category : #subscription }
TPaSubscribableAPI >> hasSubscriber: aSubscriber [

	^ subscriber == aSubscriber
]

{ #category : #subscription }
TPaSubscribableAPI >> removeSubscription: anObject [
	
	subscriber == anObject ifFalse: [ NotFound signalFor: anObject ].
	subscriber := nil
]
