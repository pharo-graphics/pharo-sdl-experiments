Class {
	#name : #ElementTest,
	#superclass : #TestCase,
	#category : #'SDLExperiments-IPC-COW'
}

{ #category : #resources }
ElementTest >> newRootWithTwoChildrenAndGrandChild [

	^ Element new
			background: Color red;
			opacity: 0.1;
			addChildren: {
				Element new
					background: Color green;
					opacity: 0.2;
					addChildren: { Element new };
					yourself.
		      Element new
					background: Color blue;
					opacity: 0.3;
					yourself };
			commitWithAllChildren;
			yourself
]

{ #category : #tests }
ElementTest >> testAccessors [

	| root child1 child2 grandChild |
	root := self newRootWithTwoChildrenAndGrandChild.
	child1 := root children first.
	child2 := root children second.
	grandChild := child1 children first.

	self assert: root opacity equals: 0.1.
	self assert: child1 opacity equals: 0.2.
	self assert: child2 opacity equals: 0.3.
	self assert: grandChild opacity equals: 1.0. "default value"

	self assert: root background equals: Color red.
	self assert: child1 background equals: Color green.
	self assert: child2 background equals: Color blue.
	self assert: grandChild background equals: Color white. "default value"

	self assertCollection: root children hasSameElements: { child1. child2 }.
	self assertCollection: child1 children hasSameElements: { grandChild }.
	self assertCollection: child2 children hasSameElements: #().
	self assertCollection: grandChild children hasSameElements: #()
]

{ #category : #tests }
ElementTest >> testAddChild [

	| a b c |
	a := Element new opacity: 0.1; background: Color red; yourself.
	b := Element new opacity: 0.2; background: Color green; yourself.
	c := Element new opacity: 0.3; background: Color blue; yourself.

	a addChild: b.
	self assertCollection: a children hasSameElements: { b }.
	self assert: b parent identicalTo: a.

	a addChild: c.
	self assertCollection: a children hasSameElements: { b. c }.
	self assert: c parent identicalTo: a.

	a removeChild: b.
	self assertCollection: a children hasSameElements: { c }.
	self assert: b parent isNil.

	"Add b to another parent"
	c addChild: b.
	self assertCollection: c children hasSameElements: { b }.
	self assert: b parent identicalTo: c.

	"Ensure values are right afterwards"
	self assert: a opacity equals: 0.1.
	self assert: b opacity equals: 0.2.
	self assert: c opacity equals: 0.3.
	
	self assert: a background equals: Color red.
	self assert: b background equals: Color green.
	self assert: c background equals: Color blue
]

{ #category : #tests }
ElementTest >> testAddChildren [

	| a b c |
	a := Element new opacity: 0.1; background: Color red; yourself.
	b := Element new opacity: 0.2; background: Color green; yourself.
	c := Element new opacity: 0.3; background: Color blue; yourself.

	a addChildren: { b. c }.
	self assertCollection: a children hasSameElements: { b. c }.
	self assert: a parent isNil.
	self assert: b parent identicalTo: a.
	self assert: c parent identicalTo: a.

	a removeChildren: { b. c }.
	self assertCollection: a children hasSameElements: {}.
	self assert: a parent isNil.
	self assert: b parent isNil.
	self assert: c parent isNil.

	"Compose them in another way"
	c addChildren: { b. a }.
	self assertCollection: c children hasSameElements: { b. a }.
	self assert: a parent identicalTo: c.
	self assert: b parent identicalTo: c.
	self assert: c parent isNil.

	"Ensure values are right afterwards"
	self assert: a opacity equals: 0.1.
	self assert: b opacity equals: 0.2.
	self assert: c opacity equals: 0.3.
	
	self assert: a background equals: Color red.
	self assert: b background equals: Color green.
	self assert: c background equals: Color blue
]

{ #category : #tests }
ElementTest >> testIsDraft [

	| root child1 child2 grandChild |
	root := self newRootWithTwoChildrenAndGrandChild.
	child1 := root children first.
	child2 := root children second.
	grandChild := child1 children first.

	self deny: root activeShot isDraft.
	self deny: child1 activeShot isDraft.
	self deny: child2 activeShot isDraft.
	self deny: grandChild activeShot isDraft.

	child1 opacity: 0.1.
	
	self assert: root activeShot isDraft.
	self assert: child1 activeShot isDraft.
	self deny: child2 activeShot isDraft.
	self deny: grandChild activeShot isDraft.

	root commitWithAllChildren.

	self deny: root activeShot isDraft.
	self deny: child1 activeShot isDraft.
	self deny: child2 activeShot isDraft.
	self deny: grandChild activeShot isDraft
]

{ #category : #tests }
ElementTest >> testMutators [

	| initialShot root child1 grandChild |
	root := self newRootWithTwoChildrenAndGrandChild.
	initialShot := root completedShot.
	child1 := root children first.
	grandChild := child1 children first.

	root withAllChildrenDo: [ :each | self deny: each activeShot isDraft ].


	"Set a color in first child"
	child1 background: Color blue.
	self assert: child1 background equals: Color blue.

	"After mutation, the commit shots are the same, but active shot did change."
	self
		assert: child1 completedShot
		identicalTo: initialShot children first.
	self
		deny: child1 activeShot
		identicalTo: initialShot children first.
	
	self assert: root activeShot isDraft.
	self assert: child1 activeShot isDraft.
	child1 commitWithAllParents.
	root withAllChildrenDo: [ :each | self deny: each activeShot isDraft ].
	self
		deny: child1 completedShot
		identicalTo: initialShot children first.

	"Both the sibling and the grand-child elements keep same shot"
	self
		assert: root children second activeShot
		identicalTo: initialShot children second.
	self
		assert: grandChild activeShot
		identicalTo: initialShot children first children first.


	"Now mutate the grand-child"
	grandChild background: Color purple.
	"The colors are set"
	self assert: grandChild background equals: Color purple.
	self assert: child1 background equals: Color blue
]

{ #category : #tests }
ElementTest >> testRemoveChild [

	| children root |
	children :=
		(0 to: 10) collect: [ :i |
			Element new opacity: i/10.0; yourself ].
	root := Element new addChildren: children; yourself.
	self assert: root children size equals: 11.
	self assert: root children first opacity equals: 0.0.

	root removeChild: root children first.
	self assert: root children size equals: 10.
	self assert: root children first opacity equals: 0.1.

	root removeChild: (root children at: 5).
	self assert: root children size equals: 9.
	self
		assertCollection: (root children collect: #opacity)
		hasSameElements: #(0.1 0.2 0.3 0.4 0.6 0.7 0.8 0.9 1.0).

	root removeChild: root children last.
	self assert: root children size equals: 8.
	self assert: root children last opacity equals: 0.9.

]
