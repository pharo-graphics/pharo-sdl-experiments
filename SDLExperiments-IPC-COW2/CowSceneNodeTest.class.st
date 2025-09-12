Class {
	#name : #CowSceneNodeTest,
	#superclass : #TestCase,
	#category : #'SDLExperiments-IPC-COW2-Tests'
}

{ #category : #tests }
CowSceneNodeTest >> test01CreateNode [

	| node |
	node := CowSceneNode new.
	self deny: node hasDraftState.
	node opacity: 0.5.
	
	self assert: node hasDraftState.
	self assert: node opacity equals: 0.5.

	node completeDepthFirst.
	self deny: node hasDraftState.
	self assert: node opacity equals: 0.5

]

{ #category : #tests }
CowSceneNodeTest >> test02CreateTree [

	| a b c |
	a := CowSceneNode new.
	a opacity: 0.1.
	a completeDepthFirst.

	b := CowSceneNode new.
	a addChild: b.
	b opacity: 0.2.

	c := CowSceneNode new.
	c opacity: 0.3.
	b addChild: c.
	a completeDepthFirst

]

{ #category : #tests }
CowSceneNodeTest >> test03MultiplePointers [

	| node list |
	node := CowSceneNode new.

	"The node knows that each position of the list points to it"
	list := CowArray new: 5.
	1 to: list size do: [ :i | list at: i put: node ].
	self assert: node incomingPointers size equals: 5.

	"The node knows that one position of the list isn't pointing to it anymore"
	list at: 3 put: nil.
	self assert: node incomingPointers size equals: 4.

	"This list is already draft because of all at:put:, but the node is not draft"
	self deny: node hasDraftState.
	self assert: list hasDraftState.
	self assert: list outgoingPointersWithDraftState isEmpty.
	node opacity: 0.5.
	self assert: list outgoingPointersWithDraftState size equals: 4.

	list completeDepthFirst.
	self deny: list hasDraftState.
	self assert: list outgoingPointersWithDraftState isEmpty.

	"The list becomes draft when the node becomes draft (propagation)"
	node opacity: 0.6.
	self assert: list hasDraftState.
	self assert: list outgoingPointersWithDraftState size equals: 4.

	"Completion affects the whole graph"
	list completeDepthFirst.
	self deny: list hasDraftState.
	self deny: node hasDraftState.
	self assert: list outgoingPointersWithDraftState isEmpty
]
