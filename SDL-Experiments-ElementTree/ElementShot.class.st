"
I am an immutable representation a scene graph element.

See comment in my superclass.
"
Class {
	#name : #ElementShot,
	#superclass : #TreeNodeShot,
	#type : #variable,
	#instVars : [
		'#opacity => ShotSlot',
		'#background => ShotSlot'
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

{ #category : #initialization }
ElementShot >> initializeInstanceVariablesFrom: sourceObject [

	background := sourceObject background.
	opacity := sourceObject opacity
]

{ #category : #accessing }
ElementShot >> opacity [

	^ opacity ifNil: [ 1.0 ]
]

{ #category : #private }
ElementShot >> opacity: aFloat [

	opacity := aFloat
]
