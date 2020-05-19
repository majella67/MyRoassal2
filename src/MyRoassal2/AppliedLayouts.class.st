"
When the LAyout DropListPresenter SelectionChanges calls    the Selected Layout Class is added to me. 
appLayouts has 0.many Layout Class Keys.
I  have a Dictionary appLayouts
Each key has a Layout
Layouts saved in the Dictionary are used to apply to the view being tweaked.
Changes made to tweaks are stored here for later recall.
 
"
Class {
	#name : #AppliedLayouts,
	#superclass : #Object,
	#instVars : [
		'appLayouts'
	],
	#category : #'MyRoassal2-Layouts'
}

{ #category : #adding }
AppliedLayouts >> addLayout: aLayout [
	appLayouts at: aLayout class ifPresent: [ ] ifAbsentPut: [aLayout]	"translator: RTSmoothLayoutTranslator new"
]

{ #category : #accessing }
AppliedLayouts >> clear [
	appLayouts  removeAll
]

{ #category : #adding }
AppliedLayouts >> getLayoutFor: aLayoutClass [
	^ appLayouts at: aLayoutClass  ifAbsent: [ nil ]
]

{ #category : #accessing }
AppliedLayouts >> initialize [
	appLayouts := Dictionary new
]

{ #category : #adding }
AppliedLayouts >> layouts [
^appLayouts 
]

{ #category : #adding }
AppliedLayouts >> removeLayout: aLayout [
	appLayouts  removeKey: aLayout ifAbsent: [  ]
]
