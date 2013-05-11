package sample.air 
{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import sample.flash.SampleGraphics;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleDragDrop extends Sprite
	{
		
		public function SampleDragDrop() 
		{
			setup(this);
			addChild(SampleGraphics.circle());//当たり判定にする。なにも描画しないオブジェクトは当たり判定がない。
		}
		static public function setup(target:InteractiveObject):void 
		{
			//ドロップの受付
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, _onDragEnter);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, _onDragDrop);
			
			/**
			 * ドラッグ範囲に入った時
			 * @param	event
			 */
			function _onDragEnter(event:NativeDragEvent):void 
			{
				trace("onDragEnter");
				NativeDragManager.acceptDragDrop(target);// ドロップを受け付ける
			}
			
			/**
			 * ドロップされた時
			 * @param	event
			 */
			function _onDragDrop(event:NativeDragEvent):void 
			{
				trace("ファイルがドロップされました。");
				// クリップボードからデータを取り出す
				var droppedFiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				
				for (var name:String in droppedFiles) 
				{
					var file:File = droppedFiles[name];
					
					trace(file.url);//ドロップされたファイル
				}
			}
		}
	}

}