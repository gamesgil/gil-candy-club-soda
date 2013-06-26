package view 
{
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gil.Utils;
	import model.Board;
	import model.Cell;
	import model.types.CellType;
	import model.types.Pattern;
	import model.types.Speed;
	import model.types.Status;
	import model.types.Tools;
	import view.effects.ShakerManager;
	
	/**
	 * ...
	 * @author gil
	 */
	public class BoardView extends Sprite 
	{
		static private var cellRect:Rectangle;
		
		private var m_tool:String;
		private var m_queuedCells:uint;
		private var m_status:String;
		private var m_board:Board;
		private var m_pos1:Point;
		private var m_pos2:Point;
		private var m_frame:MovieClip;
		private var m_nextFunction:Function;
		private var m_mask:Sprite;
		
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
					
					board.getCellAt(point).clip = cell;
					
					if (!cellRect)
					{
						cellRect = new Rectangle(0, 0, cell.width, cell.height);
					}
				}
			}
			
			setReady();
			
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (status == Status.READY)
			{
				unshake();
				
				var curPos:Point = localToModel((new Point(BoardView(e.currentTarget).mouseX, BoardView(e.currentTarget).mouseY)).add(new Point(cellRect.width / 2, cellRect.height / 2)));
			
				switch(tool)
				{
					case Tools.BREAKER:
						board.removePattern(curPos, [new Point(0, 0)]);
						break;
						
					case Tools.BOMB:
						board.removePattern(curPos, Pattern.BOMB);
						break;
						
					default:
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
						break;
				}
				
				tool = null;
				
			}
		}
		
		private function unshake():void 
		{
			Tweener.removeTweens(this);
			ShakerManager.destroyAll();
		}
		
		private function tryToSwap():void 
		{
			if ((Math.abs(m_pos1.x - m_pos2.x) == 1 && m_pos1.y == m_pos2.y) || (Math.abs(m_pos1.y - m_pos2.y) == 1 && m_pos1.x == m_pos2.x))
			{
				status = Status.BUSY;
				
				board.swapCells(m_pos1, m_pos2);
			
				Tweener.addTween(this, { delay: Speed.SWAP_SPEED, onComplete: checkPatternsAfterSwap } );
			}
		}
		
		private function checkPatternsAfterSwap():void 
		{
			if (board.isThereAnyPattern())
			{
				board.checkPatterns();
			}
			else
			{
				board.swapCells(m_pos1, m_pos2);
				
				Tweener.addTween(this, { delay: Speed.SWAP_SPEED, onComplete: setReady } );
			}
			
			clearMarks();
		}
		
		private function highlightCell():void 
		{
			var point:Point = new Point(Math.floor(Math.random() * board.width), Math.floor(Math.random() * board.height));
			var clip:CellView = board.getCellAt(point).clip;
			
			ShakerManager.shake(clip);
		}
		
		public function setReady():void 
		{
			status = Status.READY;
			
			Tweener.addTween(this, { delay: 3, onComplete: highlightCell } );
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
			Tweener.addTween(this, { delay: Speed.CHECK_SPEED, onComplete: board.checkPatterns } );
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
			
			addEventListener(Event.ENTER_FRAME, processNextFunction, false, 0, true);
		}
		
		public function get tool():String 
		{
			return m_tool;
		}
		
		public function set tool(value:String):void 
		{
			m_tool = value;
		}
		
		private function processNextFunction(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, processNextFunction);
			
			nextFunction();
			
			m_nextFunction = null;
		}
		
		public function createMask():void
		{
			m_mask = new Sprite();
			m_mask.graphics.beginFill(0x000000);
			m_mask.graphics.drawRect(0, 0, width, height + 10);
			m_mask.x = getBounds(parent).x;
			m_mask.y = getBounds(parent).y - 5;
			mask = m_mask;
		}
	}

}