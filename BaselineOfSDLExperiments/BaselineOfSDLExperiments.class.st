Class {
	#name : #BaselineOfSDLExperiments,
	#superclass : #BaselineOf,
	#category : #BaselineOfSDLExperiments
}

{ #category : #baselines }
BaselineOfSDLExperiments >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			self declareAlexandrieOn: spec.

			"Experimental windows using direct SDL2 FFI calls (skip OSWindow abstraction layer)"
			spec
				package: 'SDLExperiments' with: [ spec requires: #('Alexandrie' 'SDLExperiments-FFI') ];
				package: 'SDLExperiments-Demo' with: [ spec requires: #('Alexandrie' 'SDLExperiments') ];
				package: 'SDLExperiments-FFI';
				package: 'SDLExperiments-Tests' with: [ spec requires: #('SDLExperiments') ].

			"Experimental collections"
			spec
				package: 'SDLExperiments-RTree';
				package: 'SDLExperiments-BooleanArray'.

			"Experimental IPC window compositor architecture"
			self
				declareSoilOn: spec;
				declareOSSubprocessOn: spec;
				declareOSWinSubprocessOn: spec.
			spec
				package: 'SDLExperiments-IPC-Patches';
				package: 'SDLExperiments-IPC-Patches-Tests' with: [
					spec requires: #('SDLExperiments-IPC-Patches') ];

				package: 'SDLExperiments-IPC-Patches-Transmission' with: [
					spec requires: #('SDLExperiments-IPC-Patches') ];
				package: 'SDLExperiments-IPC-Patches-Transmission-Tests' with: [
					spec requires: #('SDLExperiments-IPC-Patches-Transmission') ];

				package: 'SDLExperiments-IPC-App' with: [
					spec requires: #(
						'SDLExperiments-IPC-Patches-Transmission-Tests'
						'Soil'
						'OSSubprocess'
						'OSWinSubprocess') ]

			]
]

{ #category : #'external projects' }
BaselineOfSDLExperiments >> declareAlexandrieOn: spec [

	spec
		baseline: 'Alexandrie'
		with: [ spec repository: 'github://pharo-graphics/Alexandrie:master/src' ]
]

{ #category : #'external projects' }
BaselineOfSDLExperiments >> declareOSSubprocessOn: spec [

	spec
		baseline: 'OSSubprocess'
		with: [ spec repository: 'github://pharo-contributions/OSSubprocess:master/repository' ]
]

{ #category : #'external projects' }
BaselineOfSDLExperiments >> declareOSWinSubprocessOn: spec [

	spec
		baseline: 'OSWinSubprocess'
		with: [ spec repository: 'github://pharo-contributions/OSWinSubprocess:master/repository' ]
]

{ #category : #'external projects' }
BaselineOfSDLExperiments >> declareSoilOn: spec [

	spec
		baseline: 'Soil'
		with: [ spec repository: 'github://ApptiveGrid/Soil:v3/src' ]
]
