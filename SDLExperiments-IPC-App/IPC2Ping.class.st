Class {
	#name : #IPC2Ping,
	#superclass : #IPC2Command,
	#instVars : [
		'initialMicroseconds'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
IPC2Ping >> initialMicroseconds [

	^ initialMicroseconds
]

{ #category : #initialization }
IPC2Ping >> initialize [

	super initialize.
	initialMicroseconds := Time microsecondClockValue
]

{ #category : #accessing }
IPC2Ping >> value: _ [

	^ Array
		with: initialMicroseconds
		with: Time microsecondClockValue
]
