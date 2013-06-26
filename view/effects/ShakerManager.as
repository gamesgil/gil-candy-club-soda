package view.effects 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	/**
	 * ...
	 * @author gil
	 */
	public class ShakerManager 
	{
		static private var shakers:Array = [];
		
		public function ShakerManager() 
		{
		}
		
		static public function shake(clip:DisplayObject):void
		{
			var shaker:Shaker = new Shaker(clip);
			shaker.addEventListener(Event.COMPLETE, destroy, false, 0 , true);
			shakers.push(shaker);
		}
		
		static public function destroy(e:Event):void
		{
			for (var i:int = 0; i < shakers.length; i++) 
			{
				if (shakers[i] == e.currentTarget)
				{
					shakers.splice(i, 1);
					break;
				}
			}
		}
		
		static public function destroyAll():void
		{
			for (var i:int = 0; i < shakers.length; i++) 
			{
				Shaker(shakers[i]).destroy();
			}
		}
		
	}

}