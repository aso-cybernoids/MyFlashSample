package sample.flash 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.media.Sound;
	/**
	 * ...
	 * @author ...
	 */
	public class SampleAssets extends Sprite
	{
		
		[Embed(source = '../assets/expression.json', mimeType = 'application/octet-stream')]static public var CStrJson:Class;
		[Embed(source = '../assets/sample_shiro.jpg')]static private var CImageShiro:Class;
		[Embed(source = '../assets/sample512.png')]static private var CImage512:Class;
		[Embed(source = '../assets/sample.mp3')]static private var CSound:Class;

		public function SampleAssets() 
		{
			addChild(getImage());
		}
		static public function getSound():Sound
		{
			return new CSound();
		}
		static public function getImage(imageClass:Class=null):Bitmap 
		{
			if (imageClass == null) return new  CImage512; //
			return new imageClass;
		}
	}

}