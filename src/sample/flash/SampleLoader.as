
package sample.flash

{
	//import com.adobe.serialization.json.JSON;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import mx.graphics.codec.PNGEncoder;
	
	
	import flash.net.URLRequest;

/**
 * file utility
 */
public class SampleLoader 
{
	//組み込みファイルで完了イベントを送出するためのダミー画像
	//LoaderはEvent.Completeを手動で出せないので、読み込んだように見せかけられない。
	//そのためバイト配列からダミー画像の読み込みを行ってCompleteを送出する。
	//[Embed(source = 'dummy.png', mimeType='application/octet-stream')]
	static private var DAMMY_IMAGE:Class;

	//キャッシュファイル。キーはファイルパス。
	static private var caches:Array = new Array();
	//パスの切り替え。指定パスA（key)は指定パスB(value)として読み込む
	static private var uniqPath:Array = new Array();
	//組み込みファイル。キーはファイルパス。値はクラス型
	static private var embedFile:Array = new Array();
	//基準となるディレクトリ。設定しなくてもよい
	static private var currentDir:String;
	/**
	 * キャッシュを保存する。
	 * @param	filepath　ファイルパス
	 * @param	data　データ
	 */
	static public function setCache(filepath:String, data:*):void {
		caches[filepath] = data;
	}
	/**
	 * キャッシュを取得する。ない場合はnull
	 * @param	filepath
	 * @return
	 */
	static public function getCache(filepath:String):* {
		return caches[filepath];
	}
	/**
	 * 
	 * 特定のファイルパスを切り替える.
	 * ドロップ時など、パスを上書きしたい時に使用
	 * @param	filepath
	 * @param	fullpath
	 */
	static public function setUniqDir(filepath:String, fullpath:String):void {
		uniqPath[filepath] = fullpath;
	}
	
	
	/**
	 * 組み込みファイルの登録
	//key:ファイルパス　value:クラス 
	//SWFに組み込んで登録したファイルは読み込まない。外からはファイルロードと同じように扱える
	//とりあえずByteArrayだけ対応
	 * @param	classname
	 * @param	path
	 */
	public static function embed(classname:Class, path:String):void {
		embedFile[path] = classname;
	}
	
	
	/**
	 * パス設定からパスを変更、生成.
	 * @param	path
	 */
	static private function checkPath(path:String):String 
	{
		if (uniqPath[path]!=null) {//代替パスがある場合
			return uniqPath[path];
		}
		if (currentDir) {//カレントディレクトリ設定している場合
			return currentDir + path;
		}
		return path;
	}
	/**
	 * 組み込みバイト配列ファイルを読み込み.
	 * なければnull
	 * @param	path
	 * @param	loader
	 * @return
	 */
		static private function loadEmbedBytes(path:String,loader:URLLoader):Boolean {
			if (embedFile[path] != null) {
				loader.addEventListener(Event.COMPLETE,function ():void 
				{
					UtSystem.printf("embed file loaded\t: "+ path);
				});
				
				//クラス名の文字列からクラスの参照を生成
				loader.data = new (Class(embedFile[path])) as ByteArray;
				
				//完了イベントを手動で起こす
				loader.dispatchEvent(new Event(Event.COMPLETE));
				return true;//読み込み完了してるので終了
			}
			return false;//Embed データなし
		}
		/**
		 * キャッシュデータバイト配列から読み込み.
		 * なければnull
		 * @param	path
		 * @param	loader
		 * @return
		 */
		static private function loadCacheBytes(path:String,loader:URLLoader):Boolean {
			if (caches[path] != null) {
				loader.addEventListener(Event.COMPLETE,function ():void 
				{
					UtSystem.printf("cashed byte file loaded\t: "+ path);
				});
				
				loader.data = caches[path];
				
				//完了イベントを手動で起こす
				loader.dispatchEvent(new Event(Event.COMPLETE));
				return true;
			}
			return false;//Cacheなし
		}
		/**
		 * バイト配列を連続読み込み.
		 * 
		 * @param	paths
		 * @param	bytes
		 * @param	compFunc
		 * @param	errFunc
		 */
		static public function loadBytesFiles(paths:Vector.<String>, bytes:Vector.<ByteArray>, compFunc:Function, errFunc:Function=null):void {
			var count:int = 0;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;//binaryで読み込み
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			loadByteArray(paths[count], loader);
				
			function onComplete(e:Event):void 
			{
				loader.removeEventListener(Event.COMPLETE, onComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.dataFormat = URLLoaderDataFormat.BINARY;//binaryで読み込み
				bytes[count] = ByteArray(e.target.data);
				count++;
				
				if (count == paths.length) {
					try 
					{
						UtSystem.printf("まとめて読み込み完了");
						compFunc();
					} 
					catch (err:Error) 
					{
						UtSystem.errPrintf("関数実行エラー");
					}
				}else {
					loader = new URLLoader();
					loader.addEventListener(Event.COMPLETE, onComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
					
					loadByteArray(paths[count], loader);
				}
			}
			function onError(e:Event):void 
			{
				try 
				{
					errFunc(e);
				} 
				catch (err:Error) 
				{
					UtSystem.errPrintf("エラー関数実行エラー");
				}
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			}
		}
		/**
		 * ByteArrayを読み込み.
		 * embedデータがあったらそちらから読み込み.
		 * キャッシュがあったらそっちから読み込み.
		 * どちらもなければ通常読み込み
		 * @param	path
		 * @param	f		引数はByteArray型
		 */
		static public function loadByteArray(path:String, loader:URLLoader,enableEmbed:Boolean=true,enableCache:Boolean=true):void {
			if (enableEmbed && loadEmbedBytes(path,loader)) return;
			if (enableCache && loadCacheBytes(path,loader)) return;
			
			//通常の読み込み
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.dataFormat = URLLoaderDataFormat.BINARY;//binaryで読み込み
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(new URLRequest(checkPath(path)));
			UtSystem.printf("load start\t: " +checkPath(path));
			function onComplete(e:Event):void 
			{
				UtSystem.printf("load complete\t: " +checkPath(path));
			}
			function onError(e:IOErrorEvent):void 
			{
				UtSystem.errPrintf("load failed\t: " +checkPath(path));
				
				throw new Error("ByteArrayの読み込みでエラー\t: "+e.text);
			}
			
		}
		/**
		 * 組み込み画像データを読み込み.
		 * なければnull
		 * @param	path
		 * @param	loader
		 * @param	bm
		 * @return
		 */
		static private function loadEmbedImage(path:String,loader:Loader,bm:Bitmap):Boolean {
			if (embedFile[path] != null) {
				
				//クラス名の文字列からクラスの参照を生成
				if(bm!=null){
					bm.bitmapData = Bitmap( new (Class(embedFile[path])) ).bitmapData;
				}
				
				loader.contentLoaderInfo.addEventListener(Event.INIT, dummyComplete);
				//loader.load(new URLRequest("dummy.png"));//ダミーファイルを読み込んで完了イベントを起こす
				loader.loadBytes(new DAMMY_IMAGE as ByteArray);
				function dummyComplete(e:Event):void 
				{
					UtSystem.printf("embed image file loaded\t: "+ path);
				}
				return true;//読み込み完了してるので終了
			}
			return false;//Embed データなし
		}
		/**
		 * キャッシュされた画像を読み込み.
		 * ImageがByteArrayで格納されてる場合は判別してBitmapに読み込み直す
		 * なければnull
		 * @param	path
		 * @param	loader
		 * @param	bm
		 * @return
		 */
		static private function loadCasheImage(path:String,loader:Loader,bm:Bitmap):Boolean {
			if (caches[path] != null) {
				//loader.addEventListener(Event.COMPLETE,function ():void 
				//{
					//UtLog.log("cashed image file loaded"+ path);
				//});
				
				//ImageがByteArrayで格納されてる場合は判別してBitmapに読み込み直す
				if (caches[path] as ByteArray != null) {
					loadImageFromByteArray(caches[path], loader);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function ():void 
					{
						bm.bitmapData = Bitmap( loader.content).bitmapData;
						if (bm.bitmapData == null) {
							UtSystem.errPrintf("画像なし");
						}
						UtSystem.printf("cashed bytes image file loaded\t: "+ path);
					},false,2);
					return true;
				}
				
				if(bm!=null){
					bm.bitmapData = caches[path].bitmapData;
				}
			
				loader.contentLoaderInfo.addEventListener(Event.INIT, dummyComplete);
				loader.loadBytes(new DAMMY_IMAGE as ByteArray);
				function dummyComplete(e:Event):void 
				{
					UtSystem.printf("cashed image file loaded\t: "+ path);
					//UtLog.log("load complete\t: dummy.png" );
				}
				return true;
			}
			return false;
		}
		/**
		 * 画像を連続読み込み.
		 * 
		 * @param	paths
		 * @param	bitmaps
		 * @param	compFunc
		 * @param	errFunc
		 */
		static public function loadImages(paths:Vector.<String>, bitmaps:Vector.<Bitmap>, compFunc:Function, errFunc:Function=null):void {
			var count:int = 0;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			if(bitmaps[count]==null){
				bitmaps[count] = new Bitmap();
			}
			loadImage(paths[count], loader, bitmaps[count]);
				
			function onComplete(e:Event):void 
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);

				count++;
				
				if (count == paths.length) {
					try 
					{
						UtSystem.printf("まとめて読み込み完了");
						compFunc();
					} 
					catch (err:Error) 
					{
						UtSystem.errPrintf("関数実行エラー");
					}
				}else {
					loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
					
					if(bitmaps[count]==null){
						bitmaps[count] = new Bitmap();
					}
					loadImage(paths[count], loader, bitmaps[count]);
				}
			}
			function onError(e:Event):void 
			{
				try 
				{
					errFunc(e);
				} 
				catch (err:Error) 
				{
					UtSystem.errPrintf("エラー関数実行エラー");
				}
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			}
		}
		/**
		 * 画像を読み込み.
		 * キャッシュがあったらそっちから読み込み
		 * embedデータがあったらそちらから読み込み
		 * どちらもなければ通常読み込み
		 * @param	path
		 * @param	f		引数はBitmap型
		 */
		static public function loadImage(path:String, loader:Loader, bmp:Bitmap = null,enableEmbed:Boolean=true,enableCache:Boolean=true):void {
			if (enableCache && loadCasheImage(path, loader, bmp)) return;
			if (enableEmbed && loadEmbedImage(path, loader, bmp)) return;
			
			
			////////////////////////////////////////////////////////////////
			//var loader:Loader= new Loader();//Loader で読み込んだファイル（jpg, jpeg, png, gif）は Bitmap に変換される。
			loader.contentLoaderInfo.addEventListener(Event.INIT, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function ():void 
			{
				UtSystem.errPrintf("load failed\t: "+path);
			});
			loader.load(new URLRequest(checkPath(path)));
			UtSystem.printf("load start\t: "+ checkPath(path));
			function onComplete(e:Event):void 
			{
				if(bmp!=null){
					bmp.bitmapData = Bitmap(loader.content).bitmapData;
				}
				UtSystem.printf("load complete\t: " + checkPath(path));
			}
		}
		/**
		 * ByteArrayから画像を読み込み
		 * @param	path
		 * @param	f		引数はBitmap型
		 */
		static public function loadImageFromByteArray(data:ByteArray, loader:Loader):void {
			//var loader:Loader= new Loader();//Loader で読み込んだファイル（jpg, jpeg, png, gif）は Bitmap に変換される。
			loader.contentLoaderInfo.addEventListener(Event.INIT, onComplete);//INITでいいのかな
			loader.loadBytes(data);
			
			function onComplete(e:Event):void 
			{
				UtSystem.printf("image load complete from ByteArray");
				//f(Bitmap(loader.content));
			}
		}
		
		/**
		 * XMLを読み込み
		 * @param	path
		 * @param	f		引数はXML型
		 */
		static public function loadXML(path:String, loader:URLLoader):void{
			//loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(new URLRequest(checkPath(path)));
			
			function onComplete(e:Event):void 
			{
				UtSystem.printf("load complete\t: "+ path);
				//f(XML(e.target.data));
			}
			function onError(e:IOErrorEvent):void 
			{
				UtSystem.errPrintf(e.text );
				throw new Error("XMLの読み込みでエラー")
			}
		}
		/**
		 * JSONを読み込み
		 * @param	path
		 * @param	f		引数はXML型
		 */
		static public function loadJson(path:String, loader:URLLoader):Object {
			var obj:Object = new Object();
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(new URLRequest(checkPath(path)));
			return obj;
			function onComplete(e:Event):void 
			{
				// 読み込んだデータを取得
				var str:String = e.target.data;

				// JSONエンコーダーを利用してObject型に変換
				try{
				var o:Object = Json.parseFromString(str);
				for (var key:String in o) 
				{
					obj[key] = o[key];
				}
				}catch (err:Error)
				{
					UtSystem.errPrintf("JSONパースエラー");
				}
			}
			function onError(e:IOErrorEvent):void 
			{
				UtSystem.errPrintf(e.text);
				throw new Error("JSONの読み込みでエラー")
			}
		}
		/**
		 * サウンド読み込み
		 * @param	path
		 * @param	s		引数はSound型
		 */
		static public function loadSound(path:String, s:Sound):void{
			var url : URLRequest = new URLRequest(path);
			//var sound : Sound = 
			s.load(url);
			s.addEventListener(Event.COMPLETE,function ():void 
			{
				UtSystem.printf("load complete\t: "+path);
			});
		}

		/**
		 * ファイルダイアログからファイル読み込み
		 * @param	path
		 * @param	f		引数はByteArray型
		 */

		static public function fileUploadDialogJson( fr:FileReference):Object {
			//ファイルダイアログを用意。選択したら読み込み
			//var fl:FileReference = new FileReference();
			var obj:Object = new Object();
			fr.addEventListener(Event.SELECT, function(e:Event):void { FileReference(e.target).load(); } );
			fr.addEventListener(Event.COMPLETE, onComplete,false,255);
			fr.addEventListener(IOErrorEvent.IO_ERROR, onError);
			fr.browse();
			return obj;
			function onComplete(e:Event):void
			{
				UtSystem.printf("upload complete\t: "+fr.name);
				//var str:String = String(e.data);
				// 読み込んだデータを取得
				var str:String = String(fr.data);

				// JSONエンコーダーを利用してObject型に変換
				try{
					var o:Object = Json.parseFromString(str);
					for (var key:String in o) 
					{
						obj[key] = o[key];
					}
				}catch (err:Error)
				{
					UtSystem.errPrintf("JSONパースエラー");
				}
				
			}
			function onError(e:IOErrorEvent):void 
			{
				UtSystem.errPrintf(e.text);
				throw new Error("読み込みエラー")
			}
		}	
		/**
		 * ファイルダイアログからファイル読み込み
		 * 選択されたら自動で読み込み。読み込み完了イベントを設定してください
		 * @param	fl
		 */
		static public function fileUploadDialog(fr:FileReference):void {
			//ファイルダイアログを用意。選択したら読み込み
			//var fl:FileReference = new FileReference();
			fr.addEventListener(Event.SELECT, function(e:Event):void { FileReference(e.target).load(); } );
			fr.addEventListener(Event.COMPLETE, onComplete);
			fr.addEventListener(IOErrorEvent.IO_ERROR, onError);
			fr.browse();
			function onComplete(e:Event):void
			{
				UtSystem.printf("upload complete\t: " +fr.name);
				//bytearrayで読み込まれる
				//f(ByteArray(e.target.data),e.target.name,e.target.size);
				
			}
			function onError(e:IOErrorEvent):void 
			{
				UtSystem.errPrintf(e.text);
				throw new Error("読み込みエラー")
			}
		}	
		/**
		 * ファイルダイアログからファイル読み込み
		 * 選択されたら自動で読み込み。読み込み完了イベントを設定してください
		 * @param	fl
		 */
		static public function fileUploadDialogImage(loader:Loader,fr:FileReference):void {
			//ファイルダイアログを用意。選択したら読み込み
			if (fr == null) {
				fr = new FileReference();
			}
			
			fr.addEventListener(Event.SELECT, function(e:Event):void { FileReference(e.target).load(); } );
			fr.addEventListener(Event.COMPLETE, onComplete);
			fr.addEventListener(IOErrorEvent.IO_ERROR, onError);
			fr.browse();
			function onComplete(e:Event):void
			{
				loadImageFromByteArray(fr.data, loader);
				//f(ByteArray(e.target.data),e.target.name,e.target.size);
				
			}
			function onError(e:IOErrorEvent):void 
			{
				UtSystem.errPrintf(e.text);
				throw new Error("読み込みエラー")
			}
		}		
		/**
		 * ファイルダイアログからファイル保存
		 * @param	data　保存するデータ。型はなんでも良い
		 * @param	name　最初に表示するファイル名。なくても良い
		 */
		static public function fileSaveDialog(data:*,name:String=null):void {
			var fl:FileReference = new FileReference();
			fl.save(data, name);
		}
		/**
		 * ファイルダイアログからPNG保存
		 * @param	data　保存するデータ。型はなんでも良い
		 * @param	name　最初に表示するファイル名。なくても良い
		 */
		static public function fileSaveDialogPNG(bmd:BitmapData, name:String = null):void {
			var fr:FileReference = new FileReference();
			var pngEn:PNGEncoder = new PNGEncoder();
			var data:ByteArray = pngEn.encode(bmd);
			if (name == null) {
				name = "image.png";
			}
			fr.save(data, name);
			
		}
		/**
		 * 基準となるディレクトリを設定
		 * @param	path
		 */
		static public function setCurrentDir(path:String):void 
		{
			currentDir = path;
			//var tmp:Array = path.match(/.*\//);
			//if(tmp){
				//currentDir = tmp[0];
			//}
			UtSystem.printf("setCurrentDir\t: "+currentDir);
		}
		/**
		 * 基準ディレクトリを解除
		 */
		static public function resetCurrentDir():void {
			currentDir = "";
			UtSystem.printf("resetCurrentDir");
		}
		/**
		 * Embedファイルかキャッシュファイルが存在するかどうか
		 * @param	path
		 * @return
		 */
		static public function isExistFile(path:String):Boolean {
			if (embedFile[path] != null) return true;
			if (caches[path] != null) return true;
			return false;
		}
	}
}


