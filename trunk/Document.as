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
			boardView.y = 200;
			addChild(boardView);
			
			//stage.addEventListener(MouseEvent.CLICK, checkPattern);
		}
		
	}

}