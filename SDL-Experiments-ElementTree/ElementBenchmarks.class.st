"
I define benchmarks for the scene graph elements.
"
Class {
	#name : #ElementBenchmarks,
	#superclass : #Object,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #benchmarks }
ElementBenchmarks >> benchFractal: depth n: n [

	| rootElement leafElement colors i bytes |
	'---' traceCr.
	{#depth. depth. #n. n} traceCr.

	'frequency to create tree: ' trace.
	[ rootElement := (self fractalBranchDepth: depth n: n) first ] bench shortPrintString traceCr.

	'element count: ' trace.
	rootElement withAllChildrenCount traceCr.

	'leaf level: ' trace.
	leafElement := rootElement anyLeaf.
	leafElement level traceCr.

	colors := Color wheel: 100.
	i := 1.
	'frequency to set background: ' trace.
	[	leafElement background: (colors atWrap: (i := i+1)) ]
		bench shortPrintString traceCr.

	'ms to serialize: ' trace. [ bytes := rootElement serializeToByteArray ] timeToRun asMilliSeconds traceCr.

	'ms to materialize: ' trace. [ FLMaterializer materializeFromByteArray: bytes ] timeToRun asMilliSeconds traceCr.

	'byte count: ' trace. bytes size traceCr
]

{ #category : #benchmarks }
ElementBenchmarks >> benchMultipleN [
	<script: 'self new benchMultipleN'>

	1 to: 6 do: [ :n | self benchFractal: 1 n: n ]
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
