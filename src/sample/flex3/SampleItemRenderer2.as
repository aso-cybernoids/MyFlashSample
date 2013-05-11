package sample.flex3 
{
	import mx.controls.treeClasses.TreeItemRenderer;
	import spark.components.CheckBox;
	/**
	 * ...
	 * @author aso
	 */
	public class SampleItemRenderer2 extends TreeItemRenderer
	{
		private var checkBox:CheckBox;
		
		public function SampleItemRenderer2() 
		{
			
		}
		override protected function createChildren():void{
			super.createChildren();
			
			
		}
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number) : void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);

			if (super.data != null) {
				if (super.data.@enableCheck=="true") 
				{
					if (checkBox==null) 
					{
						checkBox = new CheckBox();
						//checkBox.setStyle("verticalAlign","middle");
						this.addChild(checkBox);
					}
					if(icon != null){
						checkBox.x = icon.x;
						icon.x = checkBox.x + checkBox.width + 20;
						label.x = icon.x + icon.width + 5;
					}
					else{
						checkBox.x = super.label.x;
						label.x = checkBox.x + checkBox.width + 20;
					}
					checkBox.y = ( unscaledHeight - checkBox.height ) /2;
				}
				else 
				{
					//checkBox.visible = false;
				}
				
			}
		}
	}

}