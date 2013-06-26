package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import model.Board;
	import model.Cell;
	import model.types.Pattern;
	import model.types.Tools;
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
			addChild(boardView);
			boardView.init(board);
			boardView.x = 50;
			boardView.y = 100;
			
			//boardView.createMask();
			
			mcHammer.addEventListener(MouseEvent.CLICK, selectSpecial);
			mcBomb.addEventListener(MouseEvent.CLICK, selectSpecial);
		}
		
		private function selectSpecial(e:MouseEvent):void 
		{
			switch (e.currentTarget)
			{
				case mcHammer:
					boardView.tool = Tools.BREAKER;
					break;
					
				case mcBomb:
					boardView.tool = Tools.BOMB;
					break;
			}
			
		}
		
	}

}