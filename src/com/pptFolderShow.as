package com
{
	import flash.display.MovieClip;
	
	public class pptFolderShow extends MovieClip
	{
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="pptFolder")]
		private var pptFolder:Class;
		public var eMc_pptFolder:* = new pptFolder();
		
		
		public function pptFolderShow()
		{
			this.addChild( eMc_pptFolder );
			//this.width = 120;
			//this.height = 94;
			
			super();
		}
	}
}