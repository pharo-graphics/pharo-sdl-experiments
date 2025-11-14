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
SDL2StreamingTextureUpdateBench >> preparePixels [

	| cairoSurface cairoContext |
	sdlTexture lock: SDL_Rect null pixels: pixelsAddress pitch: pitchAddress.

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
	cairoSurface flush
]

{ #category : #'as yet unclassified' }
SDL2StreamingTextureUpdateBench >> prepareToRun [

	super prepareToRun.
	
	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer
]

{ #category : #'as yet unclassified' }
SDL2StreamingTextureUpdateBench >> textureAccessType [

	^ SDL_TEXTUREACCESS_STREAMING
]

{ #category : #accessing }
SDL2StreamingTextureUpdateBench >> title [

	^ 'STREAM'
]

{ #category : #'as yet unclassified' }
SDL2StreamingTextureUpdateBench >> updatePixels [

	sdlTexture unlock
]
