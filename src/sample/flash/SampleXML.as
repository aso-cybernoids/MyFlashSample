package sample.flash 
{
	import flash.display.Sprite;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import mx.rpc.xml.SimpleXMLEncoder;
	/**
	 * XMLにはプロパティがない。メソッドなので注意!
	 * ○ xml.length()		← これは長さ
	 * × xml.length         ← これはlengthという名前のタグへの参照
	 * @author aso
	 */
	public class SampleXML extends Sprite
	{
		
		public function SampleXML() 
		{
			var xml:XML =
			<XML>
				<data>テスト１</data>
				<obj1 id = "属性１">
					<data1>テスト２</data1>
					<data2>テスト３</data2>
					<data3>テスト４</data3>
				</obj1>
				<obj2 id = "属性２">
					<data id="a" label="aaa">テスト５</data>
					<data id="b">テスト６</data>
					<data>テスト７</data>
				</obj2>
				<!--comment-->
			</XML>
			
		
			//var obj:Object=xmlToObject(xml);
			//sampleFind();
			//var tmp:XMLNode = xml.children[i];
			aaa()
			trace();
		}
		static public function aaa():void 
		{
			var xml:XML =<XML/>;
			var text:String = "1";
			xml.appendChild(
					<{text}>
						<FADE_IN>10</FADE_IN>
						<FADE_OUT>10</FADE_OUT>
						<PARAMS></PARAMS>
					</{text}>
				);
			for each (var item:* in xml.children()) 
			{
				trace(item);
				trace(item.localName());
			}
			trace(xml[text]["FADE_IN"]);
		}
		
		
		
		/**
		 * XMLを分解してなんとなく表示してみる。
		 * コメントのとり方がわからない
		 * xml.commentes()?
		 * 
		 * @param	xml
		 */
		static public function dump(xml:XML):void 
		{
			var children:XMLList = xml.children();//子供をXMLの配列として取得
			for (var i:int = 0; i < children.length(); i++) 
			{
				var item:XML = children[i];//子供のXML
				var attributes:XMLList = item.attributes();//属性。カラの時は要素のないXMLList。Nullにはならない
				//trace(item.nodeKind());//element
				//属性の処理
				for (var j:int = 0; j < attributes.length(); j++) 
				{
					var attribute:XML = attributes[j];
					//trace(attribute.nodeKind());//attribute
					trace(attribute.name());//属性名
					//trace(attribute.localName());//ネームスペースなしの属性名
					//trace(attribute.text());//なし
					trace(" "+attribute.toString());//属性の値
				}
				
				//要素の判定
				if (item.hasComplexContent()) 
				{
					//子供にXMLを含む場合は更に分解
					dump(item);
				}
				else if (item.hasSimpleContent()) 
				{
					//単純内容の時
					trace(item.name());//タグ名
					//trace(item.localName());//ネームスペースなしのタグ名
					trace(" "+item.text());//内容
				}else {
					//コメントまたは処理命令(こない?)
					trace("＼(^o^)／ なぜきたし");
				}
			}
		}
		static public function sampleFind():void 
		{
			var xml:XML =
			<XML>
				<data>テスト１</data>
				<obj1 id = "属性１">
					<data1>テスト２</data1>
					<data2>テスト３</data2>
					<data3>テスト４</data3>
				</obj1>
				<obj2 id = "属性２">
					<data id="a">テスト５</data>
					<data id="b">テスト６</data>
					<data>テスト７</data>
				</obj2>
				
			</XML>
			trace(xml.obj2.data.(hasOwnProperty("@id") && @id == "b"));
		}
		static public function xmlToJson():void 
		{
			
		}
		/**
		 * オブジェクトの値をXML形式に変換する。
		 * @param object 対象のデータ
		 * @param rootName XMLルート名
		 * @return XML
		 * */
		public static function objectToXML( object:Object,rootName:String="data"):XML
		{
			var qName:QName = new QName(rootName);
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(object, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			return xml;
		}
		
		/**
		 * XMLをObjectに変換する
		 * 
		 * 注意!
		 * 属性は@から始まる名前に変換される。
		 * 単純内容の時は属性は無視される。
		 * 
		 * @param	str
		 * @return
		 */
		static public function xmlToObject(xml:XML):Object 
		{
			var ret:Object = new Object;
			var children:XMLList = xml.children();//子供をXMLの配列として取得
			for (var i:int = 0; i < children.length(); i++) 
			{
				var item:XML = children[i];//子供のXML
				var attributes:XMLList = item.attributes();//属性。カラの時は要素のないXMLList。Nullにはならない
				var name:String = item.localName();//タグ名
				
				
				
				
				//要素の判定
				if (item.hasComplexContent()) 
				{
					//子供にXMLを含む場合は更に分解
					if (ret[name]!=null && ret[name] is Object) 
					{
						//配列化
						var array:Array = new Array;
						array.push(ret[name]);
						ret[name] = array;
					}
					
					if (ret[name] is Array) 
					{
						ret[name].push(xmlToObject(item));
					}else{
						ret[name] = xmlToObject(item);
					}
					//属性の処理
					for (var j:int = 0; j < attributes.length(); j++) 
					{
						var attribute:XML = attributes[j];
						var attributeName:String = attribute.localName();//属性名
						var attributeValue:String = attribute.toString();//属性の値
						
						ret[name]["@"+attributeName] = attributeValue;
					}
				}
				else if (item.hasSimpleContent()) 
				{
					//単純内容の時。属性は破棄
					var value:String = item.text().toString();//すべてString
					//子供にXMLを含む場合は更に分解
					
					
				}else {
					//コメントまたは処理命令(こない?)
				}
			}
			return ret;
		}
		
		/**
		 * 使い方サンプル
		 */
		static private function sample():void 
		{
			
			var xml:XML =
			<XML>
				<data>テスト１</data>
				<obj1 id = "属性１">
					<data1>テスト２</data1>
					<data2>テスト３</data2>
					<data3>テスト４</data3>
				</obj1>
				<obj2 id = "属性２">
					<data id="a">テスト５</data>
					<data id="b">テスト６</data>
					<data>テスト７</data>
				</obj2>
				
			</XML>
			
			
			var tmp:XMLList = XMLList(xml);//XMLListの下にXMLが付く形
			var tmp1:XMLList = xml.children();//構造はそのまま。
			var tmp2:*= xml.toJSON("test");//XMLという文字列。ナニコレ
			var tmp3:XMLList = tmp1.children();//階層がフラットになる
			
			
			xml.appendChild(<data1>aaa</data1>);//最後に追加
			xml.prependChild(<data2>bbb</data2>);// 最初に追加
			xml.prependChild(
				<data3>
					<data4>ccc</data4>
				</data3>
			);
			
			xml.data1.name = "aaa";//追加方法2
			xml.data1.@id = 1;//属性の追加

			delete xml.data2;//削除
			trace(xml);
		}
		
		
		/**
		 * XMLデータからJSONの文字列に変換
		 * 
		 * todo
		 * 属性はしらん
		 * 配列はしらん
		 * 
		 * @param	xml
		 */
		static private var nest:int = 0;
		static public function xmlToJsonString(xml:XML):String 
		{
			var ret:String="{\n"+parseXmlToJsonString(xml)+" \n}\n" ;
			
			return ret;
		}
		static private function parseXmlToJsonString(xml:XML):String 
		{
			var ret:String="" ;
			var children:XMLList = xml.children();//子供をXMLの配列として取得
			for (var i:int = 0; i < children.length(); i++) 
			{
				var item:XML = children[i];//子供のXML
				var name:String = item.localName();//タグ名
				
				if (ret!="") 
				{
					ret += " ,\n";
				}
				for (var j:int = 0; j < nest; j++) 
				{
					ret += "    ";
				}
				//要素の判定
				if (item.hasComplexContent()) 
				{
					//子供にXMLを含む場合は更に分解
					nest++;
					ret += "\""+ name+"\" : "+" {\n" + parseXmlToJsonString(item) + " \n} ";
					
				}
				else if (item.hasSimpleContent()) 
				{
					//単純内容の時。属性は破棄
					var value:String = item.text().toString();//すべてString
					if (isNaN(parseFloat(value))) 
					{
						//数字にできない時
						ret +="\""+ name+"\" : \""+value+"\"";
					}else {
						//数字の時
						
						ret +="\""+ name+"\" : "+Number(parseFloat(value)).toFixed(2);
					}
					
				}else {
					//コメントまたは処理命令(こない?)
				}
			}
			nest--;
			return ret;
		}
	}
}