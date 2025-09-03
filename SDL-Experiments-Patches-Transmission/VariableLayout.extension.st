Extension { #name : #VariableLayout }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
VariableLayout >> patcheableSoilBasicMaterialize: description with: materializer [
	"When materializing, we update the base patcheable (avoid patches)."

	| patcheable basicSize |
	basicSize := materializer nextLengthEncodedInteger.
	patcheable := description basicNew: basicSize.
	materializer registerObject: patcheable.

	description patcheableSlotIndices do: [ :index | 
		patcheable basicInstVarAt: index put: (materializer nextSoilObject) ].

	1 to: basicSize do: [ :index |
		patcheable basicAt: index put: materializer nextSoilObject ].

	^ patcheable
]

{ #category : #'*SDL-Experiments-Patches-Transmission' }
VariableLayout >> patcheableSoilBasicSerialize: patcheable with: serializer [
	"Encode the patcheable. Prepare it by applying any available patch."

	| description basicSize |
	patcheable applyPatches.

	description := serializer serializeBehaviorDescriptionFor: patcheable.
	basicSize := patcheable basicSize.
	serializer nextPutLengthEncodedInteger: basicSize.

	description patcheableSlotIndices do: [ :index |
		(patcheable instVarAt: index) soilSerialize: serializer ].

	1 to: basicSize do: [ :index |
		(patcheable at: index) soilSerialize: serializer ].

	serializer notifyFullySerialized: patcheable
]
