Class {
	#name : #PaSoilTypeCodes,
	#superclass : #SharedPool,
	#classVars : [
		'NumberOfEmbeddedIndexInstVarAtPutPatchTypeCode',
		'PaTypeCodeMapping',
		'TypeCodeAtPutPatch',
		'TypeCodeFloatOne',
		'TypeCodeFloatZero',
		'TypeCodeInstVarAtPutPatch',
		'TypeCodeNullPatch',
		'TypeCodePatches',
		'TypeCodeRoot',
		'WellKnownObjects'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #'class initialization' }
PaSoilTypeCodes class >> initialize [

	self initializeTypeCodes.
	self initializeTypeCodeMapping.
	self initializeWellKnownObjects
]

{ #category : #initialization }
PaSoilTypeCodes class >> initializeTypeCodeMapping [
	"Extend Soil v3 typecodes, to optimize space and speed performance."

	PaTypeCodeMapping := self originalTypeCodes copy.

	"Common float values"
	self
		mapAt: TypeCodeFloatZero put: [ :_ | 0.0 ];
		mapAt: TypeCodeFloatOne  put: [ :_ | 1.0 ].

	"Singleton instance (anyway we may avoid all references in the graph to this instance)"
	self mapAt: TypeCodeNullPatch put: [ :_ | PaNullPatch instance ].



	"We do not register the patches because we assume it is not referenced by other
	object in the graph"
	self mapAt: TypeCodeAtPutPatch put: [ :materializer | materializer nextPaAtPutPatch ].

	"Map the PaInstVarAtPutPatch generically for all indices"
	self mapAt: TypeCodeInstVarAtPutPatch put: [ :materializer |
		materializer nextPaInstVarAtPutPatchAt: materializer nextByte ].

	"Map PaInstVarAtPutPatch for small indices (reduces 1 byte)"
	1 to: NumberOfEmbeddedIndexInstVarAtPutPatchTypeCode do: [ :index |
		self mapAt: TypeCodeInstVarAtPutPatch + index put: [ :materializer |
			materializer nextPaInstVarAtPutPatchAt: index ] ]
]

{ #category : #initialization }
PaSoilTypeCodes class >> initializeTypeCodes [
	
	TypeCodeFloatZero := 11.
	TypeCodeFloatOne := 12.

	TypeCodeRoot := 68.
	TypeCodePatches := 69.
		
	TypeCodeNullPatch := 70.
	TypeCodeAtPutPatch := 71.
	TypeCodeInstVarAtPutPatch := 72.
	NumberOfEmbeddedIndexInstVarAtPutPatchTypeCode := 7
]

{ #category : #'class initialization' }
PaSoilTypeCodes class >> initializeWellKnownObjects [

	WellKnownObjects := { PaArray empty }
]

{ #category : #initialization }
PaSoilTypeCodes class >> mapAt: anIndex put: aValuable [

	"Check we are not breaking Soil v3. We are hacking a crucial point."
	self assert: [ (PaTypeCodeMapping at: anIndex) isNil ].

	PaTypeCodeMapping at: anIndex put: aValuable
]

{ #category : #initialization }
PaSoilTypeCodes class >> originalTypeCodes [

	^ (SoilTypeCodes localBindingOf: #TypeCodeMapping) value
]
