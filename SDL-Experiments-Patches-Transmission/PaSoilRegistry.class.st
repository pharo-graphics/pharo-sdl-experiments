Class {
	#name : #PaSoilRegistry,
	#superclass : #SoilStandaloneObjectRegistry,
	#instVars : [
		'nextId',
		'descriptionByIndex',
		'indexByDescription'
	],
	#category : #'SDL-Experiments-Patches-Transmission-Soil'
}

{ #category : #query }
PaSoilRegistry >> behaviorDescriptionAt: anInteger [ 

	^ descriptionByIndex
		at: anInteger
		ifAbsentPut: [
			| aClass descriptionClass |
			aClass := classes at: anInteger.
			descriptionClass :=
			 	(self patcheableClasses includes: aClass)
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
PaSoilRegistry >> indexOfBehaviorDescription: aClass [ 

	^ indexByDescription 
		at: aClass
		ifAbsentPut: [
			| index |
			index := classes indexOf: aClass.
			index > 0
				ifTrue: [ index ]
				ifFalse: [ 
					classes add: aClass.
					classes size ] ]
]

{ #category : #initialization }
PaSoilRegistry >> initialize [

	super initialize.
	
	"Order is IMPORTANT (their index is encoded/decoded)"
	classes addAll: self wellKnownClasses.

	descriptionByIndex := IdentityDictionary new.
	indexByDescription := IdentityDictionary new
]

{ #category : #synchronization }
PaSoilRegistry >> patchClasses [

	^ PaPatch allSubclasses
]

{ #category : #query }
PaSoilRegistry >> patcheableClasses [

	^ PaBaseObject allSubclasses
]

{ #category : #synchronization }
PaSoilRegistry >> wellKnownClasses [
	
	self flag: #todo. "Make this extensible"
	^ (self patcheableClasses, self patchClasses, { Point. Rectangle })
			sorted: [ :a :b | a name < b name ]
]
