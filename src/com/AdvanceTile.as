package com
{
	import comp.ApronForTile;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import mx.containers.Grid;
	import mx.containers.Tile;
	import mx.core.UIComponent;
	
	import org.tuio.TuioTouchEvent;
	
	
	public class AdvanceTile extends Tile
	{
		private var a:UIComponent = new UIComponent();
		
		public function AdvanceTile()
		{
			super();
			
			this.drawFocus(false);
			//this.height = 720 / 94 * 95;
			
			this.height = 720 ;
			this.width = 140;
			this.tileWidth = 120;
			this.tileHeight = 94;
			
//			this.height = 720 ;
//			this.width = 140;
//			this.tileWidth = 50;
//			this.tileHeight = 94;
			
			//
			this.verticalScrollPolicy = "on";
			this.horizontalScrollPolicy = "off";
			
			//如果兩指都點在圖片 就會觸發 MOUSE_MOVE 可能就要用MOUSE的距離去轉換BAR
			//如果兩指都空白處 就是一般可以拖曳
			//如果一隻手指在圖片上 一樣可以拖曳
//			this.addEventListener(TransformGestureEvent.GESTURE_PAN, handleDrag);
//			var a:ApronForTile = new ApronForTile();
//			this.addChild(a);
			
			//var a:UIComponent = new UIComponent();
			/*
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveInTile);
			this.addEventListener(MouseEvent.CLICK,onMouseMoveInTile);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseMoveInTile);
			*/
		}
		//當往下移動時   ScrollPosition 也會跟著變動 
		private function handleDrag(e:TransformGestureEvent):void 
		{
			this.verticalScrollPosition += e.offsetY;
		}
		
		//把檔板上升
		public function setTheBoardShow():void
		{
			//trace( this.numChildren )
		}
	}
}