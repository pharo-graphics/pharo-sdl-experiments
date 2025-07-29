Class {
	#name : #PatcheableObjectTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #tests }
PatcheableObjectTest >> testAccessors [

	| e |
	e := PatcheableElement new.
	self assert: e opacity isNil.
	self assert: e background isNil.
	self deny: e hasPatches.
	self assert: e patchCount equals: 0.

	e opacity: 0.2.
	self assert: e hasPatches.
	self assert: e patchCount equals: 1.
	self assert: e background isNil.
	self assert: e opacity equals: 0.2.

	e background: Color blue.
	self assert: e background equals: Color blue.
	self assert: e opacity equals: 0.2.
	self assert: e patchCount equals: 2.
	self assert: e hasPatches.
	e discardPatches.
	self deny: e hasPatches.
	self assert: e opacity isNil.
	self assert: e background isNil.

	e opacity: 0.3.
	e background: Color green.
	self assert: e hasPatches.
	self assert: e patchCount equals: 2.
	e applyPatches.
	self deny: e hasPatches.
	self assert: e patchCount equals: 0.
	self assert: e opacity equals: 0.3.
	self assert: e background equals: Color green.

	e background: Color red.
	e opacity: 0.4.
	self assert: e hasPatches.
	e discardPatches.
	self deny: e hasPatches.
	self assert: e opacity equals: 0.3.
	self assert: e background equals: Color green.

	e background: Color red.
	e opacity: 0.4.
	e applyPatches.
	self deny: e hasPatches.
	self assert: e opacity equals: 0.4.
	self assert: e background equals: Color red.

	e background: nil.
	e opacity: nil.
	self assert: e opacity isNil.
	self assert: e background isNil.
	e applyPatches.
	self assert: e opacity isNil.
	self assert: e background isNil
]

{ #category : #tests }
PatcheableObjectTest >> testInstVarNamedPut [

	| e |
	e := PatcheableElement new.
	self assert: (e instVarNamed: #opacity) isNil.
	self assert: (e instVarNamed: #background) isNil.
	self deny: e hasPatches.
	self assert: e patchCount equals: 0.

	e instVarNamed: #opacity put: 0.2.
	self assert: e hasPatches.
	self assert: e patchCount equals: 1.
	self assert: (e instVarNamed: #background) isNil.
	self assert: (e instVarNamed: #opacity) equals: 0.2.

	e instVarNamed: #background put: Color blue.
	self assert: (e instVarNamed: #background) equals: Color blue.
	self assert: (e instVarNamed: #opacity) equals: 0.2.
	self assert: e patchCount equals: 2.
	self assert: e hasPatches.
	e discardPatches.
	self deny: e hasPatches.
	self assert: (e instVarNamed: #opacity) isNil.
	self assert: (e instVarNamed: #background) isNil.

	e instVarNamed: #opacity put: 0.3.
	e instVarNamed: #background put: Color green.
	self assert: e hasPatches.
	self assert: e patchCount equals: 2.
	e applyPatches.
	self deny: e hasPatches.
	self assert: e patchCount equals: 0.
	self assert: (e instVarNamed: #opacity) equals: 0.3.
	self assert: (e instVarNamed: #background) equals: Color green.

	e instVarNamed: #background put: Color red.
	e instVarNamed: #opacity put: 0.4.
	self assert: e hasPatches.
	e discardPatches.
	self deny: e hasPatches.
	self assert: (e instVarNamed: #opacity) equals: 0.3.
	self assert: (e instVarNamed: #background) equals: Color green.

	e instVarNamed: #background put: Color red.
	e instVarNamed: #opacity put: 0.4.
	e applyPatches.
	self deny: e hasPatches.
	self assert: (e instVarNamed: #opacity) equals: 0.4.
	self assert: (e instVarNamed: #background) equals: Color red.

	e instVarNamed: #background put: nil.
	e instVarNamed: #opacity put: nil.
	self assert: (e instVarNamed: #opacity) isNil.
	self assert: (e instVarNamed: #background) isNil.
	e applyPatches.
	self assert: (e instVarNamed: #opacity) isNil.
	self assert: (e instVarNamed: #background) isNil
]

{ #category : #tests }
PatcheableObjectTest >> testInterleavedWrites [

	| e |
	e := PatcheableElement new: 2.

	e opacity: 0.1.
	e at: 1 put: $a.
	e instVarNamed: #background put: Color red.
	e at: 2 put: $b.

	self assert: (e instVarNamed: #opacity) equals: 0.1.
	self assert: e background equals: Color red.
	self assert: (e at: 1) equals: $a.
	self assert: (e at: 2) equals: $b.

	e background: Color green.
	e at: 2 put: $d.
	e instVarNamed: #opacity put: 0.2.
	e at: 1 put: $c.

	self assert: e opacity equals: 0.2.
	self assert: (e instVarNamed: #background) equals: Color green.
	self assert: (e at: 1) equals: $c.
	self assert: (e at: 2) equals: $d
]

{ #category : #tests }
PatcheableObjectTest >> testMultipleAtPutReusesPatch [

	| e |
	e := PatcheableElement new: 2.
	self assert: (e at: 1) isNil.
	self assert: (e at: 2) isNil.
	self assert: e patchCount equals: 0.

	1 to: 10 do: [ :i | e at: 1 put: 1.0/i ].
	self assert: e patchCount equals: 1.
	self assert: (e at: 1) equals: 0.1.
	self assert: (e at: 2) isNil.

	1 to: 100 do: [ :i | e at: 2 put: 1.0/i ].
	self assert: e patchCount equals: 2.
	self assert: (e at: 1) equals: 0.1.
	self assert: (e at: 2) equals: 0.01.

	e at: 1 put: 0.5.
	self assert: e patchCount equals: 2.

	e applyPatches.
	self assert: e patchCount equals: 0.
	self assert: (e at: 1) equals: 0.5.
	self assert: (e at: 2) equals: 0.01.

	e at: 1 put: 7.
	e at: 1 put: nil.
	e at: 2 put: 8.
	e at: 2 put: nil.
	self assert: (e at: 1) isNil.
	self assert: (e at: 2) isNil.
	self assert: e patchCount equals: 2.
	e applyPatches.
	self assert: (e at: 1) isNil.
	self assert: (e at: 2) isNil.
	self assert: e patchCount equals: 0
]

{ #category : #tests }
PatcheableObjectTest >> testMultipleInstVarNamedPutReusesPatch [

	| e |
	e := PatcheableElement new.
	self assert: (e instVarNamed: #opacity) isNil.
	self assert: e patchCount equals: 0.

	1 to: 10 do: [ :i | e instVarNamed: #opacity put: 1.0/i ].

	self assert: e patchCount equals: 1.
	self assert: (e instVarNamed: #opacity) equals: 0.1.
	e applyPatches.
	self assert: e patchCount equals: 0.
	self assert: (e instVarNamed: #opacity) equals: 0.1
]

{ #category : #tests }
PatcheableObjectTest >> testSubscriptOutOfBounds [

	| e |
	e := PatcheableElement new: 1.

	self should: [ e at: -1 ] raise: SubscriptOutOfBounds.
	self should: [ e at: 0 ] raise: SubscriptOutOfBounds.
	self should: [ e at: 2 ] raise: SubscriptOutOfBounds.
	self should: [ e at: -1 put: $a ] raise: SubscriptOutOfBounds.
	self should: [ e at: 0 put: $a ] raise: SubscriptOutOfBounds.
	self should: [ e at: 2 put: $a ] raise: SubscriptOutOfBounds
]
