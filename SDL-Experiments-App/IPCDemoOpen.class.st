Class {
	#name : #IPCDemoOpen,
	#superclass : #IPCDemoWindowCommand,
	#category : #'SDL-Experiments-App-Demo'
}

{ #category : #accessing }
IPCDemoOpen >> value: aCommandService [

	| aDemo |
	aDemo := IPCDemoWindow new.
	aDemo commandService: aCommandService.

	IPCCompositor current openWindow: aDemo.

	^ aDemo windowId
]
