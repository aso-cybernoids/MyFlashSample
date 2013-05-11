package sample.flash 
{
	/**
	 * ...
	 * @author ...
	 */
	public class SampleError 
	{
		
		public function SampleError() 
		{
			
		}
		static public function stackTrace():String 
		{
			var err:Error = new Error;
			return err.getStackTrace();
		}
	}

}