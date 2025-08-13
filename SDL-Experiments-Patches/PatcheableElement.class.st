Class {
	#name : #PatcheableElement,
	#superclass : #Patcheable,
	#type : #variable,
	#instVars : [
		'#opacity => PatchSlot',
		'#background => PatchSlot'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
PatcheableElement >> background [

	^ background
]

{ #category : #accessing }
PatcheableElement >> background: anObject [

	background := anObject
]

{ #category : #accessing }
PatcheableElement >> opacity [

	^ opacity
]

{ #category : #accessing }
PatcheableElement >> opacity: anObject [

	opacity := anObject
]

{ #category : #printing }
PatcheableElement >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' opacity: ';
		print: opacity.
	aStream
		nextPutAll: ' background: ';
		print: background
]
