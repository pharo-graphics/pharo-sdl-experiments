Extension { #name : #OSEvent }

{ #category : #'*SDLExperiments-IPC' }
OSEvent >> asAnnouncement [

	^ self
]

{ #category : #'*SDLExperiments-IPC' }
OSEvent class >> handlesAnnouncement: anObject [

	^ anObject isKindOf: self
]

{ #category : #'*SDLExperiments-IPC' }
OSEvent >> prepareForDelivery [

]
