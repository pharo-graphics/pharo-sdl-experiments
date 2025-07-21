"
I am a mutable representation a scene graph element.

See comment in my superclass.
"
Class {
	#name : #Element,
	#superclass : #TreeNode,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #'instance creation' }
Element class >> new [

	^ self shot: ElementShot new
]

{ #category : #accessing }
Element >> background [

	^ self readShot background
]

{ #category : #accessing }
Element >> background: aColor [

	self writeShot: [ :shot | shot privateBackground: aColor ]
]

{ #category : #accessing }
Element >> opacity [

	^ self readShot opacity
]

{ #category : #accessing }
Element >> opacity: aOpacity [

	self writeShot: [ :shot | shot privateOpacity: aOpacity ]
]
