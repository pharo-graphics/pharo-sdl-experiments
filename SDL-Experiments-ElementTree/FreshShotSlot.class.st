"
I'm Slot to reduce duplicated code in accessors and mutators to shots, from mutable objects.

If we define `#background => FreshShotSlot`, then we can define:
```
background
	^ background
```
instead of:
```
background
	^ freshShot background
```

and, more importantly:
```
background: aColor
	background := aColor
```
instead of:
```
background: aColor
	self writeShot: [ :shot | shot privateBackground: aColor ]
```

And benchmarks show better performance, especially on write.

"
Class {
	#name : #FreshShotSlot,
	#superclass : #DerivedSlot,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #accessing }
FreshShotSlot >> accessingSelector [

	^ self name asSymbol
]

{ #category : #accessing }
FreshShotSlot >> baseSlot [

	^ baseSlot ifNil: [
		baseSlot := owningClass allSlots
			detect: [ :slot | slot name = #freshShot ] ]
]

{ #category : #'code generation' }
FreshShotSlot >> emitStore: aMethodBuilder [
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
		send: #ensureDraftShot.

	aMethodBuilder
		pushInstVar: self baseSlot index;
		pushTemp: tempName;
		send: self mutatorSelector
]

{ #category : #'code generation' }
FreshShotSlot >> emitValue: methodBuilder [
	"Generate bytecode for 'freshSlot <name>' message send to the instvar."

	methodBuilder
		pushInstVar: self baseSlot index;
		send: self accessingSelector
]

{ #category : #'meta-object-protocol' }
FreshShotSlot >> freshShotFrom: anObject [

	^ self baseSlot read: anObject
]

{ #category : #accessing }
FreshShotSlot >> mutatorSelector [

	^ (self name copyWith: $:) asSymbol
]

{ #category : #'meta-object-protocol' }
FreshShotSlot >> read: anObject [
	<reflection: 'Object Inspection - State inspection'>

	^ (self freshShotFrom: anObject) perform: self accessingSelector
]

{ #category : #'meta-object-protocol' }
FreshShotSlot >> write: aValue to: anObject [
	<reflection: 'Object Modification - State modification'>

	anObject ensureDraftShot.
	(self freshShotFrom: anObject)
		perform: self mutatorSelector
		with: aValue
]
