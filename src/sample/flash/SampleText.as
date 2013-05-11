package sample.flash 
{
	import flash.text.TextField;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleText 
	{
		
		public function SampleText() 
		{
			
		}
		static public function hello():TextField
		{
			var tf:TextField = new TextField;
			tf.text = "hello";
			
			return tf;
		}
	}

}