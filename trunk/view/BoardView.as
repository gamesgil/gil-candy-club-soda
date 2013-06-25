package view 
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import model.Board;
	import model.Cell;
	import model.types.CellType;
	import model.types.Pattern;
	import model.types.Speed;
	import model.types.Status;
	
	/**
	 * ...
	 * @author gil
	 */
	public class BoardView extends Sprite 
	{
		static private var cellRect:Rectangle;
		
		private var m_queuedCells:uint;
		private var m_status:String;
		private var m_board:Board;
		private var m_pos1:Point;
		private var m_pos2:Point;
		private var m_frame:MovieClip;
		private var m_nextFunction:Function;
		
		public function BoardView() 
		{
			m_frame = new mcFrame();
			queuedCells = 0;
		}
		
		public function init(board:Board):void
		{
			this.board = board;
			this.board.boardView = this;
			
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
			
			status = Status.READY;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (status == Status.READY)
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
				status = Status.BUSY;
				
				board.swapCells(m_pos1, m_pos2);
				
				Tweener.addTween(this, { delay: Speed.SWAP_SPEED, onComplete: checkPatterns } );
			}
			
			clearMarks();
		}
		
		private function checkPatterns():void 
		{
			board.findAndRemoveNextPattern([Pattern.H_TRIPLET, Pattern.V_TRIPLET]);
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
			if (status == Status.READY)
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
		
		public function waitAndCheck():void 
		{
			Tweener.addTween(this, { delay: Speed.CHECK_SPEED, onComplete: checkPatterns } );
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
		
		public function get queuedCells():uint 
		{
			return m_queuedCells;
		}
		
		public function set queuedCells(value:uint):void 
		{
			m_queuedCells = value;
		}
		
		public function get nextFunction():Function 
		{
			return m_nextFunction;
		}
		
		public function set nextFunction(value:Function):void 
		{
			m_nextFunction = value;
			
			addEventListener(Event.ENTER_FRAME, processNextFunction);
		}
		
		private function processNextFunction(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, processNextFunction);
			
			nextFunction();
			
			m_nextFunction = null;
		}
	}

}