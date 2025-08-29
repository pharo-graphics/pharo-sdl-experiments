Extension { #name : #VariableLayout }

{ #category : #'*SDL-Experiments-ElementTree2' }
VariableLayout >> cowStateSizeFor: aCowObject [

	^ (super cowStateSizeFor: aCowObject) + aCowObject size
]
