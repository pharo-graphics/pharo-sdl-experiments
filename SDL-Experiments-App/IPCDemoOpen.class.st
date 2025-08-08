Class {
	#name : #IPCDemoOpen,
	#superclass : #IPCCommand,
	#category : #'SDL-Experiments-App-Demo'
}

{ #category : #accessing }
IPCDemoOpen >> value: aCommandService [

	| aDemo |
	aDemo := IPCDemoWindow new.
	aDemo sendKeystrokesTo: aCommandService.

	IPCWindowServer current openWindow: aDemo.

	^ aDemo windowId
]
