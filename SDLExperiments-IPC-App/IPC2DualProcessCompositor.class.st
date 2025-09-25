Class {
	#name : #IPC2DualProcessCompositor,
	#superclass : #IPC2Compositor,
	#instVars : [
		'commandService'
	],
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #testing }
IPC2DualProcessCompositor class >> isAbstract [

	^ self == IPC2DualProcessCompositor
]

{ #category : #accessing }
IPC2DualProcessCompositor >> commandService [

	^ commandService
]

{ #category : #'as yet unclassified' }
IPC2DualProcessCompositor >> ping [

	commandService
		sendCommand: IPC2Ping new
		onSuccess: [ :data |
			| t1 t2 t3 |
			t1 := data first.
			t2 := data second.
			t3 := Time microsecondClockValue.

			IPC2Log current
				logPingSendMicroseconds: t2 - t1 
				answerMicroseconds: t3 - t2 ]
]

{ #category : #initialization }
IPC2DualProcessCompositor >> startCommandServiceOn: socketStream onSuccess: aBlock [

	commandService := IPC2CommandService on: socketStream.
	commandService owner: self.
	commandService runningStartBlock: aBlock.
	commandService start
]

{ #category : #'as yet unclassified' }
IPC2DualProcessCompositor >> terminate [

	commandService ifNotNil: [
		commandService stop.
		commandService := nil ].

]
