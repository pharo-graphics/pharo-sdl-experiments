Extension { #name : #FixedLayout }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
FixedLayout >> patcheableSoilBasicMaterialize: description with: materializer [

	| patcheable |
	patcheable := description basicNew.
	materializer registerObject: patcheable.

	self flag: #review. "When materializing, we update the base patcheable (avoid patches)."

	description patcheableSlotIndices do: [ :index | 
		patcheable basicInstVarAt: index put: (materializer nextSoilObject) ].

	^ patcheable
]

{ #category : #'*SDL-Experiments-Patches-Transmission' }
FixedLayout >> patcheableSoilBasicSerialize: patcheable with: serializer [

	| description |
	description := serializer serializeBehaviorDescriptionFor: patcheable.

	self flag: #review. "When serializing, the patches are taken into account"

	description patcheableSlotIndices do: [:index |
		(patcheable instVarAt: index) soilSerialize: serializer ].

	serializer patcheableWasFullySerialized: patcheable
]
