package sample.flash 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	/**
	 * ...
	 * @author ...
	 */
	public class SampleStage 
	{
		
		public function SampleStage() 
		{
			
		}
		static public function getRootStage(obj:DisplayObject):Stage 
		{
			while (obj.parent!=null) 
			{
				obj = obj.parent;
			}
			return obj.stage;
		}
	}

}