Extension { #name : #PaAtPutPatch }

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
PaAtPutPatch >> soilSerialize: serializer [

	serializer nextPutPaAtPutPatch: self
]
