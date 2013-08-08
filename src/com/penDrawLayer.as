package com
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.geom.ColorTransform;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class penDrawLayer extends MovieClip
	{
		//主容器 
		public var main:Sprite = new Sprite();
		//
		public var mc_move :MovieClip = new MovieClip();
		
		//臨時容器
		private var mc:Sprite = new Sprite();
		
		//保存最终畫出来的内容的bitmapdata 
		private var content:BitmapData ;//= new BitmapData(1286,730,true,0x00FFFFFF);
		
		//把content顯示出来 
		private var show:Bitmap;
		///////////////////////
		
		public var currentMapName:String = "";
		
		/**筆的狀態**/
		public var isPenUse:Boolean = true;
		/**橡皮擦的狀態**/
		public var isEraserUse:Boolean = false;
		/**pen size*/
		public var penSize:int = 5;
		/**使用什麼顏色**/
		public var activeColor:uint = 0x000000;
		/**是否用半透明的筆*/
		public var transparent:Boolean = true;
		/**畫板大小*/
		private var theboardWidth:int ;
		private var theboardHeigh:int ;
		
		/**筆 半透明的數值**/
		private var thePenAlpha:Number = 0.85;
		
		
		public function penDrawLayer(boardWidth:int,boardHeigh:int)
		{
			super();
			
			theboardWidth = boardWidth;
			theboardHeigh = boardHeigh;
			
			//以下是畫筆感應區
			//先畫出來 但是還沒有ADD 到元件去
			/**繪畫版的大小**/
			mc_move.graphics.lineStyle();
			mc_move.graphics.beginFill(0xFFFFEE,0.01);
			mc_move.graphics.moveTo(0,0);
			mc_move.graphics.lineTo(boardWidth,0);
			mc_move.graphics.lineTo(boardWidth,boardHeigh);
			mc_move.graphics.lineTo(0,boardHeigh);
			mc_move.graphics.lineTo(0,0);
			//mc_move.alpha = 0.01;
			
			/**實際顯示圖層大小**/
			mc_move.addEventListener(MouseEvent.MOUSE_DOWN,startDrawDown);
			//
			content = new BitmapData( boardWidth,boardHeigh,true,0x00FFFFFF );
			this.show = new Bitmap(content);
			//
			/**有下這行  mc_move 的事件才收的到**/
			main.mouseEnabled = false;
			//
			main.addChild(mc);
			main.addChildAt(show,0);
			//
			this.addChild( mc_move );
			this.addChild( main );
		}
		
		
		/**改變畫筆時要做的動作**/
		public function setPenState(penState:Boolean):void
		{
			/**切換PEN*/
			/**使用PEN**/
			if( penState )
			{
				isPenUse = true;	
				mc.visible = true;
			}
			else
			{
				isPenUse = false;
				mc.visible = false;
			}
		}
		
		/**點橡皮擦**/
		public function setEraserState(eraserState:Boolean):void
		{	
			if( eraserState )
			{
				isEraserUse = true;
			}
			else
			{
				isEraserUse = false;
			}
		}
		
		/**改變PENSIZE*/
		public function changePenSize(penSize:int):void
		{
			this.penSize = penSize;
		}
		
		/**change the color**/
		public function changeColor(color:uint):void
		{
			activeColor = color;
		}
		
		
		/**點下黑板**/
		public function startDrawDown(e:MouseEvent):void
		{
			//trace( mc.width + "___" + mc.height );
			mc.graphics.lineStyle(penSize,activeColor);
			mc.graphics.moveTo(e.localX,e.localY);
			//trace( mc.width + "___" + mc.height );
			//
			if( transparent )
			{
				mc.alpha = 1;
			}
			else
			{
				mc.alpha = thePenAlpha;
			}
			
			//BOARD
			mc_move.addEventListener(MouseEvent.MOUSE_MOVE,startDrawDrag);
			//舞台
			main .addEventListener(MouseEvent.MOUSE_UP,stopDrawDrag);
			mc_move.addEventListener(MouseEvent.MOUSE_UP,stopDrawDrag);
		}
		
		/**點下鉛筆後拖動**/
		public function startDrawDrag(e:MouseEvent):void
		{
			//trace("aa");
			//鉛筆 LINETO
			mc.graphics.lineTo(e.localX,e.localY);
			//判斷是擦布時
			if ( isEraserUse ) 
			{
				// content -> BitmapData [(550,400,true,0x00FFFFFF)]
				// mc -> BOARD
				// 設定 BlendMode.ERASE
				content.draw(mc,new Matrix(),new ColorTransform(),BlendMode.ERASE);
			}
			e.updateAfterEvent();
		}
		
		/**提起筆**/
		public function stopDrawDrag(e:MouseEvent):void
		{
			//如果是鉛筆
			if ( isPenUse ) 
			{
				//改回原本的
				if( transparent )
				{
					content.draw(mc ,new Matrix() , new ColorTransform() , BlendMode.NORMAL , new Rectangle(0,0,theboardWidth,theboardHeigh));
				}
				else
				{
					content.draw(mc ,new Matrix() , new ColorTransform(1,1,1,thePenAlpha) , BlendMode.NORMAL , new Rectangle(0,0,theboardWidth,theboardHeigh));
				}
			}
			
			mc.graphics.clear();
			mc_move.removeEventListener(MouseEvent.MOUSE_MOVE,startDrawDrag);
			main.removeEventListener(MouseEvent.MOUSE_UP,startDrawDrag);
		}
		
		/**clear the board*/
		public function clearBoard():void
		{
			//先移除最底層的 "show"
			main.removeChildAt(0);
			//把 BitmapData 換成新的
			content = new BitmapData(theboardWidth,theboardHeigh,true,0x00FFFFFF);
			//填入新的SHOW
			show = new Bitmap(this.content);
			//置換回底層
			main.addChildAt(show,0);
		}
		
		/**change transparent (是否半透明)**/
		public function setTransparent(bool:Boolean):void
		{
			this.transparent = bool;
		}
		/*
		public function getBMP():ByteArray{
			
			return show.bitmapData.getPixels(new Rectangle(0,0,1920,1020));
		}
		public function setBMP(ba:ByteArray):void{
			show.bitmapData.setPixels(new Rectangle(0,0,1920,1020),ba);
		}
		*/
	}
}