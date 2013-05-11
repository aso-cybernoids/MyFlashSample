package sample.stage3d 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix3D;
	import flash.utils.Timer;
	import sample.flash.SampleBitmap;
	/**
	 * ...
	 * @author ...
	 */
	public class SampleStage3D extends Sprite
	{
		
		public function SampleStage3D() 
		{
			//createAndDrawTexture(stage.stage3Ds[0]);
		}
		
		/**
		 * 参照を取得するだけ．
		 * 設定は何もしません。
		 * 
		 * @param	stage
		 * @param	layerNo
		 * @return
		 */
		static public function getStage3D(stage:Stage,layerNo:int=0):Stage3D 
		{
			return stage.stage3Ds[layerNo];
		}
		
		
		/**
		 * Stage3Dを使える状態に設定する
		 */
		static public function create(stage3D:Stage3D,width:int=100,height:int=100,completeFunc:Function=null):void 
		{
			
			
			
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, function ():void 
			{
				var context3D:Context3D = stage3D.context3D;
				var enableErrorChecking:Boolean = true;
				var antiAlias:int = 0;
				var enableDepthAndStencil:Boolean = false;
				
				trace("Stage3D準備完了");
				trace("driverInfo : "+context3D.driverInfo);
				if (context3D.driverInfo=="Softwere"||context3D.driverInfo=="softwere") 
				{
					trace("GPUレンダリングが利用できません");
				}
				
				//3Dレイヤーの設定
				context3D.configureBackBuffer(width ,height, antiAlias, enableDepthAndStencil);
				context3D.setRenderToBackBuffer();
				context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);//ブレンドの指定
				
				context3D.enableErrorChecking = enableErrorChecking;//エラーチェック
				if (completeFunc!=null) 
				{
					completeFunc();
				}
			});//3Dレイヤー準備完了時のイベントを関連付け
			stage3D.requestContext3D(Context3DRenderMode.AUTO);//3Dレイヤー準備開始
			
			
		}
		
		
		
		/**
		 * 描画直前の準備、
		 * 指定の色で背景をクリア
		 * 
		 * @param	stage3D
		 * @param	cr
		 * @param	cg
		 * @param	cb
		 * @param	ca
		 */
		static public function startDraw(stage3D:Stage3D,cr:Number=1,cg:Number=1,cb:Number=1,ca:Number=0):void 
		{
			var context3D:Context3D = stage3D.context3D;
			context3D.clear(cr,cg,cb,ca);
		}
		
		
		/**
		 * 描画終了処理
		 * 
		 * @param	stage3D
		 */
		static public function endDraw(stage3D:Stage3D):void 
		{
			var context3D:Context3D = stage3D.context3D;
			context3D.present();
		}
		static public function setShaderProgram(stage3D:Stage3D,program:Program3D):void 
		{
			stage3D.context3D.setProgram(program);//レンダリングプログラムの登録
		}
		
		
		
		static public function drawTexture(stage3D:Stage3D,texture:Texture):void 
		{
			var context3D:Context3D = stage3D.context3D;
			var matrix:Matrix3D = new Matrix3D();//拡大縮小用
			var v:Vector.<Number> = new Matrix3D().rawData;//基本行列
	
			//通常の座標系は中心が原点(0,0,0)になる
			//頂点 x,y
			const vertexArray:Vector.<Number> = Vector.<Number>(
			[
				-1, -1,//画面左上
				-1,  1,//画面左下 
				 1, -1,//画面右上 
				 1,  1 //画面右下
			]);

			//画像のUV
			const uvArray:Vector.<Number> = Vector.<Number>(
			[
				0, 1,
				0, 0, 
				256/320, 1, //縦横比の調節 bitmap.width/stageWidth
				256/320, 0
			]);
	
			//板ポリゴン用頂点インデックス
			const indexArray:Vector.<Number> = Vector.<Number>(
			[
				0, 1, 2,
				1, 2, 3
			]);

			
			matrix.rawData = v;//行列の初期化
			var vtxBuffer:VertexBuffer3D;
			var indexBuffer:IndexBuffer3D;
			var uvBuffer:VertexBuffer3D;
			
			//行列の設定。以前の設定は無効
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);//vc0 に頂点の変換行列を設定
			context3D.setTextureAt( 1, texture );//テクスチャの登録
			
			//頂点、テクスチャUV、インデックス バッファの作成
			vtxBuffer = context3D.createVertexBuffer(vertexArray.length/2 , 2);//頂点数 vertexArray.length/2、 頂点ごとの要素数 2(x,y)
			uvBuffer = context3D.createVertexBuffer(uvArray.length / 2, 2);//頂点数 uvArray.length/2、 頂点ごとの要素数 2(u,v)
			indexBuffer = context3D.createIndexBuffer(indexArray.length);//インデックス数 indexArray.length
			
			//頂点、テクスチャUV、インデックス バッファのアップロード
			vtxBuffer.uploadFromVector(vertexArray, 0, vertexArray.length/2);//データ vertexArray, 開始頂点 0番 , 頂点数 vertexArray.length/2 
			uvBuffer.uploadFromVector(uvArray, 0, uvArray.length / 2);//データ vertexArray, 開始頂点 0番 , 頂点数 uvArray.length/2
			indexBuffer.uploadFromVector(Vector.<uint>(indexArray), 0, indexArray.length);//データ vertexArray, 開始インデックス 0番 , インデックス数 indexArray.length
		
			//頂点バッファのレジスタ登録
			context3D.setVertexBufferAt(0, vtxBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);//va0 データ _vtxBuffer、 開始 0番、頂点ごとの要素数 2(x,y)
			context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);//va1 データ _uvBuffer、 開始 0番、頂点ごとの要素数 2(u,v)

			
			context3D.drawTriangles(indexBuffer);//描画
			
			context3D.setTextureAt( 1, null );//テクスチャの登録

		}
		
		static public function drawTriangle(stage3D:Stage3D):void 
		{
			var context3D:Context3D = stage3D.context3D;
			var matrix:Matrix3D = new Matrix3D();//拡大縮小用
			var v:Vector.<Number> = new Matrix3D().rawData;//基本行列
	
			//通常の座標系は中心が原点(0,0,0)になる
			//頂点 x,y,z,r,g,b
			const vertexArray:Vector.<Number> = Vector.<Number>(
			[
				-1, -1,0,  1,0,0,//画面左上
				-1,  1,0,  0,1,0,//画面左下 
				 1, -1,0,  0,0,1,//画面右上 
			]);
	
			//頂点インデックス
			const indexArray:Vector.<Number> = Vector.<Number>(
			[
				0, 1, 2
			]);

			
			matrix.rawData = v;//行列の初期化
			var vtxBuffer:VertexBuffer3D;
			var indexBuffer:IndexBuffer3D;
			var uvBuffer:VertexBuffer3D;
			
			//行列の設定。以前の設定は無効
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);//vc0 に頂点の変換行列を設定
			
			//頂点、インデックス バッファの作成
			vtxBuffer = context3D.createVertexBuffer(vertexArray.length/6 , 6);//頂点数 、 頂点ごとの要素数 6(x,y,z,r,g,b)
			indexBuffer = context3D.createIndexBuffer(indexArray.length);//インデックス数 indexArray.length
			
			//頂点、インデックス バッファのアップロード
			vtxBuffer.uploadFromVector(vertexArray, 0, vertexArray.length/6);//データ vertexArray, 開始頂点 0番 , 頂点数 vertexArray.length/2 
			indexBuffer.uploadFromVector(Vector.<uint>(indexArray), 0, indexArray.length);//データ vertexArray, 開始インデックス 0番 , インデックス数 indexArray.length
		
			//頂点バッファのレジスタ登録
			context3D.setVertexBufferAt(0, vtxBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);//va0 データ _vtxBuffer、 開始 0番、頂点ごとの要素数 3(x,y,z)
			context3D.setVertexBufferAt(1, vtxBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);//va1 データ _vtxBuffer、 開始 3番、頂点ごとの要素数 3(r,g,b)

			
			context3D.drawTriangles(indexBuffer);//描画
		}

	}
}