Class {
	#name : #PingApp,
	#superclass : #App,
	#category : #'SDL-Experiments-App'
}

{ #category : #'engine-side API' }
PingApp >> ping [

	self send: #ping with: Time microsecondClockValue
]

{ #category : #'app-side API' }
PingApp >> ping: aClockValue [

	^ Time microsecondClockValue - aClockValue
]
