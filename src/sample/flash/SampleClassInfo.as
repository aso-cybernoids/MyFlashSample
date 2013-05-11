package sample.flash 
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author ...
	 */
	public class SampleClassInfo 
	{
		
		public function SampleClassInfo() 
		{
			
		}
		/*
<type>	 	XML オブジェクトのルートタグです。
 	name	ActionScript オブジェクトのデータ型の名前です。
 	base	ActionScript オブジェクトを定義しているクラスのすぐ上のスーパークラスです。ActionScript オブジェクトがクラスオブジェクトの場合、値は Class になります。
 	isDynamic	ActionScript オブジェクトを定義しているクラスが dynamic の場合は true、それ以外の場合は false になります。ActionScript オブジェクトがクラスオブジェクトの場合、Class クラスは dynamic であるため、値は true になります。
 	isFinal	ActionScript オブジェクトを定義しているクラスが final の場合は true、それ以外の場合は false になります。
 	isStatic	ActionScript オブジェクトがクラスオブジェクトまたはコンストラクタ関数の場合は true、それ以外の場合は false になります。この属性が true の場合には factory タグ内にネストされていないすべてのタグが静的になるため、この属性には isStatic という名前が付けられています。
<extendsClass>	 	ActionScript オブジェクトを定義しているクラスの各スーパークラスには、個別に extendsClass というタグがあります。
 	type	ActionScript オブジェクトを定義しているクラスを拡張したスーパークラスの名前です。
<implementsInterface>	 	ActionScript オブジェクトを定義しているクラスまたはそのいずれかのスーパークラスによって実装されている各インターフェイスには、個別に implementsInterface というタグがあります。
 	type	ActionScript オブジェクトを定義しているクラスが実装しているインターフェイスの名前です。
<accessor>	 	アクセサは、getter 関数と setter 関数によって定義されたプロパティです。
 	name	アクセサの名前です。
 	access	プロパティのアクセス権です。有効な値には、readonly、writeonly、readwrite などがあります。
 	type	プロパティのデータ型です。
 	declaredBy	関連する getter 関数または setter 関数が含まれるクラスです。
<constant>	 	定数は、const ステートメントで定義されたプロパティです。
 	name	定数の名前です。
 	type	定数のデータ型です。
<method>	 	メソッドは、クラス定義の一部として宣言された関数です。
 	name	メソッドの名前です。
 	declaredBy	メソッドの定義が含まれるクラスです。
 	returnType	メソッドの戻り値のデータ型です。
<parameter>	 	メソッドによって定義されるパラメータごとに別個の parameter タグが使用されます。このタグは、常に <method> タグ内にネストされます。
 	index	メソッドのパラメータリストにパラメータが表示される順序に対応する番号です。最初のパラメータの値は 1 です。
 	type	パラメータのデータ型です。
 	optional	パラメータがオプションの場合には true、それ以外の場合は false になります。
<variable>	 	変数は、var ステートメントで定義されたプロパティです。
 	name	変数の名前です。
 	type	変数のデータ型です。
<factory>	 	ActionScript オブジェクトがクラスオブジェクトまたはコンストラクタ関数の場合、インスタンスのすべてのプロパティおよびメソッドは、このタグ内にネストされます。<type> タグの isStatic 属性が true の場合、<factory> タグ内にネストされていないすべてのプロパティおよびメソッドは静的です。このタグは、ActionScript オブジェクトがクラスオブジェクトまたはコンストラクタ関数の場合にのみ表示されます。
		*/
		public function dumpInfo(o:Object):void {
			trace("Class : "+getQualifiedClassName(o)+"\n"+describeType(o));
		}
		
		/**
		 * 例えばSampleクラスでEmbedしたAAAクラスは
		 * aaa.bbb.ccc::Sample_AAA
		 * のようになります。
		 * @param	o
		 * @return
		 */
		static public function getQClassName(o:*):String {
			
			return getQualifiedClassName(o);
		}
		static public function getClassName(o:*):String {
			
			return getQualifiedClassName(o).replace(/(.*)::/,"");
		}
		static public function getClassRef(classname:String):Object {
			
			return getDefinitionByName(classname);
		}
		static public function getAllProperty(o:*):Array {
			var ret:Array = new Array;
			var xml:XML = describeType(o);
			for (var i:int = 0; i < xml.accessor.length(); i++) 
			{
				var obj:Object = new Object();
				obj.name = String(xml.accessor[i].@name);
				obj.access =String( xml.accessor[i].@access);//readonly、writeonly、readwrite
				obj.type =String( xml.accessor[i].@type);
				obj.declaredBy = String(xml.accessor[i].@declaredBy);
				
				ret[i] = obj;
			}
			return ret;
		}
	}

}