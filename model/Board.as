package model 
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gil.Utils;
	import model.types.CellType;
	import model.types.Pattern;
	import model.types.Status;
	import view.BoardView;
	import view.CellView;
	/**
	 * ...
	 * @author gil
	 */
	public class Board //extends EventDispatcher
	{
		private var m_width:uint;
		private var m_height:uint;
		private var m_cells:Array;
		private var m_boardView:BoardView;
		private var dummyContent:String;
		
		
		public function Board(width:uint, height:uint) 
		{
			m_width = width;
			m_height = height;
			
			cells = [];
			
			dummyContent = "";
			dummyContent += "1102";
			dummyContent += "0102";
			dummyContent += "0031";
			dummyContent += "1020";
			dummyContent += "0131";
			
			for (var i:int = 0; i < height; i++) 
			{
				for (var j:int = 0; j < width; j++) 
				{
					addCell(CellType.REGULAR, new Point(j, i));
				}
			}
			
			getCellAt(new Point(1, 1)).type = CellType.HOLE;
			getCellAt(new Point(1, 2)).locks = 1;
			
			checkPatterns();
		}

		public function addCell(type:String, pos:Point):void
		{
			var cell:Cell;
			cell = new Cell(type);
			cell.content = CellType.ALL[uint(dummyContent.charAt(pos.y * width + pos.x))];
			cell.pos = pos;
			cells.push(cell);
		}
		
		public function toString():String
		{
			var result:String = "";
			
			for (var i:int = 0; i < height; i++) 
			{
				for (var j:int = 0; j < width; j++) 
				{
					result += Cell(cells[i * width + j]).toString();
				}
				
				result += "\n";
			}
			
			return result;
		}
		
		public function get width():uint 
		{
			return m_width;
		}
		
		public function get height():uint 
		{
			return m_height;
		}
		
		public function get cells():Array 
		{
			return m_cells;
		}
		
		public function set cells(value:Array):void 
		{
			m_cells = value;
		}
		
		public function get boardView():BoardView 
		{
			return m_boardView;
		}
		
		public function set boardView(value:BoardView):void 
		{
			m_boardView = value;
		}
		
		public function getCellAt(point:Point):Cell
		{
			var result:Cell;
			
			for (var i:int = 0; i < m_cells.length; i++) 
			{
				if (Cell(m_cells[i]).pos.equals(point))
				{
					result = m_cells[i];
					break;
				}
			}
			
			return result;
		}
		
		public function checkPatterns():void 
		{
			findAndRemoveNextPattern(Utils.copyArray(Pattern.ALL_PATTERNS));
		}
		
		public function isThereAnyPattern():Boolean
		{
			var result:Boolean = false;
			var point:Point;
			
			for (var i:int = 0; i < Pattern.ALL_PATTERNS.length; i++) 
			{
				point = findPattern(Pattern.ALL_PATTERNS[i]);
				
				if (point)
				{
					result = true;
					break;
				}
			}
			
			return result;
		}
		
		public function findPattern(pattern:Array):Point
		{
			var result:Point;
			var refPoint:Point;
			var point:Point;
			var content:String;
			var matches:uint;
			var cell:Cell;
			
			outerloop: for (var i:int = 0; i < height; i++) 
			{
				for (var j:int = 0; j < width; j++) 
				{
					refPoint = new Point(j, i);
					cell = getCellAt(refPoint);
					
					if (cell)
					{
						content = getCellAt(refPoint).content;
						matches = 1;
					
						if (content)
						{
							for (var k:int = 1; k < pattern.length; k++) //no need to check the origin!
							{
								point = refPoint.add(pattern[k]);
								
								//check if falls out of bounds
								if (point.x < width && point.x >= 0 && point.y < height && point.y >= 0)
								{
									cell = getCellAt(point);
									
									if (cell)
									{
										if (cell.content == content)
										{
											matches++;
										}
										else
										{
											break;
										}
									}
								}
							}
						}
					
						
						if (matches == pattern.length)
						{
							result = refPoint;
							break outerloop;
						}
					}
				}
			}
			
			return result;
		}
		
		public function swapCells(pos1:Point, pos2:Point):void 
		{
			var cell1:Cell = getCellAt(pos1);
			var cell2:Cell = getCellAt(pos2);
			
			cell1.goToNewPos(pos2);
			cell2.goToNewPos(pos1);
		}
		
		public function virtualSwapAndCheck(pos1:Point, pos2:Point):Point
		{
			var result:Point;
			var cell1:Cell = getCellAt(pos1);
			var cell2:Cell = getCellAt(pos2);
			
			if (cell1 && cell2 && !cell1.locks && !cell2.locks && cell1.type != CellType.HOLE && cell2.type != CellType.HOLE)
			{
				cell1.pos = pos2;
				cell2.pos = pos1;
				
				if (isThereAnyPattern())
				{
					result = pos1;
				}
				
				cell1.pos = pos1;
				cell2.pos = pos2;
			}
			
			return result;
		}
		
		public function findAndRemoveNextPattern(patterns:Array):void 
		{
			var pattern:Array;
			var point:Point;
			
			if (patterns.length)
			{
				pattern = patterns[0];
				point = findPattern(pattern);
				
				if (point)
				{
					removePattern(point, pattern);
					
					if (!boardView) //this handles automatic patterns when board is created and before the view is created
					{
						if (isThereAnyPattern())
						{
							checkPatterns();
						}
					}
				}
				else
				{
					patterns.shift();
					findAndRemoveNextPattern(patterns);
				}
			}
			else
			{
				if (boardView)
				{
					boardView.setReady();
				}
			}
		}
		
		public function removePattern(point:Point, pattern:Array):void 
		{
			var newPoint:Point;
			var cell:Cell;
			
			for (var i:int = 0; i < pattern.length; i++) 
			{
				newPoint = point.add(pattern[i]);
				
				if (newPoint.x >= 0 && newPoint.x < width && newPoint.y >= 0 && newPoint.y < height)
				{
					cell = getCellAt(newPoint);
					
					if (!cell.locks && cell.type != CellType.HOLE)
					{
						cell.content = CellType.ALL[Math.floor(Math.random() * CellType.ALL.length)];
						cell.pos = new Point(newPoint.x, getMinimalRowAtColumn(newPoint.x) - 1);
					}
					else if (cell.locks)
					{
						cell.locks--;
					}
				}
			}
			
			if (boardView && cell)
			{
				boardView.nextFunction = fillEmptyCells;
			}
			else
			{
				fillEmptyCells();
			}
		}
		
		public function reshuffle():void 
		{
			var positions:Array = [];
			var rand:uint;
			var pos:Point;
			
			for (var i:int = 0; i < m_cells.length; i++) 
			{
				if (Cell(m_cells[i]).type != CellType.HOLE)
				{
					positions.push(Cell(m_cells[i]).pos);
				}
			}
			
			while (positions.length) 
			{
				rand = Math.floor(Math.random() * positions.length);
				pos = positions[rand];
				
				Cell(m_cells[positions.length - 1]).goToNewPos(pos);
				
				positions.splice(rand, 1)
			}
		}
		
		private function getMinimalRowAtColumn(column:uint):int
		{
			var result:int = 0;
			var potentials:Array = getAllCellsAtColumn(column);
			
			for (var i:int = 0; i < potentials.length; i++) 
			{
				if (Cell(potentials[i]).pos.y < result)
				{
					result = Cell(potentials[i]).pos.y;
				}
			}
			
			return result;
		}
		
		private function fillEmptyCells():void 
		{
			for (var i:int = 0; i < width; i++) 
			{
				fillEmptyCellsOnColumn(i);
			}
			
			if (boardView)
			{
				boardView.waitAndCheck();
			}
		}
		
		private function fillEmptyCellsOnColumn(column:uint):void
		{
			//work bottom up
			var cell:Cell;
			var empty:Point;
			var emptyCell:Cell;
			var point:Point;
			var newPoint:Point;
			var columnCells:Array;
			var check:uint = 0;
			
			while (getNextHoleOnColumn(column) && check < height)
			{
				check++;
				
				empty = getNextHoleOnColumn(column);
				
				if (empty)
				{
					cell = getNearestCellAbove(new Point(column, empty.y));
					
					if (cell)
					{
						cell.goToNewPos(empty);
					}
					else
					{
						check = height;
					}
				}
			}
			
			//applyDropOnColumn(column);
		}
		
		private function getNearestCellAbove(point:Point):Cell 
		{
			var result:Cell;
			var columnCells:Array = getAllCellsAtColumn(point.x);
			
			for (var i:int = 0; i < columnCells.length; i++) 
			{
				if (Cell(columnCells[i]).pos.y < point.y)
				{
					if(Cell(columnCells[i]).type != CellType.HOLE && !Cell(columnCells[i]).locks)
					{
						result = Cell(columnCells[i]);
						break;
					}
					else if (Cell(columnCells[i]).locks)
					{
						break;
					}
				}
			}
			
			return result;
		}
		
		private function getNextHoleOnColumn(column:uint):Point
		{
			var result:Point;
			var columnCells:Array = getAllCellsAtColumn(column);
			var cell:Cell;
			
			//find the nearest cell above hole
			for (var i:int = 0; i < height; i++) 
			{
				cell = getCellAt(new Point(column, height - i - 1));
				
				if (!cell)
				{
					result = new Point(column, height - i - 1);
					break;
				}
			}
			
			return result;
		}
		
		private function getAllCellsAtColumn(column:uint):Array
		{
			var result:Array = [];
			
			for (var i:int = 0; i < m_cells.length; i++) 
			{
				if (Cell(m_cells[i]).pos.x == column)
				{
					result.push(m_cells[i]);
				}
			}
			
			result.sortOn("pos", Array.DESCENDING);
			
			return result;
		}
		
		private function getAllCellsAtColumnAbove(column:uint, row:uint):Array
		{
			var result:Array = [];
			var potentials:Array = getAllCellsAtColumn(column);
			
			for (var i:int = 0; i < potentials.length; i++) 
			{
				if (Cell(potentials[i]).pos.y < row)
				{
					result.push(potentials[i]);
				}
			}
			
			return result;
		}
		
	}

}