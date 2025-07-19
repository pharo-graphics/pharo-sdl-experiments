"
I am a mutable representation a scene graph element.

See comment in my superclass.
"
Class {
	#name : #Element,
	#superclass : #TreeNode,
	#category : #'SDL-Experiments-ElementTree'
}

{ #category : #'instance creation' }
Element class >> new [

	^ self shot: ElementShot new
]

{ #category : #accessing }
Element >> background [

	^ shot background
]

{ #category : #accessing }
Element >> background: aColor [

	self privateShot: (shot copyWithBackground: aColor)
]

{ #category : #debugging }
Element >> inspectionPresenterOn: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Tree'>

	^ aBuilder newTreeTable 
		roots: { self };
		children: [ :aNode | aNode children ];
		addColumn: (SpStringTableColumn 
			title: 'Element debugId'
			evaluated: [ :each | each debugId ]);
		addColumn: (SpStringTableColumn 
			title: 'State debugId'
			evaluated: [ :each | each shot debugId ]);
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
Element >> opacity [

	^ shot opacity
]

{ #category : #accessing }
Element >> opacity: aOpacity [

	self privateShot: (shot copyWithOpacity: aOpacity)
]
