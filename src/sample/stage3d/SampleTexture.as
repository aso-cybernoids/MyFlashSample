package sample.stage3d 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class SampleTexture
	{
		
		
		public function SampleTexture() 
		{

		}
		
		
		
		static public function createTexture( stage3D:Stage3D, bm:Bitmap ):Texture { 
			var bmd:BitmapData = bm.bitmapData;
			var context3D:Context3D = stage3D.context3D;
			var texture:Texture= context3D.createTexture(bmd.width, bmd.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bmd);
			return texture;
		}
		
	}

}