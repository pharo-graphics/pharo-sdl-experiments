Extension { #name : #VariableLayout }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
VariableLayout >> patcheableSoilBasicMaterialize: description with: materializer [

	^ materializer nextVariableLayoutPatcheable: description
]

{ #category : #'*SDL-Experiments-Patches-Transmission' }
VariableLayout >> patcheableSoilBasicSerialize: patcheable with: serializer [

	serializer nextPutVariableLayoutPatcheable: patcheable
]
