"
I have a Shape Widget Builder
TabManager Presenter in ShapePresenter has one of me.
I have a Shape DropList Presenter (see Base Tab Presenter) so you can select the shapes in the view, you want to modify.
I have a Shape Widget Builder which creates my widgets.
These widgets update ChangesPresenter.
I am a Base Tab Presenter.


"
Class {
	#name : #ShapeTabPresenter,
	#superclass : #BaseTabPresenter,
	#category : #'MyRoassal2-Shapes'
}

{ #category : #specs }
ShapeTabPresenter class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #dropList height: self toolbarHeight;
		add: #widgets; yourself
]

{ #category : #initialization }
ShapeTabPresenter >> initializeWidgets [
super initializeWidgets .
	widgetBuilder := ShapeWidgetBuilder new.

]

{ #category : #accessing }
ShapeTabPresenter >> view: aView [
	(aView isKindOf: RTView)
		ifTrue: [ view := aView.
			widgetBuilder shapes: aView edges , aView elements.
			dropList
				items:
					((aView edges collect: [ :each | each shape class ])
						, (aView elements collect: [ :each | each shape class ])) removeDuplicates ]
		ifFalse: [ GrowlMorph
				openWithLabel: ''
				contents: 'Invalid view '
				color: Color red ]
]
