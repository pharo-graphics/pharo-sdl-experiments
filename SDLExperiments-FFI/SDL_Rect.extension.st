Extension { #name : #'SDL_Rect' }

{ #category : #'*SDLExperiments-FFI' }
SDL_Rect class >> autoReleasingNewOrigin: origin extent: extent [

	^ self
		  autoReleasingNewX: origin x
		  y: origin y
		  w: extent x
		  h: extent y
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Rect class >> autoReleasingNewX: x y: y w: w h: h [

	^ self new
		  x: x;
		  y: y;
		  w: w;
		  h: h;
		  autoRelease;
		  yourself
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Rect >> extent [

	^ self w @ self h
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Rect >> origin [

	^ self x @ self y
]