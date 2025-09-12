Extension { #name : #Color }

{ #category : #'*SDLExperiments-IPC-Patches-Transmission' }
Color >> soilBasicSerialize: serializer [

	self isOpaque
		ifTrue: [ serializer nextPutOpaqueColor: self ]
		ifFalse: [ serializer nextPutTranslucentColor: self ]
]
