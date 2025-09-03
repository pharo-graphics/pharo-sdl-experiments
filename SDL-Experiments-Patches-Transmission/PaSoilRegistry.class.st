Class {
	#name : #PaSoilRegistry,
	#superclass : #SoilStandaloneObjectRegistry,
	#instVars : [
		'nextId',
		'descriptionCache'
	],
	#category : #'SDL-Experiments-Patches-Transmission'
}

{ #category : #query }
PaSoilRegistry >> behaviorDescriptionAt: anInteger [ 

	^ descriptionCache
		at: anInteger
		ifAbsentPut: [
			| aClass descriptionClass |
			aClass := classes at: anInteger.
			descriptionClass :=
			 	(self concretePatcheableClasses includes: aClass)
					ifTrue: [ PaSoilBehaviorDescription ]
					ifFalse: [ SoilBehaviorDescription ].

			(descriptionClass for: aClass)
				objectId: (SoilObjectId segment: 0 index: anInteger); 
				yourself ]
]

{ #category : #query }
PaSoilRegistry >> behaviorDescriptionWithObjectId: aSoilObjectId andVersion: version [

	^ self behaviorDescriptionAt: aSoilObjectId index
]

{ #category : #query }
PaSoilRegistry >> concretePatcheableClasses [

	^ { PaArray. PaSceneNode }
]

{ #category : #initialization }
PaSoilRegistry >> initialize [

	super initialize.
	
	"Order is IMPORTANT (their index is encoded/decoded)"
	classes addAll: self wellKnownClasses.

	descriptionCache := Dictionary new
]

{ #category : #synchronization }
PaSoilRegistry >> wellKnownClasses [
	
	^ (self concretePatcheableClasses, PaPatch allSubclasses)
			sorted: [ :a :b | a name < b name ]
]
