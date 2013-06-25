package model 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import model.types.CellType;
	import model.types.Pattern;
	import model.types.Status;
	import view.BoardView;
	import view.CellView;
	/**
	 * ...
	 * @author gil
	 */
	public class Board 
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
			dummyContent += "0122";
			dummyContent += "1112";
			dummyContent += "1220";
			dummyContent += "0121";
			dummyContent += "1230";
		}
		
		public function addCell(type:String, pos:Point, clip:CellView):void
		{
			var cell:Cell;
			cell = new Cell(CellType.REGULAR, clip);
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
		
		public function findPattern(pattern:Array):Point
		{
			var result:Point;
			var refPoint:Point;
			var point:Point;
			var content:String;
			var matches:uint;
			
			outerloop: for (var i:int = 0; i < height; i++) 
			{
				for (var j:int = 0; j < width; j++) 
				{
					refPoint = new Point(j, i);
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
								if (getCellAt(point).content == content)
								{
									matches++;
								}
								else
								{
									break;
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
					trace("found @ " + point);
					removePattern(point, pattern);
					//fillHoles();
					boardView.nextFunction = fillHoles;
				}
				else
				{
					trace("didn't find");
					patterns.shift();
					findAndRemoveNextPattern(patterns);
				}
			}
			else
			{
				trace("no patterns left");
				if (boardView)
				{
					boardView.status = Status.READY;
				}
			}
		}
		
		private function removePattern(point:Point, pattern:Array):void 
		{
			var newPoint:Point;
			
			for (var i:int = 0; i < pattern.length; i++) 
			{
				newPoint = point.add(pattern[i]);
				
				getCellAt(newPoint).content = CellType.ALL[Math.floor(Math.random() * CellType.ALL.length)];
				getCellAt(newPoint).pos = new Point(newPoint.x, getMinimalRowAtColumn(newPoint.x) - 1);
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
		
		private function fillHoles():void 
		{
			for (var i:int = 0; i < width; i++) 
			{
				fillHoleOnColumn(i);
			}
			
			boardView.waitAndCheck();
		}
		
		private function fillHoleOnColumn(column:uint):void
		{
			//work bottom up
			var cell:Cell;
			var point:Point;
			var drop:uint = 0;
			var columnCells:Array;
			
			for (var i:int = 0; i < height; i++) 
			{
				point = new Point(column, height - i - 1);
				cell = getCellAt(point);
				
				if (!cell)
				{
					drop++;
					
					columnCells = getAllCellsAtColumnAbove(column, point.y + 1);
					
					for (var j:int = 0; j < columnCells.length; j++) 
					{
						Cell(columnCells[j]).drop = drop;
					}
				}
				
			}
			
			applyDropOnColumn(column);
		}
		
		private function applyDropOnColumn(column:uint):void 
		{
			var columnCells:Array = getAllCellsAtColumn(column);
			
			for (var i:int = 0; i < columnCells.length; i++) 
			{
				Cell(columnCells[i]).goToNewPos(new Point(Cell(columnCells[i]).pos.x, Cell(columnCells[i]).pos.y + Cell(columnCells[i]).drop));
				Cell(columnCells[i]).drop = 0;
			}
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