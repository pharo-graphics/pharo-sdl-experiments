Extension { #name : #'SDL_Texture' }

{ #category : #'*SDLExperiments-FFI' }
SDL_Texture >> extent [

	| xPointer yPointer |
	xPointer := FFIInt32 newBuffer.
	yPointer := FFIInt32 newBuffer.

	self queryFormat: nil access: nil width: xPointer height: yPointer.

	^ (xPointer int32AtOffset: 0) @ (yPointer int32AtOffset: 0)
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Texture >> lock: rect pixels: pixelsAddress pitch: pitchAddress [
	"See: https://wiki.libsdl.org/SDL2/SDL_LockTexture"

	^ self ffiCall: #(
		int
		SDL_LockTexture (
			self,
			SDL_Rect* rect,
			void** pixelsAddress,
			int* pitchAddress ) )
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Texture >> queryFormat: format access: access width: w height: h [
	"See: https://wiki.libsdl.org/SDL2/SDL_QueryTexture"

	^ self ffiCall: #(
		int
		SDL_QueryTexture(
			self,
			Uint32 *format,
			int *access,
			int *w,
			int *h) )
]

{ #category : #'*SDLExperiments-FFI' }
SDL_Texture >> setScaleModeNearest [
	"Set the scale mode `SDL_ScaleModeNearest` for texture scale operations.
	
	Returns 0 on success, or -1 if the texture is not valid.
	
	See: https://wiki.libsdl.org/SDL2/SDL_SetTextureScaleMode"

	^ self ffiCall: #(
		int
		SDL_SetTextureScaleMode (
			self,
			"SDL_ScaleMode" 0 ) )
]
