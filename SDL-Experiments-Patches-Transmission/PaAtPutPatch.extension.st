Extension { #name : #PaAtPutPatch }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
PaAtPutPatch >> soilSerialize: serializer [

	serializer nextPutPaAtPutPatch: self
]
