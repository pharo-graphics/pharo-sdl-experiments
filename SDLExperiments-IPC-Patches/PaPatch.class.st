"
I'm a patch to a patcheable object.
"
Class {
	#name : #PaPatch,
	#superclass : #Object,
	#category : #'SDLExperiments-IPC-Patches-Core'
}

{ #category : #accessing }
PaPatch >> count [
	"Answer the number of linked patches. Mostly intended for debugging purposes."

	^ self subclassResponsibility
]

{ #category : #testing }
PaPatch >> isNullPatch [

	^ false
]

{ #category : #reading }
PaPatch >> read: aPatcheable at: anInteger [
	"Answer the value of the specified indexed variable (either patched or real value). It is intended for objects with variable layout."

	^ self subclassResponsibility
]

{ #category : #reading }
PaPatch >> read: aPatcheable instVarAt: anInteger [
	"Answer the value of the specified instance variable (either patched or real value)."

	^ self subclassResponsibility
]

{ #category : #enumerating }
PaPatch >> withAllPatchesDo: aUnaryBlock [
	"Evaluate a block on me and each of my (not null) next patches."

	| current |
	current := self.
	[ current isNullPatch ] whileFalse: [
		aUnaryBlock value: current.
		current := current nextPatch ]
]

{ #category : #writing }
PaPatch >> write: aPatcheable at: anInteger put: aValue [ 
	"Write the value of the specified indexed variable (either create a patch or update an existing patch). It is intended for objects with variable layout."

	self subclassResponsibility
]

{ #category : #writing }
PaPatch >> write: aPatcheable instVarAt: anInteger put: aValue [ 
	"Write the value of the specified instance variable (either create a patch or update an existing patch)."

	self subclassResponsibility
]
