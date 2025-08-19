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

	^ self subclassResponsibility
]

{ #category : #testing }
Patch >> isNullPatch [

	^ false
]

{ #category : #accessing }
Patch >> last [

	^ self subclassResponsibility
]

{ #category : #reading }
Patch >> read: aPatcheable at: anInteger [

	^ self subclassResponsibility
]

{ #category : #reading }
Patch >> read: aPatcheable instVarAt: anInteger [

	^ self subclassResponsibility
]

{ #category : #writing }
Patch >> write: aPatcheable at: anInteger put: aValue [ 

	self subclassResponsibility
]

{ #category : #writing }
Patch >> write: aPatcheable instVarAt: anInteger put: aValue [ 

	self subclassResponsibility
]
