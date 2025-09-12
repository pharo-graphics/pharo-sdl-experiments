Extension { #name : #VariableLayout }

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
VariableLayout >> patcheableSoilBasicMaterialize: description with: materializer [

	^ materializer nextVariableLayoutPatcheable: description
]

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
VariableLayout >> patcheableSoilBasicSerialize: patcheable with: serializer [

	serializer nextPutVariableLayoutPatcheable: patcheable
]
