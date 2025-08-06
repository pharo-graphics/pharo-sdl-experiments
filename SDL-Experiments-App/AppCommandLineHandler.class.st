Class {
	#name : #AppCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'server',
		'process'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #accessing }
AppCommandLineHandler class >> commandName [

	^ 'launchApp'
]

{ #category : #activation }
AppCommandLineHandler >> activate [

	| newApp |
	World color: Color red.

	newApp := (App named: (self argumentAt: 1)) new.
	newApp serverAddress: #[0 0 0 0].
	newApp enginePort: (self argumentAt: 2) asInteger.
	newApp connect
]
