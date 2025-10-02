Class {
	#name : 'DamagedAreaDemo',
	#superclass : 'BenchmarkingDemo',
	#instVars : [
		'numberOfElements'
	],
	#category : 'SDLExperiments-Demo-Benchmarks',
	#package : 'SDLExperiments-Demo',
	#tag : 'Benchmarks'
}

{ #category : 'rendering' }
DamagedAreaDemo >> renderGrid [

	| columnCount rowCount boardExtent cellExtent board numberOfCellsPerSide |
	numberOfCellsPerSide := 20.
	columnCount := rowCount := numberOfCellsPerSide.

	boardExtent := 800 * 600.
	cellExtent := Point
		x: boardExtent x / columnCount
		y: boardExtent y / rowCount.

	board := Array2D
		rows: rowCount
		columns: columnCount
		tabulate: [ :row :col |
			BlElement new
				id: (col@row) asString;
				geometry: BlEllipseGeometry new;
				position: (Point
					x: cellExtent x * (col-1)
					y: cellExtent y * (row-1));
				size: cellExtent + 1;
				background: Color random darker;
				clipChildren: false;
				when: BlMouseMoveEvent
				do: [ :evt |
					"Highlight element, but enforce changing color only 
					if has not been already highlighted.
					This avoids triggering many redraws."
					evt target background paint color = Color white
						ifFalse: [ evt target background: Color white ] ];
				yourself ].

	^ BlElement new
		addChildren: board asArray;
		size: boardExtent;
		yourself
]
