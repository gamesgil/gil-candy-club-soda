package view 
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import model.types.CellType;
	
	/**
	 * ...
	 * @author gil
	 */
	public class CellView extends Sprite 
	{
		private var m_boardPos:Point;
		private var m_lock1:MovieClip;
		private var m_lock2:MovieClip;
		
		public function CellView() 
		{
		}
		
		public function set content(value:String):void 
		{
			var mc:MovieClip;
			
			while (numChildren)
			{
				removeChildAt(0);
			}
			
			switch (value)
			{
				case CellType.TYPE1:
					mc = new mc1();
					break;
					
				case CellType.TYPE2:
					mc = new mc2();
					break;
					
				case CellType.TYPE3:
					mc = new mc3();
					break;
					
				case CellType.TYPE4:
					mc = new mc4();
					break;
					
				case CellType.TYPE5:
					mc = new mc5();
					break;
			}
			
			if (mc)
			{
				addChild(mc);
			}
		}
		
		public function set type(value:String):void 
		{
			switch (value)
			{
				case CellType.HOLE:
					visible = false;
					break;
					
				case CellType.REGULAR:
					visible = true;
					break;
			}
		}
		
		public function setPos(pos:Point):void
		{
			x = boardPos.x + pos.x * width;
			y = boardPos.y + pos.y * height;
		}
		
		public function goToNewPos(pos:Point):void
		{
			Tweener.removeTweens(this);
			
			var transition:String = "easeOutBounce";
			Tweener.addTween(this, { time: 1, x: boardPos.x + pos.x * width, y: boardPos.y + pos.y * height, transition: transition } );
		}
		
		public function set locks(locks:uint):void
		{
			if (locks)
			{
				if (!m_lock1)
				{
					m_lock1 = new mcLock();
					addChild(m_lock1);
				}
				
				if (locks == 2)
				{
					m_lock2 = new mcLock();
					m_lock2.rotation = 90;
					addChild(m_lock2);
				}
				else if (m_lock2 && contains(m_lock2))
				{
					removeChild(m_lock2);
				}
			}
			else
			{
				if (m_lock1 && contains(m_lock1))
				{
					removeChild(m_lock1);
				}
				
				if (m_lock2 && contains(m_lock2))
				{
					removeChild(m_lock2);
				}
			}
		}
		
		public function get boardPos():Point 
		{
			return m_boardPos;
		}
		
		public function set boardPos(value:Point):void 
		{
			m_boardPos = value;
		}
	}

}