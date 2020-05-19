"
I allow you to select RTShapes from a Roassal2 view via a script.
Then you can adjust various attributes of the selected shapes using dynamically built widgets/presenters.

Example
	ShapePresenter  view: ShapePresenterTest new setupView.
"
Class {
	#name : #ShapePresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'script',
		'pView',
		'filteredView',
		'fView',
		'tabs',
		'shapeTab',
		'changes',
		'interactTab',
		'layoutTab'
	],
	#category : #'MyRoassal2-Core'
}

{ #category : #specs }
ShapePresenter class >> defaultSpec [
	^ SpecColumnLayout composed
		newColumn: [ :col | 
			col
				add: #script origin: 0 @ 0 corner: 1 @ (1 / 7);
				addSplitter;
				add: #filteredView origin: 0 @ (1 / 7) corner: 1 @ 0.7;
				addSplitter;
				add: #tabs origin: 0 @ 0.7 corner: 1 @ 0.9;
				addSplitter;
				add: #changes origin: 0 @ 0.9 corner: 1 @ 1 ];
		yourself
]

{ #category : #specs }
ShapePresenter class >> view: aRTView [
	^ self new
		pView: aRTView;
		openWithSpec;
		yourself 
]

{ #category : #accessing }
ShapePresenter >> changes [
	^ changes
]

{ #category : #accessing }
ShapePresenter >> changes: anObject [
	changes := anObject
]

{ #category : #'instance creation' }
ShapePresenter >> draw: aview canvas: aCanvas [
	aview addAll: fView elements , fView edges.
	aview canvas camera focusOnCenterScaled.
	aview @ RTDraggableView @ RTZoomableView.

	^ aview
]

{ #category : #private }
ShapePresenter >> evaluateFilterScript: codeText [
	| code |
	^ [ code := Smalltalk compiler
		evaluate: '[:pView| ' , codeText , '].'.
	fView
		removeAllElements;
		removeAllEdges.
	(code cull: pView)
		do: [ :each |
		
			fView add: each ].
	self filteredView refresh ]
		on: Error
		do: [ :exception | 
			GrowlMorph
				openWithLabel: ''
				contents:
					'Error: ' , exception printString , Character cr asString
						, 'Evaluating Filter  Script.'
				color: Color red ]
]

{ #category : #accessing }
ShapePresenter >> fView [
	^ fView
]

{ #category : #accessing }
ShapePresenter >> filteredView [
	^ filteredView
]

{ #category : #accessing }
ShapePresenter >> filteredView: anObject [
	filteredView := anObject
]

{ #category : #initialization }
ShapePresenter >> initializeWidgets [
	self extent: 900 @ 850.
	filteredView := RoassalModel new.
	fView := RTView new.
	fView @RTDraggableView  @RTZoomableView .
	self setupShapeFilterScript.
	pView := RTView new.
	filteredView script: self newViewScript.
	changes := ChangesPresenter new.	"Should be before setupTabs"
	tabs := self setupTabs.
	self focusOrder
		add: script;
		add: filteredView;
		add: tabs;
		add: changes
]

{ #category : #'instance creation' }
ShapePresenter >> newViewScript [
	^ [ :aview :aCanvas | self draw: aview canvas: aCanvas ].

]

{ #category : #accessing }
ShapePresenter >> pView [
	^ pView
]

{ #category : #accessing }
ShapePresenter >> pView: aView [
	(aView isKindOf: RTView)
		ifTrue: [ self rePopulateView: pView with: aView.
			self rePopulateView: fView with: aView.
			filteredView refresh.
			shapeTab view: fView.
			interactTab view: fView. layoutTab view: fView ]
		ifFalse: [ GrowlMorph
				openWithLabel: ''
				contents: 'Invalid view '
				color: Color red ]
]

{ #category : #private }
ShapePresenter >> rePopulateView: aView with: anotherView [
	aView
		removeAllEdges;
		removeAllElements.
	aView
		addAll: anotherView  elements;
		addAll: anotherView  edges
]

{ #category : #accessing }
ShapePresenter >> script [
	^ script
]

{ #category : #accessing }
ShapePresenter >> script: anObject [
	script := anObject
]

{ #category : #private }
ShapePresenter >> setupShapeFilterScript [
	script := GlamourPresentationPresenter new.
	script glmPres
		variableBindings: [ {(#pView -> pView)} ];
		title: 'Script' translated;
		display:
			'"The view (below) expects  an Array  of Elements and/or Edges" '
				, String cr,'" pView  elements, pView edges" ';
		populate: #acceptedCode
			icon: GLMUIThemeExtraIcons glamorousAccept
			on: $s
			entitled: 'Accept'
			with: [ :codePres | self evaluateFilterScript: codePres text ].
	script buildWithSpec 
]

{ #category : #private }
ShapePresenter >> setupTabs [
	| sTab iTab lTab |
	sTab := TabPresenter new.
	shapeTab := ShapeTabPresenter new cPresenter: changes.
	sTab
		label: 'Shapes';
		closeable: false;
		presenter: shapeTab.
	iTab := TabPresenter new.
	interactTab := InteractionTabPresenter new cPresenter: changes.
	iTab
		label: 'Interactions';
		closeable: false;
		presenter: interactTab.
	lTab := TabPresenter new.
		layoutTab := LayoutTabPresenter  new cPresenter: changes.
	lTab
		label: 'Layouts';
		closeable: false;
		presenter: layoutTab.
	tabs := TabManagerPresenter new.
	tabs
		addTab: sTab;
		addTab: iTab;
		addTab: lTab.
	^ tabs
]

{ #category : #accessing }
ShapePresenter >> tabs [
	^ tabs
]

{ #category : #accessing }
ShapePresenter >> tabs: anObject [
	tabs := anObject
]
