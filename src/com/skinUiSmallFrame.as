package com
{
	import flash.display.MovieClip;
	
	public class skinUiSmallFrame extends MovieClip
	{
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="pptSkinUiOut_smallandsmakk")]
		private var skinUiFrame:Class;
		public var eMc_skinUiFrameSmall:* = new skinUiFrame();
		
		public function skinUiSmallFrame(isUse:Boolean = false)
		{
			super();
			this.addChild(eMc_skinUiFrameSmall);
			if( !isUse )
			{
				this.visible = false;
			}
		}
	}
}