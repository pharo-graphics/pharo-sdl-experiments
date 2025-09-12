Extension { #name : #PaNullPatch }

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
PaNullPatch >> soilSerialize: serializer [
	"Encode this patch in a very compact way, to minimize space used and maximize speed performance."

	serializer nextPutNullPatch
]
