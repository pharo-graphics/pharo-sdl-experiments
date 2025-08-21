"
I'm an object whose mutations are written as patches. Accessors return the value from a patch, if available, or from the patcheable object, otherwise.
"
Class {
	#name : #Patcheable,
	#superclass : #Object,
	#instVars : [
		'patch'
	],
	#category : #'SDL-Experiments-Patches'
}
