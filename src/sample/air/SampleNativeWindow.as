package sample.air 
{
	import flash.desktop.NativeWindowIcon;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import sample.stage3d.SampleStage3D;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleNativeWindow extends Sprite
	{
		
		public function SampleNativeWindow() 
		{
			var win1:NativeWindow = createWindow();
			var win2:NativeWindow = createWindow();
			var win3:NativeWindow = createWindow();
			
			
			SampleStage3D.createAndDrawTexture(win1.stage.stage3Ds[0]);
			SampleStage3D.createAndDrawTexture(win2.stage.stage3Ds[0]);
			SampleStage3D.createAndDrawTexture(win3.stage.stage3Ds[0]);
		}
		
		/**
		 * OSネイティブのウィンドウを作成する
		 * 
		 * 
		 * widthにはウィンドウの幅、stage.stageWidthにはウィンドウの枠を除いた表示範囲の幅
		 * trace(width,height,stage.stageWidth,stage.stageHeight);
		 * 
		 * このstageの表示リストに追加すると座標がずれる?
		 * 
		 * だいたい標準設定
		 */
		static public function createWindow():NativeWindow 
		{
			
			//ウィンドウの設定
			var options:NativeWindowInitOptions = new NativeWindowInitOptions;
			options.systemChrome = NativeWindowSystemChrome.STANDARD; 
			options.type = NativeWindowType.UTILITY 
			options.transparent = false; 
			options.resizable = false; 
			options.maximizable = false;
			options.renderMode = "gpu";
			//ウィンドウのインスタンス
			var window:NativeWindow = new NativeWindow (options);
			window.activate();//アクティブにする。しないと見えない。
			
			return window;
		}
		
		
		/**
		 * 透明なOSネイティブのウィンドウを作成する
		 * 
		 */
		static public function createTransparentWindow():NativeWindow 
		{
			//ウィンドウの設定
			var options:NativeWindowInitOptions = new NativeWindowInitOptions;
			options.systemChrome = NativeWindowSystemChrome.NONE; //透明時はNoneにする; 
			options.type = NativeWindowType.UTILITY 
			options.transparent = true; 
			options.resizable = false; 
			options.maximizable = false;
			options.renderMode = "gpu";
			//ウィンドウのインスタンス
			var window:NativeWindow = new NativeWindow (options);
			window.activate();//アクティブにする。しないと見えない。
			
			return window;
		}
	}
}