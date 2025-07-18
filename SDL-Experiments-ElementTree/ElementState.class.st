Class {
	#name : #ElementState,
	#superclass : #Object,
	#instVars : [
		'children',
		'opacity',
		'background'
	],
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #'instance creation' }
ElementState class >> children: aCollection [

	^ self children: aCollection background: nil opacity: nil
]

{ #category : #'instance creation' }
ElementState class >> children: aCollection background: aColor opacity: aOpacity [

	^ self basicNew
		  initializeChildren: aCollection
		  background: aColor
		  opacity: aOpacity;
		  yourself
]

{ #category : #'instance creation' }
ElementState class >> new [

	^ self children: #()
]

{ #category : #accessing }
ElementState >> background [

	^ background ifNil: [ Color white ]
]

{ #category : #accessing }
ElementState >> children [

	^ children ifNil: [ #() ]
]

{ #category : #debugging }
ElementState >> debugId [

	^ (self identityHash printStringHex allButLast: 2) asLowercase
]

{ #category : #initialization }
ElementState >> initializeChildren: aCollection background: aColor opacity: aOpacity [

	children := aCollection.
	background := aColor.
	opacity := aOpacity
]

{ #category : #debugging }
ElementState >> inspectionPresenterOn: aBuilder [
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
ElementState >> opacity [

	^ opacity ifNil: [ 1.0 ]
]

{ #category : #printing }
ElementState >> printOn: aStream [
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
ElementState >> withBackground: aColor [

	^ self class children: children background: aColor opacity: opacity
]

{ #category : #copying }
ElementState >> withChildren: aCollection [

	^ self class children: aCollection background: background opacity: opacity
]

{ #category : #copying }
ElementState >> withOpacity: aOpacity [

	^ self class children: children background: background opacity: aOpacity
]
