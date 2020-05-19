"
I am an abstract class.  Do not use me directly. Use one of my classes.
"
Class {
	#name : #BaseTabPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'widgetBuilder',
		'dropList',
		'view',
		'widgets',
		'cPresenter'
	],
	#category : #'MyRoassal2-Core'
}

{ #category : #specs }
BaseTabPresenter class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #dropList height: self toolbarHeight;
		add: #widgets; yourself
]

{ #category : #accessing }
BaseTabPresenter >> cPresenter [
	^ cPresenter
]

{ #category : #accessing }
BaseTabPresenter >> cPresenter: anObject [
	cPresenter := anObject.
 widgetBuilder cPresenter: self cPresenter.
]

{ #category : #accessing }
BaseTabPresenter >> dropList [
	^ dropList
]

{ #category : #accessing }
BaseTabPresenter >> dropList: anObject [
	dropList := anObject
]

{ #category : #initialization }
BaseTabPresenter >> initializeWidgets [
	dropList := DropListPresenter new.
	dropList
		displayBlock: [ :each | each ];
		whenSelectedItemChanged: [ :aClass | 
			aClass
				ifNil: [  ]
				ifNotNil: [ widgetBuilder
						ifNotNil: [ widgets := widgetBuilder buildListFor: aClass.
							widgets
								ifNotNil: [ self
										newDynamicPresentersListIn: #widgets
										usingBuilder: widgetBuilder ] ] ] ].
	widgets := NullPresenter new.
	self focusOrder
		add: dropList;
		add: widgets
]

{ #category : #accessing }
BaseTabPresenter >> view [
	^ view
]

{ #category : #accessing }
BaseTabPresenter >> view: aView [
self subclassResponsibility 
]

{ #category : #accessing }
BaseTabPresenter >> widgetList [
	^ widgetBuilder
]

{ #category : #accessing }
BaseTabPresenter >> widgetList: anObject [
	widgetBuilder := anObject
]

{ #category : #accessing }
BaseTabPresenter >> widgets [
	^ widgets
]

{ #category : #accessing }
BaseTabPresenter >> widgets: anObject [
	^ widgets := anObject
]
