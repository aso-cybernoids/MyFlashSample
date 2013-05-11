package sample.air 
{
	import flash.desktop.NativeApplication;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleNativeApplication 
	{
		
		public function SampleNativeApplication() 
		{
			
		}
		static public function nativeApplication():NativeApplication
		{
			//NativeApplicationのシングルトンインスタンス
			return NativeApplication.nativeApplication;
		}
	}

}