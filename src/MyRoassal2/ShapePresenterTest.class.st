"
A ShapePresenterTest is a test class for testing the behavior of ShapePresenter
"
Class {
	#name : #ShapePresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'sP'
	],
	#category : #'MyRoassal2-Tests'
}

{ #category : #'as yet unclassified' }
ShapePresenterTest >> setupView [
	| v es c arrow |
	v := RTView new.
	c := RTMultiLinearColor new.
	es := (RTEllipse new
		size: 30;
		color: [ :e | c level: e / 10 ]) elementsOn: (1 to: 10).
	v addAll: es.
	es @ RTDraggable.
	arrow := RTArrowedLine new
simple;
		color: Color red;
		attachPoint: RTVerticalAttachPoint instance.
	RTEdgeBuilder new
		view: v;
		objects: (1 to: 10);
		shape: arrow;
		connectFrom: [ :n | n // 2 ] to: #yourself.
	RTTreeLayout new on: es.
	^ v
]

{ #category : #test }
ShapePresenterTest >> testEvaluateFilterScript [
	self testPView.
	sP evaluateFilterScript: 'nil'.
	self assert: sP fView canvas shapes size equals: 0.	"receiver of do is ni message displayed"
	sP evaluateFilterScript: 'pView  elements , pView edges'.
	self assert: sP fView canvas shapes size equals: 28.
	sP
		evaluateFilterScript: 'pView  edges select: [:each | each shape class = RTArrowedLine]'.
	self assert: sP fView canvas shapes size equals: 18. 
		self assert: sP fView elements  size equals: 0. 
				self assert: sP fView edges  size equals: 9. 
	sP
		evaluateFilterScript:
			'pView  elements select: [:each | each shape class = RTEllipse ifTrue:[ each  model //3 =1] ifFalse:[false] ]'.
	self assert: sP fView canvas shapes size equals: 3.
	
sP pView
]

{ #category : #test }
ShapePresenterTest >> testInitializeWidgets [
	| nScriptString |
	sP := ShapePresenter new.
	nScriptString := '[ :aview :aCanvas | self draw: aview canvas: aCanvas ]'.
	self assert: sP filteredView class equals: RoassalModel.
	self assert: sP script class equals: GlamourPresentationPresenter.
	self assert: sP pView class equals: RTView .
		self assert: sP fView class equals: RTView .
	self assert: sP focusOrder size equals: 4.
	self
		assert: sP focusOrder second class
		equals: RoassalModel.
	self assert: sP focusOrder first class equals: GlamourPresentationPresenter.
	self assert: sP newViewScript asText asString equals: nScriptString.
	self
		assert: sP filteredView script asText asString
		equals: nScriptString.
	self
		assert: sP script glmPres variableBindings
		equals: {(#pView ->  sP pView )}

]

{ #category : #test }
ShapePresenterTest >> testPView [
	sP := ShapePresenter new.
	self testInitializeWidgets.
	sP buildWithSpec.	"needed for fView to be initialized"
	sP pView: self setupView.
	self assert: sP fView canvas shapes  size equals: 28.
	self assert: sP pView  canvas shapes  size equals: 28.
		self
		assert: sP script glmPres variableBindings
		equals: {(#pView -> sP pView)}
]
