"
I have a Layout Widget Builder
TabManager Presenter in ShapePresenter has one of me.
I have a Layout DropList Presenter (see Base Tab Presenter) so you can select the layouts for aview, you want to modify.
I have a Layout Widget Builder which creates my widgets.
These widgets update ChangesPresenter.
I am a Base Tab Presenter.

"
Class {
	#name : #LayoutTabPresenter,
	#superclass : #BaseTabPresenter,
	#instVars : [
		'appliedLayouts'
	],
	#category : #'MyRoassal2-Layouts'
}

{ #category : #initialization }
LayoutTabPresenter >> initializeWidgets [
	super initializeWidgets.
	widgetBuilder := LayoutWidgetBuilder new appliedLayouts: (appliedLayouts := AppliedLayouts new)
]

{ #category : #accessing }
LayoutTabPresenter >> view: aView [
	(aView isKindOf: RTView)
		ifTrue: [ view := aView.
			widgetBuilder shapes: aView elements.
			appliedLayouts
				clear;
				addLayout: (RTOrigLayout new saveAttribOf: aView).
			dropList
				items:
					{RTOrigLayout.
					RTGroupLayout.
					RTRectanglePackLayout.
					RTEquidistantCircleLayout.
					RTWeightedCircleLayout.
					RTCircleLayout.
					RTFlowLayout.
					RTHorizontalFlowLayout.
					RTCellLayout.
					RTGridLayout.
					RTHorizontalLineLayout.
					RTVerticalLineLayout.
					RTForceBasedLayout.
					RTOptimizedForceBasedLayout.					
					RTSunburstConstantWidthLayout.
					RTSunburstExtentLayout.
					RTClusterLayout.
					RTSugiyamaLayout.
					RTRadialTreeLayout.
					RTHorizontalDominanceTreeLayout.
					RTHorizontalTreeLayout.
					RTDominanceTreeLayout.
					RTTreeLayout} ]
		ifFalse: [ GrowlMorph
				openWithLabel: ''
				contents: 'Invalid view '
				color: Color red ]
]
