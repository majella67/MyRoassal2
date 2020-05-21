"
I am a Spec widget  allowing a user to choose a Color by its RGB and alpha values and providing a preview.

self example

I am composed of a RGBASliders, TextInputFieldPresenter (use it to label a RGBASlider when you have multiple RGBAWidgets displayed simultaneously) and an ImagePresenter that display simply a form of the current color.

I provide the following methods
- color a shortcut color to access the current color of the RGBSliders.
- makeNewForm return a fresh copy of the current displayed form.
- labelText to change the ghostText  of the TextInputFieldPresenter .

I provide extentForPreview, a point used to define the size of the preview.
"
Class {
	#name : #RGBAWidget,
	#superclass : #RGBWidget,
	#instVars : [
		'label'
	],
	#category : #'MyRoassal2-Core'
}

{ #category : #specs }
RGBAWidget class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
		newColumn: [ :column | 
			column
				add: #label origin: 0 @ 0 corner: 1 @ 0.15;
				add: #preview origin: 0 @ 0.15 corner: 1 @ 0.45;
				add: #sliders origin: 0 @ 0.45 corner: 1 @ 1];
		yourself
]

{ #category : #example }
RGBAWidget class >> example [
	<sampleInstance>
	| example |
	example := self new.
	example
		title: 'RGBAWidget exampe';
		extent: 300 @ 250;
		openDialogWithSpec.
	^ example
]

{ #category : #'build ui' }
RGBAWidget >> initializeWidgets [
	preview := self instantiate: ImagePresenter.
	sliders := self instantiate: RGBASliders.
	preview image: (Form extent: 30 @ 30 depth: 32).
	preview image: self makeNewForm.
	label := TextInputFieldPresenter new.
	 
	self focusOrder add:label;add: sliders
]

{ #category : #'build ui' }
RGBAWidget >> label [
	^ label
]

{ #category : #'build ui' }
RGBAWidget >> label: anObject [
	label := anObject
]

{ #category : #'build ui' }
RGBAWidget >> labelText: aText [

label ghostText: aText
]
