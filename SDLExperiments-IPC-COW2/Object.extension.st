Extension { #name : #Object }

{ #category : #'*SDLExperiments-IPC-COW2' }
Object >> activeState [

	^ self
]

{ #category : #'*SDLExperiments-IPC-COW2' }
Object >> addPointerOfIndexedVariable: anInteger from: sourceCowObject [
	"Ignore"
]

{ #category : #'*SDLExperiments-IPC-COW2' }
Object >> addPointerOfInstanceVariable: anInteger from: sourceCowObject [
	"Ignore"
]

{ #category : #'*SDLExperiments-IPC-COW2' }
Object >> indexInCowArray: aCowArray [

	aCowArray withIndexDo: [ :each :index |
		each = self ifTrue: [ ^ index ] ].
	^ 0
]

{ #category : #'*SDLExperiments-IPC-COW2' }
Object >> removePointerOfIndexedVariable: anIndex from: aCowObject [
	"ignore"
]

{ #category : #'*SDLExperiments-IPC-COW2' }
Object >> removePointerOfInstanceVariable: anIndex from: aCowObject [
	"ignore"
]
