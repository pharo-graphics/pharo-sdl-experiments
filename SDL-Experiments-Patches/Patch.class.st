Class {
	#name : #Patch,
	#superclass : #Object,
	#instVars : [
		'nextPatch'
	],
	#classInstVars : [
		'pool'
	],
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #accessing }
Patch class >> forgetPool [

	pool := nil
]

{ #category : #accessing }
Patch class >> pool [

	^ pool ifNil: [ pool := PatchPool new patchClass: self; yourself ]
]

{ #category : #applying }
Patch >> applyPatchTo: aPatcheable [

	self subclassResponsibility
]

{ #category : #accessing }
Patch >> count [

	^ 1 + nextPatch count
]

{ #category : #printing }
Patch >> descriptionFor: aPatcheable [

	^ self subclassResponsibility
]

{ #category : #testing }
Patch >> hasNextPatch [

	^ nextPatch isNullPatch not
]

{ #category : #testing }
Patch >> isNullPatch [

	^ false
]

{ #category : #accessing }
Patch >> last [

	self hasNextPatch ifTrue: [ ^ nextPatch last ]
]

{ #category : #accessing }
Patch >> nextPatch [

	^ nextPatch
]

{ #category : #accessing }
Patch >> nextPatch: aPatchOrNil [

	nextPatch := aPatchOrNil
]

{ #category : #printing }
Patch >> printDetailsOn: aStream [

	aStream
		print: self identityHash;
		space;
		nextPutAll: 'count: ';
		print: self count
]

{ #category : #printing }
Patch >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : #reading }
Patch >> read: aPatcheable at: anInteger [

	^ nextPatch read: aPatcheable at: anInteger
]

{ #category : #reading }
Patch >> read: aPatcheable instVarAt: anInteger [

	^ nextPatch read: aPatcheable instVarAt: anInteger
]

{ #category : #reading }
Patch >> readPredecessor: aPatcheable [

	^ nextPatch readPredecessor: aPatcheable
]

{ #category : #writing }
Patch >> write: aPatcheable at: anInteger put: aValue [

	nextPatch write: aPatcheable at: anInteger put: aValue
]

{ #category : #writing }
Patch >> write: aPatcheable instVarAt: anInteger put: aValue [

	nextPatch write: aPatcheable instVarAt: anInteger put: aValue
]

{ #category : #writing }
Patch >> writePredecessor: aPatcheable put: aValue [

	nextPatch writePredecessor: aPatcheable put: aValue
]
