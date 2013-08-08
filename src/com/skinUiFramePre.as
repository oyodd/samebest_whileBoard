package com
{
	import flash.display.MovieClip;
	
	public class skinUiFramePre extends MovieClip
	{
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="pptSkinUiOut_pre")]
		private var skinUiFrame_:Class;
		public var eMc_skinUiFrame:* = new skinUiFrame_();
		
		public function skinUiFramePre(isUse:Boolean = false)
		{
			super();
			
			eMc_skinUiFrame.name = "drawBoard";
			this.addChild(eMc_skinUiFrame);
			if( !isUse )
			{
				this.visible = false;
			}
		}
		
		public function showFrame():void
		{
			this.visible = true;
		}
	}
}