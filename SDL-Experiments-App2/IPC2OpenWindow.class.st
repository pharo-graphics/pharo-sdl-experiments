Class {
	#name : #IPC2OpenWindow,
	#superclass : #Object,
	#instVars : [
		'title'
	],
	#category : #'SDL-Experiments-App2'
}

{ #category : #accessing }
IPC2OpenWindow >> title: aString [ 
	title := aString
]

{ #category : #accessing }
IPC2OpenWindow >> value: commandService [

	^ IPC2CompositorListener current openWindow: title
]
