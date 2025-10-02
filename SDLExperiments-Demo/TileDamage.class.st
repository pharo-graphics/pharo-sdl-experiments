Class {
	#name : 'TileDamage',
	#superclass : 'Object',
	#instVars : [
		'width',
		'status',
		'left',
		'right',
		'bottom',
		'top'
	],
	#category : 'SDLExperiments-Demo-Utility-Window',
	#package : 'SDLExperiments-Demo',
	#tag : 'Utility-Window'
}

{ #category : 'as yet unclassified' }
TileDamage >> addAll [
	
	status := #all
]

{ #category : 'as yet unclassified' }
TileDamage >> addLeft: aLeft top: aTop right: aRight bottom: aBottom [
	
	status := #partial.
	aLeft < left ifTrue: [ left := aLeft ].
	aTop < top ifTrue: [ top := aTop ].
	aRight > right ifTrue: [ right := aRight ].
	aBottom > bottom ifTrue: [ bottom := aBottom ]
]

{ #category : 'converting' }
TileDamage >> asSdlRectIn: aPixelExtent [ 
	
	status = #all ifFalse: [ ^self notYetImplemented ].
	
	^ SDL_Rect autoReleasingNewOrigin: 0@0 extent: aPixelExtent
]

{ #category : 'testing' }
TileDamage >> isEmpty [
	
	^ status = #empty
]

{ #category : 'removing' }
TileDamage >> removeAll [
	
	status := #empty.
	left := top := right := bottom := nil.
]
