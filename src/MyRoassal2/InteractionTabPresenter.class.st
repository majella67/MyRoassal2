"
I have a Interaction Widget Builder
TabManager Presenter in ShapePresenter has one of me.
I have a Interaction DropList Presenter (see Base Tab Presenter) so you can select the Interactions for a view or element in the view, you want to modify.
I have a Interaction Widget Builder which creates my widgets.
These widgets update ChangesPresenter.
I am a Base Tab Presenter.

"
Class {
	#name : #InteractionTabPresenter,
	#superclass : #BaseTabPresenter,
	#category : #'MyRoassal2-Interactions'
}

{ #category : #initialization }
InteractionTabPresenter >> initializeWidgets [
	super initializeWidgets.
	widgetBuilder := InteractionWidgetBuilder new

]

{ #category : #accessing }
InteractionTabPresenter >> view: aView [
	(aView isKindOf: RTView)
		ifTrue: [ view := aView.
			widgetBuilder shapes: aView elements.dropList
		items:
			{RTView.
			RTElement} ]
		ifFalse: [ GrowlMorph
				openWithLabel: ''
				contents: 'Invalid view '
				color: Color red ]
]
