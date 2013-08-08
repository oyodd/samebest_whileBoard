package com
{
	
	import examples.gestures.*;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	
	public class libearyLayer extends MovieClip
	{
		
		/**舞台大小*/
		private var thebackGroundWidth:int ;
		private var thebackGroundHeigh:int ;
		/**當前library的中心點位置*/
		private var theLibraryCenterX:int ; 
		private var theLibraryCenterY:int ;
		
		/**背景的NAME 不能刪除 所以要記錄**/
		private var mc_groundName:String = "";
		//
		private var mc_ground:MovieClip = new MovieClip();
		
		public function libearyLayer(boardWidth:int,boardHeigh:int)
		{
			super();
			
			thebackGroundWidth = boardWidth;
			thebackGroundHeigh = boardHeigh;
			
			mc_groundName = mc_ground.name;
			
			mc_ground.graphics.beginFill(0xFFFFEE);
			mc_ground.graphics.moveTo(0,0);
			mc_ground.graphics.lineTo(boardWidth,0);
			mc_ground.graphics.lineTo(boardWidth,boardHeigh);
			mc_ground.graphics.lineTo(0,boardHeigh);
			mc_ground.graphics.lineTo(0,0);
			mc_ground.alpha = 0.01;
			this.addChild( mc_ground );
			//this.width = thebackGroundWidth;
			//this.height = thebackGroundHeigh;
		}
		
		
		/**增加元件*/
		/** theLibraryX -> 滑鼠點下的位置*/
		public function addLibrary(libraryImage:Bitmap,theLibraryX:int,theLibraryY:int):void
		{
			//trace( theLibraryX );
			setTheLibraryPoint(libraryImage);
			var dragImg:DragRotateScaleOnImage = new DragRotateScaleOnImage( theLibraryX  ,theLibraryY,( libraryImage ),0,"library");
			dragImg.x = theLibraryX - theLibraryCenterX;
			dragImg.y = theLibraryY - theLibraryCenterY;
			this.addChild( dragImg );
			/**要在這邊加上去的原因是  有些元件需要用到父類別的資料**/
			dragImg.setFrame("library");
		}
		
		/**刪除所有元件**/
		public function deleteAllLibrary():void
		{
		
			for( var i:int = 0 ; i < this.numChildren ; i++)
			{
				if( this.getChildAt( i ).name != mc_groundName )
				{
					this.removeChildAt( i );
					i--;
				}
			}
		}
		
		/**刪除特定元件**/
		public function deleteDesignationLibrary(ev:MouseEvent):void
		{
			//trace(ev.target.name) closeBtn-instance1468
			var arCloseBtnName:Array = (ev.target.name as String).split("-") ;
			
			for( var i:int = 0 ; i < this.numChildren ; i++)
			{
				if( (this.getChildAt( i ).name as String).indexOf( arCloseBtnName[1] ) != -1 )
				{
					/**先跑偵聽移除**/
					if( ( this.getChildAt( i ) is DragRotateScaleOnImage ) )
					{
						( this.getChildAt( i ) as DragRotateScaleOnImage ).removeMyEventListener();
					}
					/**再跑刪除**/
					this.removeChildAt( i );
					i--;
				}
			}
		}
		
		/**設定所有關閉按鈕顯示**/
		public function showAllCloseBtn():void
		{
			for( var i:int = 0 ; i < this.numChildren ; i++)
			{
				if( ( this.getChildAt( i ) is DragRotateScaleOnImage ) )
				{
					( this.getChildAt( i ) as DragRotateScaleOnImage ).removeMyEventListener();
					( this.getChildAt( i ) as DragRotateScaleOnImage ).setCloseButtonVilible(true);
				}
			}
		}
		
		/**設定所有關閉按鈕關閉**/
		public function visibleAllCloseBtn():void
		{
			for( var i:int = 0 ; i < this.numChildren ; i++)
			{
				if( ( this.getChildAt( i ) is DragRotateScaleOnImage ) )
				{
					( this.getChildAt( i ) as DragRotateScaleOnImage ).setCloseButtonVilible(false);
				}
			}
		}
		
		/**控制當前頁面元件 開啟旋轉功能**/
		public function setLibraryRotate():void
		{
			for( var i:int = 0 ; i < this.numChildren ; i++)
			{
				if( ( this.getChildAt( i ) is DragRotateScaleOnImage ) )
				{
					( this.getChildAt( i ) as DragRotateScaleOnImage ).removeMyEventListener();
					( this.getChildAt( i ) as DragRotateScaleOnImage ).setRotateEvent();
				}
			}
		}
		
		/**控制當前頁面元件 開啟縮放功能**/
		public function setLibraryZoomOpen():void
		{
			for( var i:int = 0 ; i < this.numChildren ; i++)
			{
				if( ( this.getChildAt( i ) is DragRotateScaleOnImage ) )
				{
					( this.getChildAt( i ) as DragRotateScaleOnImage ).removeMyEventListener();
					( this.getChildAt( i ) as DragRotateScaleOnImage ).setZoomEvetn();
				}
			}
		}
		
		/**關閉所有元件的功能偵聽**/
		public function setRemoveAllAction():void
		{
			for( var i:int = 0 ; i < this.numChildren ; i++)
			{
				if( ( this.getChildAt( i ) is DragRotateScaleOnImage ) )
				{
					( this.getChildAt( i ) as DragRotateScaleOnImage ).removeMyEventListener();
					//( this.getChildAt( i ) as DragRotateScaleOnImage ).setZoomEvetn();
				}
			}
		}	
		
		
		
		/**設定library中心點*/
		private function setTheLibraryPoint(libraryImage:Bitmap):void
		{
			theLibraryCenterX = libraryImage.width / 2;
			theLibraryCenterY = libraryImage.height / 2;
		}
		
		/****/
		
	}
}