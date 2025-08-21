"
I'm a testing patcheable object that emulates being a scene graph node.
"
Class {
	#name : #PatcheableElement,
	#superclass : #Object,
	#type : #variable,
	#traits : 'TInstVarsPatcheable + TIndexedVarsPatcheable',
	#classTraits : 'TInstVarsPatcheable classTrait + TIndexedVarsPatcheable classTrait',
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

{ #category : #initialization }
PatcheableElement >> initialize [

	super initialize.
	self initializePatch.
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
