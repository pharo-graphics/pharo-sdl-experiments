Class {
	#name : #CowState,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'complete'
	],
	#category : #'SDL-Experiments-ElementTree2-Core'
}

{ #category : #asserting }
CowState >> assertDraft [

	complete ifNotNil: [ CowUnexpectedCompleteStateError signal ]
]

{ #category : #accessing }
CowState >> at: index put: value [

	self assertDraft.
	^ super at: index put: value
]

{ #category : #accessing }
CowState >> complete [
	"From now on, my mutator API signal `CannotWriteShot`.
	IMPORTANT: this is NOT recursive, so a child can be still draft."

	complete := true
]

{ #category : #testing }
CowState >> isDraft [

	^ complete isNil
]

{ #category : #copying }
CowState >> postCopy [
	"Copies are draft"

	complete := nil
]

{ #category : #printing }
CowState >> printOn: aStream [

	super printOn: aStream.

	aStream
		nextPutAll: '(';
		print: self identityHash.

	self isDraft ifTrue: [
		aStream nextPutAll: ' draft' ].

	aStream nextPutAll: ')'
]
