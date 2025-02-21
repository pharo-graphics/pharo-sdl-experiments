"
I'm a demo where multiple circles translate, and only some of them are animated.

"
Class {
	#name : #AnimatedCirclesDemo,
	#superclass : #BenchmarkingDemo,
	#instVars : [
		'numberOfCircles',
		'numberOfAnimatedCircles'
	],
	#category : #'SDLExperiments-Demo-Benchmarks'
}

{ #category : #running }
AnimatedCirclesDemo class >> driverNames [

	| driverNames |
	driverNames := SDL2 renderDriverInfos collect: #nameString.
	driverNames := driverNames copyWithout: 'opengles2'.
	driverNames := driverNames copyWithout: 'software'.
"	driverNames := #(metal)."
"	driverNames := #(opengl)."
	^ driverNames
]

{ #category : #running }
AnimatedCirclesDemo class >> runAlternatives [
	<script: '[ self runAlternatives ] fork'>

	| managers driverNames |
	managers := {
		AtlasTileManager new
			atlasPixelExtent: 2048 asPoint;
			yourself.
		TextureTileManager newStatic.
		TextureTileManager newStreaming.
		CairoDirectTileManager new }.

	self driverNames do: [ :eachDriverName |
		
'
=== Driver name: ' trace.
		eachDriverName trace.
		' ===' traceCr.
		
		#(
			(200 0 '200 static')
			(50 50 '50 animated')
		) do: [ :circleData |

			'
--- ' trace.
			circleData third trace.
			' ---' traceCr.

			managers do: [ :eachManager |
				| aDemo |
				aDemo := self new.
				aDemo
					durationMS: 5000;
					numberOfCircles: circleData first;
					numberOfAnimatedCircles: circleData second.
				aDemo sceneWindow
					tileManager: eachManager;
					sdlRenderDriverName: eachDriverName.

				0.5 seconds wait.
				Smalltalk garbageCollect.

				aDemo run.
				'' traceCr.
				eachManager asString traceCr.
				aDemo reportOnTranscript ] ] ].
'
=== Done ===' traceCr.

]

{ #category : #running }
AnimatedCirclesDemo class >> runAnimatedTiles [
	<script: '[ self runAnimatedTiles ] fork'>

	| managers |
	managers := {
		AtlasTileManager new
			atlasPixelExtent: 2048 asPoint;
			yourself.
		TextureTileManager newStatic.
		TextureTileManager newStreaming.
		CairoDirectTileManager new }.

	self driverNames do: [ :eachDriverName |

'
=== Driver name: ' trace.
		eachDriverName trace.
		' ===' traceCr.
		
		#(
			(50 50 '50 animated')
			(100 100 '100 animated')
			(200 200 '200 animated')
		) do: [ :circleData |

			'
--- ' trace.
			circleData third trace.
			' ---' traceCr.

			managers do: [ :eachManager |
				| aDemo |
				aDemo := self new.
				aDemo
					durationMS: 4000;
					numberOfCircles: circleData first;
					numberOfAnimatedCircles: circleData second.
				aDemo sceneWindow
					tileManager: eachManager;
					sdlRenderDriverName: eachDriverName.

				0.5 seconds wait.
				Smalltalk garbageCollect.

				aDemo run.
				'' traceCr.
				eachManager asString traceCr.
				aDemo reportOnTranscript ] ] ].
'
=== Done ===' traceCr.

]

{ #category : #running }
AnimatedCirclesDemo class >> runAtlasExtents [
	<script: '[ self runAtlasExtents ] fork'>

	| managers |
	managers := {
		AtlasTileManager new.
		AtlasTileManager new
			atlasPixelExtent: 8192 asPoint;
			yourself.
		AtlasTileManager new
			atlasPixelExtent: 4096 asPoint;
			yourself.
		AtlasTileManager new
			atlasPixelExtent: 2048 asPoint;
			yourself }.

	self driverNames do: [ :eachDriverName |
		
'
=== Driver name: ' trace.
		eachDriverName trace.
		' ===' traceCr.
		
		#(
			(200 0  '200 static')
			(500 0  '500 static')
			(1000 0 '1000 static')
		) do: [ :circleData |

			'
--- ' trace.
			circleData third trace.
			' ---' traceCr.

			managers do: [ :eachManager |
				| aDemo |
				aDemo := self new.
				aDemo
					durationMS: 3000;
					numberOfCircles: circleData first;
					numberOfAnimatedCircles: circleData second.
				aDemo sceneWindow
					tileManager: eachManager;
					sdlRenderDriverName: eachDriverName.

				0.5 seconds wait.
				Smalltalk garbageCollect.

				aDemo run.
				'' traceCr.
				eachManager asString traceCr.
				aDemo reportOnTranscript ] ] ].
'
=== Done ===' traceCr.

]

{ #category : #running }
AnimatedCirclesDemo class >> runCopyVsRenderGeometry [
	<script: '[ self runCopyVsRenderGeometry ] fork'>

	| durationMS managers |
	durationMS := 10000.
	managers := {
		TextureTileManager newStatic.
		TextureTileManager new useSDLRenderGeometryStaticTile; yourself.
		}.

	self driverNames do: [ :eachDriverName |
		
'
=== Driver name: ' trace.
		eachDriverName trace.
		' ===' traceCr.
		
		#(
			(200 0 '200 static')
		) do: [ :circleData |

			'
--- ' trace.
			circleData third trace.
			' ---' traceCr.

			managers do: [ :eachManager |
				| aDemo |
				aDemo := self new.
				aDemo
					durationMS: durationMS;
					numberOfCircles: circleData first;
					numberOfAnimatedCircles: circleData second.
				aDemo sceneWindow
					tileManager: eachManager;
					sdlRenderDriverName: eachDriverName.

				3 timesRepeat: [
					Smalltalk garbageCollect.
					100 milliSeconds wait ].

				aDemo run.
				'' traceCr.
				eachManager asString traceCr.
				aDemo reportOnTranscript ] ] ].
'
=== Done ===' traceCr.

]

{ #category : #running }
AnimatedCirclesDemo class >> runPixelatedOffVsOn [
	<script: '[ self runPixelatedOffVsOn ] fork'>

	| durationMS managers driverNames |
	durationMS := 5000.
	managers := {
		TextureTileManager newStatic.
		TextureTileManager new useSDLPixelatedStaticTile; yourself.
		}.

	driverNames := #(opengl).
	driverNames do: [ :eachDriverName |
		
'
=== Driver name: ' trace.
		eachDriverName trace.
		' ===' traceCr.
		
		#(
			(200 0 '100 static none animated')
			(200 100 '100 static 100 animated')
		) do: [ :circleData |

			'
--- ' trace.
			circleData third trace.
			' ---' traceCr.

			managers do: [ :eachManager |
				| aDemo |
				aDemo := self new.
				aDemo
					durationMS: durationMS;
					numberOfCircles: circleData first;
					numberOfAnimatedCircles: circleData second.
				aDemo sceneWindow
					tileManager: eachManager;
					sdlRenderDriverName: eachDriverName.

				3 timesRepeat: [
					Smalltalk garbageCollect.
					100 milliSeconds wait ].

				aDemo run.
				'' traceCr.
				eachManager asString traceCr.
				aDemo reportOnTranscript ] ] ].
'
=== Done ===' traceCr.

]

{ #category : #initialization }
AnimatedCirclesDemo >> initialize [

	super initialize.

	numberOfCircles := 100.
	numberOfAnimatedCircles := 10

]

{ #category : #accessing }
AnimatedCirclesDemo >> numberOfAnimatedCircles: aNumber [

	numberOfAnimatedCircles := aNumber
]

{ #category : #accessing }
AnimatedCirclesDemo >> numberOfCircles: aNumber [

	numberOfCircles := aNumber
]

{ #category : #running }
AnimatedCirclesDemo >> prepareSceneWindow [

	1 to: numberOfCircles do: [ :index |
		| circleRadius lineWidth padding from relativeTo isAnimated initialColor anElement |
		circleRadius := random
			nextIntegerBetween: 10
			and: sceneWindow logicalExtent x / 7.
		lineWidth := random
			nextIntegerBetween: 1
			and: circleRadius/3.
		padding := lineWidth.
		from := Point
			x: (random 
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent x - (circleRadius*2))
			y: (random
					nextIntegerBetween: 0
					and: sceneWindow logicalExtent y - (circleRadius*2)).
		relativeTo := Point
			x: (random nextIntegerBetween: -100 and: 100)
			y: (random nextIntegerBetween: -100 and: 100).
		isAnimated := index > (numberOfCircles - numberOfAnimatedCircles).
		initialColor := Color newRandomWith: random.

		anElement := sceneWindow addElement.
		
		anElement
			isAnimated: isAnimated;
			opacity: (random next >= 0.5
				ifTrue: [ 1.0 ]
				ifFalse: [ 0.5 ]);
			position: from;
			extent: ((circleRadius + padding) *2) asPoint;
			stepBlock: [ :deltaMS :totalMS |
				| amount |
				amount := totalMS / durationMS.
				anElement position: from + (relativeTo * amount) ];
			renderBlock: [ :cairoContext |
				cairoContext
					sourceColor:
						(isAnimated
							ifTrue: [ Color random: random ]
							ifFalse: [ initialColor ]);
					translateByX: padding y: padding;
					strokeSize: lineWidth;
					strokeCap: AeCairoStrokeCap square;
					strokeDashPattern: { 0. lineWidth * 2 };
					circleRadius: circleRadius;
					stroke ] ]
]

{ #category : #running }
AnimatedCirclesDemo >> run [
	<script: '[self new run; reportOnTranscript] fork'>

	super run
]
