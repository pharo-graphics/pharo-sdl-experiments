"
I am polymorphic with `CrRTree` but iterate all items to answer the queries.
"
Class {
	#name : #RectangleKeyDictionary,
	#superclass : #Object,
	#category : #'SDLExperiments-RTree-Abstract'
}

{ #category : #'instance creation' }
RectangleKeyDictionary class >> new: itemCount boundsBlock: boundsBlock valueBlock: valueBlock [ 

	^ self subclassResponsibility
]

{ #category : #'instance creation' }
RectangleKeyDictionary class >> withAll: aCollection [
	"Create an instance with the specified collection of rectangles, with the index as value.
	Important: For optimal performance, the rectangles must be sorted horizontally by their center."

	^ self
		new: aCollection size 
		boundsBlock: [ :index | aCollection at: index ]
		valueBlock: [ :index | index ]
]

{ #category : #'instance creation' }
RectangleKeyDictionary class >> withAllAssociations: aCollection [

	^ self
		new: aCollection size 
		boundsBlock: [ :index | (aCollection at: index) key ]
		valueBlock: [ :index | (aCollection at: index) value ]
]

{ #category : #'instance creation' }
RectangleKeyDictionary class >> withAllUnsorted: aCollection [

	^ self withAll: (aCollection sorted: [ :a :b | (a left + a right) < (b left + b right) ])

]

{ #category : #accessing }
RectangleKeyDictionary >> bounds [

	^ self subclassResponsibility
]

{ #category : #accessing }
RectangleKeyDictionary >> itemCount [
	"Answer the number of rectangle-value items defined in this collection."

	^ self subclassResponsibility
]

{ #category : #searching }
RectangleKeyDictionary >> valuesAtPoint: aPoint [
	
	^ Array streamContents: [ :stream |
		self
			valuesAtPoint: aPoint
			do: [ :eachValue | stream nextPut: eachValue ] ]
]

{ #category : #enumerating }
RectangleKeyDictionary >> valuesAtPoint: aPoint do: aBlock [

	self subclassResponsibility
]

{ #category : #searching }
RectangleKeyDictionary >> valuesAtRectangle: aRectangle [ 
	
	^ Array streamContents: [ :stream |
		self
			valuesAtRectangle: aRectangle
			do: [ :eachValue | stream nextPut: eachValue ] ]
]

{ #category : #enumerating }
RectangleKeyDictionary >> valuesAtRectangle: aRectangle do: aBlock [

	self subclassResponsibility
]
