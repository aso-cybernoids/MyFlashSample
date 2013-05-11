package sample.flash 
{
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleTimer 
	{
		
		public function SampleTimer() 
		{
			
		}
		static public function getSystemTimer():int 
		{
			return getTimer();
		}
		static public function delay(f:Function,ms:int=1000):void 
		{
			var t:Timer = new Timer(ms, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE,function ():void 
			{
				f();
			});
			t.start();
		}
		
		
		
		static private var timer:Array=new Array;
		/**
		 * 時間の測定.
		 * @param	name 測定名。endやdumpと合わせる
		 */
		static public function startWatch(name:String):void 
		{
			timer[name] = getTimer();//計測開始時間（VM開始からの経過ｍｓ）
			
		}
		/**
		 * startからの経過時間.
		 * startを呼んでからend（またはdump）を実行
		 * 複数回呼んでも良い
		 * @param	name
		 * @return
		 */
		static public function stopWatch(name:String):Number 
		{
			if (timer[name] == null) {
				return NaN;//startを呼ばなかった場合
			}
			return getTimer()- timer[name] ;//startからendまでの経過時間（ｍｓ）
		}
		/**
		 * 経過時間をログに表示.
		 * @param	name
		 */
		static public function dumpWatch(name:String):void 
		{
			trace("計測時間 : {0} ms ({1})",stopWatch(name),name);
		}
	}

}