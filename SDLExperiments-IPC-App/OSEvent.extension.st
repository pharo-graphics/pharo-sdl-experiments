Extension { #name : #OSEvent }

{ #category : #'*SDLExperiments-IPC-App' }
OSEvent >> asAnnouncement [

	^ self
]

{ #category : #'*SDLExperiments-IPC-App' }
OSEvent class >> handlesAnnouncement: anObject [

	^ anObject isKindOf: self
]

{ #category : #'*SDLExperiments-IPC-App' }
OSEvent >> prepareForDelivery [

]
