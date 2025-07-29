Class {
	#name : #PatchPoolTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #tests }
PatchPoolTest >> testLifecycle [

	| pool a b c d |
	pool := PatchPool new patchClass: InstVarAtPutPatch; yourself.
	self assert: pool size equals: 0.

	a := pool nextPatch.
	b := pool nextPatch.
	b nextPatch: a.
	self assert: b last identicalTo: a.

	pool returnPatch: b.
	self assert: pool size equals: 2.

	c := pool nextPatch.
	self assert: pool size equals: 1.
	self assert: c identicalTo: b.

	d := pool nextPatch.
	self assert: pool size equals: 0.
	self assert: d identicalTo: a
]
