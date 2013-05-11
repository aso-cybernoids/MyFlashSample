package sample.flash 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleSound extends Sprite
	{
		
		public function SampleSound() 
		{
			sampleLoad();
			stage.addEventListener(MouseEvent.CLICK,function ():void 
			{
				//trace("play");
			//getVolume();
			});
		}
		static public function sampleLoad():void 
		{
			// サウンドファイルのURL
			var url : URLRequest = new URLRequest("assets/24_001.mp3");

			// サウンドオブジェクトを作成
			var sound_obj : Sound = new Sound(url);

			// サウンドを再生
			//sound_obj.play(0,3);
			var tmp:SoundChannel = sound_obj.play(0,3);
			
			var t:Timer = new Timer(100,100);
			t.addEventListener(TimerEvent.TIMER,function ():void 
			{
				trace(tmp.leftPeak);
			});
			t.start();
		}
		static public function getVolume():void 
		{
			var sample:Sound = SampleAssets.getSound();
			var tmp:SoundChannel = sample.play();
			
			var t:Timer = new Timer(500,100);
			t.addEventListener(TimerEvent.TIMER,function ():void 
			{
				trace(tmp.leftPeak);
			});
			t.start();
		}
	}

}