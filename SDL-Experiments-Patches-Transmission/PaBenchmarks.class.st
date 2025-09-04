"
I define benchmarks for the scene graph elements.
"
Class {
	#name : #PaBenchmarks,
	#superclass : #Object,
	#category : #'SDL-Experiments-Patches-Transmission-Tests'
}

{ #category : #benchmarks }
PaBenchmarks >> benchNilToOneOpacity [
	<script: 'self new benchNilToOneOpacity' >

	'

#benchNilToOneOpacity

' traceCr.

	#(1 5 9 11) do: [ :n |
		| root |
		'
# n: ' trace.
		n traceCr.

		"Initial tree"
		root := (self fractalBranchDepth: 3 n: n) first.

		self
			benchRoot: root
			mutateBlock: [ :node |
				node withAllChildrenDo: [ :each | each opacity: 1.0 ] ] ]
]

{ #category : #benchmarks }
PaBenchmarks >> benchRandomOpacity [
	<script: 'self new benchRandomOpacity' >

	'

#benchRandomOpacity

' traceCr.

	#(1 5 9 11) do: [ :n |
		| random root mutateBlock |
		'
# n: ' trace.
		n traceCr.

		random := Random seed: 0.

		mutateBlock := [ :node |
			node withAllChildrenDo: [ :each | each opacity: random next ] ].

		"Initial tree"
		root := (self fractalBranchDepth: 3 n: n) first.
		mutateBlock value: root.

		self benchRoot: root mutateBlock: mutateBlock ]
]

{ #category : #benchmarks }
PaBenchmarks >> benchRoot: root mutateBlock: mutateBlock [

	| writeStream pushEndpoint initialPosition pullEndpoint |
	writeStream := WriteStream on: #[].

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: writeStream.

	pushEndpoint root: root.
	'- push 1 (all nodes): ' trace. root withAllChildrenCount traceCr.
	initialPosition := writeStream position.
	'  duration: ' trace. [ pushEndpoint push ] timeToRun traceCr.
	'  bytes:    ' trace. (writeStream position - initialPosition) traceCr.

	mutateBlock value: root.
	'- push 2 (dirty nodes): ' trace. pushEndpoint dirtyPatcheablesCount traceCr.
	initialPosition := writeStream position.
	'  duration: ' trace. [ pushEndpoint push ] timeToRun traceCr.
	'  bytes: ' trace. (writeStream position - initialPosition) traceCr.

	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	'pull 1: ' trace. [ pullEndpoint pull ] timeToRun traceCr.
	'pull 2: ' trace. [ pullEndpoint pull ] timeToRun traceCr
]

{ #category : #'sample creation' }
PaBenchmarks >> fractalBranchDepth: depth n: n [

	^ n = 0
		ifTrue: [ #() ]
		ifFalse: [
			self
				yBranchDepth: depth
				with: (self fractalBranchDepth: depth n: n - 1)
				with: (self fractalBranchDepth: depth n: n - 1) ]
]

{ #category : #'sample creation' }
PaBenchmarks >> lineBranchDepth: depth children: leafChildren [

	^ (1 to: depth)
			inject: leafChildren
			into: [ :children :each |
				{ PaSceneNode new
						addChildren: children;
						yourself } ]
]

{ #category : #'sample creation' }
PaBenchmarks >> yBranchDepth: depth with: childrenA with: childrenB [

	^ self lineBranchDepth: depth children:
		(self lineBranchDepth: depth children: childrenA),
		(self lineBranchDepth: depth children: childrenB)
]
