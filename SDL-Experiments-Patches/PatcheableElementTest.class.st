Class {
	#name : #PatcheableElementTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #tests }
PatcheableElementTest >> testAccessors [

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
PatcheableElementTest >> testCopy [

	| p q |
	"Prepare a patcheable with some values applied and some unapplied"
	p := PatcheableElement new: 3.
	p opacity: 0.1.
	p at: 1 put: $a.
	p at: 2 put: $b.
	p applyPatches.
	p background: Color green.
	p at: 1 put: $c.
	p at: 3 put: $d.
	"(opacity and second index remain untouched)"
	self assert: p opacity equals: 0.1.
	self assert: p background equals: Color green.
	self assert: p asCollection equals: #($c $b $d).
	
	q := p copy.
	"q has same values as p; patches are applied"
	self deny: q hasPatches.
	self assert: q opacity equals: 0.1.
	self assert: q background equals: Color green.
	self assert: q asCollection equals: #($c $b $d).
	"p keeps same values and patches unapplied"
	self assert: p hasPatches.
	self assert: p opacity equals: 0.1.
	self assert: p background equals: Color green.
	self assert: p asCollection equals: #($c $b $d).

]

{ #category : #tests }
PatcheableElementTest >> testInstVarAtPut [

	| e indexOfOpacityInstVar indexOfBackgroundInstVar |
	indexOfOpacityInstVar :=
		(PatcheableElement slotNamed: #opacity) index.
	indexOfBackgroundInstVar :=
		(PatcheableElement slotNamed: #background) index.
	
	e := PatcheableElement new.
	self assert: (e instVarAt: indexOfOpacityInstVar) isNil.
	self assert: (e instVarAt: indexOfBackgroundInstVar) isNil.
	self deny: e hasPatches.
	self assert: e patchCount equals: 0.

	e instVarNamed: #opacity put: 0.2.
	self assert: e hasPatches.
	self assert: e patchCount equals: 1.
	self assert: (e instVarAt: indexOfBackgroundInstVar) isNil.
	self assert: (e instVarAt: indexOfOpacityInstVar) equals: 0.2.

	e instVarNamed: #background put: Color blue.
	self assert: (e instVarAt: indexOfBackgroundInstVar) equals: Color blue.
	self assert: (e instVarAt: indexOfOpacityInstVar) equals: 0.2.
	self assert: e patchCount equals: 2.
	self assert: e hasPatches.
	e discardPatches.
	self deny: e hasPatches.
	self assert: (e instVarAt: indexOfOpacityInstVar) isNil.
	self assert: (e instVarAt: indexOfBackgroundInstVar) isNil.

	e instVarAt: indexOfOpacityInstVar put: 0.3.
	e instVarAt: indexOfBackgroundInstVar put: Color green.
	self assert: e hasPatches.
	self assert: e patchCount equals: 2.
	e applyPatches.
	self deny: e hasPatches.
	self assert: e patchCount equals: 0.
	self assert: (e instVarAt: indexOfOpacityInstVar) equals: 0.3.
	self assert: (e instVarAt: indexOfBackgroundInstVar) equals: Color green.

	e instVarAt: indexOfBackgroundInstVar put: Color red.
	e instVarAt: indexOfOpacityInstVar put: 0.4.
	self assert: e hasPatches.
	e discardPatches.
	self deny: e hasPatches.
	self assert: (e instVarAt: indexOfOpacityInstVar) equals: 0.3.
	self assert: (e instVarAt: indexOfBackgroundInstVar) equals: Color green.

	e instVarAt: indexOfBackgroundInstVar put: Color red.
	e instVarAt: indexOfOpacityInstVar put: 0.4.
	e applyPatches.
	self deny: e hasPatches.
	self assert: (e instVarAt: indexOfOpacityInstVar) equals: 0.4.
	self assert: (e instVarAt: indexOfBackgroundInstVar) equals: Color red.

	e instVarAt: indexOfBackgroundInstVar put: nil.
	e instVarAt: indexOfOpacityInstVar put: nil.
	self assert: (e instVarAt: indexOfOpacityInstVar) isNil.
	self assert: (e instVarAt: indexOfBackgroundInstVar) isNil.
	e applyPatches.
	self assert: (e instVarAt: indexOfOpacityInstVar) isNil.
	self assert: (e instVarAt: indexOfBackgroundInstVar) isNil
]

{ #category : #tests }
PatcheableElementTest >> testInstVarNamedPut [

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
PatcheableElementTest >> testInterleavedWrites [

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
PatcheableElementTest >> testLastPatch [

	| e |
	e := PatcheableElement new.

	self should: [ e firstPatch last ] raise: SubscriptOutOfBounds.

	e opacity: 0.9.
	self assert: e firstPatch last writtenValue equals: 0.9.
	
	e background: Color blue.
	self assert: e firstPatch writtenValue equals: Color blue.
	self assert: e firstPatch last writtenValue equals: 0.9
]

{ #category : #tests }
PatcheableElementTest >> testMultipleAtPutReusesPatch [

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
PatcheableElementTest >> testMultipleInstVarNamedPutReusesPatch [

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
PatcheableElementTest >> testMultipleMutatorsReusesPatch [

	| e |
	e := PatcheableElement new.
	self assert: e opacity isNil.
	self assert: e patchCount equals: 0.

	1 to: 10 do: [ :i | e opacity: 1.0/i ].

	self assert: e patchCount equals: 1.
	self assert: e opacity equals: 0.1.
	e applyPatches.
	self assert: e patchCount equals: 0.
	self assert: e opacity equals: 0.1
]

{ #category : #tests }
PatcheableElementTest >> testSubscriptOutOfBounds [

	| e |
	e := PatcheableElement new: 1.

	self should: [ e at: -1 ] raise: SubscriptOutOfBounds.
	self should: [ e at: 0 ] raise: SubscriptOutOfBounds.
	self should: [ e at: 2 ] raise: SubscriptOutOfBounds.
	self should: [ e at: -1 put: $a ] raise: SubscriptOutOfBounds.
	self should: [ e at: 0 put: $a ] raise: SubscriptOutOfBounds.
	self should: [ e at: 2 put: $a ] raise: SubscriptOutOfBounds
]
