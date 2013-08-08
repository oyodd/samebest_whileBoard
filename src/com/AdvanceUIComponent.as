package com
{
	import com.*;
	
	import flash.desktop.Clipboard;
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	import ispring.presenter.IPresentationPlayer;
	import ispring.presenter.IPresentationPlayerContainer;
	import ispring.presenter.ISlidePlayer;
	import ispring.presenter.ISlidePlayerContainer;
	import ispring.presenter.PlayerContainerEvent;
	import ispring.presenter.player.IPresentationPlaybackController;
	import ispring.presenter.player.clock.IPresentationClock;
	import ispring.presenter.player.clock.PresentationClockEvent;
	import ispring.presenter.player.events.PresentationPlaybackEvent;
	import ispring.presenter.player.slides.ISlidePlaybackController;
	import ispring.presenter.presentation.ITimestamp;
	import ispring.presenter.presentation.slides.ISlides;
	
	import mx.core.UIComponent;
	
	/**每個tile 的內容物**/
	public class AdvanceUIComponent extends UIComponent
	{
		/**folder name*/
		public var folderName:String = "";
		/**load path*/
		public var loadPathInEnglish:String = "";
		/**folder chinese path**/
		public var folderChinesePath:String = "";
		/**folder page Num**/
		public var pptPageOrderNumber:int = -10;
		/**folder path**/
		public var folderPath:String = "";
		/**folder chinese name**/
		public var folderChineseName:String = "";
		/**folder Front cover(封面) content( bitMap )**/
		public var imageContent:Bitmap ; 
		/**folder background content ( 黃色資料夾  )**/
		//public var folderBitmapContent
		/**folder order number**/
		/**type**/
		/**assets path**/
		public var assetsPath:String = "";
		public var imagePath:String = "";
		
		public var theVoType:String;
		//
		private var skinsLoader:Loader;
		//
		private var usedPage:String = "";
		/** ppt's frame**/
		public var pptImageFrame:skinUiFrame ;
		/**ppt's preFrame***/
		public var pptImagePreFrame:skinUiFramePre ;
		/**close button*/	
		public var closeButton:closeBtn;
		/**library small frame*/
		public var librarySmallFrame:skinUiSmallFrame;
		
		/**當前圖片的中心點位置*/
		private var theImageCenterX:int ; 
		private var theImageCenterY:int ;
		
		/** presenter 需要用到的變數**/
		private var container:ISlidePlayerContainer ;
		private var m_player:ISlidePlayer = null;
		private var m_playbackController:ISlidePlaybackController;
		/**代表最多有多少動作*/
		private var iPresenterNum:int = 20 ; 
			
		/**傳入路徑 loader 在這邊跑    assetContentPath -> 表示點下框後要用不同的路徑load東西**/
		public function AdvanceUIComponent(loaderPath:String,usedName:String="",assetContentPath:String="")
		{
			super();
			usedPage = usedName;
			this.theVoType = usedName;
			//框的下載路徑  讓後面的點下框可以下載用
			loadPathInEnglish = loaderPath;
			//trace( loaderPath );
			//trace( loadPathInEnglish )
			/**只有在點下去和出現的畫面路徑不一樣才需要改變路徑*/
			if( assetContentPath != "" )
			{
				imagePath = loaderPath;
				loadPathInEnglish = assetContentPath;
				assetsPath = assetContentPath;
			}
			
			/**先把框給建起來**/
			if( usedPage == "pptFolder")
			{
				setPptFolderAllFrame();
			}
			if( usedPage == "pptImage")
			{
				setPptImageAllFrame();
			}
			if( usedPage == "imageBoardImage")
			{
				setImageBoardAllFrame();
			}
			if( usedPage == "library" )
			{
				setLibraryAllFrame();
			}
			if( usedPage == "flash" )
			{
				setFlashAllFrame();
			}
			if( usedPage == "video" )
			{
				setVideoAllFrame();
			}
			if( usedPage == "ispring" )
			{
				setPptFolderAllFrame();
			}
			if( usedPage == "ispringItem" )
			{
				setIspringItemAllFrame();
			}
			/**要經過轉換中文檔案名稱*/
			//FileLoader(loaderPath);
			skinsLoader = new Loader();
			//trace( loaderPath );
			//skinsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,FileLoaderComplete,false,0,true);
			//skinsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,FileLoaderComplete);
			
			//skinsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,FileLoaderComplete);
			//skinsLoader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandlerAsyncErrorEvent);
			//skinsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgIOErrorHandler);
			//skinsLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerSecurityErrorEvent);
			skinsLoader.contentLoaderInfo.addEventListener(Event.INIT, FileLoaderComplete,false,0,true);
			
			//skinsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, infoIOErrorEvent);
			//skinsLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressListener);
			var urlRequest:URLRequest = new URLRequest( loaderPath );
			skinsLoader.load(urlRequest);
			/**跑個timer查詢是否有傳回loader init事件  如果沒有就在load一次**/
			var againTime:Timer = new Timer(1500,1);
			againTime.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
			againTime.start();
		}
		
		private function onTimerComplete(ev:Event):void
		{
			if( skinsLoader != null )
			{
				skinsLoader.contentLoaderInfo.addEventListener(Event.INIT, FileLoaderComplete,false,0,true);
				var urlRequest:URLRequest = new URLRequest( loadPathInEnglish );
				skinsLoader.load(urlRequest);
				//trace( "timeToLoaderAndPath=" + loadPathInEnglish);
			}
		}
		
		private function imgIOErrorHandler(ev:IOErrorEvent):void
		{
			trace("errorHandlerIOErrorEvent=" + ev.toString() );
		}
		
		private function progressListener (e:ProgressEvent):void{
			trace("Downloaded " + e.bytesLoaded + " out of " + e.bytesTotal + " bytes");
		}
		
		private function initHandler( e:Event ):void{
			trace( 'load init' );
		}
		
		private function errorHandlerErrorEvent( e:ErrorEvent ):void{
			trace( 'errorHandlerErrorEvent ' + e.toString() );
		}
		private function infoIOErrorEvent( e:IOErrorEvent ):void{
			trace( 'infoIOErrorEvent ' + e.toString() );
		}
		private function errorHandlerIOErrorEvent( e:IOErrorEvent ):void{
			trace( 'errorHandlerIOErrorEvent ' + e.toString() );
		}
		private function errorHandlerAsyncErrorEvent( e:AsyncErrorEvent ) :void{
			trace( 'errorHandlerAsyncErrorEvent ' + e.toString() );
		}
		private function errorHandlerSecurityErrorEvent( e:SecurityErrorEvent ):void{
			trace( 'errorHandlerSecurityErrorEvent ' + e.toString(
			) );
		}
		private function onLoadComplete( e:Event ):void{
			trace( 'onLoadComplete' );
		}
		
		/**pptFolder frame**/
		private function setPptFolderAllFrame():void
		{
			setPptFolderBackGround();
			setCloseButton();
		}
		
		/**pptImage frame**/
		private function setPptImageAllFrame():void
		{
			setPptImagePreFrame();
			setPptImageTargetFrame();
			setCloseButton();
		}
		
		/**imageBoard frame**/
		private function setImageBoardAllFrame():void
		{
			setCloseButton();
		}
		
		/**library frame*/
		private function setLibraryAllFrame():void
		{
			setLibrarySmallFrame();
			setCloseButton();
		}
		/**flash frame*/
		private function setFlashAllFrame():void
		{
			setCloseButton();
		}
		/**video frame*/
		private function setVideoAllFrame():void
		{
			setCloseButton();
		}
		
		/**ispring frame**/
		private function setIspringItemAllFrame():void
		{
			setPptImagePreFrame();
			setPptImageTargetFrame();
			setCloseButton();
		}
		
		/**LOAD好之後塞值**/
		private function FileLoaderComplete(ev:Event):void
		{
			skinsLoader.contentLoaderInfo.removeEventListener(Event.INIT, FileLoaderComplete);
			skinsLoader = null;
			/**the image content**/
			if( usedPage != "ispringItem" && usedPage != "ispring")
			{
				imageContent = ev.target.content;
			}
			
			/**這邊改變 會改掉PPT內頁IMG的尺吋**/
			//ev.target.content.width = 120;
			//ev.target.content.height = 94;
			// pptFolder的話要多背景框
			if( usedPage == "pptFolder")
			{
				//change the content size
				ev.target.content.width = 80;
				ev.target.content.height = 55;
				ev.target.content.x = 25;
				ev.target.content.y = 20;
				//
				this.addChild( ev.target.content );
			}
			
			if( usedPage == "pptImage")
			{
				ev.target.content.width = 120;
				ev.target.content.height = 94;
				
				/**轉換成小張的圖片**/
//				var bmp:BitmapData=new BitmapData(120,94);
//				bmp.draw( ev.target.content );
//				var cloneBitmap:Bitmap=new Bitmap(bmp);
//				cloneBitmap.width=120;
//				cloneBitmap.height=94;
				
				//
				//trace( this.name + "=tileName,," + ev.target.content + "=conten" );
				this.addChildAt( ev.target.content , 0);
				//this.addChildAt( cloneBitmap , 0);
			}
			
			if( usedPage == "imageBoardImage")
			{
				/**調整圖片大小 以等比例**/
				ev.target.content.width = ( setTheBitmapSize( ev.target.content ,120 , 94 ) ).width;
				ev.target.content.height  = ( setTheBitmapSize( ev.target.content ,120 , 94 ) ).height;
				/**調整圖片位置 置中**/
				setTheBackGroundPosition( ev.target.content ,120 , 94 )
				ev.target.content.x = theImageCenterX;
				ev.target.content.y = theImageCenterY;
				//
				this.addChildAt( ev.target.content , 0);
			}
			
			if( usedPage == "library" )
			{
				/**調整圖片大小 以等比例**/
				ev.target.content.width = ( setTheBitmapSize( ev.target.content ,60 , 50 ) ).width;
				ev.target.content.height  = ( setTheBitmapSize( ev.target.content ,60 , 50) ).height;
				
				// library frame size
				setTheBackGroundPosition( ev.target.content ,60 , 50)
				ev.target.content.x = theImageCenterX;
				ev.target.content.y = theImageCenterY;
				this.addChildAt( ev.target.content , 0);
			}
			
			if( usedPage == "flash" )
			{
				// library frame size
				ev.target.content.width = 120;
				ev.target.content.height = 94;
				this.addChildAt( ev.target.content , 0);
			}
			
			if( usedPage == "video" )
			{
				// library frame size
				ev.target.content.width = 120;
				ev.target.content.height = 94;
				this.addChildAt( ev.target.content , 0);
			}
			
			if( usedPage == "ispring" )
			{
				/**這邊跑ispring轉出來的standalone的一個一個swf檔案  所以要用到她的loader*/
				container = ev.target.content as ISlidePlayerContainer;
				ev.target.content.width = 80;
				ev.target.content.height = 55;
				ev.target.content.x = 25;
				ev.target.content.y = 20;
				this.addChild( ev.target.content);
			}
			
			if( usedPage == "ispringItem" )
			{
				/**這邊跑ispring轉出來的standalone的一個一個swf檔案  所以要用到她的loader*/
				container = ev.target.content as ISlidePlayerContainer;
				ev.target.content.width = 120;
				ev.target.content.height = 94;
				this.addChildAt( ev.target.content ,0);
				
				/**跑至最後一動的畫面**/
				for( var i:int = 0 ; i< container.player.slide.animationSteps.count ; i++)
				{
					container.player.view.playbackController.gotoNextStep();
				}
				//trace( (container.player.slide.animationSteps.count) );
				//trace( container.player.view.clock.timestamp.stepIndex)
				//trace( (container.player.slide.index) );
				/**因為找不到本投影片的總數 所以用此代替**/
				if( GameData.iCurrentPresentSlideCount < container.player.slide.index )
				{
					GameData.iCurrentPresentSlideCount = container.player.slide.index;
				}
			}
		}
		
		private var m_playerContainer:IPresentationPlayerContainer;
		
		/**方框(前)**/
		private function setPptImagePreFrame():void
		{
			pptImageFrame = new skinUiFrame();
			this.addChild( pptImageFrame );
		}
		
		
		/**方框( target )**/
		private function setPptImageTargetFrame():void
		{
			pptImagePreFrame = new skinUiFramePre();
			this.addChild( pptImagePreFrame );
		}
		
		/**背景黃框**/
		private function setPptFolderBackGround():void
		{
			var pptFolder:pptFolderShow = new pptFolderShow();
			this.addChild( pptFolder );
		}
		
		/**元件使用小框**/
		private function setLibrarySmallFrame():void
		{
			librarySmallFrame = new skinUiSmallFrame();
			this.addChild( librarySmallFrame );
		}
		
		/**隱藏自己所有外框**/
		public function hideAllFrame():void
		{
			this.pptImageFrame.visible = false;
			pptImagePreFrame.visible = false;
		}
		
		/**隱藏小的紅色外框**/
		public function hideSmallRedFrame():void
		{
			this.librarySmallFrame.visible = false;
		}
		
		/**開啟紅色外框**/
		public function setRedTargetFrameOpen():void
		{
			this.pptImageFrame.visible = true;
		}
		
		/**開啟綠色外框**/
		public function setGreenPreFrameOpen():void
		{
			pptImagePreFrame.visible = true;
		}
		
		/**開啟紅色小外框**/
		public function setSmallRedFrameOpen():void
		{
			this.librarySmallFrame.visible = true;;
		}
		
		/**開啟關閉按鈕**/
		public function openCloseButton():void
		{
			closeButton.openButton();
		}
		
		/**close button*/
		private function setCloseButton():void
		{
			closeButton = new closeBtn();
			this.addChild( closeButton );
		}
		
		/**修改圖片大小( 符合框 )*/
		private function setTheBitmapSize(imageBitmap:Bitmap,frameWidth:int,frameHeight:int):Bitmap
		{
			while ( imageBitmap.width > frameWidth)
			{
				imageBitmap.width *= 0.99;
				imageBitmap.height *= 0.99;
			}
			
			while ( imageBitmap.height > frameHeight)
			{
				imageBitmap.width *= 0.99;
				imageBitmap.height *= 0.99;
			}
			
			/**轉換成小張的圖片**/
			var bmp:BitmapData=new BitmapData(imageBitmap.width,imageBitmap.height);
			bmp.draw( imageBitmap );
			var cloneBitmap:Bitmap=new Bitmap(bmp);
			cloneBitmap.width=imageBitmap.width;
			cloneBitmap.height=imageBitmap.height;
			
			return cloneBitmap;
		}
		
		/**設定中心點**/
		private function setTheBackGroundPosition(imageBitmap:Bitmap,frameWidth:int,frameHeight:int):void
		{
			theImageCenterX =  ( (frameWidth / 2 ) - imageBitmap .width / 2 );
			theImageCenterY =  ( (frameHeight / 2 ) - imageBitmap .height / 2);
		}
		
		/**因為ispring的首頁點過後會跑到其他動作 所以要開一個方法讓他回到最初**/
		public function recoverIspringStep():void
		{
			if( container )
			{
				/**跑至最後一動的畫面**/
				for( var i:int = 0 ; i<= container.player.slide.animationSteps.count ; i++)
				{
					container.player.view.playbackController.gotoPreviousStep();
				}
			}
		}
	}
}