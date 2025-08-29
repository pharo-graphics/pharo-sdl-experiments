Class {
	#name : #CowNullPointer,
	#superclass : #CowPointer,
	#classInstVars : [
		'instance'
	],
	#category : #'SDL-Experiments-ElementTree2-Core'
}

{ #category : #accessing }
CowNullPointer class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : #adding }
CowNullPointer >> addPointerOfIndexedVariable: anIndex from: sourceCowObject to: targetCowObject [

	^ CowAtPutPointer new
		index: anIndex;
		source: sourceCowObject;
		target: targetCowObject;
		next: self;
		nextDraft: self;
		yourself
]

{ #category : #adding }
CowNullPointer >> addPointerOfInstanceVariable: anIndex from: sourceCowObject to: targetCowObject [

	^ CowInstVarAtPutPointer new
		index: anIndex;
		source: sourceCowObject;
		target: targetCowObject;
		next: self;
		nextDraft: self;
		yourself
]

{ #category : #copying }
CowNullPointer >> copyWithSource: aCowArray [ 
	"Don't copy as I'm singleton"

	^ self
]

{ #category : #accessing }
CowNullPointer >> indexIn: aCowArray [
	"Not found"

	^ 0
]

{ #category : #testing }
CowNullPointer >> isNull [

	^ true
]

{ #category : #execution }
CowNullPointer >> propagateDraftTarget [
]

{ #category : #accessing }
CowNullPointer >> removePointerOfIndexedVariable: anIndex from: sourceCowObject [
]

{ #category : #accessing }
CowNullPointer >> removePointerOfInstanceVariable: anInteger from: aCowObject [
]
