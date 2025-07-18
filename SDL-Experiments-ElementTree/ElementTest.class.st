Class {
	#name : #ElementTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #tests }
ElementTest >> testAddAndRemoveChildren [

	| a b c |
	a := Element new.
	b := Element new.
	c := Element new.
	a addChild: b.
	self assert: a children equals: { b }.
	self assert: b parent equals: a.

	a addChild: c.
	self assert: a children equals: { b. c }.

	a removeChild: b.
	self assert: a children equals: { c }.

	c addChild: b.
	self assert: c children equals: { b }
]

{ #category : #tests }
ElementTest >> testCreateFromStateAndSetBackground [

	| state0 root firstChild grandChild |
	state0 :=
		ElementState children: {
			ElementState
				children: { ElementState new }
				background: Color cyan
				opacity: 0.5.
	      ElementState new }.
	root := Element state: state0 parent: nil.
	firstChild := root children first.
	grandChild := firstChild children first.

	"Set a color in first child"
	firstChild background: Color blue.
	self assert: firstChild background equals: Color blue.
	"The first child and the root elements have new states"
	self
		deny: firstChild state
		identicalTo: state0 children first.

	"Both the sibling and the grand-child elements keep same state"
	self
		assert: root children second state
		identicalTo: state0 children second.
	self
		assert: grandChild state
		identicalTo: state0 children first children first.


	"Now mutate the grand-child"
	grandChild background: Color purple.
	"The colors are set"
	self assert: grandChild background equals: Color purple.
	self assert: firstChild background equals: Color blue
]
