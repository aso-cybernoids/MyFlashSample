package sample.air 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleFile extends Sprite
	{
		
		public function SampleFile() 
		{
			openMultiple();
			//trace(loadString("C:/dev/data/test.txt"));
			//trace(loadBytes("C:/dev/data/test.txt"));
			//trace(loadStringWithEncode("C:/dev/data/test.txt","UTF-8"));
		}
		static public function save(title:String="title"):void 
		{
			var file:File = File.desktopDirectory;
			file.browseForSave(title);
			
			// 
			file.addEventListener(Event.SELECT,function (e:Event):void {
				// 選択したファイル
				var selectedFile : File = e.target as File;
				trace("保存 : " + selectedFile.nativePath);
				
				// ファイルに書き込む
			});

			// キャンセルされた時
			file.addEventListener(Event.CANCEL,	function (e:Event):void {
				trace("キャンセル");
			});
		}
		/**
		 * ファイルに書き込む
		 */
		static public function write(file:File,writeString:String):void 
		{
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(writeString);
			stream.close();
		}
		/**
		 * 書き込みサンプル
		 * コピペ改変用
		 * @param	file
		 */
		static public function sampleWrite():void 
		{
			var file:File = File.desktopDirectory.resolvePath("sample.txt");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			
			stream.writeBoolean(true);//ブール値を書き込みます。1 バイトが書き込まれます。true の場合は 1、false の場合は 0 のいずれかが書き込まれます。
			stream.writeByte(0);//バイトを書き込みます。パラメーターの下位 8 ビットが使用されます。上位 24 ビットは無視されます。
			var bytes:ByteArray = new ByteArray;
			var offset:int = 0;
			var length:int = 0;
			stream.writeBytes(bytes, 0, 0);//指定したバイト配列（bytes）の offset（0 から始まるインデックス値）バイトから開始される length バイトのシーケンスをファイルストリーム、バイトストリームまたはバイト配列に書き込みます。
			stream.writeDouble(0);//IEEE 754 倍精度（64 ビット）浮動小数点数を書き込みます。
			stream.writeFloat(0);//IEEE 754 単精度（32 ビット）浮動小数点数を書き込みます。
			stream.writeInt(0);//32 ビット符号付き整数を書き込みます。
			stream.writeMultiByte("text", "shift-jis");//指定した文字セットを使用して、ファイルストリーム、バイトストリームまたはバイト配列にマルチバイトストリングを書き込みます。
			stream.writeObject(new Object);//ファイルストリーム、バイトストリームまたはバイト配列に、AMF 直列化形式でオブジェクトを書き込みます。
			stream.writeShort(0);//16 ビット整数を書き込みます。パラメーターの下位 16 ビットが使用されます。上位 16 ビットは無視されます。
			stream.writeUnsignedInt(0);//32 ビット符号なし整数を書き込みます。
			stream.writeUTF("text");//UTF-8 ストリングを書き込みます。 最初に UTF-8 ストリングの長さがバイト単位で 16 ビット整数として書き込まれ、その後にストリングの文字を表すバイトが続きます。
			stream.writeUTFBytes("text");//UTF-8 ストリングを書き込みます。writeUTF() と似ていますが、ストリングに 16 ビット長の接頭辞が付きません。
			
			
			stream.close();
		}
		static public function open(title:String="title"):void 
		{
			var file:File = File.desktopDirectory;
			file.browseForOpen(title);//title,[filter1,filter2,...]
			
			// ファイル選択イベント
			file.addEventListener(Event.SELECT, function(event:Event):void {
				var selectedFile:File = File(event.target);
				trace(selectedFile.name);
			});
		}
		
		/**
		 * 複数ファイルを開く
		 * @param	title
		 */
		static public function openMultiple(title:String="title"):void 
		{
			var file:File = File.desktopDirectory;
			file.browseForOpenMultiple(title);//title,[filter1,filter2,...]
			
			// ファイル選択イベント
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, function(event:FileListEvent):void {
				// 選択した複数ファイル
				var files : Array = event.files;
				var i : int;
				for(i=0;i < files.length;i++){
					var selectedFile : File = files[i];
					trace("開く : " + selectedFile.nativePath);
				}
			});
			
			// キャンセルされた時
			file.addEventListener(Event.CANCEL,	function(e:Event):void {
				trace("キャンセル");
			});
		}

		/**
		 * 
		 * @param	name フィルタの表示名 例)"C++ソースファイル"
		 * @param	type 受け付けるファイル名を「;」でつないで記述(ワイルドカード可) 例)"*.c;*.cpp;*.cc;*.c++"
		 * @return
		 */
		static public function createFilter(name:String,type:String):FileFilter 
		{
			var filter:FileFilter = new FileFilter(name,type);
			return filter;
		}
		static public function sampleCreateFilter(type:String):FileFilter 
		{
			// フィルタの表示名、受け付けるファイル名を「;」でつないで記述(ワイルドカード可)
			var filter:FileFilter = new FileFilter("C++ソースファイル", "*.c;*.cpp;*.cc;*.c++");
			
			return filter;
		}
		/**
		 * このファイル形式用としてオペレーティングシステムに登録されているアプリケーションで、ファイルを開きます。
		 * @param	file
		 */
		static public function openNativeApp(file:File):void 
		{
			file.openWithDefaultApplication();
		}
		/**
		 * ファイルの読み込み
		 * @param	path
		 * @return
		 */
		static public function loadBytes(path:String):ByteArray 
		{
			var file:File = new File(path);
			var reader:FileStream = new FileStream();
			var byteArray:ByteArray = new ByteArray;
			reader.open(file, FileMode.READ);
			
			var offset:int = 0;
			var length:int = reader.bytesAvailable;
			reader.readBytes(byteArray,offset,length);
			
			return byteArray;
		}
		static public function loadString(path:String):String 
		{
			var file:File = new File(path);
			var reader:FileStream = new FileStream();
			var ret:String;
			reader.open(file, FileMode.READ);
			ret=reader.readUTFBytes(reader.bytesAvailable);
			
			return ret;
		}
		
		/**
		 * 
		 * 文字セットのストリングには、"shift-jis"、"cn-gb"、および "iso-8859-1" などがあります
		 * @param	path
		 * @param	charSet
		 * @return
		 */
		static public function loadStringWithEncode(path:String,charSet:String):String 
		{
			var file:File = new File(path);
			var reader:FileStream = new FileStream();
			var ret:String;
			reader.open(file, FileMode.READ);
			ret=reader.readMultiByte(reader.bytesAvailable,charSet);
			
			return ret;
		}
	}

}