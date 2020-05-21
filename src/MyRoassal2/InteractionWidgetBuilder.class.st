"
Interaction Tab Presenter has one of me. 
I build Interaction Widgets for the Interaction Tab Presenter.
I have a Interaction Dictionary for elements.
I have a Interaction Dictionary for the view.
Currently, I only build CheckBoxPresenters.
"
Class {
	#name : #InteractionWidgetBuilder,
	#superclass : #DynamicPresentersListBuilder,
	#instVars : [
		'shapes',
		'cPresenter',
		'viewCodeScript',
		'elementCodeScript'
	],
	#category : #'MyRoassal2-Interactions'
}

{ #category : #'build ui' }
InteractionWidgetBuilder >> buildListFor: aRTShapeORRTView [
	shapes isNotEmpty
		ifTrue: [ aRTShapeORRTView = RTElement
				ifTrue: [ ^ self
						modelObjects: self elementInteractions;
						presenter: ShapePresenterWidget
							configuredAs: [ :p :m | p presenter: m value value ];
						layoutBuilder: (DynamicLeftToRightColumnsLayout columns: 4);
						build ]
				ifFalse: [ aRTShapeORRTView = RTView
						ifTrue: [ ^ self
								modelObjects: (self viewInteractions: RTView);
								presenter: ShapePresenterWidget
									configuredAs: [ :p :m | 

									p presenter: m value value ];
								layoutBuilder: (DynamicLeftToRightColumnsLayout columns: 4);
								build ] ] ]
		ifFalse: [ ^ nil ]
]

{ #category : #accessing }
InteractionWidgetBuilder >> cPresenter [
	^ cPresenter
]

{ #category : #accessing }
InteractionWidgetBuilder >> cPresenter: anObject [
	cPresenter := anObject
]

{ #category : #accessing }
InteractionWidgetBuilder >> elementInteractions [
	^ {RTBlink.
	RTDraggableChildren.
	RTMouseHoverZoom.
	RTResizable.
	RTSBFadeInteraction.
	RTSetEdgeAlpha.
	RTShowEdge.
	RTSimpleResizable.
	RTConstrainedDraggable.
	RTDraggable.
	RTDraggableSnapToGrid.
	RTGhostDraggable.
	RTHighlightable.
	RTHighlightableWithCursor.
	RTShowLabel.
	RTLabeled.
	RTPopup.
	RTSelectable.
	RTTransitivelyHighlightable.

	RTFixedPopup}
		collect: [ :each | 
			| cB |
			cB := CheckBoxPresenter new.
			cB
				label: each asString;
				state:
					shapes size
						= (shapes select: [ :aShape | aShape hasInteraction: each ]) size;
				whenChangedDo: [ :a | 
					a
						ifTrue: [ shapes do: [ :aShape | aShape addInteraction: cB label asClass ] ]
						ifFalse: [ shapes
								do: [ :aShape | aShape removeInteractionIfPresent: cB label asClass ] ] ] ]
]

{ #category : #initialization }
InteractionWidgetBuilder >> initialize [
	super initialize.
	shapes := OrderedCollection new.
	viewCodeScript := ''.
	elementCodeScript := ''.
]

{ #category : #accessing }
InteractionWidgetBuilder >> shapes: aElementsAndEdgesList [
	"Assumes all elements and edges  are in the same view"

	shapes := aElementsAndEdgesList
]

{ #category : #accessing }
InteractionWidgetBuilder >> viewInteractions: aRTInteractionClass [
	viewCodeScript := ''.
	^ (RTAbstractInteractionView allSubclasses
		reject: [ :aclass | 
			{RTAbstractDraggableView.
			RTAbstractElasticBoxInteraction.
			RTAbstractHighlightElementsInView.
			RTAbstractMorphingView.
			RTMorphingView} includes: aclass ])
		collect: [ :each | 
			| cB |
			cB := CheckBoxPresenter new.
			cB
				label: each asString;
				state: (shapes first view hasInteraction: each);
				whenChangedDo: [ :a | 
					a
						ifTrue: [ shapes first view addInteraction: cB label asClass.
							(viewCodeScript includesSubstring: cB label)
								ifFalse: [ viewCodeScript := viewCodeScript , ' @' , cB label ] ]
						ifFalse: [ shapes first view removeInteractionIfPresent: cB label asClass.
							viewCodeScript := viewCodeScript
								copyReplaceAll: ' @' , cB label
								with: '' ].
					self cPresenter
						updateTextWith: 'View Interactions'
						selector: ''
						value: viewCodeScript ].
			cB state
				ifTrue: [ viewCodeScript := viewCodeScript , ' @' , cB label ]. cB ]
]
