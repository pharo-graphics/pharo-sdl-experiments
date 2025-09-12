Extension { #name : #PaInstVarAtPutPatch }

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
PaInstVarAtPutPatch >> soilSerialize: serializer [

	serializer nextPutPaInstVarAtPutPatch: self
]
