Class {
	#name : #ResizingPatch,
	#superclass : #IndexedPatch,
	#category : #'SDL-Experiments-Patches'
}

{ #category : #applying }
ResizingPatch >> applyPatchTo: aPatcheable [
	"Resizing patches only apply on copy"

	self shouldNotImplement
]
