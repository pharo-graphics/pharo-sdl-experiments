Class {
	#name : #PaBenchmarksTest,
	#superclass : #TestCase,
	#category : #'SDLExperiments-IPC-Patches-Transmission-Tests'
}

{ #category : #tests }
PaBenchmarksTest >> testBenchIntegerOpacity [

	PaBenchmarks new benchIntegerOpacity
]

{ #category : #tests }
PaBenchmarksTest >> testBenchNilToOneOpacity [

	PaBenchmarks new benchNilToOneOpacity
]

{ #category : #tests }
PaBenchmarksTest >> testBenchRandomOpacity [

	PaBenchmarks new benchRandomOpacity
]
