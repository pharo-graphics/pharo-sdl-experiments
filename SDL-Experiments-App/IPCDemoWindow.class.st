Class {
	#name : #IPCDemoWindow,
	#superclass : #SceneInteractiveDemo,
	#instVars : [
		'commandService',
		'keyMapping',
		'playerElement'
	],
	#category : #'SDL-Experiments-App-Demo'
}

{ #category : #private }
IPCDemoWindow >> newCircleElementWithAnimatedDashes [

	| radius lineWidth anElement t cycleMS |
	radius := 50.
	lineWidth := 7.
	cycleMS := 250.
	t := 0.0.

	anElement := SceneElement new.
	anElement
		position: 50.0 asPoint;
		extent: (radius*2 + lineWidth) asPoint;
		isAnimated: true;
		stepBlock: [ :deltaMS :totalMS |
			"The animation restarts when the cycle completes"
			t := (totalMS \\ cycleMS) / cycleMS ];
		renderBlock: [ :cairoContext |
			cairoContext
				sourceColor: Color black;
				strokeSize: lineWidth;
				strokeDashPattern: { lineWidth }
					offset: t * lineWidth * 2;
				useStrokeJoinRound;
				useStrokeCapButt;
				circleCenterX: lineWidth/2 + radius y: lineWidth/2 + radius radius: radius;
				stroke ].
			
	^ anElement
]

{ #category : #accessing }
IPCDemoWindow >> playerElement [

	^ playerElement
]

{ #category : #initialization }
IPCDemoWindow >> prepareSceneWindow [

	keyMapping := Dictionary newFromPairs: {
		SDLK_UP. 'up'. 
		SDLK_DOWN. 'down'. 
		SDLK_LEFT. 'left'. 
		SDLK_RIGHT. 'right' }.

	playerElement := self newCircleElementWithAnimatedDashes.

	sceneWindow
		logicalExtent: 400 @ 400;
		addElement: playerElement
]

{ #category : #accessing }
IPCDemoWindow >> sendKeystrokesTo: aCommandService [

	commandService := aCommandService
]

{ #category : #visiting }
IPCDemoWindow >> visitKeyDownEvent: aSDL_KeyDownEvent [

	keyMapping
		at: aSDL_KeyDownEvent keysym sym
		ifPresent: [ :keyName |
			commandService
				sendCommand: (IPCDemoKeyPressed new
					windowId: self windowId;
					keyName: keyName;
					yourself)
				onSuccess: [ :id | "ignore: do not expect return" ] ].
	
	super visitKeyDownEvent: aSDL_KeyDownEvent
]

{ #category : #accessing }
IPCDemoWindow >> windowId [
	
	^ self identityHash
]
