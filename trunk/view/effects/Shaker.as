package view.effects 
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author gil
	 */
	public class Shaker extends EventDispatcher
	{
		private var m_clip:DisplayObject;
		private var m_rounds:int;
		
		public function Shaker(clip:DisplayObject) 
		{
			m_clip = clip;
			
			m_rounds = 10;
			
			shakeForth();
			
			clip.addEventListener(MouseEvent.CLICK, destroy, false, 0, true);
		}
		
		public function destroy(e:MouseEvent = null):void 
		{
			m_clip.removeEventListener(MouseEvent.CLICK, destroy);
			
			m_clip.rotation = 0;
			m_clip = null;
			
			Tweener.removeTweens(this);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function shakeForth():void 
		{
			m_clip.rotation = -5;
			
			Tweener.addTween(this, { delay: 0.1, onComplete: shakeBack } );
		}
		
		private function shakeBack():void 
		{
			m_clip.rotation = 5;
			m_rounds--;
			
			if (m_rounds)
			{
				Tweener.addTween(this, { delay: 0.1, onComplete: shakeForth } );
			}
			else
			{
				destroy();
			}
		}
		
	}

}