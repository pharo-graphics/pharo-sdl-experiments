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

{ #category : #accessing }
NullPatch >> last [

	^ self errorSubscriptBounds: 0
]

{ #category : #reading }
NullPatch >> read: aPatcheable at: anInteger [ 
	
	^ aPatcheable basicAt: anInteger
]

{ #category : #reading }
NullPatch >> read: aPatcheable instVarAt: anInteger [ 
	
	^ aPatcheable instVarAt: anInteger
]

{ #category : #writing }
NullPatch >> write: aPatcheable at: anInteger put: aValue [ 

	aPatcheable addPatchForAt: anInteger put: aValue
]

{ #category : #writing }
NullPatch >> write: aPatcheable instVarAt: anInteger put: aValue [ 

	aPatcheable addPatchForInstVarAt: anInteger put: aValue
]
