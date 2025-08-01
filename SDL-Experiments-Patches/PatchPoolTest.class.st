Class {
	#name : #PatchPoolTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #tests }
PatchPoolTest >> testLifecycle [

	| pool a b c d |
	pool := PatchPool new.
	pool patchClass: InstVarAtPutPatch.

	self assert: pool size equals: 0.
	a := pool nextPatch.
	self assert: pool size equals: 0.
	b := pool nextPatch.

	b nextPatch: a.
	self assert: b last identicalTo: a.

	pool returnPatch: b.
	pool returnPatch: a.
	self assert: pool size equals: 2.

	c := pool nextPatch.
	self assert: pool size equals: 1.
	d := pool nextPatch.
	self assert: pool size equals: 0.

	self assert: c identicalTo: a.
	self assert: d identicalTo: b
]
