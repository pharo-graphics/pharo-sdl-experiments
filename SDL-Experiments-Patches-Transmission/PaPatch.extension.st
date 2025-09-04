Extension { #name : #PaPatch }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
PaPatch >> soilSerialize: serializer [
	"Encode this patch in a very compact way, to minimize space used and maximize speed performance."

	self subclassResponsibility
]
