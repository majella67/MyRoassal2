"
An AppliedLayoutsTest is a test class for testing the behavior of AppliedLayouts
"
Class {
	#name : #AppliedLayoutsTest,
	#superclass : #TestCase,
	#instVars : [
		'appliedLayouts',
		'aView'
	],
	#category : #'MyRoassal2-Tests'
}

{ #category : #'initialization - private' }
AppliedLayoutsTest >> setup [
	aView := ShapePresenterTest new setupView.
	appliedLayouts := AppliedLayouts new.

]

{ #category : #test }
AppliedLayoutsTest >> testAddLayout [
	| aLayout |
	self setup.
	self assert: appliedLayouts layouts size equals: 0.
		self assert: (appliedLayouts getLayoutFor: RTOrigLayout) equals: nil.
	aLayout := RTOrigLayout new saveAttribOf: aView.
	appliedLayouts addLayout: aLayout.
	self assert: appliedLayouts layouts size equals: 1.
	self assert: (appliedLayouts getLayoutFor: RTOrigLayout) equals: aLayout
]

{ #category : #test }
AppliedLayoutsTest >> testClear [
	self setup.
	self testAddLayout .
	self
		assert: (appliedLayouts getLayoutFor: RTOrigLayout ) isNotNil
		equals: true.
	appliedLayouts clear.
	self
		assert: (appliedLayouts getLayoutFor: RTOrigLayout )
		equals: nil.
	self assert: appliedLayouts layouts size equals: 0
]

{ #category : #test }
AppliedLayoutsTest >> testInitialize [
	self assert: appliedLayouts equals: nil.
	self setup.
	self assert: appliedLayouts isNotNil equals: true.
	self assert: appliedLayouts layouts size equals: 0.
	self
		assert: (appliedLayouts getLayoutFor: RTOrigLayout )
		equals: nil
]

{ #category : #test }
AppliedLayoutsTest >> testRemoveLayout [
	self setup.
	self testAddLayout.
	appliedLayouts removeLayout: RTOrigLayout .
	self
		assert: (appliedLayouts getLayoutFor: RTOrigLayout )
		equals: nil.
	self assert: appliedLayouts layouts size equals: 0
]
