"
A ShapeWidgetBuilderTest is a test class for testing the behavior of ShapeWidgetBuilder
"
Class {
	#name : #ShapeWidgetBuilderTest,
	#superclass : #TestCase,
	#category : #'MyRoassal2-Tests'
}

{ #category : #tests }
ShapeWidgetBuilderTest >> testNumberResultDict [
	| nDict |
	nDict := ShapeWidgetBuilder new numberResultDict.
	self
		assert:
			({1.1.
			nil.
			[  ].
			1.
			-1.
			1e6.
			''.
			RTEllipse new.
			true.
			[ :each |  ]}
				collect: [ :each | 
					{each.
					(nDict keys select: [ :key | key includes: each class ])} ])
				asCommaString
		equals:
			'an Array(1.1 an Array(an OrderedCollection(Float Fraction Integer BoxedFloat64 SmallFloat64 ScaledDecimal LargeInteger SmallInteger LargeNegativeInteger LargePositiveInteger))), {nil. {{UndefinedObject}}}, an Array([  ] {{BlockClosure}}), an Array(1 an Array(an OrderedCollection(Float Fraction Integer BoxedFloat64 SmallFloat64 ScaledDecimal LargeInteger SmallInteger LargeNegativeInteger LargePositiveInteger))), an Array(-1 an Array(an OrderedCollection(Float Fraction Integer BoxedFloat64 SmallFloat64 ScaledDecimal LargeInteger SmallInteger LargeNegativeInteger LargePositiveInteger))), an Array(1000000 an Array(an OrderedCollection(Float Fraction Integer BoxedFloat64 SmallFloat64 ScaledDecimal LargeInteger SmallInteger LargeNegativeInteger LargePositiveInteger))), #('''' #()), an Array(a RTEllipse #()), #(true #()), an Array([ :each |  ] {{BlockClosure}})'
]
