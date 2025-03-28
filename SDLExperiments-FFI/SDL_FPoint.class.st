"
I'm a binding to the struct `SDL_FPoint`.

A point that uses float as coordinates.

See: https://wiki.libsdl.org/SDL2/SDL_FPoint
"
Class {
	#name : #'SDL_FPoint',
	#superclass : #SDL2Structure,
	#classVars : [
		'OFFSET_X',
		'OFFSET_Y'
	],
	#category : #'SDLExperiments-FFI'
}

{ #category : #'field definition' }
SDL_FPoint class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"

	^ #(
		float x;
		float y;
 		)
]

{ #category : #'instance creation' }
SDL_FPoint class >> newFrom: aPoint [

	^ self new
		  x: aPoint x;
		  y: aPoint y;
		  yourself
]

{ #category : #converting }
SDL_FPoint >> asPoint [

	^ self x @ self y
]

{ #category : #printing }
SDL_FPoint >> printOn: aStream [

	super printOn: aStream.
	aStream print: self asPoint
]

{ #category : #accessing }
SDL_FPoint >> updateFrom: aPharoPoint [

	self
		x: aPharoPoint x asFloat;
		y: aPharoPoint y asFloat
]

{ #category : #'accessing - structure variables' }
SDL_FPoint >> x [
	"This method was automatically generated"
	^handle floatAt: OFFSET_X
]

{ #category : #'accessing - structure variables' }
SDL_FPoint >> x: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_X put: anObject
]

{ #category : #'accessing - structure variables' }
SDL_FPoint >> y [
	"This method was automatically generated"
	^handle floatAt: OFFSET_Y
]

{ #category : #'accessing - structure variables' }
SDL_FPoint >> y: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_Y put: anObject
]
