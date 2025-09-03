Class {
	#name : #PaPullEndpoint,
	#superclass : #PaEndpoint,
	#instVars : [
		'materializer'
	],
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #synchronization }
PaPullEndpoint >> pull [

	| pullType |
	pullType := stream next.
	pullType = PatchesByte ifTrue: [ ^ self pullPatches ].
	pullType = FullByte ifTrue: [ ^ self pullFull ].
	self error
]

{ #category : #synchronization }
PaPullEndpoint >> pullFull [

	"IMPORTANT: the other endpoint registers the same known objects and classes, in same order"
	materializer := PaSoilMaterializer new
		stream: stream;
		yourself.
	self wellKnownObjects do: [ :each | materializer registerObject: each ].

	root := materializer materialize
]

{ #category : #synchronization }
PaPullEndpoint >> pullPatches [

	| patches |
	patches := materializer materialize.

	patches pairsDo: [ :patcheable :firstPatch |
		patcheable applyPatches: firstPatch ]
]

{ #category : #'as yet unclassified' }
PaPullEndpoint >> pullUntilEnd [

	[ stream atEnd ] whileFalse: [ self pull ]
]

{ #category : #initialization }
PaPullEndpoint >> reset [

	materializer := nil.
	root := nil
]
