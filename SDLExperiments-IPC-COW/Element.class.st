"
I am a mutable representation a scene graph element.

See comment in my superclass.
"
Class {
	#name : #Element,
	#superclass : #TreeNode,
	#instVars : [
		'#background => ActiveShotSlot',
		'#opacity => ActiveShotSlot'
	],
	#category : #'SDLExperiments-IPC-COW'
}

{ #category : #accessing }
Element >> background [

	^ background
]

{ #category : #accessing }
Element >> background: aColor [

	background := aColor
]

{ #category : #'instance creation' }
Element >> newDefaultShot [

	^ ElementShot new
]

{ #category : #accessing }
Element >> opacity [

	^ opacity
]

{ #category : #accessing }
Element >> opacity: aOpacity [

	opacity := aOpacity
]
