"
I'm a binding to the typedef `SDL_EventFilter`.

A function pointer used for callbacks that watch the event queue.

This works in a Workspace in Pharo 14:
```
count := 0.

filter := SDL_EventFilter on: [ :data :event | 
	count := count + 1 ].

SDL2 addEventWatch: filter userdata: nil.
```
(inspect count from time to time)

See: https://wiki.libsdl.org/SDL2/SDL_EventFilter
"
Class {
	#name : #'SDL_EventFilter',
	#superclass : #FFICallback,
	#category : #'SDLExperiments-FFI'
}

{ #category : #'as yet unclassified' }
SDL_EventFilter class >> exampleCountAll [

	| count filter |
	count := 0.

	filter := SDL_EventFilter on: [ :data :event | count := count + 1 ].

	SDL2 addEventWatch: filter userdata: nil
]

{ #category : #'callback spec' }
SDL_EventFilter class >> fnSpec [

	^'int (void *userdata, SDL_Event event)'
]

{ #category : #'instance creation' }
SDL_EventFilter class >> on: aBlock [

	^ self signature: self fnSpec block: aBlock
]
