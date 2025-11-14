Class {
	#name : #SDL2StaticTextureUpdateBench,
	#superclass : #SDL2TextureUpdateBench,
	#instVars : [
		'cairoSurface',
		'cairoSurfaceStride',
		'cairoSurfacePixels'
	],
	#category : #'SDLExperiments-Tests'
}

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> preparePixels [

	| cairoContext |
	cairoContext := cairoSurface newContext.
	cairoContext clearColor: Color purple.
	cairoSurface flush
]

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> prepareToRun [

	super prepareToRun.
	
	cairoSurface := AeCairoImageSurface
		extent: extent
		format: AeCairoSurfaceFormat argb32.

	cairoSurfaceStride := cairoSurface stride.
	cairoSurfacePixels := cairoSurface data
]

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> textureAccessType [

	^ SDL_TEXTUREACCESS_STATIC
]

{ #category : #accessing }
SDL2StaticTextureUpdateBench >> title [

	^ 'STATIC '
]

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> updatePixels [

	sdlTexture
		updateTextureRect: SDL_Rect null
			pixels: cairoSurfacePixels
			pitch:  cairoSurfaceStride
]
