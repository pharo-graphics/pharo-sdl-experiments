Class {
	#name : #IPCDemoMouseMotion,
	#superclass : #IPCDemoWindowCommand,
	#instVars : [
		'position'
	],
	#category : #'SDL-Experiments-App-Demo'
}

{ #category : #accessing }
IPCDemoMouseMotion >> position [

	^ position
]

{ #category : #accessing }
IPCDemoMouseMotion >> position: anObject [

	position := anObject
]

{ #category : #accessing }
IPCDemoMouseMotion >> value: aCommandService [
	"Execute and answer an object that will be sent as a result to the execution."

	aCommandService
		sendCommand: (IPCDemoUpdatePosition new
				 windowId: windowId;
				 centerPosition: position;
				 yourself)
		onSuccess: [ :id | "to ignore" ].

	^ nil
]
