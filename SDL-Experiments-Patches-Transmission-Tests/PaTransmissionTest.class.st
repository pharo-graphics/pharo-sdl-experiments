Class {
	#name : #PaTransmissionTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-Patches-Transmission-Tests'
}

{ #category : #tests }
PaTransmissionTest >> test0PushEmptyNode [

	| writeStream pushEndpoint pullEndpoint |
	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).

	self assert: pushEndpoint root isNil.

	pushEndpoint root: PaSceneNode new.
	pushEndpoint push.

	pullEndpoint := PaPullEndpoint new.

	self assert: pullEndpoint root isNil.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pull.
	self deny: pullEndpoint root isNil.

	self deny: pullEndpoint root identicalTo: pushEndpoint root.
	self deny: pullEndpoint root hasPatches
]

{ #category : #tests }
PaTransmissionTest >> test1PushWithOpacity [

	| writeStream pushEndpoint pullEndpoint |
	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint root: PaSceneNode new.
	pushEndpoint root opacity: 0.1.
	pushEndpoint push.

	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pull.

	self deny: pullEndpoint root identicalTo: pushEndpoint root.
	self assert: pullEndpoint root opacity equals: 0.1.
	self deny: pullEndpoint root hasPatches
]

{ #category : #tests }
PaTransmissionTest >> test2PushOpacityPatch [

	| writeStream pushEndpoint pullEndpoint |
	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint root: PaSceneNode new.
	pushEndpoint push.

	pushEndpoint root opacity: 0.0.
	pushEndpoint root opacity: 0.1.
	pushEndpoint push.

	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.

	pullEndpoint pull.
	self deny: pullEndpoint root identicalTo: pushEndpoint root.
	self assert: pullEndpoint root opacity isNil.
	self deny: pullEndpoint root hasPatches.

	pullEndpoint pull.
	self assert: pullEndpoint root opacity equals: 0.1.
	self deny: pullEndpoint root hasPatches
]

{ #category : #tests }
PaTransmissionTest >> test3PushTree [

	| writeStream pushEndpoint pullEndpoint a b c d pulledA pulledB pulledC pulledD |
	a := PaSceneNode new.
	a opacity: 0.1.
	b := PaSceneNode new.
	a addChild: b.
	b opacity: 0.2.
	c := PaSceneNode new.
	c opacity: 0.3.
	b addChild: c.
	d := PaSceneNode new.
	d opacity: 0.4.
	b addChild: d.

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint root: a.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint push.
	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pull.

	pulledA := pullEndpoint root.
	self assert: pulledA opacity equals: 0.1.
	pulledB := pulledA children at: 1.
	self assert: pulledB parent identicalTo: pulledA.
	self assert: pulledB opacity equals: 0.2.
	pulledC := pulledB children at: 1.
	self assert: pulledC parent identicalTo: pulledB.
	self assert: pulledC opacity equals: 0.3.
	pulledD := pulledB children at: 2.
	self assert: pulledD parent identicalTo: pulledB.
	self assert: pulledD opacity equals: 0.4.
	
	self deny: a hasPatches.
	self deny: b hasPatches.
	self deny: c hasPatches.
	self deny: d hasPatches.

	self deny: a identicalTo: pulledA.
	self deny: b identicalTo: pulledB.
	self deny: c identicalTo: pulledC.
	self deny: d identicalTo: pulledD
]

{ #category : #tests }
PaTransmissionTest >> test4PushTreeGradually [

	| writeStream pushEndpoint pullEndpoint a b c d pulledA pulledB pulledC pulledD e |
	a := PaSceneNode new.
	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint root: a.
	pushEndpoint push.

	a opacity: 0.1.
	b := PaSceneNode new.
	a addChild: b.
	b opacity: 0.2.
	pushEndpoint push.

	c := PaSceneNode new.
	c opacity: 0.3.
	b addChild: c.
	pushEndpoint push.

	d := PaSceneNode new.
	b addChild: d.
	pushEndpoint push.

	d opacity: 0.4.
	pushEndpoint push.

	e := PaSceneNode new.
	e opacity: 0.5.
	b replaceChild: c with: e.
	pushEndpoint push.

	b replaceChild: e with: c.
	pushEndpoint push.
	
	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pullUntilEnd.

	pulledA := pullEndpoint root.
	pulledB := pulledA children at: 1.
	pulledC := pulledB children at: 1.
	pulledD := pulledB children at: 2.

	self assert: pulledA opacity equals: 0.1.
	self assert: pulledB opacity equals: 0.2.
	self assert: pulledC opacity equals: 0.3.
	self assert: pulledD opacity equals: 0.4.

	self assert: pulledB parent identicalTo: pulledA.
	self assert: pulledC parent identicalTo: pulledB.
	self assert: pulledD parent identicalTo: pulledB.
	
	self deny: a hasPatches.
	self deny: b hasPatches.
	self deny: c hasPatches.
	self deny: d hasPatches.

	self deny: pulledA hasPatches.
	self deny: pulledB hasPatches.
	self deny: pulledC hasPatches.
	self deny: pulledD hasPatches.

	self deny: a identicalTo: pulledA.
	self deny: b identicalTo: pulledB.
	self deny: c identicalTo: pulledC.
	self deny: d identicalTo: pulledD
]

{ #category : #tests }
PaTransmissionTest >> test5PushAfterReplaceAndRemoveChild [

	| writeStream pushEndpoint pullEndpoint a b c d pulledA pulledB pulledC pulledD e |
	a := PaSceneNode new.
	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint root: a.
	pushEndpoint push.

	a opacity: 0.1.
	b := PaSceneNode new.
	a addChild: b.
	b opacity: 0.2.
	pushEndpoint push.

	c := PaSceneNode new.
	c opacity: 0.3.
	b addChild: c.
	pushEndpoint push.

	d := PaSceneNode new.
	b addChild: d.
	pushEndpoint push.

	d opacity: 0.4.
	pushEndpoint push.

	e := PaSceneNode new.
	e opacity: 0.5.
	b replaceChild: c with: e.
	pushEndpoint push.

	b replaceChild: e with: c.
	pushEndpoint push.
	
	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pullUntilEnd.

	pulledA := pullEndpoint root.
	pulledB := pulledA children at: 1.
	pulledC := pulledB children at: 1.
	pulledD := pulledB children at: 2.

	self assert: pulledA opacity equals: 0.1.
	self assert: pulledB opacity equals: 0.2.
	self assert: pulledC opacity equals: 0.3.
	self assert: pulledD opacity equals: 0.4.

	self assert: pulledB parent identicalTo: pulledA.
	self assert: pulledC parent identicalTo: pulledB.
	self assert: pulledD parent identicalTo: pulledB.
	
	self deny: a hasPatches.
	self deny: b hasPatches.
	self deny: c hasPatches.
	self deny: d hasPatches.

	self deny: pulledA hasPatches.
	self deny: pulledB hasPatches.
	self deny: pulledC hasPatches.
	self deny: pulledD hasPatches.

	self deny: a identicalTo: pulledA.
	self deny: b identicalTo: pulledB.
	self deny: c identicalTo: pulledC.
	self deny: d identicalTo: pulledD
]

{ #category : #tests }
PaTransmissionTest >> test6PushAfterReset [

	| writeStream pushEndpoint pullEndpoint a b c d pulledA pulledB pulledC pulledD |
	a := PaSceneNode new.
	a opacity: 0.1.
	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint root: a.
	pushEndpoint push.

	b := PaSceneNode new.
	a addChild: b.
	b opacity: 0.2.
	pushEndpoint push.

	c := PaSceneNode new.
	c opacity: 0.3.
	b addChild: c.
	pushEndpoint push.

	d := PaSceneNode new.
	b addChild: d.
	pushEndpoint reset. "Next push will be full"
	pushEndpoint push.

	d opacity: 0.4.
	pushEndpoint push.

	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pullUntilEnd.

	pulledA := pullEndpoint root.
	pulledB := pulledA childAt: 1.
	pulledC := pulledB childAt: 1.
	pulledD := pulledB childAt: 2.
	self assert: pulledA opacity equals: 0.1.
	self assert: pulledB opacity equals: 0.2.
	self assert: pulledC opacity equals: 0.3.
	self assert: pulledD opacity equals: 0.4.
	self assert: pulledB parent identicalTo: pulledA.
	self assert: pulledC parent identicalTo: pulledB.
	self assert: pulledD parent identicalTo: pulledB
]

{ #category : #tests }
PaTransmissionTest >> test7PushAfterNewRoot [

	| writeStream pushEndpoint pullEndpoint a b |
	a := PaSceneNode new.
	a opacity: 0.1.
	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint root: a.
	pushEndpoint push.

	b := PaArray new: 1.
	b at: 1 put: $a.
	pushEndpoint root: b.
	pushEndpoint push.

	b at: 1 put: $b.
	pushEndpoint push.

	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pullUntilEnd.

	self assert: pullEndpoint root class equals: PaArray.
	self assert: (pullEndpoint root at: 1) equals: $b.
	self deny: b identicalTo: pullEndpoint root
]

{ #category : #tests }
PaTransmissionTest >> test8GarbageCollection [

	| writeStream pushEndpoint pullEndpoint a b c pulledA pulledB pulledC |

	"Set up a tree with A and B"
	a := PaSceneNode new.
	a opacity: 0.1.
	b := PaSceneNode new.
	a addChild: b.
	b opacity: 0.2.
	pushEndpoint := PaPushEndpoint new.
	pushEndpoint root: a.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint push.
	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pullUntilEnd.
	pulledA := pullEndpoint root.
	pulledB := pulledA childAt: 1.
	self assert: b pointersTo size equals: 3.
	self assert: pulledB pointersTo size equals: 2.
	
	"Replace B by C and gc should show a decrement in pointers to B"
	c := PaSceneNode new opacity: 0.3; yourself.
	self assert: b pointersTo size equals: 3.
	self assert: c pointersTo size equals: 0.
	a replaceChild: b with: c.
	3 timesRepeat: [ Smalltalk garbageCollect ].
	self assert: b pointersTo size equals: 4.
	self assert: c pointersTo size equals: 1.
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint push.
	3 timesRepeat: [ Smalltalk garbageCollect ].
	self assert: b pointersTo size equals: 2.
	self assert: c pointersTo size equals: 3.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pullUntilEnd.
	pulledC := pulledA childAt: 1.
	self assert: pulledC opacity equals: 0.3.
	3 timesRepeat: [ Smalltalk garbageCollect ].
	self assert: pulledB pointersTo size equals: 1. "After pull, B stays in the index (weak) dictionary"
	self assert: pulledC pointersTo size equals: 2. "C is in the index as well, and is ponited by A"

	"B is not pointed anymore by the root, but the endpoint is still subscribed to B"
	self assert: (pushEndpoint dirtyPatcheables count: #notNil) equals: 0.
	b opacity: 0.9.
	self assert: (pushEndpoint dirtyPatcheables count: #notNil) equals: 1.

	"Push should tolerate that a dirty patcheable has been GCed"
	pushEndpoint stream: (writeStream := WriteStream on: #[]).
	pushEndpoint push.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pull.
 
	self assert: (pushEndpoint subscriptions count: #notNil) equals: 4.
	b := nil.
	3 timesRepeat: [ Smalltalk garbageCollect ].
	self assert: (pushEndpoint subscriptions count: #notNil) equals: 3.

	self assertCollection: pushEndpoint pointersTo hasSameElements: { a. a children. c }.
	pushEndpoint reset. "Empty internal collections"
	3 timesRepeat: [ Smalltalk garbageCollect ].
	self assert: c pointersTo size equals: 1 "Only node A points to C"
]
