"
I'm a testing patcheable object that emulates being a scene graph node.
"
Class {
	#name : #PaTestingElement,
	#superclass : #Object,
	#type : #variable,
	#traits : 'TPaInstanceVariablesAPI + TPaResizeAPI',
	#classTraits : 'TPaInstanceVariablesAPI classTrait + TPaResizeAPI classTrait',
	#instVars : [
		'#opacity => PaSlot',
		'#background => PaSlot'
	],
	#category : #'SDL-Experiments-Patches-Tests'
}

{ #category : #accessing }
PaTestingElement >> background [

	^ background
]

{ #category : #accessing }
PaTestingElement >> background: anObject [

	background := anObject
]

{ #category : #accessing }
PaTestingElement >> opacity [

	^ opacity
]

{ #category : #accessing }
PaTestingElement >> opacity: anObject [

	opacity := anObject
]

{ #category : #printing }
PaTestingElement >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' opacity: ';
		print: opacity.
	aStream
		nextPutAll: ' background: ';
		print: background
]
