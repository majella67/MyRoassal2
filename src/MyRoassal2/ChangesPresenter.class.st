"
MyRoassal2 has one of me 
I am a Text Presenter with a Code Snippet Dictionary (dict)
I update the  Text Presenter Text using dict.
Widgets in the LayoutTabPresenter, ShapeTabPresenter and InteractionTabPresenter update the text in my TextPresenter using dict. 

This allows the values to be stored along with their respective selectors.

"
Class {
	#name : #ChangesPresenter,
	#superclass : #TextPresenter,
	#instVars : [
		'dict'
	],
	#category : #'MyRoassal2-Core'
}

{ #category : #initialization }
ChangesPresenter >> initializeWidgets [
	super initializeWidgets.
		dict := Dictionary new
]

{ #category : #private }
ChangesPresenter >> updateTextWith: aTRShapeClass selector: aString value: aValue [
dict
		at:
			{aTRShapeClass asString.
			aString}
		put: aValue asString.
	self
		text:
			(dict associations
				inject: ''
				into: [ :all :each | 
					all , each key second , ' ' , each value asString , ' "'
						, each key first , '"' , String cr ])
]
