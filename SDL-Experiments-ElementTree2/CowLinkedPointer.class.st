Class {
	#name : #CowLinkedPointer,
	#superclass : #CowPointer,
	#instVars : [
		'source',
		'target',
		'index',
		'next',
		'nextDraft'
	],
	#category : #'SDL-Experiments-ElementTree2-Core'
}

{ #category : #adding }
CowLinkedPointer >> addPointerOfIndexedVariable: anIndex from: sourceCowObject to: targetCowObject [

	next :=
		next
			addPointerOfIndexedVariable: anIndex
			from: sourceCowObject
			to: targetCowObject
]

{ #category : #adding }
CowLinkedPointer >> addPointerOfInstanceVariable: anIndex from: sourceCowObject to: targetCowObject [

	next :=
		next
			addPointerOfInstanceVariable: anIndex
			from: sourceCowObject
			to: targetCowObject
]

{ #category : #copying }
CowLinkedPointer >> copyWithSource: aCowObject [

	| copiedNext copiedNextDraft |
	copiedNext := next copyWithSource: aCowObject.
	copiedNextDraft :=
		nextDraft == next
			ifTrue: [ copiedNext ]
			ifFalse: [ 1halt. "test it!". copiedNext nextDraft ].

	^ self species new
		index: index;
		source: aCowObject;
		target: target;
		next: copiedNext;
		nextDraft: copiedNextDraft;
		yourself
]

{ #category : #accessing }
CowLinkedPointer >> index [

	^ index
]

{ #category : #accessing }
CowLinkedPointer >> index: anObject [

	index := anObject
]

{ #category : #accessing }
CowLinkedPointer >> indexIn: aCowArray [

	^ next indexIn: aCowArray
]

{ #category : #testing }
CowLinkedPointer >> isNull [

	^ false
]

{ #category : #accessing }
CowLinkedPointer >> next [

	^ next
]

{ #category : #accessing }
CowLinkedPointer >> next: anObject [

	next := anObject
]

{ #category : #accessing }
CowLinkedPointer >> nextDraft [

	^ nextDraft
]

{ #category : #accessing }
CowLinkedPointer >> nextDraft: anObject [

	nextDraft := anObject
]

{ #category : #accessing }
CowLinkedPointer >> popNextDraft [

	| tmp |
	tmp := nextDraft.
	nextDraft := CowNullPointer instance.
	^ tmp
]

{ #category : #execution }
CowLinkedPointer >> propagateDraftTarget [

	next propagateDraftTarget
]

{ #category : #removing }
CowLinkedPointer >> removePointerOfIndexedVariable: anIndex from: sourceCowObject [

	next := next removePointerOfIndexedVariable: anIndex from: sourceCowObject.
	^ self
]

{ #category : #removing }
CowLinkedPointer >> removePointerOfInstanceVariable: anIndex from: sourceCowObject [

	next := next removePointerOfInstanceVariable: anIndex from: sourceCowObject.
	^ self
]

{ #category : #accessing }
CowLinkedPointer >> source [

	^ source
]

{ #category : #accessing }
CowLinkedPointer >> source: anObject [

	source := anObject
]

{ #category : #accessing }
CowLinkedPointer >> target [

	^ target
]

{ #category : #accessing }
CowLinkedPointer >> target: anObject [

	target := anObject
]
