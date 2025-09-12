Extension { #name : #VariableLayout }

{ #category : #'*SDLExperiments-IPC-COW2' }
VariableLayout >> cowStateSizeFor: aCowObject [

	^ (super cowStateSizeFor: aCowObject) + aCowObject size
]
