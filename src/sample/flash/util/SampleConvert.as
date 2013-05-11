package sample.flash.util 
{
	import flash.display.Sprite;
	import sample.flash.SampleAssets;
	import sample.flash.SampleXML;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleConvert extends Sprite
	{
		
		public function SampleConvert() 
		{
			var str:String = "{\"PARAMS\" : {\"PARAM_EYE_L_OPEN\" :	-0.50}}";
			var xml:XML = JsonStrToXml(new SampleAssets.CStrJson);
			var jsonStr:String = xmlToJsonStr(xml);
			trace(jsonStr);
			var xml2:XML = JsonStrToXml(jsonStr);
		}
		
		
		/**
		 * JSONの文字列データからXMLへ
		 * 順番が保存される
		 * Object型は順番が保存されないのでシステム規定のJSONは不便
		 * 
		 * @param	jsonStr
		 * @return
		 */
		static public function JsonStrToXml(jsonStr:String):XML 
		{
			var xml:XML = Json.parseFromStringToXml(jsonStr);
			return xml;
		}
		
		
		/**
		 * XMLデータからJSONの文字列へ
		 * 
		 */
		static public function xmlToJsonStr(xml:XML):String
		{
			var jsonStr:String = SampleXML.xmlToJsonString(new XML(xml));
			return jsonStr;
		}
	}

}