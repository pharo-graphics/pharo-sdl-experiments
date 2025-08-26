"
I'm a patch that links to a next patch.
"
Class {
	#name : #LinkPatch,
	#superclass : #Patch,
	#instVars : [
		'nextPatch'
	],
	#category : #'SDL-Experiments-Patches'
}

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

{ #category : #public }
LinkPatch >> sizeOf: aPatcheable [

	^ nextPatch sizeOf: aPatcheable
]

{ #category : #writing }
LinkPatch >> write: aPatcheable add: aValue at: anInteger [

	nextPatch write: aPatcheable add: aValue at: anInteger
]

{ #category : #writing }
LinkPatch >> write: aPatcheable at: anInteger put: aValue [

	nextPatch write: aPatcheable at: anInteger put: aValue
]

{ #category : #writing }
LinkPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	nextPatch write: aPatcheable instVarAt: anInteger put: aValue
]

{ #category : #writing }
LinkPatch >> write: aPatcheable removeAt: anInteger [

	nextPatch write: aPatcheable removeAt: anInteger
]
