Class {
	#name : #PaPushEndpoint,
	#superclass : #PaEndpoint,
	#instVars : [
		'serializer'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Core'
}

{ #category : #accessing }
PaPushEndpoint >> dirtyPatcheablesCount [

	^ serializer dirtyPatcheables size
]

{ #category : #initialization }
PaPushEndpoint >> initialize [

	super initialize.
	
	root := PaSceneNode new.
	self reset
]

{ #category : #synchronization }
PaPushEndpoint >> push [

	^ serializer ifNil: [ self pushFull ] ifNotNil: [ self pushPatches ]
]

{ #category : #synchronization }
PaPushEndpoint >> pushFull [

	stream nextPut: FullByte.
	
	"IMPORTANT: the other endpoint registers the same known objects and classes, in same order"
	serializer := PaSoilSerializer new
		stream: stream;
		yourself.
	self wellKnownObjects do: [ :each | serializer registerObject: each ].

	serializer serialize: root
]

{ #category : #synchronization }
PaPushEndpoint >> pushPatches [

	stream nextPut: PatchesByte.

	serializer serializePatches
]

{ #category : #synchronization }
PaPushEndpoint >> reset [

	serializer ifNil: [ ^ self ].

	serializer release.
	serializer := nil
]

{ #category : #accessing }
PaPushEndpoint >> root: aPatcheable [

	root := aPatcheable.
	self reset
]
