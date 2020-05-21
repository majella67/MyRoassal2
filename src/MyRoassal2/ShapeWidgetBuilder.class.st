"
ShapeTabPresenter  has one of me.

I have a  Shape Widget Dictionary  (allwidgets) .

I  build Shape Widgets using  Shape Widget Dictionary  (allwidgets)  and  TRShape Group (shapes).

TRShape Group (shapes) is obtained from Filtered Shape View Presentation from ShapePresenter 

"
Class {
	#name : #ShapeWidgetBuilder,
	#superclass : #DynamicPresentersListBuilder,
	#instVars : [
		'shapes',
		'cPresenter'
	],
	#category : #'MyRoassal2-Shapes'
}

{ #category : #'initialization - Widgets' }
ShapeWidgetBuilder >> allWidgets [
	| elementWidgets edgeWidgets |
	elementWidgets := OrderedCollection new.
	edgeWidgets := OrderedCollection new.
	((shapes first view elements collect: #shape) asSet collect: #class)
		do: [ :each | 
			 (RTAbstractElementShape allSubclasses includes: each)
				ifTrue: [ elementWidgets addAll: (self basicElementsList: each) ] ].
	((shapes first view edges collect: #shape) asSet collect: #class)
		do: [ :each | 
 (RTAbstractLine allSubclasses includes: each)
				ifTrue: [ edgeWidgets addAll: (self basicList: each) ] ].
	^ elementWidgets , edgeWidgets , self arrowLineWidgets
]

{ #category : #'initialization - Widgets' }
ShapeWidgetBuilder >> arrowLineWidgets [
	^ {(RTArrowedLine
		->
			(self
				setupSliderInputWidgetFor: RTArrowedLine
				selectors: {'' . 'shape width:'}
				sliderInput: (self sliderInput0To10 label: 'Width')))}
		,
			{(RTArrowedLine
				->
					(self
						setupSliderInputWidgetFor: RTArrowedLine
						selectors: {'shape head percentageFor:aS' . 'shape headOffset:'}
						sliderInput: (self sliderInput0To1 label: 'Head Offset')))}
]

{ #category : #'initialization - private' }
ShapeWidgetBuilder >> basicElementsList: aRTShapeClass [
	shapes isNotEmpty
		ifTrue: [ ^ {(aRTShapeClass
				-> (self colorWidgetFor: aRTShapeClass selectors: {'color' . 'color'})).
			(aRTShapeClass
				->
					(self
						setupSliderInputWidgetFor: aRTShapeClass
						selectors: {'height' . 'shape height:'}
						sliderInput: (self sliderInput0To1000 label: 'Height'))).
			(aRTShapeClass
				->
					(self
						colorWidgetFor: aRTShapeClass
						selectors: {' shape borderColor' . ' borderColor'})).
			(aRTShapeClass
				->
					(self
						setupSliderInputWidgetFor: aRTShapeClass
						selectors: {'width' . 'shape width:'}
						sliderInput: (self sliderInput0To1000 label: 'Width'))).
			(aRTShapeClass
				->
					(self
						setupSliderInputWidgetFor: aRTShapeClass
						selectors: {'' . 'rotateByDegrees:'}
						sliderInput: (self sliderInput0To1000 label: 'Rotate By Degrees'))).
			(aRTShapeClass
				->
					(self
						setupSliderInputWidgetFor: aRTShapeClass
						selectors: {'shape borderWidth ' . 'shape borderWidth:'}
						sliderInput: (self sliderInput0To10 label: 'Border Width')))} ]
		ifFalse: [ ^ OrderedCollection new ]
]

{ #category : #'initialization - private' }
ShapeWidgetBuilder >> basicList: aTRShapeClass [
	^ {(aTRShapeClass
		-> (self colorWidgetFor: aTRShapeClass selectors:{'color' . 'color'}))}
]

{ #category : #'build ui' }
ShapeWidgetBuilder >> buildListFor: aRTShapeClass [
	shapes isNotEmpty
		ifTrue: [ ^ self
				modelObjects: (self allWidgets select: [ :each | each key = aRTShapeClass ]);
				presenter: ShapePresenterWidget 
					configuredAs: [ :p :m | p presenter: m value value ];
				layoutBuilder: (DynamicLeftToRightColumnsLayout columns: 2);
				build ]
		ifFalse: [ ^ nil ]
]

{ #category : #accessing }
ShapeWidgetBuilder >> cPresenter [
	^ cPresenter
]

{ #category : #accessing }
ShapeWidgetBuilder >> cPresenter: anObject [
	cPresenter := anObject
]

{ #category : #'initialization - private' }
ShapeWidgetBuilder >> colorResultDict [
^	Dictionary
		newFromPairs:
			{UndefinedObject.
			'Color transparent'.
			Color.
			'result'.
			BlockClosure.
			'(result value: aShape)'}
]

{ #category : #'private ' }
ShapeWidgetBuilder >> colorResultFor: aTRShapeClass using: aBlock [
	| aShape result comp |
	"Assumption: Senders of this method check that shapes is not Empty"
	comp := OpalCompiler new.
	aShape := self firstShape: aTRShapeClass.
	result := aBlock value: aShape.
	^ (comp
		evaluate:
			'[:result :aShape |'
				, (self colorResultDict at: result class ifAbsent: 'Color transparent')
				, ' value]') value: result value: aShape
]

{ #category : #'private ' }
ShapeWidgetBuilder >> colorWidgetFor: aTRShapeClass selectors: aArrayof2String [
	| code setColor comp |
	^ [ | w rW |
	rW := RGBAWidget new.
	rW
		title:
			(aTRShapeClass asString
				copyFrom: 3
				to: aTRShapeClass asString asString size) , ' '
				, aArrayof2String first;
		labelText: aTRShapeClass asString , ' ' , aArrayof2String first.
	comp := OpalCompiler new.
	code := comp evaluate: '[:aS | aS ' , aArrayof2String first , ']'.
	setColor := self colorResultFor: aTRShapeClass using: code.
	code := comp
		evaluate:
			'[:aW :aC|aW  sliders redSlider value: aC  red * 255.
	aW  sliders greenSlider value: aC green * 255.
aW  sliders blueSlider value: aC  blue * 255.
aW  sliders alphaSlider value: aC alpha.]'.
	code value: rW value: setColor.
	w := ShapeTabColorWidget new
		colorWidget: rW;
		label: aTRShapeClass asString , ' ' , aArrayof2String first.
	rW sliders
		whenChangedDo: [ self
				updateShapesOf: aTRShapeClass
				using: [ :uShape | 
					code := comp
						evaluate: '[:aW :aS| aS shape ' , aArrayof2String second , ':  aW color]'.
					code value: rW value: uShape.
					self cPresenter isNotNil
						ifTrue: [ self cPresenter
								updateTextWith: aTRShapeClass
								selector: aArrayof2String second
								value: rW color ].
					uShape update.
					uShape view signalUpdate ] ].
	rW extent: 210 @ 230.
	w ]
]

{ #category : #accessing }
ShapeWidgetBuilder >> firstShape: aRTShapeClass [
	"Assumption: Senders of this method check that shapes is not Empty"
	^ (shapes
		select: [ :each | 
			each isNotNil
				ifTrue: [ each shape class = aRTShapeClass ]
				ifFalse: [ false ] ]) first
]

{ #category : #initialization }
ShapeWidgetBuilder >> initialize [
	super initialize.
	shapes := OrderedCollection new.

]

{ #category : #'initialization - private' }
ShapeWidgetBuilder >> numberResultDict [
	^ Dictionary
		newFromPairs:
			{{UndefinedObject}.
			0.
			Number allSubclasses.
			'result'.
			{BlockClosure}.
			'[result value: aShape]'}
]

{ #category : #'private ' }
ShapeWidgetBuilder >> numberResultFor: aTRShapeClass using: aBlock [
	| result temp comp |
	"Assumption: Senders of this method check that shapes is not Empty"
	comp := OpalCompiler new.
	result := aBlock value: (self firstShape: aTRShapeClass).
	temp := self numberResultDict keys
		select: [ :key | key includes: result class ].
	^ temp isNotEmpty
		ifTrue: [ (comp
				evaluate:
					'[:result :aShape |' , (self numberResultDict at: temp first)
						, ' value]')
				value: result
				value: (self firstShape: aTRShapeClass) ]
		ifFalse: [ 0 ]
]

{ #category : #'initialization - private' }
ShapeWidgetBuilder >> setupSliderInputWidgetFor: aTRShapeClass selectors: aArrayof2String sliderInput: aSliderInput [
	^ [ (shapes
		select: [ :each | 
			each isNotNil
				ifTrue: [ each shape class = aTRShapeClass ]
				ifFalse: [ false ] ]) isNotEmpty
		ifTrue: [ (self
				sliderInputFor: aTRShapeClass
				selectors: aArrayof2String
				sliderInput: aSliderInput) value  ]
		ifFalse: [ TextPresenter new
				text:
					'Oops.  No ' , aTRShapeClass asString , ' shapes found. No '
						, aArrayof2String second , ' sliderInput widget. Just me.' ] ]
]

{ #category : #accessing }
ShapeWidgetBuilder >> shapes: aElementsAndEdgesList [
	"Assumes all elements and edges  are in the same view"

	shapes := aElementsAndEdgesList
]

{ #category : #'initialization - private' }
ShapeWidgetBuilder >> sliderInput0To1 [
	| s |
	s := SliderInput new.
	s
		min: 0;
		max: 1;
		extent: 200 @ 50.
	s slider quantum: 0.01.
	^ s
]

{ #category : #'initialization - private' }
ShapeWidgetBuilder >> sliderInput0To10 [
	| s |
	s := SliderInput new.
	s
		min: 0;
		max: 10.
			s slider quantum: 0.1.
	^ s
]

{ #category : #'initialization - private' }
ShapeWidgetBuilder >> sliderInput0To1000 [
	| s |
	s := SliderInput new.
	s
		min: 0;
		max: 1000.
	^ s
]

{ #category : #'private ' }
ShapeWidgetBuilder >> sliderInputFor: aTRShapeClass selectors: aArrayof2String sliderInput: aSliderInput [
	| comp setValue init |
	^ [ | code w |
	w := aSliderInput.
	init := true.
	aArrayof2String first isNotEmpty
		ifTrue: [ comp := OpalCompiler new.
			code := comp evaluate: '[:aS | aS ' , aArrayof2String first , ']'.
			setValue := self numberResultFor: aTRShapeClass using: code.
			code := Smalltalk compiler
				evaluate: '[:aW :aV|aW   value: (aV value  )]'.
			code value: w value: setValue ].
	w
		whenValueChangedDo: [ init
				ifFalse: [ self
						updateShapesOf: aTRShapeClass
						using: [ :aShape | 
							code := Smalltalk compiler
								evaluate: '[:aW :aS| aS ' , aArrayof2String second , '  aW value]'.
							code value: w value: aShape. 
							self cPresenter isNotNil
								ifTrue: [ self cPresenter
										updateTextWith: aTRShapeClass
										selector: aArrayof2String first
										value: w value ].
							aShape update.
							aShape view signalUpdate ] ].
			init := false ].
	w extent: 210 @ 50.
	w ]
]

{ #category : #accessing }
ShapeWidgetBuilder >> updateShapesOf: aTRShapeSubClass using: aBlock [
	(shapes select: [ :each | each shape class = aTRShapeSubClass ])
		do: [ :shape | aBlock value: shape ]
]
