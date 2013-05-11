package sample.flash.old 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleDrag 
	{
		
		public function SampleDrag() 
		{
			
		}
		
		/**
		 * ドラッグ可能にする
		 * @param	sp
		 * @return
		 */
		static public function setupDrag(sp:Sprite):Sprite 
		{
			sp.buttonMode = true;

			sp.addEventListener(MouseEvent.MOUSE_DOWN, boxStartDrag);
			sp.addEventListener(MouseEvent.MOUSE_UP, boxStopDrag);
			return sp;
			function boxStartDrag(event:MouseEvent):void {
				sp.startDrag();
			}
			function boxStopDrag(event:MouseEvent):void {
				sp.stopDrag();
			}
		}
	}

}