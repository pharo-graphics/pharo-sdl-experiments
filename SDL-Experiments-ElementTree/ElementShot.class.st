"
I am an immutable representation a scene graph element.

See comment in my superclass.
"
Class {
	#name : #ElementShot,
	#superclass : #TreeNodeShot,
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
ElementShot >> opacity [

	^ opacity ifNil: [ 1.0 ]
]

{ #category : #private }
ElementShot >> privateBackground: aColor [

	background := aColor	
]

{ #category : #copying }
ElementShot >> privateCopyFor: newSize [
	"Answer a copy of self with the specified size. The children are not copied at all, this is a responsibility of sender."

	^ (super privateCopyFor: newSize)
			privateBackground: background;
			privateOpacity: opacity;
			yourself
]

{ #category : #private }
ElementShot >> privateOpacity: aFloat [

	opacity := aFloat	
]
