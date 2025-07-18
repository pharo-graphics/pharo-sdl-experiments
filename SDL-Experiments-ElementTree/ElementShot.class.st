"
I am an immutable representation a scene graph element.
"
Class {
	#name : #ElementShot,
	#superclass : #Object,
	#instVars : [
		'children',
		'opacity',
		'background'
	],
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #'instance creation' }
ElementShot class >> children: aCollection [

	^ self children: aCollection background: nil opacity: nil
]

{ #category : #'instance creation' }
ElementShot class >> children: aCollection background: aColor opacity: aOpacity [

	^ self basicNew
		  initializeChildren: aCollection
		  background: aColor
		  opacity: aOpacity;
		  yourself
]

{ #category : #'instance creation' }
ElementShot class >> new [

	^ self children: #()
]

{ #category : #accessing }
ElementShot >> background [

	^ background ifNil: [ Color white ]
]

{ #category : #accessing }
ElementShot >> children [

	^ children ifNil: [ #() ]
]

{ #category : #debugging }
ElementShot >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #initialization }
ElementShot >> initializeChildren: aCollection background: aColor opacity: aOpacity [

	children := aCollection.
	background := aColor.
	opacity := aOpacity
]

{ #category : #debugging }
ElementShot >> inspectionPresenterOn: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Tree'>

	^ aBuilder newTreeTable 
		roots: { self };
		children: [ :aNode | aNode children ];
		addColumn: (SpStringTableColumn 
			title: 'debugId'
			evaluated: [ :each | each debugId ]);
		addColumn: (SpStringTableColumn 
			title: 'background'
			evaluated: [ :each | each background ]);
		addColumn: (SpStringTableColumn 
			title: 'opacity'
			evaluated: [ :each | each opacity ]);
		expandAll;
		yourself
]

{ #category : #accessing }
ElementShot >> opacity [

	^ opacity ifNil: [ 1.0 ]
]

{ #category : #printing }
ElementShot >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '#';
		print: self debugId.

	aStream
		nextPutAll: ' #children: ';
		print: children size.
	aStream
		nextPutAll: ' background: ';
		print: background.
	aStream
		nextPutAll: ' opacity: ';
		print: opacity
]

{ #category : #copying }
ElementShot >> withBackground: aColor [

	^ self class children: children background: aColor opacity: opacity
]

{ #category : #copying }
ElementShot >> withChildren: aCollection [

	^ self class children: aCollection background: background opacity: opacity
]

{ #category : #copying }
ElementShot >> withOpacity: aOpacity [

	^ self class children: children background: background opacity: aOpacity
]
