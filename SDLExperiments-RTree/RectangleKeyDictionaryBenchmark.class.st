Class {
	#name : #RectangleKeyDictionaryBenchmark,
	#superclass : #Object,
	#category : #'SDLExperiments-RTree-Benchmark'
}

{ #category : #running }
RectangleKeyDictionaryBenchmark >> collectionOfNs [

	^ 25 to: 150 by: 25
]

{ #category : #running }
RectangleKeyDictionaryBenchmark >> rectanglesOfN: n [

	| rectangles |
	rectangles := OrderedCollection new.
	1 to: n do: [ :y |
		1 to: n do: [ :x |
			rectangles add: (Rectangle origin: x@y extent: 5@5) ] ].
	
	^ rectangles shuffledBy: (Random seed: 7)
]

{ #category : #running }
RectangleKeyDictionaryBenchmark >> run [
	"Log a CSV in stdout"
	<script: 'self new run'>

	"header"
	Stdio stdout << 'n;rectangles;'.
	self subjectClasses do: [ :each |
		Stdio stdout << each name; << ' us;' ].
	Stdio stdout lf; flush.

	self collectionOfNs do: [ :n |
		| rectangles rtree |
		rectangles := self rectanglesOfN: n.

		Stdio stdout
			print: n; << ';';
			print: rectangles size; << ';'.

		self subjectClasses
			do: [ :eachClass |
				2 timesRepeat: [Smalltalk garbageCollect].
				rtree := eachClass withAllUnsorted: rectangles.  "--> to bench only query time"
				Stdio stdout print: [


					"Benchmarked code:"
"					rtree := eachClass withAllUnsorted: rectangles. --> to include in bench results "
					(0.01 to: 1.0 by: 0.01) do: [ :d |
						rtree valuesAtPoint: (n * d) asInteger asPoint do: [ :_ | ] ]


					] bench timePerExecution asMicroseconds.
				Stdio stdout << ';' ]
			displayingProgress: [ :eachClass | eachClass name ].

		Stdio stdout lf; flush ] displayingProgress: [ :n | n asString ]
]

{ #category : #'as yet unclassified' }
RectangleKeyDictionaryBenchmark >> subjectClasses [

	^ { CrRTree. IbRTree. FakeRTree }
]
