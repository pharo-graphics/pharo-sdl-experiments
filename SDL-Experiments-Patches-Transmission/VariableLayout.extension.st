Extension { #name : #VariableLayout }

{ #category : #'*SDL-Experiments-Patches-Transmission' }
VariableLayout >> patcheableSoilBasicMaterialize: description with: materializer [

	| patcheable basicSize |
	basicSize := materializer nextLengthEncodedInteger.
	patcheable := description basicNew: basicSize.
	materializer registerObject: patcheable.

	self flag: #review. "When materializing, we update the base patcheable (avoid patches)."

	description patcheableSlotIndices do: [ :index | 
		patcheable basicInstVarAt: index put: (materializer nextSoilObject) ].

	1 to: basicSize do: [ :index |
		patcheable basicAt: index put: materializer nextSoilObject ].

	^ patcheable
]

{ #category : #'*SDL-Experiments-Patches-Transmission' }
VariableLayout >> patcheableSoilBasicSerialize: patcheable with: serializer [

	| description basicSize |
	description := serializer serializeBehaviorDescriptionFor: patcheable.
	basicSize := patcheable basicSize.
	serializer nextPutLengthEncodedInteger: basicSize.

	self flag: #review. "When serializing, the patches are taken into account"

	description patcheableSlotIndices do: [ :index |
		(patcheable basicInstVarAt: index) soilSerialize: serializer ].

	1 to: basicSize do: [ :index |
		(patcheable basicAt: index) soilSerialize: serializer ].

	serializer patcheableWasFullySerialized: patcheable
]
