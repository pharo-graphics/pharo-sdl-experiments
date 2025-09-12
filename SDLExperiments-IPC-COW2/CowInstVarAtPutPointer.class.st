Class {
	#name : #CowInstVarAtPutPointer,
	#superclass : #CowLinkedPointer,
	#category : #'SDLExperiments-IPC-COW2-Core'
}

{ #category : #execution }
CowInstVarAtPutPointer >> propagateDraftTarget [

	source propagateDraftTargetAtInstanceVariablePointer: self.
	super propagateDraftTarget
]

{ #category : #accessing }
CowInstVarAtPutPointer >> removePointerOfInstanceVariable: anIndex from: sourceCowObject [

	^ (sourceCowObject == source and: [ anIndex == index ])
		ifTrue: [
			"Return next means removing myself. No need to continue forwarding."
			next ]
		ifFalse: [
			"Forward to next pointer, may update next, and return self"
			super removePointerOfInstanceVariable: anIndex from: sourceCowObject ]
]
