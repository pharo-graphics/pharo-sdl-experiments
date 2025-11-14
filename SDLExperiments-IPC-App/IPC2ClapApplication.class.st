"
I'm a Clap command line application to start a `IPC2SecondaryCompositor` (Intended for internal use).
"
Class {
	#name : #IPC2ClapApplication,
	#superclass : #ClapApplication,
	#category : #'SDLExperiments-IPC-App'
}

{ #category : #accessing }
IPC2ClapApplication class >> commandName [

	^ #ipc2
]

{ #category : #'command line' }
IPC2ClapApplication class >> specification [
	<commandline>

	^ (ClapCommandSpec id: self commandName)
		commandClass: self;
		description: 'Reserved for internal use in ', self packageName, ' package';
		addPositional: #PORT
			description: 'Socket port where a ', IPC2SecondaryCompositor name, ' must connect to a ', IPC2PrimaryCompositor name, ', that listens.';
		yourself
]

{ #category : #execution }
IPC2ClapApplication >> execute [

	| socketStream portNumber |
	OSWindowDriver current startUp: true.

	"Change desktop background to easily differenciate Pharo images"
	self currentWorld color: Color random.

	portNumber := (self positional: #PORT) asInteger.
	IPC2Log current logSecondaryProcessLaunchedOnPort: portNumber.

	socketStream :=
		ZdcSocketStream
			openConnectionToHost: #[127 0 0 1]
			port: portNumber.

	IPC2SecondaryCompositor current
		startCommandServiceOn: socketStream
		onSuccess: [
			IPC2Log current logSecondaryProcessLaunchedOnPort: portNumber ].

	self flag: #todo. "Workaround: The Halt keeps the image alive"
	Halt now
]
