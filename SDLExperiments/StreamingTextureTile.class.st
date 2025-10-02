"
I am a `TextureTile` that uses `SDL_LockTexture`/`SDL_UnlockTexture` API to update pixel contents.

See:
* https://wiki.libsdl.org/SDL2/SDL_LockTexture
* https://wiki.libsdl.org/SDL2/SDL_UnlockTexture
"
Class {
	#name : 'StreamingTextureTile',
	#superclass : 'TextureTile',
	#instVars : [
		'pixelsAddress',
		'pitchAddress'
	],
	#category : 'SDLExperiments-Manager-Texture',
	#package : 'SDLExperiments',
	#tag : 'Manager-Texture'
}

{ #category : 'enumerating' }
StreamingTextureTile >> cairoContextToOverride: sdlRect do: aBlock [

	| aCairoSurface aCairoContext |

	"Obtain a RAM buffer to draw on it, that is
	write-only and needs to be cleaned."
	sdlTexture
		lockRect: sdlRect
		  pixels: pixelsAddress
		   pitch: pitchAddress.

	"Draw on the buffer"
	aCairoSurface := AeCairoImageSurface
		unownedNewForData: pixelsAddress
			         width: sdlRect w
		           height: sdlRect h
		           stride: (pitchAddress signedLongAt: 1)
		 format: AeCairoSurfaceFormat argb32.
	aCairoSurface
		deviceScale: deviceScalePoint;
		deviceOffsetX: sdlRect x
		            y: sdlRect y.
	aCairoContext :=
		AeCairoContext unownedNewFor: aCairoSurface.
	aCairoContext clearTransparent.
	aBlock value: aCairoContext.

	"Update texture and free cairo objects"
	aCairoSurface flush.
	sdlTexture unlock.
	aCairoContext externallyFree.
	aCairoSurface externallyFree.
]

{ #category : 'enumerating' }
StreamingTextureTile >> cairoContextToOverrideDo: aBlock [

	| aCairoSurface aCairoContext |

	"Obtain a RAM buffer to draw on it, that is
	write-only and needs to be cleaned."
	sdlTexture
		lockRect: ExternalAddress null
		  pixels: pixelsAddress
		   pitch: pitchAddress.

	"Draw on the buffer"
	aCairoSurface := AeCairoImageSurface
		unownedNewForData: pixelsAddress
			         width: pixelExtent x
		           height: pixelExtent y
		           stride: (pitchAddress signedLongAt: 1)
		 format: AeCairoSurfaceFormat argb32.
	aCairoSurface deviceScale: deviceScalePoint.

	aCairoContext := AeCairoContext unownedNewFor: aCairoSurface.
	aCairoContext clearTransparent.
	aBlock value: aCairoContext.

	"Update texture and free cairo objects"
	aCairoSurface flush.
	sdlTexture unlock.
	aCairoContext externallyFree.
	aCairoSurface externallyFree.
]

{ #category : 'life cycle' }
StreamingTextureTile >> createCairoObjects [
	"Cairo objects are created and freed on each draw."
]

{ #category : 'initialization' }
StreamingTextureTile >> initialize [

	super initialize.

	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer

]

{ #category : 'life cycle' }
StreamingTextureTile >> sdlTextureAccess [ 

	^ SDL_TEXTUREACCESS_STREAMING
]
