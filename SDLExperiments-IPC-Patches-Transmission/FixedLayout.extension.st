Extension { #name : #FixedLayout }

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
FixedLayout >> patcheableSoilBasicMaterialize: description with: materializer [

	^ materializer nextFixedLayoutPatcheable: description
]

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
FixedLayout >> patcheableSoilBasicSerialize: patcheable with: serializer [

	serializer nextPutFixedLayoutPatcheable: patcheable
]
