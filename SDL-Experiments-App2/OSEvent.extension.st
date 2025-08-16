Extension { #name : #OSEvent }

{ #category : #'*SDL-Experiments-App2' }
OSEvent >> asAnnouncement [

	^ self
]

{ #category : #'*SDL-Experiments-App2' }
OSEvent class >> handlesAnnouncement: anObject [

	^ anObject isKindOf: self
]

{ #category : #'*SDL-Experiments-App2' }
OSEvent >> prepareForDelivery [

]
