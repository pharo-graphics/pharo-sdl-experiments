Class {
	#name : #CowSlot,
	#superclass : #InstanceVariableSlot,
	#instVars : [
		'activeStateSlot',
		'indexInState'
	],
	#category : #'SDL-Experiments-ElementTree2-Core'
}

{ #category : #'meta-object-protocol' }
CowSlot >> activeStateFrom: aCowObject [

	^ self activeStateSlot read: aCowObject
]

{ #category : #accessing }
CowSlot >> activeStateSlot [

	^ activeStateSlot ifNil: [
		activeStateSlot := owningClass slotNamed: #activeState ]
]

{ #category : #'code generation' }
CowSlot >> emitStore: aMethodBuilder [
	"generate bytecode to call the reflective write method of the Slot"

	| tempName |
	tempName := '0slotTempForStackManipulation'.
	aMethodBuilder
		addTemp: tempName;
		storeTemp: tempName;
		popTop;
		pushReceiver;
		pushLiteral: self;
		pushTemp: tempName;
		send: #writeSlot:value:
]

{ #category : #'code generation' }
CowSlot >> emitValue: aMethodBuilder [

	aMethodBuilder
		pushLiteral: self;
		pushReceiver;
		send: #read:
]

{ #category : #accessing }
CowSlot >> indexInState [
	"Answer my offset, that is my position among all similar slots in the hierarchy"

	^ indexInState ifNil: [
		indexInState := owningClass cowInstanceVariableSlots indexOf: self ]
]

{ #category : #'meta-object-protocol' }
CowSlot >> write: newValue to: aCowObject [
	<reflection: 'Object Modification - State modification'>

	| oldValue |

	"Optimization: return early if no change"
	oldValue := self read: aCowObject.
	newValue == oldValue ifTrue: [ ^ self ].

	super write: newValue to: aCowObject.

	"Don't point to the old value anymore"
	oldValue
		removePointerOfInstanceVariable: self indexInState
		from: aCowObject.
	"Point ot the new value"
	newValue
		addPointerOfInstanceVariable: self indexInState
		from: aCowObject.

	"Replicate mutation in the draft active state"
	aCowObject prepareToWrite.
	(self activeStateFrom: aCowObject)
		at: self indexInState
		put: newValue activeState
]
