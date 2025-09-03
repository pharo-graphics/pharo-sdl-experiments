Extension { #name : #FixedLayout }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
FixedLayout >> patcheableSoilBasicMaterialize: description with: materializer [
	"When materializing, we update the base patcheable (avoid patches)."

	| patcheable |
	patcheable := description basicNew.
	materializer registerObject: patcheable.

	description patcheableSlotIndices do: [ :index | 
		patcheable basicInstVarAt: index put: (materializer nextSoilObject) ].

	^ patcheable
]

{ #category : #'*SDL-Experiments-Patches-Transmission' }
FixedLayout >> patcheableSoilBasicSerialize: patcheable with: serializer [
	"Encode the patcheable. Prepare it by applying any available patch."

	| description |
	patcheable applyPatches.

	description := serializer serializeBehaviorDescriptionFor: patcheable.

	description patcheableSlotIndices do: [:index |
		(patcheable instVarAt: index) soilSerialize: serializer ].

	serializer notifyFullySerialized: patcheable
]
