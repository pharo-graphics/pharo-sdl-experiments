Class {
	#name : #ResizingPatch,
	#superclass : #IndexedPatch,
	#category : #'SDL-Experiments-Patches-Core'
}

{ #category : #applying }
ResizingPatch >> applyPatchTo: aPatcheable [
	"Resizing patches only apply on copy"

	self shouldNotImplement
]
