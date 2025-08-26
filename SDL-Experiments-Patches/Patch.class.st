"
I'm a patch to a patcheable object.
"
Class {
	#name : #Patch,
	#superclass : #Object,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
Patch >> count [
	"Answer the number of linked patches. Mostly intended for debugging purposes."

	^ self subclassResponsibility
]

{ #category : #testing }
Patch >> isNullPatch [

	^ false
]

{ #category : #reading }
Patch >> read: aPatcheable at: anInteger [
	"Answer the value of the specified indexed variable (either patched or real value). It is intended for objects with variable layout."

	^ self subclassResponsibility
]

{ #category : #reading }
Patch >> read: aPatcheable instVarAt: anInteger [
	"Answer the value of the specified instance variable (either patched or real value)."

	^ self subclassResponsibility
]

{ #category : #accessing }
Patch >> sizeOf: aPatcheable [
	"Answer the variable size (either patched or real size). It is intended for objects with variable layout."

	^ self subclassResponsibility
]

{ #category : #writing }
Patch >> write: aPatcheable add: aValue at: anInteger [
	"Insert a value the specified indexed position of a variable patcheable object."

	self subclassResponsibility
]

{ #category : #writing }
Patch >> write: aPatcheable at: anInteger put: aValue [ 
	"Write the value of the specified indexed variable (either create a patch or update an existing patch). It is intended for objects with variable layout."

	self subclassResponsibility
]

{ #category : #writing }
Patch >> write: aPatcheable instVarAt: anInteger put: aValue [ 
	"Write the value of the specified instance variable (either create a patch or update an existing patch)."

	self subclassResponsibility
]

{ #category : #writing }
Patch >> write: aPatcheable removeAt: anInteger [
	"Remove the specified indexed position of a variable patcheable object."

	self subclassResponsibility
]
