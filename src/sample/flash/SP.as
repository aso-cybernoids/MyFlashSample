package  flash
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * last update　2011/12/1
	 * ver 0.1.4 
	 * @author aso
	 */
	public class SP 
	{
		static public var width:Number = 300;
		static public var height:Number = 300;
		static public var scaleX:Number = 0.1;
		static public var scaleY:Number = 0.1;
		
		

		public function SP() 
		{
			
		}
		public static function init(s:DisplayObject) :void{
			width = s.width;
			height = s.height;
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
			if (isNaN(w)) w = Math.random() * width*scaleX;
			if (isNaN(h)) h = Math.random() * height*scaleY;
			if (isNaN(c)) c = Math.random() * 0xffffff;
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(c);
			sp.graphics.drawRect(x, y, w, h);
			sp.graphics.endFill();
			return sp;
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
			if (isNaN(r)) r = Math.random() * width*scaleX;
			if (isNaN(c)) c = Math.random() * 0xffffff;

			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(c);
			sp.graphics.drawCircle(x,y, r);
			sp.graphics.endFill();
			return sp;
		}
		static public function drag(sp:Sprite):Sprite 
		{
			sp.buttonMode = true;//MCをボタンMCのようにカーソルを変えます。

			sp.addEventListener(MouseEvent.MOUSE_DOWN, boxStartDrag);
			sp.addEventListener(MouseEvent.MOUSE_UP, boxStopDrag);
			return sp;
			function boxStartDrag(event:MouseEvent):void {
				sp.startDrag();//引数は未記述
			}
			function boxStopDrag(event:MouseEvent):void {
				sp.stopDrag();
			}
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
		static public function print(str:String,obj:DisplayObjectContainer):void 
		{
			var tf:TextField = new TextField();
			tf.text = str;
			tf.autoSize = TextFieldAutoSize.LEFT;
			obj.addChild(tf);
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE,function ():void 
			{
				obj.removeChild(tf);
				t.removeEventListener( TimerEvent.TIMER_COMPLETE,arguments.callee);
			});
			t.start();
		}
		static public function text(str:String):Sprite
		{
			var sp:Sprite = new Sprite();
			var tf:TextField = new TextField();
			tf.text = str;
			tf.autoSize = TextFieldAutoSize.LEFT;
			sp.addChild(tf);
			return sp;
		}
		static public function wheel(sp:Sprite):Sprite
		{
			sp.addEventListener(MouseEvent.MOUSE_WHEEL,function (e:MouseEvent):void 
			{
				if (e.delta>0) {
					sp.scaleX *= 1.1;
					sp.scaleY *= 1.1;
				}else {
					sp.scaleX *= 0.9;
					sp.scaleY *= 0.9;
				}
			});
			return sp;
		}
		/**
		 * コンテストメニューに項目と実行関数を登録する
		 * @param	target
		 * @param	caption
		 * @param	func
		 */
		static public function menu(target:InteractiveObject,caption:String, func:Function=null):void {
			var menu_item:ContextMenuItem = new ContextMenuItem("");	// メニューアイテムを作成

			menu_item.caption = caption;		// キャプション名
			if(func!=null){
				menu_item.enabled = true;			// 有効か
				menu_item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, func);
			}else {
				menu_item.enabled = false;			
			}
			menu_item.separatorBefore = false;		// １つ上にセパレータを付けるか
			menu_item.visible = true;			// 可視表示するか

			
			if(target.contextMenu==null){
				var menu_cm:ContextMenu = new ContextMenu ();
				menu_cm.customItems = [menu_item];		// カスタムメニューに登録
				
				// スプライトにコンテキストメニューを登録
				target.contextMenu = menu_cm;
				
			}else {
				//Flashではtarget.contextMenuはContextMenu
				//Airではtarget.contextMenuはNativeMenu（ContextMenuのスーパークラス）
				
				//target.contextMenu.hideBuiltInItems();
				if (target.contextMenu is ContextMenu) {
					if (ContextMenu(target.contextMenu).customItems==null) 
					{
						ContextMenu(target.contextMenu).customItems = new Array();
					}
					ContextMenu(target.contextMenu).customItems.push(menu_item);
				}
			}
			CONFIG::COMPILE_FOR_BROWSERS{
				target.contextMenu.hideBuiltInItems();
			}
		}
		static private var start:int = 0;
		static private var end:int = 0;
		static public function fps():Sprite 
		{
			var sp:Sprite = new Sprite();
			var tf:TextField = new TextField();
			tf.text = "init fps";
			tf.autoSize = TextFieldAutoSize.LEFT;
			sp.addChild(tf);
			var count:int = 0;
			sp.addEventListener(Event.ENTER_FRAME,function ():void 
			{
				count++;
				end = getTimer();
				var f:Number = 1000/(end - start) ;
				
				start = end;
				if (count%10==0) 
				{
					tf.text = f.toFixed(2);
				
					
				}
			});
			return sp;
		}
		static private var sliderCount:int = 0;
		static  public function slider(key:String,target:Object,max:Number=100,min:Number=0):Sprite 
		{
			if (!target.hasOwnProperty(key)) 
			{
				trace("key が存在しません。　SP.slider");
				return null;
			}
			var sp:Sprite = new Sprite;
			var tf:TextField = new TextField;
			sliderCount++;
			sp.x = 50;
			sp.y = 50 * sliderCount;
			tf.text = String(target) + ":" + key;
			tf.y = -23;
			tf.x = -10;
			tf.autoSize = TextFieldAutoSize.LEFT;
			sp.addChild(tf);
			
			
			var tfValue:TextField = new TextField;
			tfValue.text = target[key];
			tfValue.x = 120;
			tfValue.y = -10;
			sp.addChild(tfValue);
			
			//sprite
			var hBar:Sprite=new Sprite();;//x軸スライダーの背景
			var handle:Sprite=new Sprite();;//ドラッグハンドル
			//hBar.x = 50;
			//handle.x = 50;
				
			//スライダー範囲
			hBar.graphics.beginFill(0x969696);
			hBar.graphics.drawRoundRect(-5,  - 5, 100+10, 10, 4, 4);
			hBar.graphics.endFill();
			
			//可動範囲
			hBar.graphics.beginFill(0xC0C0C0);
			hBar.graphics.drawRoundRect(0,  - 3, 100, 6, 4, 4);
			hBar.graphics.endFill();
			
			//ハンドル
			handle.buttonMode = true;
			handle.x = (target[key]-min) / (max - min) * 100;
			handle.addEventListener(MouseEvent.MOUSE_DOWN, startDragSlider);
			
			handle.graphics.beginFill(0x569843);
			handle.graphics.drawCircle(0, 0, 6);
			handle.graphics.endFill();
			
			handle.graphics.beginFill(0x74ED6D);
			handle.graphics.drawCircle(0, 0, 5);
			handle.graphics.endFill();
			
			sp.addChild(hBar);
			hBar.addChild(handle);
			
			return sp;
	
			
			
			/**
			 * start drag event
			 * @param	e
			 */
			function startDragSlider(e:MouseEvent):void 
			{
				handle.removeEventListener(MouseEvent.MOUSE_DOWN, startDragSlider);
				sp.stage.addEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
				sp.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragSlider);
			}
			/**
			 * stop drag event
			 * @param	e
			 */
			function stopDragSlider(e:MouseEvent):void 
			{
				sp.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
				handle.addEventListener(MouseEvent.MOUSE_DOWN, startDragSlider);
				sp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragSlider);
			}
			/**
			 * drag event
			 * @param	e
			 */
			function dragSlider(e:MouseEvent):void 
			{
				//trace("move ", mouseH, mouseY);
				var x:Number = sp.mouseX;
				if (x >100 ) {
					x = 100;
				}else if (x <0 ) {
					x = 0;
				}
				
				handle.x = x;
				var value:Number=(max - min) / 100 * x + min;
				target[key] = value;
				tfValue.text = value.toString();
			}
		
		}
	
	}

}