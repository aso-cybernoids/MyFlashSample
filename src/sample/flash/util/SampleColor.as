package sample.flash.util 
{
	/**
	 * ...
	 * @author aso
	 */
	public class SampleColor 
	{
		
		
		
		public static function getColorFromRGB(r:Number,g:Number,b:Number):uint
		{
			//0x00rrggbb
			return ( (r*255) << 16 ) || ( (g*255) << 8 ) || (b*255);
		}
		
		public static function getColorFromRGB256(r:int,g:int,b:int):uint
		{
			//0x00rrggbb
			return ( r << 16 ) || ( g << 8 ) || b;
		}
	}

}