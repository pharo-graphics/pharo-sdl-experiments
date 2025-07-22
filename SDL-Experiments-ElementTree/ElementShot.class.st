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

{ #category : #private }
ElementShot >> background: aColor [

	background := aColor
]

{ #category : #accessing }
ElementShot >> opacity [

	^ opacity ifNil: [ 1.0 ]
]

{ #category : #private }
ElementShot >> opacity: aFloat [

	opacity := aFloat
]

{ #category : #copying }
ElementShot >> privateCopyFor: newSize [
	"Answer a copy of self with the specified size. The children are not copied at all, this is a responsibility of sender."

	^ (super privateCopyFor: newSize)
			background: background;
			opacity: opacity;
			yourself
]
