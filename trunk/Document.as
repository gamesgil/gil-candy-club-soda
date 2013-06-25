package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import model.Board;
	import model.Cell;
	import model.types.Pattern;
	import view.BoardView;
	/**
	 * ...
	 * @author gil
	 */
	public class Document extends Sprite
	{
		private var boardView:BoardView;
		private var board:Board;
		private var checkQueue:Array;
		
		public function Document() 
		{
			board = new Board(4, 5);
			
			boardView = new BoardView();
			boardView.init(board);
			
			boardView.x = 50;
			boardView.y = 50;
			addChild(boardView);
			
			clonePatterns()
			
			//stage.addEventListener(MouseEvent.CLICK, checkPattern);
		}
		
		private function checkPattern(e:MouseEvent):void 
		{
			
			
			checkNextPattern();
		}
		
		private function checkNextPattern(e:Event = null):void 
		{
			if (checkQueue.length)
			{
				trace("check: " + checkQueue[0]);
				
				var check:Point = board.findPattern(checkQueue[0]);
				
				trace("found at " + check);;
				
				if (check)
				{
					//remove pattern
					board.removePattern(check, checkQueue[0]);
					
					checkNextPattern();
				}
				else if (checkQueue.length)
				{
					checkQueue.shift();
				}
			}
			
		}
		
		private function clonePatterns():void
		{
			checkQueue = [];
			
			for (var i:int = 0; i < Pattern.ALL_PATTERNS.length; i++) 
			{
				checkQueue.push(Pattern.ALL_PATTERNS[i]);
			}
		}
		
	}

}