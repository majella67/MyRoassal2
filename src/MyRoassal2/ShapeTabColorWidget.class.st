"
Shape Widget Builder  uses a  Color Widget Block  to create me.

I have a Label Presenter. 
I have a Image  Presenter. 
I have a Button Presenter. 

I open RGBWidget to adjust the color of Shapes.

Example
(self new colorWidget: RGBAWidget new; label: 'Example') openWithSpec .
"
Class {
	#name : #ShapeTabColorWidget,
	#superclass : #ComposablePresenter,
	#instVars : [
		'button',
		'image',
		'desc',
		'colorWidget'
	],
	#category : #'MyRoassal2-Shapes'
}

{ #category : #specs }
ShapeTabColorWidget class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :col | 
			col
				add: #desc origin: 0 @ 0 corner: 0.6 @ 1;
				add: #image origin: 0.6 @ 0 corner: 0.8 @ 1;
				add: #button origin: 0.8 @ 0 corner: 1 @ 1 ];
		yourself
]

{ #category : #accessing }
ShapeTabColorWidget >> button [
	^ button
]

{ #category : #accessing }
ShapeTabColorWidget >> button: anObject [
	button := anObject
]

{ #category : #accessing }
ShapeTabColorWidget >> color [ 
^ image color 
]

{ #category : #accessing }
ShapeTabColorWidget >> color: aColor [
	image image fillColor: aColor
]

{ #category : #accessing }
ShapeTabColorWidget >> colorWidget [
^ colorWidget

]

{ #category : #accessing }
ShapeTabColorWidget >> colorWidget: aRGBAWidget [
	colorWidget := aRGBAWidget.
	self color: aRGBAWidget color.
]

{ #category : #accessing }
ShapeTabColorWidget >> desc [
	^ desc
]

{ #category : #accessing }
ShapeTabColorWidget >> desc: anObject [
	desc := anObject
]

{ #category : #accessing }
ShapeTabColorWidget >> image [
	^ image
]

{ #category : #accessing }
ShapeTabColorWidget >> image: anObject [
	image := anObject
]

{ #category : #'as yet unclassified' }
ShapeTabColorWidget >> initializePresenters [ 	button
		action: [ colorWidget isNotNil
				ifTrue: [ colorWidget sliders
						whenChangedDo: [ image
								image: ((Form extent: 30 @ 30 depth: 32) fillColor: colorWidget color) ].
					button disable.
					colorWidget openWithSpec whenClosedDo: [ button enable ] ] ].

]

{ #category : #'as yet unclassified' }
ShapeTabColorWidget >> initializeWidgets [
	button := ButtonPresenter new.
	image := ImagePresenter new.
	desc := LabelPresenter new.
	colorWidget := nil.
	button
		label: 'Edit';
		action: [ colorWidget isNotNil
				ifTrue: [ colorWidget sliders whenChangedDo: [ image image: ((Form extent: 30 @ 30 depth: 32) fillColor: (colorWidget color)) ].  button disable. 
					colorWidget openWithSpec whenClosedDo: [ button enable ] ] ].
	desc label: 'Nothing yet'.
	image
		image: ((Form extent: 30 @ 30 depth: 32) fillColor: Color random).
	self focusOrder
		add: desc;
		add: image;
		add: button
]

{ #category : #accessing }
ShapeTabColorWidget >> label: aText [
	desc label: aText 
]
