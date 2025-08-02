Class {
	#name : #AppServerCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'server',
		'process'
	],
	#category : #'SDL-Experiments-App'
}

{ #category : #accessing }
AppServerCommandLineHandler class >> commandName [

	^ 'appServer'
]

{ #category : #activation }
AppServerCommandLineHandler >> activate [

	| client |
	World color: Color red.

	client := AppClient atName: (self argumentAt: 1).
	client address: #[0 0 0 0].
	client port: (self argumentAt: 2) asInteger.
	client open
]
