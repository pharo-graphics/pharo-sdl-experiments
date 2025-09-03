Class {
	#name : #PaEndpoint,
	#superclass : #Object,
	#instVars : [
		'stream',
		'root'
	],
	#classVars : [
		'FullByte',
		'PatchesByte'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Core'
}

{ #category : #'class initialization' }
PaEndpoint class >> initialize [

	FullByte := 1.
	PatchesByte := 2
]

{ #category : #accessing }
PaEndpoint >> root [

	^ root
]

{ #category : #accessing }
PaEndpoint >> stream [

	^ stream
]

{ #category : #accessing }
PaEndpoint >> stream: anObject [

	stream := anObject
]

{ #category : #synchronization }
PaEndpoint >> wellKnownObjects [
	
	^ { PaNullPatch instance }
]
