package com
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class closeBtn extends MovieClip
	{
		
		//關閉的按鈕
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="imageCloseBtn")]
		private var CloseBtn:Class;
		public var eMc_CloseBtn:* = new CloseBtn();
		
		public function openButton():void
		{
			this.visible = true;
			//this.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		public function visibleTheCloseButton():void
		{
			this.visible = false;
		}
		
		public function closeBtn(isUse:Boolean = false)
		{
			super();
			
			eMc_CloseBtn.name = "drawBoard";
			this.addChild(eMc_CloseBtn);
			if( !isUse )
			{
				this.visible = false;
			}
			
			//this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function onClick(ev:MouseEvent):void
		{
			this.dispatchEvent( ev );
		}
		
	}
}