"
I'm a texture update benchmark for SDL2's `SDL_TEXTUREACCESS_STATIC` textures.
"
Class {
	#name : #SDL2StaticTextureUpdateBench,
	#superclass : #SDL2TextureUpdateBench,
	#instVars : [
		'cairoSurface',
		'cairoSurfaceStride',
		'cairoSurfacePixels',
		'cairoContext'
	],
	#category : #'SDLExperiments-Tests'
}

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> setUp [

	super setUp.
	
	cairoSurface := AeCairoImageSurface
		extent: extent
		format: AeCairoSurfaceFormat argb32.

	cairoContext := cairoSurface newContext.

	cairoSurfaceStride := cairoSurface stride.
	cairoSurfacePixels := cairoSurface data
]

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> stepA [
]

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> stepB [

	cairoContext clearColor: Color purple.
	cairoSurface flush.
	cairoContext status ensureIsSuccess
]

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> stepC [

	sdlTexture
		updateTextureRect: SDL_Rect null
			pixels: cairoSurfacePixels
			pitch:  cairoSurfaceStride
]

{ #category : #'as yet unclassified' }
SDL2StaticTextureUpdateBench >> textureAccessType [

	^ SDL_TEXTUREACCESS_STATIC
]

{ #category : #accessing }
SDL2StaticTextureUpdateBench >> title [

	^ 'STATIC'
]
