"
The demo shows how to avoid freezing the Window surface while the user drags the window border to resize it.

SDL will send an SDL_EVENT_WINDOW_EXPOSED event for the window during the modal interaction and you can use an event watcher to redraw your window directly from the callback.

See: https://github.com/libsdl-org/SDL/commit/509c70c6982b6927f5a8d4fb32f9319cbaf0c2ef
"
Class {
	#name : #SceneResizingDemo,
	#superclass : #SceneInteractiveDemo,
	#instVars : [
		'eventFilter'
	],
	#category : #'SDLExperiments-Demo-Interactive'
}

{ #category : #running }
SceneResizingDemo >> close [

	"Delete the event filter (added in #open)"
	SDL2 deleteEventWatch: eventFilter userdata: nil.

	super close
]

{ #category : #private }
SceneResizingDemo >> filterAndRedrawIfExposedEvent: eventAddress [
	"Answer 0 to filter (it won't be received by main loop), 1 otherwise"

	| event mappedEvent |
	event := SDL_Event fromHandle: eventAddress.
	event type = SDL_WindowEvent eventType ifFalse: [ ^ 1 ].
	mappedEvent := event mapped.
	
	"We only care about this event"
	mappedEvent event = SDL_WINDOWEVENT_EXPOSED ifFalse: [ ^ 1 ].

	"We may care of our window, but not clear as resizing a window freezes all windows"
	"mappedEvent windowID = sceneWindow sdlWindow windowID ifFalse: [ ^ 1 ]."

	"Simulate a longer redrawing time"
	"100 milliSeconds wait."

	"Redraw during modal move/resize loop.
	See: https://github.com/libsdl-org/SDL/commit/509c70c6982b6927f5a8d4fb32f9319cbaf0c2ef"
	sceneWindow step.
	^ 0
]

{ #category : #private }
SceneResizingDemo >> newMatchWindowElement [

	| lineWidth theElement |
	lineWidth := 16.

	theElement := SceneElement new.
	theElement
		stepBlock: [ :deltaMS :totalMS |
			| currentExtent |
			currentExtent := sceneWindow sdlWindow extent.
			(currentExtent = theElement extent) ifFalse: [
				theElement extent: currentExtent ]
			];
		renderBlock: [ :cairoContext |
			cairoContext
				sourceColor: Color blue;
				strokeSize: lineWidth;
				useStrokeJoinRound;
				rectangleX: lineWidth
				         y: lineWidth
				     width: theElement extent x - (lineWidth*2)
				    height: theElement extent y - (lineWidth*2);
				stroke ].
			
	^ theElement
]

{ #category : #private }
SceneResizingDemo >> newSquaredElementWithAnimatedDashes [

	| squareSide lineWidth theElement t cycleMS |
	squareSide := 150.
	lineWidth := 10.
	cycleMS := 500.
	t := 0.0.

	theElement := SceneElement new.
	theElement
		position: 50.0 asPoint;
		extent: (squareSide*2 + lineWidth) asPoint;
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
				rectangleX: lineWidth
					y: lineWidth
					width:  squareSide
					height: squareSide;
				stroke ].
			
	^ theElement
]

{ #category : #running }
SceneResizingDemo >> open [

	super open.
	
	sceneWindow sdlWindow resizable: true.

	"Install filter, which is a FFI callback that will receive all events
	in this OS process."	
	eventFilter :=
		SDL_EventFilter on: [ :data :eventAddress |
			Stdio stdout print: eventAddress; lf.
			self filterAndRedrawIfExposedEvent: eventAddress ].
	SDL2 addEventWatch: eventFilter userdata: nil
]

{ #category : #initialization }
SceneResizingDemo >> prepareSceneWindow [

	sceneWindow
		logicalExtent: 300 @ 300;
		addElement: self newMatchWindowElement;
		addElement:	self newSquaredElementWithAnimatedDashes
]
