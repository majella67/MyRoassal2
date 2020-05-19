"
A DiagramTextPresenterTest is a test class for testing the behavior of DiagramTextPresenter
"
Class {
	#name : #DiagramTextPresenterTest,
	#superclass : #TestCase,
	#category : #'MyRoassal2-Tests'
}

{ #category : #test }
DiagramTextPresenterTest >> testGetLinesOfTextFrom [
	| dTP |
	dTP := DiagramTextPresenter new.
	^ ({'[Waiting to Fix ]is a [Fixing]' . '[Waiting to Fix ][Fixing]'.
	'[]' . '[Waiting to Fix ] [Fixing]'}
		collect:
			[ :each | (dTP getLinesOfTextFrom: each) asArray ])
				=
					{{'[Waiting to Fix ]' . 'is a ' . '[Fixing]'}.
					{'[Waiting to Fix ]' . '[Fixing]'}.
					{'[]'}.
					{'[Waiting to Fix ]' . ' ' . '[Fixing]'}}
]
