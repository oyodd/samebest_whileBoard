package com
{
	import examples.gestures.*;
	
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.text.TextField;
	
	import ispring.presenter.IPresentationPlayer;
	import ispring.presenter.IPresentationPlayerContainer;
	import ispring.presenter.PlayerContainerEvent;
	import ispring.presenter.player.IPresentationPlaybackController;
	import ispring.presenter.player.clock.IPresentationClock;
	import ispring.presenter.player.clock.PresentationClockEvent;
	import ispring.presenter.player.events.PresentationPlaybackEvent;
	import ispring.presenter.presentation.ITimestamp;
	import ispring.presenter.presentation.slides.ISlides;
	
	import mx.containers.Canvas;
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	import org.tuio.legacy.FiducialTuioAS3LegacyListener;
	
	import sban.flexStudy.avm1to2.AVM1MvoieProxy;
	
	public class backGroundLayer extends MovieClip
	{
		/**背景大小*/
		private var thebackGroundWidth:int ;
		private var thebackGroundHeigh:int ;
		/**背景的NAME 不能刪除 所以要記錄**/
		private var mc_groundName:String = "";
		/**當前圖片的大小*/
//		private var currentImageWidth:int ;
//		private var currentImageHeigh:int ; 
		/**當前圖片的中心點位置*/
		private var theImageCenterX:int ; 
		private var theImageCenterY:int ;
		//
		public var mc_ground:MovieClip = new MovieClip();
		//
		private var activeSound:Sound ;
		
		/**the backgound layer**/
		public function backGroundLayer(boardWidth:int,boardHeigh:int)
		{
			super();
			thebackGroundWidth = boardWidth;
			thebackGroundHeigh = boardHeigh;
			//
			mc_groundName = mc_ground.name;
			
			mc_ground.graphics.beginFill(0xFFFFEE);
			mc_ground.graphics.moveTo(0,0);
			mc_ground.graphics.lineTo(boardWidth,0);
			mc_ground.graphics.lineTo(boardWidth,boardHeigh);
			mc_ground.graphics.lineTo(0,boardHeigh);
			mc_ground.graphics.lineTo(0,0);
			mc_ground.alpha = 0.01;
			this.addChild( mc_ground );
			
		}
		
		/**設定背景圖案  丟進來時 需要把 imageBitmap的大小先設定好**/
		public function setBackGroundFromImage(imageBitmap:Bitmap):void
		{
			/**要先清除背景圖案**/
			clearAllBackGroung();
			setTheBackGroundPosition(imageBitmap);
			//暫時用bitmap代替 之後改成 DragRotateScaleOnImage 
			var dragImg:DragRotateScaleOnImage = new DragRotateScaleOnImage( theImageCenterX  ,theImageCenterY,( imageBitmap ),0,"backGround");
			dragImg.x = theImageCenterX;
			dragImg.y = theImageCenterY;
			this.addChild( dragImg );
		}
		
		/**設定背景圖案  丟進來時 需要把 animation的大小先設定好**/
		public function setBackGroundFromAnimation(animation:MovieClip):void
		{
			/**要先清除背景圖案**/
			clearAllBackGroung();
			this.addChild( animation );
			//this.height = thebackGroundHeigh; // 768   1360
			//trace( thebackGroundHeigh );
			//trace( this.thebackGroundWidth );
			//trace( thebackGroundHeigh );
			//trace(this.width);
			//trace(this.scaleX );
		}
		
		private function check_w(e:Event):void
		{
			/*
			trace("this.width" + this.width);
			trace("width" + (e.target as Loader).content.width);
			trace("width" + (e.target as Loader).content.scaleX);
			//this.width = 1500;
			//this.height = 728;
			trace("this.width" + this.width);
			trace("width" + (e.target as Loader).content.width);
			trace("width" + (e.target as Loader).content.scaleX);
			*/
			
		}
		/**設定背景圖案  丟進來時 需要把 animation的大小先設定好**/
		public function setBackGroundFromAnimation_as2(animation:*):void
		{
			/**要先清除背景圖案**/
			clearAllBackGroung();
			//animation.width = 1200;
			//trace( this.width )
			//this.width = 1290;
			//this.height = 728;tra
			//(animation as Loader).width = 1360;
			//(animation as Loader).content.width = 1360;
			//trace( (animation as Loader).width) //2445.9
			//trace( (animation as Loader).height)//1200
//			trace( (animation as Loader).content.width)
//			trace( (animation as Loader).scaleX )
			
			//animation.addEventListener( Event.ADDED_TO_STAGE, check_w);
			//trace( this.scaleX )
			//trace( this.width );
			//(animation as Loader).width = 2000;
			//trace( (animation as Loader).width - this.stage.width );
			//(animation as Loader).width = 1290 + ( (animation as Loader).width * 0.5264876336625582 );+1290
			this.addChild( animation );
			//trace( 1290 + ( (animation as Loader).width * 0.5264876336625582 ) );
			//trace( this.width );
			//trace( this.height);
			//trace( this.scaleY);
			//trace( animation.x)
			//trace( animation.y)
			
			//if( (animation as Loader).width
			/*
			var tw:Number = 1290 / (animation as Loader).width  ; 
			var th:Number = 724 / (animation as Loader).height  ; 
			var a:MovieClip = new MovieClip();
			*/
			
//			this.width = 1290 + ( 1290 * ( 1 - tw ) ); // 1970
//			this.height = 724  + ( 724 * ( 1 - th  ) );
			/*
			this.width = 1290 + ( 1290 * ( tw ) ); // 1970
			this.height = 724  + ( 724 * ( th  ) );
			*/
			//trace( this.width)
			//this.width = 1290;
			//this.height = 724 + 250;  //0.345
			//trace( 724 * 0.6066666666666667 );
			//this.height = 724 + ( 724 * 0.195);
			//trace( this.scaleY);
			//trace( thebackGroundWidth );
//			trace( this.width );
//			trace( this.scaleX )
//			trace( this.scaleY )
//			trace( this.height);
			//this.width = thebackGroundWidth;
			//trace( this.width );
			//trace( this.scaleX ) // 0.5560325442577374   0.5264876336625582
			//trace( this.stage.scaleX )
			//trace( this.stage.width );
			//this.width = 1360;
			//this.height = 728;
			//this.scaleX = 1;
			//this.scaleY = 1;
			//trace( this.width )
			//trace( this.scaleX );
			//trace( this.thebackGroundWidth );
			//trace( this.width );
			//animation.height = this.thebackGroundHeigh;
			//animation.width = 2000;
			//activeSound = new Sound( animation );
			//this.height = thebackGroundHeigh;
		}
		
		/**設定背景圖案  丟進來時 需要把 video的大小先設定好**/
		public function setBackGroundFromVideo(video:*):void
		{
			/**要先清除背景圖案**/
			clearAllBackGroung();
			this.addChild( video );
			this.height = thebackGroundHeigh;
		}
		
		public function setBackGroundFromPPT( PPT:* ):void
		{
			/**要先清除背景圖案**/
			clearAllBackGroung();
			//trace( PPT.width);
			//trace( PPT.height);
			//trace( this.thebackGroundHeigh );
			//trace( this.thebackGroundWidth );
			//PPT.height = this.thebackGroundHeigh;
			//PPT.width = this.thebackGroundWidth;
			this.addChild( PPT );
			//trace(this.scaleX)
			//trace(this.scaleY)
			//this.width = 1132;
			//this.height = 724;
			//trace(this.scaleX)
			//trace(this.scaleY)
			/**投影片位置會跑掉 可能要再看看 先填數據**/
			//this.height = 770;
			//this.width = 1520;
			//PPT.x = -80;
		}
		
		/**設定影片背景  丟uiComp近來**/
		public function setBackGroundFormVideoUi(videoUI:UIComponent):void
		{
			//clearAllBackGroung();
			//this.addChild( a );
		}
		
		/**清除所有背景圖片_除了背景框*/
		private function clearAllBackGroung():void
		{
			//SoundMixer.stopAll();
			for( var i:int = 0 ; i < this.numChildren ; i++)
			{
				if( this.getChildAt( i ).name != mc_groundName )
				{
					if( this.getChildAt( i ) is Loader )
					{
						SoundMixer.stopAll();
						//( this.getChildAt( i ) as Loader ) = null;
					}
					
					if( this.getChildAt( i ) is DisplayObjectContainer )
					{
						stopAllChildMovieClips ( this.getChildAt( i ) as DisplayObjectContainer );
					}
					this.removeChildAt( i );
				}
			}
		}
		
		/**設定背景中心點**/
		private function setTheBackGroundPosition(imageBitmap:Bitmap):void
		{
			theImageCenterX =  ( (thebackGroundWidth / 2 ) - imageBitmap .width / 2 );
			theImageCenterY =  ( (thebackGroundHeigh / 2 ) - imageBitmap .height / 2);
		}
		
		/**停止MC跑**/
		public function stopAllChildMovieClips(displayObject:DisplayObjectContainer):void
		{
			var numChildren:int = displayObject.numChildren;
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = displayObject.getChildAt(i);
				if (child is DisplayObjectContainer)
				{
					if (child is MovieClip)
					{
						MovieClip(child).stop();
						//MovieClip(child).gotoAndStop(1);
					}
					stopAllChildMovieClips(DisplayObjectContainer(child));
				}
			}
		}
		
	}
}