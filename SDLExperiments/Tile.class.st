Class {
	#name : 'Tile',
	#superclass : 'Object',
	#category : 'SDLExperiments-Core',
	#package : 'SDLExperiments',
	#tag : 'Core'
}

{ #category : 'enumerating' }
Tile >> renderTo: aSDLFRect opacity: alphaByte [
	"Render myself on the associated SDL_Renderer, at the specified position (a SDL_FRect) and opacity (0..255 value)."

	self subclassResponsibility
]
