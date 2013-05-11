package sample.flash 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleFPS 
	{
		
		public function SampleFPS() 
		{
			
		}
		static private var start:int = 0;
		static private var end:int = 0;
		static public function fpsDisplayObject():Sprite 
		{
			var sp:Sprite = new Sprite();
			var tf:TextField = new TextField();
			tf.text = "init fps";
			tf.autoSize = TextFieldAutoSize.LEFT;
			sp.addChild(tf);
			var count:int = 0;
			sp.addEventListener(Event.ENTER_FRAME,function ():void 
			{
				count++;
				end = getTimer();
				var f:Number = 1000/(end - start) ;
				
				start = end;
				if (count%10==0) 
				{
					tf.text = f.toFixed(2);
				
					
				}
			});
			return sp;
		}
	}

}