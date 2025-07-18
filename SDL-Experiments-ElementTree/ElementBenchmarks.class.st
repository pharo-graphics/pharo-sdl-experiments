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

	| rootElement leafElement colors i |
	rootElement := (self fractalBranchDepth: depth n: n) first.
	leafElement := rootElement anyLeaf.

	colors := Color wheel: 100.
	i := 1.

	'element count: ' trace.
	rootElement withAllChildrenCount trace.
	'; leaf level: ' trace.
	leafElement level trace.
	'; frequency: ' trace.
	[	leafElement background: (colors atWrap: (i := i+1)) ]
		bench shortPrintString traceCr.

	[ | bytes |
	'ms to serialize: ' trace.
	[ bytes := rootElement serializeToByteArray ] timeToRun trace.
	' ms to materialize: ' trace.
	[ FLMaterializer materializeFromByteArray: bytes ] timeToRun trace.
	' byte count: ' trace. bytes size traceCr.
	] value
]

{ #category : #benchmarks }
ElementBenchmarks >> benchMultipleN [
	<script: 'self new benchMultipleN'>

	1 to: 8 do: [ :n |
		self benchFractal: 2 n: n ]
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
