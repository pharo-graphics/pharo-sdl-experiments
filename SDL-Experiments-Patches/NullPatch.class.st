"
I implement the NULL object pattern for patches.
"
Class {
	#name : #NullPatch,
	#superclass : #Patch,
	#classInstVars : [
		'instance'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
NullPatch class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : #accessing }
NullPatch >> count [

	^ 0
]

{ #category : #testing }
NullPatch >> isNullPatch [

	^ true
]

{ #category : #reading }
NullPatch >> read: aPatcheable at: anInteger [ 
	
	^ aPatcheable basicAt: anInteger
]

{ #category : #reading }
NullPatch >> read: aPatcheable instVarAt: anInteger [ 
	
	^ aPatcheable basicInstVarAt: anInteger
]

{ #category : #public }
NullPatch >> sizeOf: aPatcheable [

	^ aPatcheable basicSize
]

{ #category : #writing }
NullPatch >> write: aPatcheable add: aValue at: anInteger [

	aPatcheable linkPatchForAdd: aValue at: anInteger
]

{ #category : #writing }
NullPatch >> write: aPatcheable at: anInteger put: aValue [ 

	aPatcheable linkPatchForAt: anInteger put: aValue
]

{ #category : #writing }
NullPatch >> write: aPatcheable instVarAt: anInteger put: aValue [ 

	aPatcheable linkPatchForInstVarAt: anInteger put: aValue
]

{ #category : #writing }
NullPatch >> write: aPatcheable removeAt: anInteger [

	aPatcheable linkPatchForRemoveAt: anInteger
]
