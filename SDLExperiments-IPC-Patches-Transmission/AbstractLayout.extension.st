Extension { #name : #AbstractLayout }

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
AbstractLayout >> patcheableSoilBasicMaterialize: objectClass with: materializer [
	
	^ self subclassResponsibility
]

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
AbstractLayout >> patcheableSoilBasicSerialize: anObject with: serializer [
	
	^ self subclassResponsibility
]
