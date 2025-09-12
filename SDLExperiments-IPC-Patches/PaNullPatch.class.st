"
I implement the NULL object pattern for patches.
"
Class {
	#name : #PaNullPatch,
	#superclass : #PaPatch,
	#classInstVars : [
		'instance'
	],
	#category : #'SDLExperiments-IPC-Patches-Core'
}

{ #category : #accessing }
PaNullPatch class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : #accessing }
PaNullPatch >> count [

	^ 0
]

{ #category : #testing }
PaNullPatch >> isNullPatch [

	^ true
]

{ #category : #reading }
PaNullPatch >> read: aPatcheable at: anInteger [ 
	
	^ aPatcheable basicAt: anInteger
]

{ #category : #reading }
PaNullPatch >> read: aPatcheable instVarAt: anInteger [ 
	
	^ aPatcheable basicInstVarAt: anInteger
]

{ #category : #writing }
PaNullPatch >> write: aPatcheable at: anInteger put: aValue [ 

	aPatcheable addPatchForAt: anInteger put: aValue
]

{ #category : #writing }
PaNullPatch >> write: aPatcheable instVarAt: anInteger put: aValue [ 

	aPatcheable addPatchForInstVarAt: anInteger put: aValue
]
