Class {
	#name : #SDL2TextureUpdateBench,
	#superclass : #Object,
	#instVars : [
		'sdlWindow',
		'sdlRenderer',
		'sdlTexture',
		'duration',
		'extent',
		'sdlRenderDriverName'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'SDLExperiments-Tests'
}

{ #category : #running }
SDL2TextureUpdateBench class >> driverNames [

	| driverNames |
	driverNames := SDL2 renderDriverInfos collect: #nameString.
	driverNames := driverNames copyWithout: 'opengles2'.
	driverNames := driverNames copyWithout: 'software'.
	^ driverNames
]

{ #category : #examples }
SDL2TextureUpdateBench class >> run [
	<script>

	| extents benchClasses |
	benchClasses := { SDL2StaticTextureUpdateBench. SDL2StreamingTextureUpdateBench }.
	benchClasses := { SDL2StreamingTextureUpdateBench }.
	
	extents := SortedCollection
		sortBlock: [ :a :b | (a x * a y) < (b x * b y) ].
	extents
		add: 3840 @ 2160; "4K"
		add: 2560 @ 1440; "1440p"
		add: 1920 @ 1080. "1080p"
	(12 to: 8 by: -1) do: [ :i |
		extents add: (2 ** i) asPoint ].

	extents do: [ :eachExtent |
		benchClasses do: [ :eachBenchClass |
			self driverNames do: [ :eachDriverName |
				eachBenchClass new
					extent: eachExtent;
					sdlRenderDriverName: eachDriverName;
					runIterations: 200 ] ] ]

]

{ #category : #accessing }
SDL2TextureUpdateBench >> byteSize [

	^ 32 * extent x * extent y
]

{ #category : #accessing }
SDL2TextureUpdateBench >> extent: aPoint [

	extent := aPoint
]

{ #category : #initialization }
SDL2TextureUpdateBench >> initialize [

	super initialize.
	
	extent := 3840 @ 2160 "4K"
]

{ #category : #private }
SDL2TextureUpdateBench >> preparePixels [

	self subclassResponsibility
]

{ #category : #private }
SDL2TextureUpdateBench >> prepareToRun [

	OSSDL2Driver current. "Ensure SDL2 is initialized (may help if running headless)"

	sdlRenderDriverName ifNotNil: [
		SDL2 setHint: 'SDL_RENDER_DRIVER' value: sdlRenderDriverName ].
		
	sdlWindow :=
		SDL2
			createWindow: 'Bench'
			x: 100
			y: 100
			width: 800
			height: 600
			flags: SDL_WINDOW_HIDDEN.

	sdlRenderer := sdlWindow createAcceleratedRenderer.

	sdlTexture := 
		sdlRenderer
			createTextureFormat: SDL_PIXELFORMAT_ARGB8888
			access: self textureAccessType
			width: extent x
			height: extent y.
	sdlTexture signalErrorIfNull
]

{ #category : #private }
SDL2TextureUpdateBench >> printPhase1: phase1 phase2: phase2 [

	Stdio stdout

		<< (sdlRenderDriverName padRightTo: 8);
		<< (self title padRightTo: 8);
		<< (self byteSize humanReadableByteSizeString padLeftTo: 12);
		
		<< (extent x asString padLeftTo: 6);
		<< '@';
		<< (extent y asString padRightTo: 6);

		<< '    phase1 (avg min max): ';
		<< ((phase1 average printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((phase1 min printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((phase1 max printShowingDecimalPlaces: 2) padLeftTo: 5);

		<< '    phase2 (avg min max): ';
		<< ((phase2 average printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((phase2 min printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((phase2 max printShowingDecimalPlaces: 2) padLeftTo: 5);

		lf
]

{ #category : #running }
SDL2TextureUpdateBench >> runIterations: n [

	| result phase2 |
	self prepareToRun.
	result := OrderedCollection new: n.
	phase2 := OrderedCollection new: n.
	n timesRepeat: [
		1 milliSecond wait.
		result add: [ self preparePixels ] microsecondsToRun.
		phase2 add: [ self updatePixels ] microsecondsToRun ].
	self tearDownAfterRun.

	"Convert microseconds to ms"
	result := result / 1e3.
	phase2 := phase2 / 1e3.

	self
		printPhase1: result
		phase2: phase2
]

{ #category : #accessing }
SDL2TextureUpdateBench >> sdlRenderDriverName: aName [

	sdlRenderDriverName := aName
]

{ #category : #private }
SDL2TextureUpdateBench >> tearDownAfterRun [

	sdlTexture destroy.
	sdlRenderer destroy.
	sdlWindow destroy
]

{ #category : #private }
SDL2TextureUpdateBench >> textureAccessType [

	^ self subclassResponsibility
]

{ #category : #accessing }
SDL2TextureUpdateBench >> title [

	^ self subclassResponsibility
]

{ #category : #private }
SDL2TextureUpdateBench >> updatePixels [

	self subclassResponsibility
]
