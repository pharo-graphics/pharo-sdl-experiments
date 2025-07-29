Class {
	#name : #Patch,
	#superclass : #Object,
	#instVars : [
		'nextPatch'
	],
	#classInstVars : [
		'pool'
	],
	#category : #'SDL-Experiments-Patches'
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

	^ nextPatch
		ifNil: [ 1 ]
		ifNotNil: [ :p | 1 + p count ]
]

{ #category : #printing }
Patch >> descriptionFor: aPatcheable [

	^ self subclassResponsibility
]

{ #category : #accessing }
Patch >> last [

	^ nextPatch
		ifNil: [ self ]
		ifNotNil: [ :p | p last ]
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

	^  self subclassResponsibility
]

{ #category : #reading }
Patch >> read: aPatcheable instVarAt: anInteger [

	^  self subclassResponsibility
]

{ #category : #writing }
Patch >> write: aPatcheable at: anInteger put: aValue [

	self subclassResponsibility
]

{ #category : #writing }
Patch >> write: aPatcheable instVarAt: anInteger put: aValue [

	self subclassResponsibility
]
