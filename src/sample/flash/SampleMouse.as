package sample.flash 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleMouse 
	{
		
		public function SampleMouse() 
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
		
		/**
		 * ホイールでスプライトを拡大縮小可能にする
		 * @param	sp
		 * @return
		 */
		static public function setupWheelScale(sp:Sprite):Sprite
		{
			sp.addEventListener(MouseEvent.MOUSE_WHEEL,function (e:MouseEvent):void 
			{
				if (e.delta>0) {
					sp.scaleX *= 1.1;
					sp.scaleY *= 1.1;
				}else {
					sp.scaleX *= 0.9;
					sp.scaleY *= 0.9;
				}
			});
			return sp;
		}
	}

}