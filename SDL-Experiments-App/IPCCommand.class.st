Class {
	#name : #IPCCommand,
	#superclass : #Object,
	#category : #'SDL-Experiments-App-Core'
}

{ #category : #'fuel support' }
IPCCommand class >> fuelIgnoredInstanceVariableNames [

	^  #(successValuable)
]

{ #category : #accessing }
IPCCommand >> value: aCommandService [
	"Execute and answer an object that will be sent as a result to the execution."

	^ self subclassResponsibility
]
