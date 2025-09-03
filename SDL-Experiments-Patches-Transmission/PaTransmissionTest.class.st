Class {
	#name : #PaTransmissionTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #tests }
PaTransmissionTest >> test0PushEmpty [

	| writeStream pushEndpoint pullEndpoint |
	writeStream := WriteStream on: #[].

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: writeStream.
	pushEndpoint push.

	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.

	self assert: pullEndpoint root isNil.
	pullEndpoint pull.

	self deny: pullEndpoint root identicalTo: pushEndpoint root.
	self deny: pullEndpoint root hasPatches
]

{ #category : #tests }
PaTransmissionTest >> test1PushWithOpacity [

	| writeStream pushEndpoint pullEndpoint |
	writeStream := WriteStream on: #[].

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: writeStream.
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
	writeStream := WriteStream on: #[].

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: writeStream.
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
	writeStream := WriteStream on: #[].

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: writeStream.

	a := pushEndpoint root.
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

	| writeStream pushEndpoint pullEndpoint a b c d pulledA pulledB pulledC pulledD |
	writeStream := WriteStream on: #[].

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: writeStream.

	a := pushEndpoint root.
	a opacity: 0.1.
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
	pushEndpoint push.
	d opacity: 0.4.
	pushEndpoint push.

	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pullUntilEnd.

	pulledA := pullEndpoint root.
	self assert: pulledA opacity equals: 0.1.
	pulledB := pulledA children at: 1.
	self assert: pulledB opacity equals: 0.2.
	pulledC := pulledB children at: 1.
	self assert: pulledC opacity equals: 0.3.
	pulledD := pulledB children at: 2.
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

{ #category : #nil }
PaTransmissionTest >> testLifecycle [

	| writeStream pushEndpoint pullEndpoint a b c pulledB pulledC d pulledD |
	writeStream := WriteStream on: #[].

	pushEndpoint := PaPushEndpoint new.
	pushEndpoint stream: writeStream.
	pushEndpoint push.
	a := pushEndpoint root.
	a opacity: 0.1.
	pushEndpoint push.
	b := PaSceneNode new.
	a addChild: b.
	pushEndpoint push.
	b opacity: 0.2.
	pushEndpoint push.
	c := PaSceneNode new.
	c opacity: 0.3.
	b addChild: c.
	pushEndpoint push.
	d := PaSceneNode new.
	d opacity: 0.4.
	b addChild: d.
	pushEndpoint push.

	pullEndpoint := PaPullEndpoint new.
	pullEndpoint stream: writeStream contents readStream.
	pullEndpoint pullUntilEnd.
	a := pullEndpoint root.
	self assert: a opacity equals: 0.1.
	pulledB := a children at: 1.
	self assert: pulledB opacity equals: 0.2.
	pulledC := pulledB children at: 1.
	self assert: pulledC opacity equals: 0.3.
	pulledD := pulledB children at: 2.
	self assert: pulledD opacity equals: 0.4.
]
