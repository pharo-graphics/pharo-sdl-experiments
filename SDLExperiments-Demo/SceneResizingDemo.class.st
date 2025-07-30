"
The demo shows how to avoid freezing the Window surface while the user drags the window border to resize it.

SDL will send an SDL_EVENT_WINDOW_EXPOSED event for the window during the modal interaction and you can use an event watcher to redraw your window directly from the callback.

See: https://github.com/libsdl-org/SDL/commit/509c70c6982b6927f5a8d4fb32f9319cbaf0c2ef
"
Class {
	#name : #SceneResizingDemo,
	#superclass : #SceneInteractiveDemo,
	#category : #'SDLExperiments-Demo-Interactive'
}

{ #category : #private }
SceneResizingDemo >> filterAndRedrawIfExposedEvent: eventAddress [
	"Answer 0 to filter, 1 to do not filter."

	| event mappedEvent |
	event := SDL_Event fromHandle: eventAddress.
	event type = SDL_WindowEvent eventType ifFalse: [ ^ 1 ].
	mappedEvent := event mapped.
	mappedEvent event = SDL_WINDOWEVENT_EXPOSED ifFalse: [ ^ 1 ].
	
	"Redraw during modal move/resize loop.
	See: https://github.com/libsdl-org/SDL/commit/509c70c6982b6927f5a8d4fb32f9319cbaf0c2ef"
	sceneWindow step.
	^ 0
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
		position: 100.0 asPoint;
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

	| exposedFilter |
	super open.
	
	sceneWindow sdlWindow resizable: true.
	
	exposedFilter :=
		SDL_EventFilter on: [ :data :eventAddress |
			self filterAndRedrawIfExposedEvent: eventAddress ].

	SDL2 addEventWatch: exposedFilter userdata: nil
]

{ #category : #initialization }
SceneResizingDemo >> prepareSceneWindow [

	sceneWindow addElement: self newSquaredElementWithAnimatedDashes
]
