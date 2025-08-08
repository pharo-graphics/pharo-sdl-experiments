Class {
	#name : #IPCPing,
	#superclass : #IPCCommand,
	#instVars : [
		'initialMicroseconds'
	],
	#category : #'SDL-Experiments-App-Core'
}

{ #category : #accessing }
IPCPing >> initialMicroseconds [

	^ initialMicroseconds
]

{ #category : #initialization }
IPCPing >> initialize [

	super initialize.
	initialMicroseconds := Time microsecondClockValue
]

{ #category : #accessing }
IPCPing >> value: aCommandService [

	^ Array
		with: initialMicroseconds
		with: Time microsecondClockValue
]
