Class {
	#name : #PaSceneNodeTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-Patches-Transmission-Tests'
}

{ #category : #tests }
PaSceneNodeTest >> testCantShareNode [

	| a b c |
	a := PaSceneNode new.
	b := PaSceneNode new.
	c := PaSceneNode new.

	a addChild: c.
	self should: [ b addChild: c ] raise: Error
]

{ #category : #tests }
PaSceneNodeTest >> testLevel [

	| a b c d |
	a := PaSceneNode new.
	b := PaSceneNode new.
	c := PaSceneNode new.
	d := PaSceneNode new.
	a addChild: b.
	b addChildren: {c. d}.
	
	self assert: a level equals: 0.
	self assert: b level equals: 1.
	self assert: c level equals: 2.
	self assert: d level equals: 2
]

{ #category : #tests }
PaSceneNodeTest >> testTreeCreation [

	| a b c d |
	a := PaSceneNode new.
	a opacity: 0.1.

	b := PaSceneNode new.
	a addChild: b.
	b opacity: 0.2.

	c := PaSceneNode new.
	c opacity: 0.3.
	d := PaSceneNode new.
	d opacity: 0.4.
	b addChildren: {c. d}.
	
	d addChildren: ((1 to: 5) collect: [ :i | PaSceneNode new ]).
	d addChildren: ((1 to: 5) collect: [ :i | PaSceneNode new ]).
	
	self assert: a opacity equals: 0.1.
	self assert: b identicalTo: (a children at: 1).
	self assert: b parent identicalTo: a.
	self assert: b opacity equals: 0.2.
	self assert: c identicalTo: (b children at: 1).
	self assert: c parent identicalTo: b.
	self assert: c opacity equals: 0.3.
	self assert: d identicalTo: (b children at: 2).
	self assert: d parent identicalTo: b.
	self assert: d opacity equals: 0.4.
	self assert: d children size equals: 10.
	d children do: [ :each | self assert: each parent identicalTo: d ]
]
