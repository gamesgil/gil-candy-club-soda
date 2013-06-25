package view 
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import model.Board;
	import model.Cell;
	import model.types.CellType;
	import model.types.Pattern;
	import model.types.Speed;
	
	/**
	 * ...
	 * @author gil
	 */
	public class BoardView extends Sprite 
	{
		static private var cellRect:Rectangle;
		static private var STATUS_BUSY:String = "busy";
		static private var STATUS_READY:String = "ready";
		
		
		private var m_status:String;
		private var m_board:Board;
		private var m_pos1:Point;
		private var m_pos2:Point;
		private var m_frame:MovieClip;
		
		public function BoardView() 
		{
			m_frame = new mcFrame();
		}
		
		public function init(board:Board):void
		{
			this.board = board;
			
			var cell:CellView;
			var point:Point;
			var originPos:Point = new Point(x, y);
			
			for (var i:int = 0; i < board.height; i++) 
			{
				for (var j:int = 0; j < board.width; j++) 
				{
					point = new Point(j, i);
					cell = new CellView();
					cell.boardPos = originPos;
					addChild(cell);
					
					board.addCell(CellType.REGULAR, point, cell);
					
					if (!cellRect)
					{
						cellRect = new Rectangle(0, 0, cell.width, cell.height);
					}
				}
			}
			
			status = STATUS_READY;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (status == STATUS_READY)
			{
				var curPos:Point = localToModel((new Point(BoardView(e.currentTarget).mouseX, BoardView(e.currentTarget).mouseY)).add(new Point(cellRect.width / 2, cellRect.height / 2)));
			
				if (!m_pos1)
				{
					m_pos1 = curPos;
				
					mark(board.getCellAt(m_pos1).clip);
				}
				else
				{
					m_pos2 = curPos;
					
					tryToSwap();
				}
			}
		}
		
		private function tryToSwap():void 
		{
			if ((Math.abs(m_pos1.x - m_pos2.x) == 1 && m_pos1.y == m_pos2.y) || (Math.abs(m_pos1.y - m_pos2.y) == 1 && m_pos1.x == m_pos2.x))
			{
				status = STATUS_BUSY;
				
				board.swapCells(m_pos1, m_pos2);
				
				Tweener.addTween(this, { delay: Speed.SWAP_SPEED, onComplete: checkPatterns } );
			}
			
			clearMarks();
		}
		
		private function checkPatterns():void 
		{
			board.findAndRemoveNextPattern();
		}
		
		private function clearMarks():void 
		{
			m_pos1 = null;
			m_pos2 = null;
			
			unmark(m_pos1);
			unmark(m_pos2);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (status == STATUS_READY)
			{
				var curPos:Point = localToModel((new Point(BoardView(e.currentTarget).mouseX, BoardView(e.currentTarget).mouseY)).add(new Point(cellRect.width / 2, cellRect.height / 2)));
			
				if (m_pos1)
				{
					if (!curPos.equals(m_pos1))
					{
						m_pos2 = localToModel((new Point(BoardView(e.currentTarget).mouseX, BoardView(e.currentTarget).mouseY)).add(new Point(cellRect.width / 2, cellRect.height / 2)));
						
						tryToSwap();
					}
				}
			}
		}
		
		private function unmark(m_pos:Point):void 
		{
			if (contains(m_frame))
			{
				removeChild(m_frame);
			}
		}
		
		private function mark(cell:CellView):void 
		{
			trace("mark: " + cell.boardPos);
			
			m_frame.x = cell.x;
			m_frame.y = cell.y;
			
			addChild(m_frame);
		}
		
		private function localToModel(point:Point):Point
		{
			var result:Point = new Point();
			result.x = Math.floor(point.x / cellRect.width);
			result.y = Math.floor(point.y / cellRect.height);
			
			return result;
		}
		
		public function modelToLocal(pos:Point):uint
		{
			return pos.y * board.width + pos.x;
		}
		
		public function get board():Board 
		{
			return m_board;
		}
		
		public function set board(value:Board):void 
		{
			m_board = value;
		}
		
		public function get status():String 
		{
			return m_status;
		}
		
		public function set status(value:String):void 
		{
			m_status = value;
		}
	}

}