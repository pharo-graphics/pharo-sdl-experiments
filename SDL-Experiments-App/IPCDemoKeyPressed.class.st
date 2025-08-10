Class {
	#name : #IPCDemoKeyPressed,
	#superclass : #IPCDemoWindowCommand,
	#instVars : [
		'keyName'
	],
	#category : #'SDL-Experiments-App-Demo'
}

{ #category : #accessing }
IPCDemoKeyPressed >> delta [

	| gap |
	gap := 20.

	keyName = 'right' ifTrue: [
		^ gap @ 0 ].

	keyName = 'left' ifTrue: [
		^ gap negated @ 0 ].

	keyName = 'down' ifTrue: [
		^ 0 @ gap ].

	keyName = 'up' ifTrue: [
		^ 0 @ gap negated ].

	self error
]

{ #category : #accessing }
IPCDemoKeyPressed >> keyName [

	^ keyName
]

{ #category : #accessing }
IPCDemoKeyPressed >> keyName: anObject [

	keyName := anObject
]

{ #category : #accessing }
IPCDemoKeyPressed >> value: aCommandService [

	aCommandService
		sendCommand: (IPCDemoUpdatePosition new
				 windowId: windowId;
				 delta: self delta;
				 yourself)
		onSuccess: [ :id | "to ignore" ].

	^ nil
]
