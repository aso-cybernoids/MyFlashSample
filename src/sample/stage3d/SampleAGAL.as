package sample.stage3d 
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	/**
	 * AGAL入門
	 * 
	 * 基本形
	 * <オぺコード> <出力先レジスタ>, <入力レジスタ１>, <入力レジスタ２ または サンプラーレジスタ> 
	 * 
	 * 
	 * 代表的なコード
		mov: 入力１から出力にデータを移動
		add: 出力 = 入力１ + 入力２
		sub: 出力 = 入力１ - 入力２
		mul: 出力 = 入力１ * 入力２
		div: 出力 = 入力１ / 入力２
		m44 入力1の4成分ベクトルと入力2の4*4行列の積
		tex 入力2のテクスチャから読み込んだテクスチャを入力1の座標に貼り付ける
	 * 
	 * レジスタ
		各レジスタは128bit長で、4つのfloat値をもつ。
		レジスタの成分にはxyzwの座標アクセサかrgbaのカラーアクセサどちらでもを通してアクセスできる。
		
		属性レジスタ(va0~7) 頂点バッファからの入力である、頂点属性を値として持つ。Context3D.setVertexBufferAt() で属性を設定する。
		定数レジスタ(vc0~127 または fc0~27) 頂点シェーダでは vc + 番号、断片シェーダでは fc + 番号。setProgramConstantsFromMatrix()で設定;
		一時レジスタ(vt0～7 または ft0~7) データ一時保管専用。
		出力レジスタ(op または oc) シェーダ毎に 1つ 存在。頂点シェーダ用の名前は op、断片シェーダ用の名前は oc
		可変レジスタ(v0~7) 頂点シェーダから断片シェーダにデータを渡す
		サンプラーレジスタ(fs0~7) テクスチャからサンプルを取り出す
	 * 
	 * サンプラーのフラグ一覧
		テクスチャの次元： 2d, cube
		ミップマップのオプション： nomip , mipnearest, miplinear
		テクスチャフィルタのオプション： nearest, linear
		テクスチャの繰り返しのオプション： repeat, wrap, clamp

	 * @author ...
	 */
	public class SampleAGAL 
	{
		
		public function SampleAGAL() 
		{
		}
		

		static public function createProgram3D(context : Context3D):Program3D 
		{
			var vshsrc : String =
				"m44 op, va0, vc0 \n" +  //行列演算。頂点(va0)に変換行列(vc0)をかけて出力
				"mov v0, va1 \n";// 変数(v0)にuv情報(va1)を設定して、断片シェーダで使えるようにする
				
			var fshsrc : String =
				"tex oc, v0.xy, fs1 <2d,clamp,linear>\n" ; //頂点シェーダで設定したuv情報(v0)からテクスチャ(fs1)を読み込んで一時レジスタに出力(ft0)
				//"m44 oc,  ft0 , fc0\n" ; //alpha用行列(fc0)をrgbaそれぞれに乗算して出力

			var vsh:AGALMiniAssembler = new AGALMiniAssembler;
			var fsh:AGALMiniAssembler = new AGALMiniAssembler;
			
			vsh.assemble(Context3DProgramType.VERTEX, vshsrc);;//頂点シェーダをコンパイルして作成
			fsh.assemble(Context3DProgramType.FRAGMENT, fshsrc);;//断片シェーダをコンパイルして作成
		
			var program:Program3D = context.createProgram();//Program3Dを作成
			program.upload(vsh.agalcode, fsh.agalcode);//頂点シェーダと断片シェーダを設定
			
			return program;
		}


	}

}