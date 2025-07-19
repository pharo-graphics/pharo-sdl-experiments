"
I am an immutable representation a scene graph element.

I am a variable-layer object, to point to my children without need of a separate collection.
"
Class {
	#name : #ElementShot,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'opacity',
		'background'
	],
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #'instance creation' }
ElementShot class >> children: aCollection [

	^ self children: aCollection background: nil opacity: nil
]

{ #category : #'instance creation' }
ElementShot class >> children: aCollection background: aColor opacity: aOpacity [

	| new |
	new := self basicNew: aCollection size.

	new
		privateBackground: aColor;
		privateOpacity: aOpacity.

	aCollection withIndexDo: [ :each :index | new at: index put: each ].

	^ new
]

{ #category : #'instance creation' }
ElementShot class >> new [

	^ self children: #()
]

{ #category : #accessing }
ElementShot >> background [

	^ background ifNil: [ Color white ]
]

{ #category : #accessing }
ElementShot >> children [

	^ Array
		  new: self childrenCount
		  streamContents: [ :stream |
			  self childrenDo: [ :each | stream nextPut: each ] ]
]

{ #category : #accessing }
ElementShot >> childrenCount [

	^ self size
]

{ #category : #accessing }
ElementShot >> childrenDo: aBlock [

	1 to: self size do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #enumerating }
ElementShot >> childrenWithIndexDo: aBlock [

	1 to: self size do: [ :index |
		aBlock value: (self at: index) value: index ]
]

{ #category : #copying }
ElementShot >> copyWithBackground: aColor [

	^ self shallowCopy
		  privateBackground: aColor;
		  yourself
]

{ #category : #copying }
ElementShot >> copyWithChild: aShot at: index [

	^ self shallowCopy
		  basicAt: index put: aShot;
		  yourself
]

{ #category : #copying }
ElementShot >> copyWithChildLastt: aShot [ 
	"Answer a copy of the receiver that is 1 bigger than the receiver and has
	newElement at the last element."

	| newSize |
	newSize := self size + 1.

	^ (self privateCopyFor: newSize)
			replaceFrom: 1
				to: self size
				with: self
				startingAt: 1;
			basicAt: newSize put: aShot;
			yourself
]

{ #category : #copying }
ElementShot >> copyWithOpacity: aColor [

	^ self shallowCopy
		  privateOpacity: aColor;
		  yourself
]

{ #category : #copying }
ElementShot >> copyWithoutChildAt: index [
	"We assume the child has exactly one occurrence."

	| newSize |
	newSize := self size - 1.

	^ (self privateCopyFor: newSize)
			replaceFrom: 1
				to: index - 1 
				with: self
				startingAt: 1;
			replaceFrom: index
				to: newSize
				with: self
				startingAt: index + 1;
			yourself
]

{ #category : #debugging }
ElementShot >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #debugging }
ElementShot >> inspectionPresenterOn: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Tree'>

	^ aBuilder newTreeTable 
		roots: { self };
		children: [ :aNode | aNode children ];
		addColumn: (SpStringTableColumn 
			title: 'debugId'
			evaluated: [ :each | each debugId ]);
		addColumn: (SpStringTableColumn 
			title: 'background'
			evaluated: [ :each | each background ]);
		addColumn: (SpStringTableColumn 
			title: 'opacity'
			evaluated: [ :each | each opacity ]);
		expandAll;
		yourself
]

{ #category : #accessing }
ElementShot >> opacity [

	^ opacity ifNil: [ 1.0 ]
]

{ #category : #printing }
ElementShot >> printDetailsOn: aStream [

	background ifNotNil: [
		aStream
			nextPutAll: ' background: ';
			print: background ].

	opacity ifNotNil: [
		aStream
			nextPutAll: ' opacity: ';
			print: opacity ]
]

{ #category : #printing }
ElementShot >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self debugId;
		nextPutAll: ' size: ';
		print: self childrenCount.

	self printDetailsOn: aStream.

	aStream nextPutAll: ')'
]

{ #category : #private }
ElementShot >> privateBackground: aColor [

	background := aColor	
]

{ #category : #copying }
ElementShot >> privateCopyFor: newSize [
	"Answer a copy of self with the specified size. The children are not copied at all, this is a responsibility of sender."

	^ (self class basicNew: newSize)
		privateBackground: background;
		privateOpacity: opacity;
		yourself
]

{ #category : #private }
ElementShot >> privateOpacity: aFloat [

	opacity := aFloat	
]

{ #category : #private }
ElementShot >> replaceFrom: start to: stop with: replacement startingAt: repStart [
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 105>

	start to: stop do: [ :i |
		self basicAt: i put: (replacement basicAt: repStart - start + i) ]
]
