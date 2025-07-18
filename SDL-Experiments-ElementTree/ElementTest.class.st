Class {
	#name : #ElementTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #tests }
ElementTest >> testCreateFromShotAndMutateBackground [

	| initialShot root firstChild grandChild |
	initialShot :=
		ElementShot children: {
			ElementShot
				children: { ElementShot new }
				background: Color cyan
				opacity: 0.5.
	      ElementShot new }.
	root := Element shot: initialShot parent: nil.
	firstChild := root children first.
	grandChild := firstChild children first.

	"Set a color in first child"
	firstChild background: Color blue.
	self assert: firstChild background equals: Color blue.
	"The first child and the root elements have new shots"
	self
		deny: firstChild shot
		identicalTo: initialShot children first.

	"Both the sibling and the grand-child elements keep same shot"
	self
		assert: root children second shot
		identicalTo: initialShot children second.
	self
		assert: grandChild shot
		identicalTo: initialShot children first children first.


	"Now mutate the grand-child"
	grandChild background: Color purple.
	"The colors are set"
	self assert: grandChild background equals: Color purple.
	self assert: firstChild background equals: Color blue
]

{ #category : #tests }
ElementTest >> testMutateChildren [

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
