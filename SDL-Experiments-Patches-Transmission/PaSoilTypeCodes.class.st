Class {
	#name : #PaSoilTypeCodes,
	#superclass : #SharedPool,
	#classVars : [
		'PaTypeCodeMapping',
		'TypeCodeAtPutPatch',
		'TypeCodeFloatOne',
		'TypeCodeFloatZero',
		'TypeCodeInstVarAtPutPatch',
		'TypeCodeNullPatch'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #'class initialization' }
PaSoilTypeCodes class >> initialize [

	self initializeTypeCodes.
	self initializeTypeCodeMapping
]

{ #category : #initialization }
PaSoilTypeCodes class >> initializeTypeCodeMapping [
	<script>

	PaTypeCodeMapping := self originalTypeCodes copy.

	"Optimization for common float values"
	self
		mapAt: TypeCodeFloatZero put: [ :_ | 0.0 ];
		mapAt: TypeCodeFloatOne  put: [ :_ | 1.0 ].

	"Singleton instance (anyway we may avoid all references in the graph to this instance)"
	self mapAt: TypeCodeNullPatch put: [ :_ | PaNullPatch instance ].

	"We do not register the patch because we assume it is not referenced by other
	object in the graph and this way we improve performance."
	self
		mapAt: TypeCodeAtPutPatch put: [ :materializer |
			PaAtPutPatch
				index: materializer nextByte
				value: materializer nextSoilObject
				nextPatch: materializer nextSoilObject ];
		mapAt: TypeCodeInstVarAtPutPatch put: [ :materializer |
			PaInstVarAtPutPatch
				index: materializer nextByte
				value: materializer nextSoilObject
				nextPatch: materializer nextSoilObject ]
]

{ #category : #initialization }
PaSoilTypeCodes class >> initializeTypeCodes [
	<script>
	
	TypeCodeFloatZero := 11.
	TypeCodeFloatOne := 12.
	
	TypeCodeNullPatch := 70.
	TypeCodeInstVarAtPutPatch := 71.
	TypeCodeAtPutPatch := 72
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
