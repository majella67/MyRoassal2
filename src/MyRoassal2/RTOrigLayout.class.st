"
I store :-
	the positions of elements and
	the attachpoints of edges 
	in a View.
	
I restore :-
	the positions of elements and
	the attachpoints of edges 
	in a View.
	
This allows reverting to the original Layout of a view after changing its layout. 
"
Class {
	#name : #RTOrigLayout,
	#superclass : #RTLayout,
	#instVars : [
		'savedElems',
		'savedEdegs',
		'savedEdges'
	],
	#category : #'MyRoassal2-Extensions'
}

{ #category : #'initialize-release' }
RTOrigLayout >> initialize [
	super initialize.
	savedElems := Dictionary new.
		savedEdges  := Dictionary new
]

{ #category : #'initialization - private' }
RTOrigLayout >> saveAttribOf: aView [

	savedElems removeAll.
	savedEdges removeAll.
	aView elements do: [ :each | savedElems at: each put: each position ].
	aView edges
		do: [ :each | savedEdges at: each put: each shape attachPoint ]
]
