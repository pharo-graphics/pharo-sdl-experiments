Extension { #name : #Object }

{ #category : #'*SDL-Experiments-Patches' }
Object >> attachPredecessor: aPatcheable [
]

{ #category : #'*SDL-Experiments-Patches' }
Object >> detachPredecessor: aPatcheable [
]

{ #category : #'*SDL-Experiments-Patches' }
Object >> isPatcheable [

	^ false
]

{ #category : #'*SDL-Experiments-Patches' }
Object >> withAllPatcheablesDo: aBlock [
	"Evaluate the block depth-first. Do nothing for objects in general."
]
