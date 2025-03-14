Class {
	#name : #RectangleKeyDictionaryTest,
	#superclass : #TestCase,
	#category : #'SDLExperiments-RTree-Abstract'
}

{ #category : #testing }
RectangleKeyDictionaryTest class >> isAbstract [

	^ self == RectangleKeyDictionaryTest
]

{ #category : #running }
RectangleKeyDictionaryTest >> classToTest [

	^ self subclassResponsibility
]

{ #category : #tests }
RectangleKeyDictionaryTest >> test01SingleNode [

	| aDictionary aRectangle |
	aRectangle := 1@2 extent: 3@4.

	aDictionary := self classToTest withAll: { aRectangle }.
	
	self assert: aDictionary bounds equals: aRectangle.
	self assert: aDictionary itemCount equals: 1.

	self
		assert: (aDictionary valuesAtRectangle: (5@4 extent: 1@1))
		equals: #().
	self
		assert: (aDictionary valuesAtRectangle: (1@2 extent: 1@1))
		equals: #(1).

	self
		assert: (aDictionary valuesAtPoint: 5@4)
		equals: #().
	self
		assert: (aDictionary valuesAtPoint: 1@2)
		equals: #(1)
]

{ #category : #tests }
RectangleKeyDictionaryTest >> test02SomeNodes [

	| rectangles aDictionary |
	rectangles := OrderedCollection new.
	1 to: 4 do: [ :y |
		1 to: 4 do: [ :x |
			rectangles add: (x@y extent: 1@1) ] ].

	aDictionary := self classToTest withAll: rectangles.
	
	self assert: aDictionary bounds equals: (1@1 extent: 4@4).
	self assert: aDictionary itemCount equals: 16.

	self
		assert: (aDictionary valuesAtRectangle: (1@1 extent: 2@1))
		equals: #(1 2).
	self
		assert: (aDictionary valuesAtRectangle: (3@3 extent: 2@2))
		equals: #(11 12 15 16).

	self
		assert: (aDictionary valuesAtPoint: 1@1)
		equals: #(1).
	self
		assert: (aDictionary valuesAtPoint: 3@3)
		equals: #(11)
]

{ #category : #tests }
RectangleKeyDictionaryTest >> test03NonOverlappingNodes [

	| rectangles aDictionary results |
	rectangles := OrderedCollection new.
	1 to: 50 do: [ :y |
		1 to: 50 do: [ :x |
			rectangles add: ((x-1)@(y-1) extent: 1@1) ] ].

	aDictionary := self classToTest withAll: rectangles.
	self assert: aDictionary itemCount equals: 2500.

	"Note: The results have to be sorted"
	results := aDictionary valuesAtRectangle: (Rectangle origin: 0@0 corner: 50@50).
	self assert: results size equals: 2500.
	self assert: results equals: (1 to: results size).

	results := aDictionary valuesAtRectangle: (Rectangle origin: 0@0 corner: 50@49).
	self assert: results size equals: 2450.
	self assert: results equals: (1 to: results size).

	results := aDictionary valuesAtRectangle: (Rectangle origin: 5@6 extent: 1@1).
	self assert: results size equals: 1.
	self assert: results first equals: 1 + (6*50) + 5.

	self
		assert: (aDictionary valuesAtPoint: 5@6)
		equals: { 1 + (6*50) + 5 }.
	self
		assert: (aDictionary valuesAtPoint: 50@50)
		equals: #()
]

{ #category : #tests }
RectangleKeyDictionaryTest >> test04OverlappingNodes [

	| rectangles aDictionary results |
	rectangles := OrderedCollection new.
	1 to: 50 do: [ :h |
		1 to: 50 do: [ :w |
			rectangles add: (0@0 extent: w@h) ] ].

	aDictionary := self classToTest withAll: rectangles.

	"Both the checks for the elements assume elements are sorted."
	results := aDictionary valuesAtRectangle: (0@0 extent: 1@1).
	self assert: results equals: (1 to: results size).

	results := aDictionary valuesAtRectangle: (0@49 extent: 1@1).
	self assert: results equals: (2451 to: 2500).

	results := aDictionary valuesAtPoint: 0@0.
	self assert: results equals: (1 to: results size).

	results := aDictionary valuesAtPoint: 0@49.
	self assert: results equals: (2451 to: 2500)
]
