package  
{
	import flash.display.Sprite;
	import sample.flash.*;
	/**
	 * ...
	 * @author aso
	 */
	public class Main extends Sprite
	{
		
		public function Main() 
		{
			var sample:Sprite = SampleGraphics.circle();
			SampleMouse.setupDrag(sample);
			SampleContextMenu.addMenu(sample,"sample menu",function ():void 
			{
				trace("sample menu");
			});
			addChild(sample);
		}
		
	}

}