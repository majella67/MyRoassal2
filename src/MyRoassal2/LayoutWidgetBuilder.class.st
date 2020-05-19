"
I create Layout Widgets using Selected Layout Class and Selector Pairs from Layout Widget Dictionary (allLayoutWidgets ).

I have a Layout Widget Dictionary (allLayoutWidgets ).

I check if  Selected Layout Class was already selected for a view and use the Saved Layout in appliedLayouts.

Layout Tab Presenter has one of me.
I build widgets for Layout Tab Presenter




"
Class {
	#name : #LayoutWidgetBuilder,
	#superclass : #DynamicPresentersListBuilder,
	#instVars : [
		'shapes',
		'cPresenter',
		'appliedLayouts'
	],
	#category : #'MyRoassal2-Layouts'
}

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> allLayoutWidgets [
	^ Dictionary
		newFromPairs:
			{RTOrigLayout.
			{(self
				labelFor: RTOrigLayout
				label: (LabelPresenter new label: 'Original Layout. no Adjustments'))}}
				, self treeLayouts , self circleLayouts , self flowLayouts
				, self gridLayouts , self lineLayouts , self rPackLayout, self forceLayouts 
]

{ #category : #initialization }
LayoutWidgetBuilder >> appliedLayouts:anAppliedLayouts [
appliedLayouts := anAppliedLayouts 
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> buildListFor: aLayoutClass [
	appliedLayouts addLayout: aLayoutClass new.
	^ self
		modelObjects: (self widgetsFor: aLayoutClass);
		presenter: ShapePresenterWidget 
			configuredAs: [ :p :m | p presenter: m value ];
		layoutBuilder: (DynamicLeftToRightRowsLayout rows: 4);
		build
]

{ #category : #accessing }
LayoutWidgetBuilder >> cPresenter [
	^ cPresenter
]

{ #category : #accessing }
LayoutWidgetBuilder >> cPresenter: anObject [
	cPresenter := anObject
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> circleLayouts [
	^ RTAbstractCircleLayout allSubclasses
		flatCollect: [ :each | 
			{each.
			{(self
				setupSliderWidgetFor: each
				selectors: {'initialRadius' . 'initialRadius:'}
				slider: self sliderInput1To100).
			(self
				setupSliderWidgetFor: each
				selectors: {'initialAngleInDegree' . 'initialAngleInDegree:'}
				slider: self sliderInput0To360)}} ]
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> flowLayouts [
	^ RTAbstractFlowLayout allSubclasses
		flatCollect: [ :each | 
			{each.
			{(self
				setupSliderWidgetFor: each
				selectors: {'gapSize' . 'gapSize:'}
				slider: self sliderInput1To100)}} ]
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> forceLayouts [
	^ {RTForceBasedLayout. RTOptimizedForceBasedLayout}
		flatCollect: [ :each | 
			{each.
			{(self
				setupSliderWidgetFor: each
				selector: 'charge:'
				slider: self sliderInputNeg1000To1000
				initialValue: -500).
			(self
				setupSliderWidgetFor: each
				selector: 'length:'
				slider: self sliderInput1To100 
				initialValue: 10).
}} ]
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> gridLayouts [
	^ RTAbstractGridLayout allSubclasses
		flatCollect: [ :each | 
			{each.
			{(self
				setupSliderWidgetFor: each
				selectors: {'gapSize' . 'gapSize:'}
				slider: self sliderInput1To100)}} ]
]

{ #category : #initialization }
LayoutWidgetBuilder >> initialize [
	super initialize.

]

{ #category : #'private ' }
LayoutWidgetBuilder >> labelFor: aLayout label: aLabel [
	^ [ | w aSLayout |
	aSLayout := appliedLayouts getLayoutFor: aLayout.
	w := aLabel.
	self cPresenter isNotNil
		ifTrue: [ self cPresenter updateTextWith: aLayout selector: '' value: '' ].
	aSLayout on: shapes.
	shapes first view signalUpdate.
	shapes first view canvas focusOnCenterScaled.
"	w extent: 210 @ 50."
	w ]
]

{ #category : #'private ' }
LayoutWidgetBuilder >> labelFor: aLayout selector: aString value: anObject label: aLabel [
	| comp |
	^ [ | code w aSLayout |
	aSLayout := appliedLayouts getLayoutFor: aLayout.
	w := aLabel.
	aString isNotEmpty
		ifTrue: [ comp := OpalCompiler new.
			code := comp
				evaluate: '[:aL :aV| aL ' , aString ,   ' aV ]'.
			w label: aString asCamelCase , ' ' , anObject asString.
			code value: aSLayout value:anObject ].
	w extent: 210 @ 50.
	w ]
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> lineLayouts [
	^ RTAbstractLineLayout allSubclasses
		flatCollect: [ :each | 
			{each.
			{(self
				setupSliderWidgetFor: each
				selectors: {'horizontalGap' . 'horizontalGap:'}
				slider: self sliderInput1To100).
			(self
				setupSliderWidgetFor: each
				selectors: {'verticalGap' . 'verticalGap:'}
				slider: self sliderInput1To100)}} ]
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> rPackLayout [
	^ {RTRectanglePackLayout }
		flatCollect: [ :each | 
			{each.
			{(self
				setupSliderWidgetFor: each
				selectors: {'gap' . 'gap:'}
				slider: self sliderInput1To100)}} ]
]

{ #category : #'initialization - private' }
LayoutWidgetBuilder >> setupLabelWidgetFor: aRTLayout selector: aString label: aLabel initialValue: anObject [
	^ [ self allLayoutWidgets
		at: aRTLayout
		ifPresent: [ (self
				labelFor: aRTLayout
				selector: aString value: anObject 
				label: (aLabel label: aString , ' ' , anObject asString)) value ]
		ifAbsent: [ ^ TextPresenter new
				text:
					'Oops.  No ' , aRTLayout asString , ' shapes found. No '
						, aString second , ' slider widget. Just me.' ] ]
]

{ #category : #'initialization - private' }
LayoutWidgetBuilder >> setupSliderWidgetFor: aRTLayout selector: aString slider: aSlider initialValue: aNumber [
	^ [ self allLayoutWidgets
		at: aRTLayout
		ifPresent:
			[ (self sliderFor: aRTLayout selector: aString slider: aSlider initialValue: aNumber) value ]
		ifAbsent: [ ^ TextPresenter new
				text:
					'Oops.  No ' , aRTLayout asString , ' shapes found. No '
						, aString second , ' slider widget. Just me.' ] ]
]

{ #category : #'initialization - private' }
LayoutWidgetBuilder >> setupSliderWidgetFor: aRTLayout selectors: aString slider: aSlider [
	^ [ self allLayoutWidgets
		at: aRTLayout
		ifPresent: [ (self
				sliderFor: aRTLayout
				selectors: aString
				slider: aSlider) value	]
		ifAbsent: [ ^ TextPresenter new
				text:
					'Oops.  No ' , aRTLayout asString , ' shapes found. No '
						, aString second , ' slider widget. Just me.' ] ]
]

{ #category : #accessing }
LayoutWidgetBuilder >> shapes: aElementsAndEdgesList [
	"Assumes all elements and edges  are in the same view"

	shapes := aElementsAndEdgesList.

]

{ #category : #'private ' }
LayoutWidgetBuilder >> sliderFor: aLayout selector: aString slider: aSlider initialValue: aNumber [
	| comp init |
	^ [ | code w aSLayout |
	aSLayout := appliedLayouts getLayoutFor: aLayout.
	w := aSlider.
	init := true.
	aString isNotEmpty
		ifTrue: [
			w label: aString allButLast asCamelCase , ' ' , aNumber asString.
			w value: aNumber ].
	w
		whenValueChangedDo: [ init
				ifFalse: [ code := Smalltalk compiler
						evaluate: '[:aW :aL| aL ' , aString , '  aW value]'.
					code value: w value: aSLayout.
					self cPresenter isNotNil
						ifTrue: [ self cPresenter
								updateTextWith: aLayout
								selector: aString
								value: w value ].
					aSLayout on: shapes.
					shapes first view signalUpdate.
					shapes first view canvas focusOnCenterScaled.
					w label: aString asCamelCase , ' ' , w value asString ].
			init := false ].
	w extent: 210 @ 50.
	w ]
]

{ #category : #'private ' }
LayoutWidgetBuilder >> sliderFor: aLayout selectors: aArrayof2String slider: aSlider [
	| comp init |
	^ [ | code w aSLayout |
	aSLayout := appliedLayouts getLayoutFor: aLayout.
	w := aSlider.
		init := true.
	w
		whenValueChangedDo: [ init
				ifFalse: [ code := Smalltalk compiler
						evaluate: '[:aW :aL| aL ' , aArrayof2String second , '  aW value]'.
					code value: w value: aSLayout.
					self cPresenter isNotNil
						ifTrue: [ self cPresenter
								updateTextWith: aLayout
								selector: aArrayof2String first
								value: w value ].
					aSLayout on: shapes.
					shapes first view signalUpdate.
					shapes first view canvas focusOnCenterScaled.
					w
						label: aArrayof2String first asCamelCase , ' ' , w value asString ].
			init := false ].
	aArrayof2String first isNotEmpty
		ifTrue: [ comp := OpalCompiler new.
			code := comp evaluate: '[:aL | aL ' , aArrayof2String first , ']'.
			w label: aArrayof2String first asCamelCase , ' ' , w value asString.
			w value: (code value: aSLayout) ].
	w extent: 210 @ 50.
	w ]
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> sliderInput0To360 [
	| s |
	s := SliderPresenter new.
	s
		extent: 500 @ 20;
		min: 0;
		max: 360;
		quantum: 1;
		label: s value asString.
	^ s
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> sliderInput1To100 [
	| s |
	s := SliderPresenter new.
	s extent: 500@ 20;
		min: 1;
		max: 100;
		quantum: 1;
		label: s value asString.
	^ s
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> sliderInputNeg1000To1000 [
	| s |
	s := SliderPresenter new.
	s
		extent: 500 @ 20;
		min: -1000;
		max: 1000;
		quantum: 1;
		label: s value asString.
	^ s
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> sunburstLayouts [
	^ RTAbstractSunburstLayout allSubclasses
		flatCollect: [ :each | 
			{each.
			{(self
				setupLabelWidgetFor: each
				selector: 'builder:'
				label: self sliderInput1To100
				initialValue: RTSunburstBuilder new ).
			(self
				setupSliderWidgetFor: each
				selectors: {'angularSpacing' . 'angularSpacing:'}
				slider: self sliderInput1To100).
			(self
				setupSliderWidgetFor: each
				selectors: {'radialSpacing' . 'radialSpacing:'}
				slider: self sliderInput1To100)}} ]
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> treeLayouts [
	^ RTAbstractGraphLayout allSubclasses
		flatCollect: [ :each | 
			{each.
			{(self
				setupSliderWidgetFor: each
				selectors: {'horizontalGap' . 'horizontalGap:'}
				slider: self sliderInput1To100).
			(self
				setupSliderWidgetFor: each
				selectors: {'verticalGap' . 'verticalGap:'}
				slider: self sliderInput1To100)}} ]
]

{ #category : #'as yet unclassified' }
LayoutWidgetBuilder >> widgetsFor: aLayout [
	^ self allLayoutWidgets at: aLayout ifAbsent: [ {(LabelPresenter new label: 'Nothing here yet or invalid Class')}]
]
