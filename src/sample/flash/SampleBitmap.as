package sample.flash 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class SampleBitmap extends Sprite
	{
		public function SampleBitmap() 
		{
			//var bm:Bitmap = getSpriteImage(100, 100, SampleGraphics.circle(10,10,5) );
			
			var bm:Bitmap = getSpriteImage(100, 100, SampleText.hello() );
			
			addChild(bm);
		}
		static public function getEmbedImage(imageClass:Class=null):Bitmap 
		{
			return SampleAssets.getImage(imageClass);
		}
		static public function getSpriteImage(w:int,h:int,sp:IBitmapDrawable):Bitmap 
		{
			var bm:Bitmap = new Bitmap;
			var bmd:BitmapData = new BitmapData(w,h);
			
			bmd.draw(sp);
			
			bm.bitmapData = bmd;
			return bm;
			
			
		}
	}

}