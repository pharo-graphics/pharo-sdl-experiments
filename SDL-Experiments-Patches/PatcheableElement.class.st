Class {
	#name : #PatcheableElement,
	#superclass : #Patcheable,
	#type : #variable,
	#instVars : [
		'#opacity => PatchSlot',
		'#background => PatchSlot'
	],
	#category : #'SDL-Experiments-Patches-Core'
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
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: ' opacity: ';
		print: opacity.
	aStream
		nextPutAll: ' background: ';
		print: background
]
