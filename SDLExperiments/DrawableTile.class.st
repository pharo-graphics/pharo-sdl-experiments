Class {
	#name : 'DrawableTile',
	#superclass : 'Tile',
	#category : 'SDLExperiments-Core',
	#package : 'SDLExperiments',
	#tag : 'Core'
}

{ #category : 'enumerating' }
DrawableTile >> cairoContextToOverrideDo: aBlock [
	"Evaluate a block with a Cairo context that will override the Tile contents."

	self subclassResponsibility
]
