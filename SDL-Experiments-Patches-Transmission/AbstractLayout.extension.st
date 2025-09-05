Extension { #name : #AbstractLayout }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
AbstractLayout >> patcheableSoilBasicMaterialize: objectClass with: materializer [
	
	^ self subclassResponsibility
]

{ #category : #'*SDL-Experiments-Patches-Transmission' }
AbstractLayout >> patcheableSoilBasicSerialize: anObject with: serializer [
	
	^ self subclassResponsibility
]
