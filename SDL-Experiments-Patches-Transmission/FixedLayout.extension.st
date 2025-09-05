Extension { #name : #FixedLayout }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
FixedLayout >> patcheableSoilBasicMaterialize: description with: materializer [

	^ materializer nextFixedLayoutPatcheable: description
]

{ #category : #'*SDL-Experiments-Patches-Transmission' }
FixedLayout >> patcheableSoilBasicSerialize: patcheable with: serializer [

	serializer nextPutFixedLayoutPatcheable: patcheable
]
