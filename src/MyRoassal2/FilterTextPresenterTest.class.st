"
A FilterTextPresenterTest is a test class for testing the behavior of FilterTextPresenter
"
Class {
	#name : #FilterTextPresenterTest,
	#superclass : #TestCase,
	#category : #'MyRoassal2-Tests'
}

{ #category : #tests }
FilterTextPresenterTest >> testInitializeWidgets [
	| fT |
	fT := DiagramTextPresenter new.
	self assert: fT filter class equals: TextInputFieldPresenter.
	self assert: fT filter ghostText equals: 'Showing All'.
	self assert: fT filter autoAccept equals: false.

	self assert: fT text hasUnacceptedEdits equals: true.
	self assert: fT saveFile equals: nil
]
