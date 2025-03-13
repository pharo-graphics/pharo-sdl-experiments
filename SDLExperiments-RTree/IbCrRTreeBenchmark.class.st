Class {
	#name : #IbCrRTreeBenchmark,
	#superclass : #Object,
	#category : #'SDLExperiments-RTree-Benchmark'
}

{ #category : #running }
IbCrRTreeBenchmark class >> run [
	<script>

	Stdio stdout << 'n;rectangles;IbRTree avg us;CrRTree avg us;'; lf.
	(5 to: 105 by: 10) do: [ :n |
		| rectangles |
		rectangles := OrderedCollection new.
		1 to: n do: [ :y |
			1 to: n do: [ :x |
				rectangles add: (Rectangle origin: x@y extent: 1@1) ] ].

		Stdio stdout
			print: n; << ';';
			print: rectangles size; << ';'.
		2 timesRepeat: [Smalltalk garbageCollect].
		Stdio stdout print: [ IbRTree withAll: rectangles ] bench timePerExecution asMicroseconds; << ';'.
		2 timesRepeat: [Smalltalk garbageCollect].
		Stdio stdout print: [ CrRTree withAll: rectangles ] bench timePerExecution asMicroseconds; << ';'. 
		Stdio stdout lf; flush ]
]

{ #category : #'see class side' }
IbCrRTreeBenchmark >> seeClassSide [ 
]
