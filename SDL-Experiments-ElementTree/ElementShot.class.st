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
