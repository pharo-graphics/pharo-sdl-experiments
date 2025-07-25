"
I define benchmarks for the scene graph elements.
"
Class {
	#name : #ElementBenchmarks,
	#superclass : #Object,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #benchmarks }
ElementBenchmarks >> benchAddRemoveChildBulk [
	<script: 'self new benchAddRemoveChildBulk'>

	| rootElement elements |
	rootElement := (self fractalBranchDepth: 2 n: 9) first.
	rootElement commitWithAllChildren.

	elements := OrderedCollection new.
	rootElement withAllChildrenDo: [ :each | elements add: each ].

	'element count: ' trace.
	elements size traceCr.

	'frequency to add a child to each element & commit once: ' trace.
	[	elements do: [ :each | each addChild: Element new ].
		rootElement commitWithAllChildren ] bench shortPrintString traceCr.

	'frequency to remove each added element & commit once: ' trace.
	[	elements do: [ :each |
			each children size >= 1 ifTrue: [
				each removeChild: each children last ] ].
		rootElement commitWithAllChildren ] bench shortPrintString traceCr
]

{ #category : #benchmarks }
ElementBenchmarks >> benchAddRemoveChildIIndividual [
	<script: 'self new benchAddRemoveChildIIndividual'>

	| rootElement elements |
	rootElement := (self fractalBranchDepth: 2 n: 9) first.
	rootElement commitWithAllChildren.

	elements := OrderedCollection new.
	rootElement withAllChildrenDo: [ :each | elements add: each ].

	'element count: ' trace.
	elements size traceCr.

	'frequency to add a child to each element & commit each time: ' trace.
	[	elements do: [ :each |
			each addChild: Element new.
			rootElement commitWithAllChildren ] ] bench shortPrintString traceCr.

	'frequency to remove each added element & commit each time: ' trace.
	[	elements do: [ :each |
			each children size >= 1 ifTrue: [
				each removeChild: each children last.
				rootElement commitWithAllChildren ] ] ] bench shortPrintString traceCr
]

{ #category : #benchmarks }
ElementBenchmarks >> benchCreateAndUpdateDepth: depth n: n [
	<script: '1 to: 6 do: [ :n | self new benchCreateAndUpdateDepth: 1 n: n ]'>

	| rootElement leafElement bytes |
	'---' traceCr.
	{#depth. depth. #n. n} traceCr.

	'frequency to create tree: ' trace.
	[ 	rootElement := (self fractalBranchDepth: depth n: n) first.
		rootElement commitWithAllChildren ] bench shortPrintString traceCr.

	'element count: ' trace.
	rootElement withAllChildrenCount traceCr.

	'tree depth: ' trace.
	leafElement := rootElement anyLeaf.
	leafElement level traceCr.

	'frequency to set opacity 100 times and commit: ' trace.
	[ (1 to: 100) do: [ :i | leafElement opacity: i / 100.0 ].
		rootElement commitWithAllChildren ] bench shortPrintString traceCr.

	'ms to serialize: ' trace.
	[ bytes := rootElement serializeToByteArray ] timeToRun asMilliSeconds traceCr.

	'ms to materialize: ' trace. 
	[ FLMaterializer materializeFromByteArray: bytes ] timeToRun asMilliSeconds traceCr.

	'byte count: ' trace.
	bytes size traceCr
]

{ #category : #'sample creation' }
ElementBenchmarks >> fractalBranchDepth: depth n: n [

	^ n = 0
		ifTrue: [ #() ]
		ifFalse: [
			self
				yBranchDepth: depth
				with: (self fractalBranchDepth: depth n: n - 1)
				with: (self fractalBranchDepth: depth n: n - 1) ]
]

{ #category : #'sample creation' }
ElementBenchmarks >> lineBranchDepth: depth children: leafChildren [

	^ (1 to: depth)
			inject: leafChildren
			into: [ :children :each |
				{ Element new
						addChildren: children;
						yourself } ]
]

{ #category : #'sample creation' }
ElementBenchmarks >> yBranchDepth: depth with: childrenA with: childrenB [

	^ self lineBranchDepth: depth children:
		(self lineBranchDepth: depth children: childrenA),
		(self lineBranchDepth: depth children: childrenB)
]
