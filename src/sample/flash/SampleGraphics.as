package sample.flash 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleGraphics 
	{
		/**
		 * 最大幅
		 * 初期値 300
		 */
		static public var width:Number = 300;
		
		/**
		 * 最大高さ
		 * 初期値 300
		 */
		static public var height:Number = 300;
		
		

		public function SampleGraphics() 
		{
			
		}
		/**
		 * 円のスプライトを返す。値を省略すると適当に作る
		 * @param	x
		 * @param	y
		 * @param	r
		 * @param	c
		 * @return
		 */
		static public function circle(x:Number=NaN,y:Number=NaN,r:Number=NaN,c:Number=NaN):Sprite {
			if (isNaN(x)) x = Math.random() * width;
			if (isNaN(y)) y = Math.random() * height;
			if (isNaN(r)) r = Math.random() * 10;
			if (isNaN(c)) c = Math.random() * 0xffffff;

			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(c);
			sp.graphics.drawCircle(x,y, r);
			sp.graphics.endFill();
			return sp;
		}
		/**
		 * 四角形のスプライトを返す。値を省略すると適当に作る
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	c
		 * @return
		 */
		static public function rect(x:Number = NaN, y:Number = NaN, w:Number = NaN, h:Number = NaN, c:Number =NaN):Sprite {
			if (isNaN(x)) x = Math.random() * width;
			if (isNaN(y)) y = Math.random() * height;
			if (isNaN(w)) w = Math.random() * width;
			if (isNaN(h)) h = Math.random() * height;
			if (isNaN(c)) c = Math.random() * 0xffffff;
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(c);
			sp.graphics.drawRect(x, y, w, h);
			sp.graphics.endFill();
			return sp;
		}
	}

}