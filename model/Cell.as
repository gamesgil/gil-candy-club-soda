package model 
{
	import flash.geom.Point;
	import view.CellView;
	/**
	 * ...
	 * @author gil
	 */
	public class Cell 
	{
		private var m_type:String;
		private var m_piece:String;
		private var m_pos:Point;
		private var m_frozen:Boolean;
		private var m_content:String;
		private var m_clip:CellView;
		private var m_drop:uint;
		
		public function Cell(type:String, clip:CellView) 
		{
			this.type = type;
			this.clip = clip;
		}
		
		public function toString():String
		{
			return content.charAt(0);
		}
		
		public function get type():String 
		{
			return m_type;
		}
		
		public function set type(value:String):void 
		{
			m_type = value;
			
			if (clip)
			{
				clip.type = type;
			}
		}
		
		public function get piece():String 
		{
			return m_piece;
		}
		
		public function set piece(value:String):void 
		{
			m_piece = value;
		}
		
		public function get frozen():Boolean 
		{
			return m_frozen;
		}
		
		public function set frozen(value:Boolean):void 
		{
			m_frozen = value;
		}
		
		public function get content():String 
		{
			return m_content;
		}
		
		public function set content(value:String):void 
		{
			m_content = value;
			
			if (clip)
			{
				clip.content = content;
			}
		}
		
		public function get clip():CellView 
		{
			return m_clip;
		}
		
		public function set clip(value:CellView):void 
		{
			m_clip = value;
		}
		
		public function get pos():Point 
		{
			return m_pos;
		}
		
		public function set pos(value:Point):void 
		{
			m_pos = value;
			
			if (clip)
			{
				clip.setPos(value);
			}
		}
		
		public function get drop():uint 
		{
			return m_drop;
		}
		
		public function set drop(value:uint):void 
		{
			m_drop = value;
			
			//trace(pos + " will drop: " + drop);
		}
		
		public function goToNewPos(value:Point):void 
		{
			m_pos = value;
			
			if (clip)
			{
				clip.goToNewPos(value);
			}
		}
		
	}

}