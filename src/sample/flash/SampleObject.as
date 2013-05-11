package sample.flash 
{
	/**
	 * ...
	 * @author aso
	 */
	public class SampleObject 
	{
		
		public function SampleObject() 
		{
			
		}
		static public function runtimeError():void 
		{
			var obj:Object = new Object;
			
			
			try 
			{
				obj.@value = 1;//error!
			} 
			catch (err:Error) 
			{
				trace(err.getStackTrace());
			}
			
			try 
			{
				obj["@value"] = 1;//ok
				trace(obj.@value);//error!
			} 
			catch (err:Error) 
			{
				trace(err.getStackTrace());
			}
		}
	}

}