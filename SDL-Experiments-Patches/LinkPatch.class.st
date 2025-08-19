"
I'm a patch that links to a next patch.
"
Class {
	#name : #LinkPatch,
	#superclass : #Patch,
	#instVars : [
		'nextPatch'
	],
	#classInstVars : [
		'pool'
	],
	#category : #'SDL-Experiments-Patches'
}

{ #category : #accessing }
LinkPatch class >> forgetPool [

	pool := nil
]

{ #category : #accessing }
LinkPatch class >> pool [

	^ pool ifNil: [ pool := PatchPool new patchClass: self; yourself ]
]

{ #category : #applying }
LinkPatch >> applyPatchTo: aPatcheable [

	self subclassResponsibility
]

{ #category : #accessing }
LinkPatch >> count [

	^ 1 + nextPatch count
]

{ #category : #printing }
LinkPatch >> descriptionFor: aPatcheable [

	^ self subclassResponsibility
]

{ #category : #testing }
LinkPatch >> hasNextPatch [

	^ nextPatch isNullPatch not
]

{ #category : #accessing }
LinkPatch >> last [

	self hasNextPatch ifTrue: [ ^ nextPatch last ]
]

{ #category : #accessing }
LinkPatch >> nextPatch [

	^ nextPatch
]

{ #category : #accessing }
LinkPatch >> nextPatch: aPatch [

	nextPatch := aPatch
]

{ #category : #printing }
LinkPatch >> printDetailsOn: aStream [

	aStream
		print: self identityHash;
		space;
		nextPutAll: 'count: ';
		print: self count
]

{ #category : #printing }
LinkPatch >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : #reading }
LinkPatch >> read: aPatcheable at: anInteger [

	^ nextPatch read: aPatcheable at: anInteger
]

{ #category : #reading }
LinkPatch >> read: aPatcheable instVarAt: anInteger [

	^ nextPatch read: aPatcheable instVarAt: anInteger
]

{ #category : #writing }
LinkPatch >> write: aPatcheable at: anInteger put: aValue [

	nextPatch write: aPatcheable at: anInteger put: aValue
]

{ #category : #writing }
LinkPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	nextPatch write: aPatcheable instVarAt: anInteger put: aValue
]
