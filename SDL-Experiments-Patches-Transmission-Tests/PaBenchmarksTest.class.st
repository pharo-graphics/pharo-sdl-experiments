Class {
	#name : #PaBenchmarksTest,
	#superclass : #TestCase,
	#category : #'SDL-Experiments-Patches-Transmission-Tests'
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
