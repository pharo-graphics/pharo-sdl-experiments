"
I'm a patch that links to a next patch.
"
Class {
	#name : #PaLinkPatch,
	#superclass : #PaPatch,
	#instVars : [
		'nextPatch'
	],
	#category : #'SDLExperiments-IPC-Patches-Core'
}

{ #category : #applying }
PaLinkPatch >> applyPatchTo: aPatcheable [

	self subclassResponsibility
]

{ #category : #accessing }
PaLinkPatch >> count [

	^ 1 + nextPatch count
]

{ #category : #printing }
PaLinkPatch >> descriptionFor: aPatcheable [

	^ self subclassResponsibility
]

{ #category : #testing }
PaLinkPatch >> hasNextPatch [

	^ nextPatch isNullPatch not
]

{ #category : #accessing }
PaLinkPatch >> nextPatch [

	^ nextPatch
]

{ #category : #accessing }
PaLinkPatch >> nextPatch: aPatch [

	nextPatch := aPatch
]

{ #category : #printing }
PaLinkPatch >> printDetailsOn: aStream [

	aStream
		print: self identityHash;
		space;
		nextPutAll: 'count: ';
		print: self count
]

{ #category : #printing }
PaLinkPatch >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : #reading }
PaLinkPatch >> read: aPatcheable at: anInteger [

	^ nextPatch read: aPatcheable at: anInteger
]

{ #category : #reading }
PaLinkPatch >> read: aPatcheable instVarAt: anInteger [

	^ nextPatch read: aPatcheable instVarAt: anInteger
]

{ #category : #writing }
PaLinkPatch >> write: aPatcheable at: anInteger put: aValue [

	nextPatch write: aPatcheable at: anInteger put: aValue
]

{ #category : #writing }
PaLinkPatch >> write: aPatcheable instVarAt: anInteger put: aValue [

	nextPatch write: aPatcheable instVarAt: anInteger put: aValue
]
