"
I'm a texture update benchmark for SDL2's `SDL_TEXTUREACCESS_STREAMING` textures.
"
Class {
	#name : #SDL2StreamingTextureUpdateBench,
	#superclass : #SDL2TextureUpdateBench,
	#instVars : [
		'pitchAddress',
		'pixelsAddress'
	],
	#category : #'SDLExperiments-Tests'
}

{ #category : #'as yet unclassified' }
SDL2StreamingTextureUpdateBench >> setUp [

	super setUp.
	
	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer
]

{ #category : #'as yet unclassified' }
SDL2StreamingTextureUpdateBench >> stepA [

	sdlTexture lock: SDL_Rect null pixels: pixelsAddress pitch: pitchAddress
]

{ #category : #'as yet unclassified' }
SDL2StreamingTextureUpdateBench >> stepB [

	| cairoSurface cairoContext |
	"Draw on the buffer"
	cairoSurface :=
		AeCairoImageSurface
			unownedNewForData: pixelsAddress
			           format: AeCairoSurfaceFormat argb32
			            width: extent x
			           height: extent y
			           stride: (pitchAddress signedLongAt: 1).
	cairoContext := cairoSurface newContext.
	cairoContext clearColor: Color purple.
	cairoSurface flush.
	cairoContext status ensureIsSuccess
]

{ #category : #'as yet unclassified' }
SDL2StreamingTextureUpdateBench >> stepC [

	sdlTexture unlock
]

{ #category : #'as yet unclassified' }
SDL2StreamingTextureUpdateBench >> textureAccessType [

	^ SDL_TEXTUREACCESS_STREAMING
]

{ #category : #accessing }
SDL2StreamingTextureUpdateBench >> title [

	^ 'STREAM'
]
