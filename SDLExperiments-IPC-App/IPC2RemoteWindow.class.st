Class {
	#name : #IPC2RemoteWindow,
	#superclass : #IPC2AbstractWindow,
	#instVars : [
		'id',
		'pushEndpoint',
		'pushLoopProcess',
		'pushDeferrer'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #'as yet unclassified' }
IPC2RemoteWindow >> destroy [

	super destroy.
	
	pushLoopProcess ifNil: [ ^self ].
	pushLoopProcess terminate.
	pushLoopProcess := nil
]

{ #category : #accessing }
IPC2RemoteWindow >> id [

	^ id
]

{ #category : #accessing }
IPC2RemoteWindow >> id: anId [

	id := anId
]

{ #category : #'as yet unclassified' }
IPC2RemoteWindow >> initialize [

	super initialize.

	pushDeferrer := MinMaxDeferrer
		value: (MessageSend receiver: self selector: #push)
		minMSDeferral: 1
		maxMSDeferral: 5
]

{ #category : #'API - remotes' }
IPC2RemoteWindow >> push [

	'push (ms): ' trace.

	[	| bytes |
		"Reuse the endpoint as it keeps track of the already pushed nodes."
		bytes := ByteArray streamContents: [ :stream |
			pushEndpoint
				stream: stream;
				push ].

		"It could happen that all dirty patcheables were garbage collected"
		bytes ifNotEmpty: [
			compositor updateSceneGraph: bytes windowId: id ]
	
		] millisecondsToRun traceCr
]

{ #category : #accessing }
IPC2RemoteWindow >> pushEndpoint: aPushEndpoint [

	pushEndpoint := aPushEndpoint.
 
	pushEndpoint dirtyPatcheablesSubscription:
		(MessageSend receiver: self selector: #schedulePush)
]

{ #category : #accessing }
IPC2RemoteWindow >> sceneTree [

	^ pushEndpoint root
]

{ #category : #accessing }
IPC2RemoteWindow >> sceneTree: aTreeNode [

	pushEndpoint root: aTreeNode
]

{ #category : #'as yet unclassified' }
IPC2RemoteWindow >> schedulePush [

	pushDeferrer schedule
]
