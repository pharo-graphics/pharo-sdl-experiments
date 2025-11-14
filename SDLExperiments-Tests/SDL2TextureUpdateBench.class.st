"
Benchmark the update of `SDL_Texture` pixel contents. 

See: https://github.com/pharo-graphics/pharo-sdl-experiments/wiki#headless-benchmark
"
Class {
	#name : #SDL2TextureUpdateBench,
	#superclass : #Object,
	#instVars : [
		'sdlWindow',
		'sdlRenderer',
		'sdlTexture',
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
	Stdio stdout
		<< '--- '; << self name; << ' ---'; lf; lf;
		<< '* Cairo: '; << AeCairoLibrary uniqueInstance versionString; lf;
		<< '* SDL2: '; << SDL2 version versionString; lf;
		lf.
	
	benchClasses := { SDL2StaticTextureUpdateBench. SDL2StreamingTextureUpdateBench }.
"	benchClasses := { SDL2StreamingTextureUpdateBench }."
	
	extents := SortedCollection
		sortBlock: [ :a :b | (a x * a y) < (b x * b y) ].
	extents
		add: 3840 @ 2160; "4K"
		add: 2560 @ 1440; "1440p"
		add: 1920 @ 1080. "1080p"
	(12 to: 8 by: -1) do: [ :i |
		extents add: (2 ** i) asPoint ].

	extents
		do: [ :eachExtent |
			benchClasses do: [ :eachBenchClass |
				self driverNames do: [ :eachDriverName |
					eachBenchClass new
						extent: eachExtent;
						sdlRenderDriverName: eachDriverName;
						runIterations: 200 ] ] ]
		separatedBy: [ Stdio stdout lf ]

]

{ #category : #accessing }
SDL2TextureUpdateBench >> byteSize [

	^ 32 * extent x * extent y
]

{ #category : #accessing }
SDL2TextureUpdateBench >> extent: aPoint [

	extent := aPoint
]

{ #category : #private }
SDL2TextureUpdateBench >> printStepA: msA stepB: msB stepC: msC [

	| totalMS |
	totalMS := msA + msB + msC.

	Stdio stdout

		<< (sdlRenderDriverName padRightTo: 12);
		<< (self title padRightTo: 8);
		<< (self byteSize humanReadableByteSizeString padLeftTo: 9);
		
		<< (extent x asString padLeftTo: 6);
		<< '@';
		<< (extent y asString padRightTo: 6);

		<< '  sum: ';
		<< ((totalMS average printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((totalMS min printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((totalMS max printShowingDecimalPlaces: 2) padLeftTo: 5);

		<< '    pre: ';
		<< ((msA average printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((msA min printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((msA max printShowingDecimalPlaces: 2) padLeftTo: 5);

		<< '    cairo: ';
		<< ((msB average printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((msB min printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((msB max printShowingDecimalPlaces: 2) padLeftTo: 5);

		<< '    update: ';
		<< ((msC average printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((msC min printShowingDecimalPlaces: 2) padLeftTo: 5);
		<< ' ';
		<< ((msC max printShowingDecimalPlaces: 2) padLeftTo: 5);

"		<< ' (avg min max)';"
		lf
]

{ #category : #running }
SDL2TextureUpdateBench >> runIterations: n [

	| ms1 ms2 ms3 |
	ms1 := OrderedCollection new: n.
	ms2 := OrderedCollection new: n.
	ms3 := OrderedCollection new: n.

	self setUp.
	n timesRepeat: [
		1 milliSecond wait.
		ms1 add: [ self stepA ] microsecondsToRun.
		ms2 add: [ self stepB ] microsecondsToRun.
		ms3 add: [ self stepC ] microsecondsToRun ].
	self tearDown.

	"Convert microseconds to ms"
	ms1 := ms1 / 1e3.
	ms2 := ms2 / 1e3.
	ms3 := ms3 / 1e3.

	self printStepA: ms1 stepB: ms2 stepC: ms3
]

{ #category : #accessing }
SDL2TextureUpdateBench >> sdlRenderDriverName: aName [

	sdlRenderDriverName := aName
]

{ #category : #private }
SDL2TextureUpdateBench >> setUp [

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
	sdlTexture blendMode: SDL2 premultipliedAlphaBlendMode.
	sdlTexture signalErrorIfNull
]

{ #category : #private }
SDL2TextureUpdateBench >> stepA [
	"Prepare the texture as on a new frame (e.g. lock)"

	self subclassResponsibility
]

{ #category : #private }
SDL2TextureUpdateBench >> stepB [
	"Render that pixels using cairo (still do not update the texture)"

	self subclassResponsibility
]

{ #category : #private }
SDL2TextureUpdateBench >> stepC [
	"Update the texture with the fresh pixels"

	self subclassResponsibility
]

{ #category : #private }
SDL2TextureUpdateBench >> tearDown [

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
