Extension { #name : #Object }

{ #category : #'*SDL-Experiments-ElementTree2' }
Object >> activeState [

	^ self
]

{ #category : #'*SDL-Experiments-ElementTree2' }
Object >> addPointerOfIndexedVariable: anInteger from: sourceCowObject [
	"Ignore"
]

{ #category : #'*SDL-Experiments-ElementTree2' }
Object >> addPointerOfInstanceVariable: anInteger from: sourceCowObject [
	"Ignore"
]

{ #category : #'*SDL-Experiments-ElementTree2' }
Object >> indexInCowArray: aCowArray [

	aCowArray withIndexDo: [ :each :index |
		each = self ifTrue: [ ^ index ] ].
	^ 0
]

{ #category : #'*SDL-Experiments-ElementTree2' }
Object >> removePointerOfIndexedVariable: anIndex from: aCowObject [
	"ignore"
]

{ #category : #'*SDL-Experiments-ElementTree2' }
Object >> removePointerOfInstanceVariable: anIndex from: aCowObject [
	"ignore"
]
