"
I'm a Slot to ensure immutability of a shot when it's completed, and so not draft anymore.
"
Class {
	#name : #ShotSlot,
	#superclass : #InstanceVariableSlot,
	#category : #'SDLExperiments-IPC-COW'
}

{ #category : #'code generation' }
ShotSlot >> emitStore: aMethodBuilder [
	"Generate bytecode to ensure the shot is draft and then send the new value via mutator selector."

	| tempName |
	"Keep the new value, to use it later, if the assertion passed."
	tempName := '0slotTempForStackManipulation'.
	aMethodBuilder
		addTemp: tempName;
		storeTemp: tempName;
		popTop.

	"The shot must be draft"
	aMethodBuilder
		pushReceiver;
		send: #assertDraft.

	"Store the new value since the assertion passed"
	aMethodBuilder
		pushTemp: tempName;
		storeInstVar: index
]
