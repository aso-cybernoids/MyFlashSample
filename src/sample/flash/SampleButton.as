package sample.flash 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleButton 
	{
		
		public function SampleButton() 
		{
			
		}
		static public function create(label:String,click:Function):Sprite 
		{
			var sp:Sprite =SampleGraphics.rect(0, 0, 50, 30);
			sp.addEventListener(MouseEvent.CLICK, click);
			return sp;
		}
	}

}