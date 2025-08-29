Class {
	#name : #CowAtPutPointer,
	#superclass : #CowLinkedPointer,
	#category : #'SDL-Experiments-ElementTree2-Core'
}

{ #category : #accessing }
CowAtPutPointer >> indexIn: aCowArray [

	^ source == aCowArray
		ifTrue: [ index ]
		ifFalse: [ super indexIn: aCowArray ]
]

{ #category : #execution }
CowAtPutPointer >> propagateDraftTarget [

	source propagateDraftTargetAtIndexedVariablePointer: self.
	super propagateDraftTarget
]

{ #category : #removing }
CowAtPutPointer >> removePointerOfIndexedVariable: anIndex from: sourceCowObject [

	^ (sourceCowObject == source and: [ anIndex == index ])
		ifTrue: [
			"Return next means removing myself. No need to continue forwarding."
			next ]
		ifFalse: [
			"Forward to next pointer, may update next, and return self"
			super removePointerOfIndexedVariable: anIndex from: sourceCowObject ]
]
