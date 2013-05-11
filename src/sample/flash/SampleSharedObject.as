package sample.flash 
{
	/**
	 * ...
	 * @author ...
	 */
	public class SampleSharedObject 
	{
		
		public function SampleSharedObject() 
		{
			
		}
		/**
		 * 各OSのSharedObjectの保存先

			[Windows]
			C:\Documents and Settings\[ユーザー名]\Application Data\Macromedia\Flash Player\#SharedObjects

			[Mac]
			~/Library/Preferences/Macromedia/Flash Player

			[Linux]
			~/.macromedia
	

			[AIR コンパイル前]( Windowsの場合）

			C:\Documents and Settings\[ユーザー名]\Application Data\[AIRのID]\Local Store\#SharedObjects
		*/
		static public function saveSharedObject(key:String,obj:Object,filename:String="saveData"):Boolean 
		{				
			var so : SharedObject = SharedObject.getLocal(filename);
			if (so) {
				so.data[key] = obj;
				CONFIG::DEBUG{
					so.addEventListener (NetStatusEvent.NET_STATUS ,SharedObjectStatusEventFunc);
					function SharedObjectStatusEventFunc (event : NetStatusEvent):void {
						switch(event.info.code){
						case "SharedObject.Flush.Success":
							
								Util.logger.debug("ユーザーがハードディスク書き込み許可ボタンを押した");
							
							break;
						case "SharedObject.Flush.Failed":
							
								Util.logger.debug("ユーザーがハードディスク書き込み拒否ボタンを押した");
							
							break;
						default:
							
								Util.logger.debug("その他のイベントコード:" + event.info.code);
							
						}
					}
				}
				
				try {

					var str:String = so.flush(300);
				
					switch (str) {
						case SharedObjectFlushStatus.FLUSHED :
							CONFIG::DEBUG{
								Util.logger.debug("正常にハードディスクに書き込めました。");
							}
							
							  break;
						case SharedObjectFlushStatus.PENDING :
							CONFIG::DEBUG{
							  Util.logger.debug ("ユーザーにハードディスク書き込み要求を出します。");
							}
							return false;
							  
						default:
							Util.logger.debug("Write SharedObject. state:{0}", str);
							return false;
					}
				} catch (e:Error) {
					Util.logger.error ("書き込みに失敗しました。");
					return false;
				}
				
			}else {
				Util.logger.error("Could not write.");
				return false;
			}
			return true;
		}
		static public function deleteSharedObject(key:String,filename:String="saveData"):void 
		{				
			var so : SharedObject = SharedObject.getLocal(filename);
			if (so) {
				delete so.data[key];
				
				CONFIG::DEBUG{
					Util.logger.debug("Delete SharedObject key:{0}", key);
				}
			}else {
				Util.logger.error("Could not delete.");
			}
		}
		/**
		 * SharedObjectの内容を全て削除
		 */
		static public function clearSharedObject(filename:String="saveData"):void 
		{				
			var so : SharedObject = SharedObject.getLocal(filename);
			if (so) {
				so.clear();
				CONFIG::DEBUG{
					Util.logger.debug("Clear SharedObject ");
				}
			}else {
				Util.logger.error("Could not write.");
			}
		}
		static public function loadSharedObject(key:String,filename:String="saveData"):Object 
		{
			var so : SharedObject = SharedObject.getLocal(filename);
			return so.data[key];
		}
	}

}