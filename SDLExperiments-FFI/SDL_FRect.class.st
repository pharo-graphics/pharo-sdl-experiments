"
I'm a binding to the struct `SDL_FRect`.

A rectangle, with the origin at the upper left (floating point).

See: https://wiki.libsdl.org/SDL2/SDL_FRect
"
Class {
	#name : #'SDL_FRect',
	#superclass : #SDL2Structure,
	#classVars : [
		'OFFSET_H',
		'OFFSET_W',
		'OFFSET_X',
		'OFFSET_Y'
	],
	#category : #'SDLExperiments-FFI'
}

{ #category : #'field definition' }
SDL_FRect class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^#(
    float x;
    float y;
    float w;
    float h;
 	)
]

{ #category : #'instance creation' }
SDL_FRect class >> newOrigin: origin extent: extent [

	^ self
		  newX: origin x
		  y: origin y
		  w: extent x
		  h: extent y
]

{ #category : #'instance creation' }
SDL_FRect class >> newX: x y: y w: w h: h [

	^ self new
		  x: x;
		  y: y;
		  w: w;
		  h: h;
		  yourself
]

{ #category : #converting }
SDL_FRect >> asRectangle [

	^ self origin extent: self extent
]

{ #category : #accessing }
SDL_FRect >> bottom [

	^ self y + self h
]

{ #category : #accessing }
SDL_FRect >> extent [

	^ self w @ self h
]

{ #category : #accessing }
SDL_FRect >> extent: aPoint [

	self w: aPoint x.
	self h: aPoint y
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> h [
	"This method was automatically generated"
	^handle floatAt: OFFSET_H
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> h: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_H put: anObject
]

{ #category : #accessing }
SDL_FRect >> left [
	
	^ self x
]

{ #category : #accessing }
SDL_FRect >> origin [

	^ self x @ self y
]

{ #category : #accessing }
SDL_FRect >> origin: aPoint [

	self x: aPoint x.
	self y: aPoint y
]

{ #category : #printing }
SDL_FRect >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self asRectangle;
		nextPut: $)
]

{ #category : #accessing }
SDL_FRect >> right [
	
	^ self x + self w
]

{ #category : #accessing }
SDL_FRect >> top [

	^ self y
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> w [
	"This method was automatically generated"
	^handle floatAt: OFFSET_W
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> w: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_W put: anObject
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> x [
	"This method was automatically generated"
	^handle floatAt: OFFSET_X
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> x: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_X put: anObject
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> y [
	"This method was automatically generated"
	^handle floatAt: OFFSET_Y
]

{ #category : #'accessing - structure variables' }
SDL_FRect >> y: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_Y put: anObject
]
