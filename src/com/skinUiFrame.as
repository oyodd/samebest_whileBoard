package com
{
	import flash.display.MovieClip;
	
	public class skinUiFrame extends MovieClip
	{
		
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="pptSkinUiOut")]
		private var skinUiFrame_:Class;
		public var eMc_skinUiFrame:* = new skinUiFrame_();
		
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="pptSkinUiOut_smallandsmakk")]
		private var skinUiFrame__:Class;
		public var eMc_skinUiFrameSmall:* = new skinUiFrame__();
		
		public function skinUiFrame(isUse:Boolean = false,useSmallFrame:Boolean=false)
		{
			super();
			if( useSmallFrame )
			{
				eMc_skinUiFrame.name = "drawBoard";
				this.addChild(eMc_skinUiFrameSmall);
			}
			else
			{
				eMc_skinUiFrame.name = "drawBoard";
				this.addChild(eMc_skinUiFrame);
			}
			
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