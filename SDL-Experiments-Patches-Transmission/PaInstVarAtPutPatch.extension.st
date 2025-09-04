Extension { #name : #PaInstVarAtPutPatch }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
PaInstVarAtPutPatch >> soilSerialize: serializer [

	serializer nextPutPaInstVarAtPutPatch: self
]
