Extension { #name : #AbstractLayout }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
AbstractLayout >> patcheableSoilBasicMaterialize: objectClass with: materializer [
	"Allow hooking for patcheables (see sender and overrides)"
	
	^ self subclassResponsibility
]

{ #category : #'*SDL-Experiments-Patches-Transmission' }
AbstractLayout >> patcheableSoilBasicSerialize: anObject with: serializer [
	"Allow hooking for patcheables (see sender and overrides)"
	
	^ self subclassResponsibility
]
