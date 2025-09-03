Class {
	#name : #PaSceneNode,
	#superclass : #PaBaseObject,
	#traits : 'TPaInstanceVariablesAPI - {#addPatchFirst:} + TPaSubscribableAPI',
	#classTraits : 'TPaInstanceVariablesAPI classTrait + TPaSubscribableAPI classTrait',
	#instVars : [
		'#opacity => PaSlot',
		'#children => PaSlot',
		'#parent => PaSlot'
	],
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #adding }
PaSceneNode >> addChild: aChild [

	aChild parent: aChild.
	children := children
		            ifNil: [ PaArray with: aChild ]
		            ifNotNil: [ children copyWith: aChild ]
]

{ #category : #accessing }
PaSceneNode >> children [

	^ children
]

{ #category : #accessing }
PaSceneNode >> opacity [

	^ opacity
]

{ #category : #accessing }
PaSceneNode >> opacity: aNumber [

	opacity := aNumber
]

{ #category : #accessing }
PaSceneNode >> parent [

	^ parent
]

{ #category : #accessing }
PaSceneNode >> parent: aNode [

	parent := aNode
]
