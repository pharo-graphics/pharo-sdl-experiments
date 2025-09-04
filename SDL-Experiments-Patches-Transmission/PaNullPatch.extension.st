Extension { #name : #PaNullPatch }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
PaNullPatch >> soilSerialize: serializer [
	"Encode this patch in a very compact way, to minimize space used and maximize speed performance."

	serializer nextPutNullPatch
]
