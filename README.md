# MyRoassal2


## Installation

Roassal2 is required. 
If you do not have it installed, you can load it using -:

```Smalltalk

Metacello new
    baseline: 'Roassal2';
    repository: 'github://ObjectProfile/Roassal2/src';
    load.	
```

Load MyRoassal2 using 

```Smalltalk
Metacello new 
	repository: 'github://majella67/MyRoassal2/src';
	baseline: 'MyRoassal2';
	load.
```

It works in Pharo 8 and 9.


## Intro
A sample of what you can do with MyRoassal2.

Use the code below in a Playground to see the demo below.


```Smalltalk
ShapePresenter  view: ShapePresenterTest new setupView 
```


![Image of Intro](https://github.com/majella67/MyRoassal2/blob/master/Intro.gif)

## Known issues

- Changing the view while open requires you to close then open the app to maintain real time updates.
	
- Not all shapes can be tweaked. To be added.
	
- Composite shapes are not handled properly.
