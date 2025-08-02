Class {
	#name : #AppClient,
	#superclass : #Object,
	#category : #'SDL-Experiments-App'
}

{ #category : #accessing }
AppClient class >> atName: aString [

	self allSubclassesDo: [ :each |
		each appName = aString ifTrue: [ ^ each new ] ].

	NotFound signalFor: aString
]
