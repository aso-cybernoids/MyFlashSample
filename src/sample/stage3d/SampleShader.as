package sample.stage3d 
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.Stage3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleShader 
	{
		
		public function SampleShader() 
		{
			
		}
		/**
		 * テクスチャ用シェーダ
		 * @return
		 */
		static public function texture2DFShader():ByteArray
		{
			var sh:AGALMiniAssembler = new AGALMiniAssembler();
			var src : String =
				"tex oc, v0.xy, fs1 <2d,clamp,linear>\n" ; //頂点シェーダで設定したuv情報(v0)からテクスチャ(fs1)を読み込んで一時レジスタに出力(ft0)
		

			sh.assemble(Context3DProgramType.FRAGMENT, src);
			return sh.agalcode;
		}
		
		
		/**
		 * テクスチャ用シェーダ
		 * 頂点バッファ０番はアフィン変換
		 * 頂点バッファ１番はフラグメントに渡すUV情報を想定
		 * 
		 * @return
		 */
		static public function texture2DVShader():ByteArray
		{
			var sh:AGALMiniAssembler = new AGALMiniAssembler();
			var src : String =
				"m44 op, va0, vc0 \n" +  //行列演算。頂点(va0)に変換行列(vc0)をかけて出力
				"mov v0, va1 \n";// 変数(v0)にuv情報(va1)を設定して、断片シェーダで使えるようにする
		

			sh.assemble(Context3DProgramType.VERTEX, src);
			return sh.agalcode;
		}
		
		
		/**
		 * ポリゴン用頂点シェーダ
		 * 
		 * @return
		 */
		static public function triangleVShader():ByteArray
		{
			var sh:AGALMiniAssembler = new AGALMiniAssembler();
			var src : String =
				"mov op, va0 \n" +  
				"mov v0, va1 \n";// 
		

			sh.assemble(Context3DProgramType.VERTEX, src);
			return sh.agalcode;
		}
		
		
		/**
		 * ポリゴン用ピクセルシェーダ
		 * 
		 * @return
		 */
		static public function triangleFShader():ByteArray
		{
			var sh:AGALMiniAssembler = new AGALMiniAssembler();
			var src : String =
				"mov oc, v0\n" ; //
		

			sh.assemble(Context3DProgramType.FRAGMENT, src);
			return sh.agalcode;
		}
		
	
		/**
		 * テクスチャ用シェーダの作成
		 * @param	stage3D
		 * @return
		 */
		static public function createTextureSheder(stage3D:Stage3D):Program3D 
		{
			//シェーダプログラムの作成
			var program:Program3D = stage3D.context3D.createProgram();
			program.upload(texture2DVShader(),texture2DFShader());
			
			return program;
		}
		
		
		/**
		 * ポリゴン用シェーダの作成
		 * @param	stage3D
		 * @return
		 */
		static public function createTriangleSheder(stage3D:Stage3D):Program3D 
		{
			//シェーダプログラムの作成
			var program:Program3D = stage3D.context3D.createProgram();
			program.upload(triangleVShader(),triangleFShader());
			
			return program;
		}

	}

}