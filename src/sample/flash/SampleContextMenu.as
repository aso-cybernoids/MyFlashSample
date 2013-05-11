package sample.flash 
{
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleContextMenu 
	{
		
		public function SampleContextMenu() 
		{
			
		}
		/**
		 * コンテストメニューに項目と実行関数を登録する
		 * @param	target
		 * @param	caption
		 * @param	func
		 */
		static public function addMenu(target:InteractiveObject,caption:String, func:Function=null):void {
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
			//target.contextMenu.hideBuiltInItems();
		}
	}

}