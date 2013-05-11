package sample.flash.util 
{
/**
 * JsonParser 0.1.00 (2011/02/14)
 * 
 * Ascii文字のみ対応した最小限の軽量JSONパーサ
 * 仕様はJSONのサブセットとなる。
 * 
 * 設定ファイルなどのロード用
 * 
 * <JSONファイルの byteデータからパース>
 *  var v:Object = JsonParser.parseFromBytes( bytes ) ;//ファイルから読み込んだバッファの場合
 * 
 * <JSON文字列からパース>
 *  var s:String = '{  "abc" :\n[  2  ,[3.1415,3232,"good"] ,4,5 ] }' ;
 * 	var v:Object = JsonParser.parseFromString( s ) ;//JSON文字列の場合
 *  trace( " json :: " + o ) ;
 *  trace( " json :: " + o["abc"][1] ) ;
 * 
 * < 未対応項目 >
 * ・日本語などの非ASCII文字
 * ・e による指数表現
 */

import flash.utils.ByteArray;


public class Json 
{
	private var buf:ByteArray ; 
	private var len:int ; 
	private var line_count:int = 0 ; 
	private var root:Object ;
	private var rootXml:XML;


	/**
	 * JSONの文字列バッファをパースする
	 * 
	 * var v:Object = JsonParser.parseFromBytes( buf ) ; 
	 * 
	 * @param	buf
	 * @return
	 */
	public static function parseFromBytes( buf:ByteArray ):Object { // ByteArray<byte>
		var jp:Json = new Json( buf ) ;
		var ret:Object = jp.parse() ;
		return ret ;
	}
	
	/**
	 * JSONの文字列をパースする
	 * 
	 * var v:Object = JsonParser.parseFromString( buf ) ; 
	 * @param	str
	 * @return
	 */
	public static function parseFromString( str:String ):Object { // ByteArray<byte>
		var buf:ByteArray = new ByteArray() ;
		buf.writeUTF( str ) ;
		
		var jp:Json = new Json( buf ) ;
		var ret:Object = jp.parse() ;
		return ret ;
	}
	
	/**
	 * JsonParserのコンストラクタ(非推奨）
	 * 
	 * 実体をつくらずに下記のstaticメソッドで直接処理すれば良い( ActionScript3 , Javaの場合 )
	 * 
	 * var v:Object = JsonParser.parse( buf ) ; 
	 * 
	 * @param	buf
	 */
	public function Json( buf:ByteArray ){ // ByteArray<byte>
		this.buf = buf ;
		this.len = buf.length ;
	}

	/**
	 * 
	 * @return
	 */
	public function parse():Object { 
		try {
			var ret_pos:Vector.<int> = new Vector.<int>(1) ;
			root = parseValue(buf , len , 0 , ret_pos) ;
			return root ;
		}
		catch( e:Error ){
			throw new Error( "JSON error " + "@line:" + line_count + " / " + e.message , e ) ;
		}
		return null ;
	}
	
	
	private static function getString( str:ByteArray , start:int , length:int ):String {
		var tmp:ByteArray = new ByteArray() ;
		str.position = start ;
		str.readBytes( tmp , 0 , length ) ;
		return tmp.toString() ;
	}
	
	private static function parseString( str:ByteArray , len:int , _pos:int , ret_endpos:Vector.<int> ):String { // Array<byte> Array<int>
		var i:int = _pos ;
		var c:uint , c2:uint ;
//		var sbuf:StringBuffer = null ;
		var sbuf:String = null ;

		var buf_start:int = _pos ;
		for(  ; i < len ; i++ ) {
			c = str[i] ;

			if( c == 0x22 ){// "
				ret_endpos[0] = i + 1 ;
				if( sbuf != null ) {
					if( i - 1 > buf_start ) sbuf += getString( str , buf_start , i - 1 - buf_start ) ;//最後の"をのぞくため -1
					return sbuf ;
				}
				else {
					return getString( str , _pos , i - _pos ) ;
				}
			}
			else if( c == 0x5c ){ // '\\'
				if( sbuf == null ) {
					sbuf = "" ;
				}
				
				if ( i > buf_start ) {
					sbuf += getString( str , buf_start , i - buf_start ) ;
				}
				
				i++ ;
				if( i < len ) {
					c2 = str[i] ;
					if( c2 == 0x5c ){// '\\'
						sbuf += '\\' ;// sbuf.append('\\') ;
					}
					else if( c2 == 0x22 ){// "
						sbuf += '\"' ;// sbuf.append('\"') ;
					}
					else if( c2 == 0x2f ){// /
						sbuf += '/"' ;// sbuf.append('/') ;
					}
					else if( c2 == 0x62 ){//アルファベットのb
						sbuf += '\b' ;// sbuf.append('\b') ;
						break ;
					}
					else if( c2 == 0x66 ){ // アルファベットのf
						sbuf += '\f' ;// sbuf.append('\f') ;
					}
					else if( c2 == 0x6e ){ // アルファベットのn
						sbuf += '\n' ;// sbuf.append('\n') ;
					}
					else if( c2 == 0x72 ){ // アルファベットのr
						sbuf += '\r' ;// sbuf.append('\r') ;
					}
					else if( c2 == 0x74 ){ // アルファベットのt
						sbuf += '\t' ;// sbuf.append('\t') ;
					}
					else if( c2 ==0x75 ){ // アルファベットのu
						throw new Error( "parse string/unicode escape not supported" ) ;
					}
				}
				else {
					throw new Error( "parse string/escape error" ) ;
				}
				buf_start = i + 1 ;
			}
		}
		throw new Error( "parse string/illegal end" ) ;
	}
	
	private function parseObject( buf:ByteArray , len:int , _pos:int , ret_endpos:Vector.<int> ):Object { // Array<byte> Array<int>
		var ret:Object = {} ;
		
		var key:String = null ;
		var i:int = _pos ;
		var c:uint ;
		var local_ret_endpos2:Vector.<int> = new Vector.<int>(1) ;
		var ok:Boolean = false ;
		
		for(  ; i < len ; i++ ) {
			
			for(  ; i < len ; i++ ) {
				c = buf[i] ;
	
				if ( c == 0x22 ) {// "
					key = parseString(buf , len , i + 1 , local_ret_endpos2) ;
					i = local_ret_endpos2[0] ;
					ok = true ;
					break ;
				}
				else if ( c == 0x7d ) {// }
					ret_endpos[0] = i + 1 ;
					return ret ;
				}
				else if ( c == 0x3a ) {// :
					throw new Error( "illegal ':' position" ) ;
				}

			}

			if( !ok ) throw new Error( "key not found" ) ;
			
			ok = false ;
			for(  ; i < len ; i++ ) {
				c = buf[i] ;

				if(  c == 0x3a ) {// :
					ok = true ;
					i++ ;
					break ;
				}
				else if(  c == 0x7d ) {// }
					throw new Error( "illegal '}' position" ) ;
				}
				else if( c == 0x0a ){// \n
					line_count++ ;
				}
			}
			if( !ok ) throw new Error( "':' not found" ) ;
			
			var value:Object = parseValue(buf , len , i , local_ret_endpos2) ;
			i = local_ret_endpos2[0] ;
			ret[key] = value ;
			
			for(  ; i < len ; i++ ) {
				c = buf[i] ;
				
				if ( c == 0x2c ) {// ','
					break ;
				}
				else if( c == 0x7d ){ //'}':
					ret_endpos[0] = i + 1 ;
					return ret ;
				}
				else if( c == 0x6e ){//case '\n':
					line_count++ ;
				}
			}
		}
		throw new Error( "illegal end of parseObject" ) ;
	}
	
	private function parseArray( buf:ByteArray , len:int , _pos:int , ret_endpos:Vector.<int> ):Vector.<Object>  { // Array<byte> Array<int>
		var ret:Vector.<Object> = new Vector.<Object>() ;
		
		var i:int = _pos ;
		var c:uint ;
		var local_ret_endpos2:Vector.<int> = new Vector.<int>(1) ;
		for(  ; i < len ; i++ ) {
			var value:Object = parseValue(buf , len , i , local_ret_endpos2) ;
			i = local_ret_endpos2[0] ;
			ret.push(value) ;
			
			for(  ; i < len ; i++ ) {
				c = buf[i] ;

				if ( c == 0x2c ) {// ','
					break ;
				}
				else if ( c == 0x5d ) {// ']'
					ret_endpos[0] = i + 1 ;
					return ret ;
				}
				else if ( c == 0x6e ){// \n
					line_count++ ;
				}
			}
		}
		throw new Error( "illegal end of parseObject" ) ;
	}
	
	private function parseValue( buf:ByteArray , len:int , _pos:int , ret_endpos2:Vector.<int> ):Object { // Array<byte> Array<int>
		var o:Object ;
		var i:int = _pos ;
		var c:uint ;
		for(  ; i < len ; i++ ) {
			c = buf[i] ;

			if( c == 0x09 || c == 0x20 ){// TAB , SPACE
				//スキップ
			}
			else if ( c == 0x0a ) {// '\n'
				line_count++ ;
			}
			else if ( (0x30 <= c && c <= 0x39) || c == 0x2d || c == 0x2e ) {//'0'..'9'  , '.' , '-' 
				var f:Number = 0//UtString.strToDouble(buf , i , ret_endpos2) ;
				trace("todo: json");
				return f ;
			}
			else if ( c == 0x22 ) {// '"'
				o = parseString(buf , len , i + 1 , ret_endpos2) ;
				return o ;
			}
			else if ( c == 0x5b ) {// '['
				o = parseArray(buf , len , i + 1 , ret_endpos2) ;
				return o ;
			}
			else if( c == 0x7b ){// '{'
				o = parseObject(buf , len , i + 1 , ret_endpos2) ;
				return o ;
			}
			else if ( c == 0x6e ) {// 'n'
				if( i + 3 < len ) o = null ;
				else throw new Error( "parse null" ) ;
				return o ;			
			}
			else if ( c == 0x74 ) {// 't'
				if ( i + 3 < len ) o = true ;// Boolean.TRUE ;
				else throw new Error( "parse true" ) ;
				return o ;
			}
			else if ( c == 0x66 ) {// 'f'
				if ( i + 4 < len ) o = false ;// Boolean.FALSE ;
				else throw new Error( "parse false" ) ;
				return o ;
			}
			else if ( c == 0x2c ) {// ','
				throw new Error( "illegal ',' position" ) ;
			}
//			else {}	//なにもしない
		}
		
		throw new Error( "illegal end of value" ) ;
	}
	
	
	
	/**
	 * JSONの文字列をXMLへパースする
	 * 
	 * var v:Object = JsonParser.parseFromString( buf ) ; 
	 * @param	str
	 * @return
	 */
	public static function parseFromStringToXml( str:String ):XML { // ByteArray<byte>
		var buf:ByteArray = new ByteArray() ;
		buf.writeUTFBytes( str ) ;
		
		var jp:Json = new Json( buf ) ;
		var ret:XML = jp.parseXml() ;
		return ret ;
	}
	/**
	 * 
	 * @return
	 */
	public function parseXml():XML { 
		try {
			var ret_pos:Vector.<int> = new Vector.<int>(1) ;
			
			var list:XMLList = XMLList(parseValueToXml(buf , len , 0 , ret_pos));
			rootXml =<XML/>;
			rootXml.appendChild(list);
			//rootXml =  list;
			return rootXml ;
		}
		catch( e:Error ){
			throw new Error( "JSON error " + "@line:" + line_count + " / " + e.message , e ) ;
		}
		return null ;
	}
	private function parseValueToXml( buf:ByteArray , len:int , _pos:int , ret_endpos2:Vector.<int> ):Object { 
		var i:int = _pos ;
		var c:uint ;
		for(  ; i < len ; i++ ) {
			c = buf[i] ;

			if( c == 0x09 || c == 0x20  ){// TAB , SPACE 
				//スキップ
			}
			else if ( c == 0x0a ) {// '\n'
				line_count++ ;
			}
			else if ( (0x30 <= c && c <= 0x39) || c == 0x2d || c == 0x2e ) {//'0'..'9'  , '.' , '-' 
				var f:Number = strToDouble(buf , i , ret_endpos2) ;
				
				
				return f ;
			}
			else if ( c == 0x22 ) {// '"'
				var str:String=parseString(buf , len , i + 1 , ret_endpos2) ;
				
				return str ;
			}
			else if ( c == 0x5b ) {// '['
				var xml:XMLList = parseArrayToXml(buf , len , i + 1 , ret_endpos2) ;
				return xml ;
			}
			else if( c == 0x7b ){// '{'
				xml = parseObjectToXml(buf , len , i + 1 , ret_endpos2) ;
				return xml ;
			}
			else if ( c == 0x6e ) {// 'n'
				if( i + 3 < len ) xml = null ;
				else throw new Error( "parse null" ) ;
				return null ;			
			}
			else if ( c == 0x74 ) {// 't'
				if ( i + 3 < len ) xml = null ;// Boolean.TRUE ;
				else throw new Error( "parse true" ) ;
				return true ;
			}
			else if ( c == 0x66 ) {// 'f'
				if ( i + 4 < len ) xml = null ;// Boolean.FALSE ;
				else throw new Error( "parse false" ) ;
				return false ;
			}
			else if ( c == 0x2c ) {// ','
				throw new Error( "illegal ',' position" ) ;
			}
//			else {}	//なにもしない
		}
		
		throw new Error( "illegal end of value" ) ;
	}
	private function parseObjectToXml( buf:ByteArray , len:int , _pos:int , ret_endpos:Vector.<int> ):XMLList {
		var ret:XMLList  =null;
		
		var key:String = null ;
		var i:int = _pos ;
		var c:uint ;
		var local_ret_endpos2:Vector.<int> = new Vector.<int>(1) ;
		var ok:Boolean = false ;
		
		
			
		for(  ; i < len ; i++ ) {
			
			for(  ; i < len ; i++ ) {
				c = buf[i] ;
	
				if ( c == 0x22 ) {// "
					key = parseString(buf , len , i + 1 , local_ret_endpos2) ;
					i = local_ret_endpos2[0] ;
					ok = true ;
					break ;
				}
				else if ( c == 0x7d ) {// }
					ret_endpos[0] = i + 1 ;
					return new XMLList ;
				}
				else if ( c == 0x3a ) {// :
					throw new Error( "illegal ':' position" ) ;
				}

			}

			if( !ok ) throw new Error( "key not found" ) ;
			
			ok = false ;
			for(  ; i < len ; i++ ) {
				c = buf[i] ;

				if(  c == 0x3a ) {// :
					ok = true ;
					i++ ;
					break ;
				}
				else if(  c == 0x7d ) {// }
					throw new Error( "illegal '}' position" ) ;
				}
				else if( c == 0x0a ){// \n
					line_count++ ;
				}
			}
			if( !ok ) throw new Error( "':' not found" ) ;
			
			var value:Object = parseValueToXml(buf , len , i , local_ret_endpos2) ;
			
			
			if (ret==null) 
			{
				ret = new XMLList(<{key}>{value}</{key}>);
				//ret.setChildren(<{key}>{value}</{key}>);
				//ret[0] =<{key}>{value}</{key}>;
			}else {
				ret[ret.length()] = <{key}>{value}</{key}>;
				//ret.appendChild(<{key}>{value}</{key}>);
			}
			
			
			i = local_ret_endpos2[0] ;
			
			
			for(  ; i < len ; i++ ) {
				c = buf[i] ;
				
				if ( c == 0x2c ) {// ','
					break ;
				}
				else if( c == 0x7d ){ //'}':
					ret_endpos[0] = i + 1 ;
					return ret ;
				}
				else if( c == 0x6e ){//case '\n':
					line_count++ ;
				}
			}
		}
		throw new Error( "illegal end of parseObject" ) ;
	}
	
	private function parseArrayToXml( buf:ByteArray , len:int , _pos:int , ret_endpos:Vector.<int> ):XMLList {
		var ret:XMLList=new XMLList ;
		
		var i:int = _pos ;
		var c:uint ;
		var local_ret_endpos2:Vector.<int> = new Vector.<int>(1) ;
		for(  ; i < len ; i++ ) {
			var value:Object = parseValueToXml(buf , len , i , local_ret_endpos2) ;
			i = local_ret_endpos2[0] ;
			
			ret.appendChild(value);
			for(  ; i < len ; i++ ) {
				c = buf[i] ;

				if ( c == 0x2c ) {// ','
					break ;
				}
				else if ( c == 0x5d ) {// ']'
					ret_endpos[0] = i + 1 ;
					return ret ;
				}
				else if ( c == 0x6e ){// \n
					line_count++ ;
				}
			}
		}
		throw new Error( "illegal end of parseObject" ) ;
	}
	public static function strToDouble( str:ByteArray ,  pos:int , ret_endpos:Vector.<int> ):Number { 
		var len:int = pos+10;
		var i:int = pos ;
		var minus:Boolean = false ;
		var period:Boolean = false ;
		var v1:Number = 0 ;
		str.position = i;
		var c:String = String.fromCharCode(str.readByte());
		if( c == '-' ) {
			minus = true ;
			i++ ;
		}

		loop:for (  ; i < len ; i++ ) {
			str.position = i;
			c =String.fromCharCode(str.readByte());
			switch( c ){
			case '0':
				v1 = v1 * 10 ;
				break ;
			case '1':
				v1 = v1 * 10 + 1 ;
				break ;
			case '2':
				v1 = v1 * 10 + 2 ;
				break ;
			case '3':
				v1 = v1 * 10 + 3 ;
				break ;
			case '4':
				v1 = v1 * 10 + 4 ;
				break ;
			case '5':
				v1 = v1 * 10 + 5 ;
				break ;
			case '6':
				v1 = v1 * 10 + 6 ;
				break ;
			case '7':
				v1 = v1 * 10 + 7 ;
				break ;
			case '8':
				v1 = v1 * 10 + 8 ;
				break ;
			case '9':
				v1 = v1 * 10 + 9 ;
				break ;
			case '.':
				period = true ;
				i++ ;
				break loop;
			default:
				break  loop;
			}
		}
		
		if( period ) {
			var mul:Number = 0.1 ;
			
			loop2:for (  ; i < len ; i++ ) {
				str.position = i;
				c = String.fromCharCode(str.readByte());
				switch( c ){
				case '0':
					break ;
				case '1':
					v1 += mul * 1 ;
					break ;
				case '2':
					v1 += mul * 2 ;
					break ;
				case '3':
					v1 += mul * 3 ;
					break ;
				case '4':
					v1 += mul * 4 ;
					break ;
				case '5':
					v1 += mul * 5 ;
					break ;
				case '6':
					v1 += mul * 6 ;
					break ;
				case '7':
					v1 += mul * 7 ;
					break ;
				case '8':
					v1 += mul * 8 ;
					break ;
				case '9':
					v1 += mul * 9 ;
					break ;
				default:
					break  loop2;
				}
				mul *= 0.1 ;
			}
		}
		
		if( minus ) v1 = -v1 ;
		
		ret_endpos[0] = i ;
		return v1 ;
	}
	
	
	
}
}
