"
I'm Slot to reduce duplicated code in accessors and mutators to shots, from mutable objects.

If we define `#background => ActiveShotSlot`, then we can define:
```
background
	^ background
```
instead of:
```
background
	^ activeShot background
```

and, more importantly:
```
background: aColor
	background := aColor
```
instead of:
```
background: aColor
	self ensureActiveShotIsDraft.
	activeShot background: aColor
```

And benchmarks show better performance, especially on write.

"
Class {
	#name : #ActiveShotSlot,
	#superclass : #DerivedSlot,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #accessing }
ActiveShotSlot >> accessingSelector [

	^ self name asSymbol
]

{ #category : #'meta-object-protocol' }
ActiveShotSlot >> activeShotFrom: anObject [

	^ self baseSlot read: anObject
]

{ #category : #accessing }
ActiveShotSlot >> baseSlot [

	^ baseSlot ifNil: [
		baseSlot := owningClass allSlots
			detect: [ :slot | slot name = #activeShot ] ]
]

{ #category : #'code generation' }
ActiveShotSlot >> emitStore: aMethodBuilder [
	"Generate bytecode to ensure the shot is draft and then send the new value via mutator selector."

	| tempName |
	"Pop the value to store into a temp to push it back in the right order"
	tempName := '0slotTempForStackManipulation'.
	aMethodBuilder
		addTemp: tempName;
		storeTemp: tempName;
		popTop.

	aMethodBuilder
		pushReceiver;
		send: #ensureActiveShotIsDraft.

	aMethodBuilder
		pushInstVar: self baseSlot index;
		pushTemp: tempName;
		send: self mutatorSelector
]

{ #category : #'code generation' }
ActiveShotSlot >> emitValue: methodBuilder [
	"Generate bytecode for 'activeSlot <name>' message send to the instvar."

	methodBuilder
		pushInstVar: self baseSlot index;
		send: self accessingSelector
]

{ #category : #accessing }
ActiveShotSlot >> mutatorSelector [

	^ (self name copyWith: $:) asSymbol
]

{ #category : #'meta-object-protocol' }
ActiveShotSlot >> read: anObject [
	<reflection: 'Object Inspection - State inspection'>

	^ (self activeShotFrom: anObject) perform: self accessingSelector
]

{ #category : #'meta-object-protocol' }
ActiveShotSlot >> write: aValue to: anObject [
	<reflection: 'Object Modification - State modification'>

	anObject ensureActiveShotIsDraft.
	(self activeShotFrom: anObject)
		perform: self mutatorSelector
		with: aValue
]
