package model 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import model.types.CellType;
	import model.types.Pattern;
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
		
		private var dummyContent:String;
		
		
		public function Board(width:uint, height:uint) 
		{
			m_width = width;
			m_height = height;
			
			cells = [];
			
			dummyContent = "";
			dummyContent += "0121";
			dummyContent += "2301";
			dummyContent += "1230";
			dummyContent += "0113";
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
		
		public function isThereAnyPattern():Array
		{
			var result:Array;
			
			for (var i:int = 0; i < Pattern.ALL_PATTERNS.length; i++) 
			{
				if (findPattern(Pattern.ALL_PATTERNS[i]))
				{
					result = Pattern.ALL_PATTERNS[i];
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
		
		public function removePattern(point:Point, pattern:Array):void 
		{
			var newPoint:Point;
			
			for (var i:int = 0; i < pattern.length; i++) 
			{
				newPoint = point.add(pattern[i]);
				
				getCellAt(newPoint).pos = new Point(newPoint.x, newPoint.y - height);
			}
		}
		
		public function findNextHole(column:uint):Rectangle
		{
			var result:Rectangle;
			
			outerloop: for (var j:int = 0; j < height; j++) 
			{
				result = new Rectangle(column, j, 1, 0);
				
				if (getCellAt(new Point(result.x, result.y)).content == null)
				{
					for (var k:int = j; k < height; k++) 
					{
						if (getCellAt(new Point(column, k)).content == null)
						{
							result.height++;
						}
						else
						{
							break outerloop;
						}
					}
					
					break outerloop;
				}
			}
			
			if (result && result.height == 0)
			{
				result = null;
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
		
		public function findAndRemoveNextPattern():void 
		{
			var patterns:Array = [Pattern.H_TRIPLET, Pattern.V_TRIPLET];
			var point:Point;
			
			for (var i:int = 0; i < patterns.length; i++) 
			{
				point = findPattern(patterns[i]);
				
				if (point)
				{
					removePattern(point, patterns[i]);
					break;
				}
			}
		}
	}

}