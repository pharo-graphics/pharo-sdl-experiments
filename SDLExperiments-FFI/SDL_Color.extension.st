Extension { #name : #'SDL_Color' }

{ #category : #'*SDLExperiments-FFI' }
SDL_Color class >> newFrom: aPharoColor [

	^ self new
		updateFrom: aPharoColor;
		yourself
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Color >> updateFrom: aPharoColor [
	
	self
		r: (SDL2 fromFloatToByte: aPharoColor red);
		g: (SDL2 fromFloatToByte: aPharoColor green);
		b: (SDL2 fromFloatToByte: aPharoColor blue);
		a: (SDL2 fromFloatToByte: aPharoColor alpha)

]
