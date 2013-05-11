package sample.air 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.InvokeEvent;
	/**
	 * アプリケーション起動時のイベント
	 * 
	 * 参考
	 * application.xmlに記述
	 * 
	 <fileTypes>
		<fileType>
		  <name>moc</name>
		  <extension>moc</extension>
		  <description>Live2D model data</description>
		  <contentType>moc</contentType>
		</fileType>
	  </fileTypes>
	 * @author aso
	 */
	public class SampleInvoke extends Sprite
	{
		
		public function SampleInvoke() 
		{
			setupEvent(this);
		}
		
		public function setupEvent(app:EventDispatcher):void 
		{
			app.addEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		/**
		 * 関連付けられたファイルを開いた時のイベント.
		 * ApplicationCompleteより先に呼ばれる
		 * @param	e
		 */
		protected function onInvoke(e:InvokeEvent):void 
		{
			trace("invoke event");
			for (var name:String in e.arguments) 
			{
				trace("invoke args:"+name+e.arguments[name]);
			}
			
		}
	}

}