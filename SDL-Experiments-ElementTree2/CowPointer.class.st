Class {
	#name : #CowPointer,
	#superclass : #Object,
	#category : #'SDL-Experiments-ElementTree2-Core'
}

{ #category : #adding }
CowPointer >> addPointerOfIndexedVariable: anIndex from: sourceCowObject to: targetCowObject [

	^ self subclassResponsibility
]

{ #category : #adding }
CowPointer >> addPointerOfInstanceVariable: anIndex from: sourceCowObject to: targetCowObject [

	^ self subclassResponsibility
]

{ #category : #copying }
CowPointer >> copyWithSource: aCowObject [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
CowPointer >> indexIn: aCowArray [
	"Answer my index in a collection"

	^ self subclassResponsibility
]

{ #category : #testing }
CowPointer >> isNull [
	^ self subclassResponsibility
]

{ #category : #accessing }
CowPointer >> next [

	^ CowNullPointer instance
]

{ #category : #execution }
CowPointer >> propagateDraftTarget [
	^ self subclassResponsibility
]

{ #category : #removing }
CowPointer >> removePointerOfIndexedVariable: anIndex from: sourceCowObject [

	^ self subclassResponsibility
]

{ #category : #removing }
CowPointer >> removePointerOfInstanceVariable: anInteger from: aCowObject [

	^ self subclassResponsibility
]
