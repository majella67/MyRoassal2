"
I am an elementary Spec widget allowing a user to choose a Color by its RGB and alpha values.

self example

I manage three SliderInput.
I set their min at 0 and their max at 255 , (0-1 for alpha).

I provide the methods color that calculate the Color obtains with the current value of the sliders.
"
Class {
	#name : #RGBASliders,
	#superclass : #RGBSliders,
	#instVars : [
		'alphaSlider'
	],
	#category : #'MyRoassal2-Extensions'
}

{ #category : #specs }
RGBASliders class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
		newColumn: [ :column | 
			column
				add: #redSlider;
				add: #greenSlider;
				add: #blueSlider ;
				add: #alphaSlider ];
		yourself
]

{ #category : #example }
RGBASliders class >> example [
	<sampleInstance>
	| example |
	example := self new.
	example
		title: 'RGBASliders example';
		extent: 300 @ 200;
		openDialogWithSpec.
	^ example
]
