package com
{
	import com.*;
	import com.longtailvideo.jwplayer.utils.RootReference;
	
	import flash.display.*;
	import flash.display.AVM1Movie;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.media.SoundMixer;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.getTimer;
	
	import ispring.as2player.IPlayer;
	import ispring.as2player.PlayerEvent;
	import ispring.as2player.PresentationLoader;
	import ispring.as2player.SlidePlaybackEvent;
	import ispring.presenter.IPresentationPlayer;
	import ispring.presenter.IPresentationPlayerContainer;
	import ispring.presenter.PlayerContainerEvent;
	import ispring.presenter.player.IPresentationPlaybackController;
	import ispring.presenter.player.clock.IPresentationClock;
	import ispring.presenter.player.clock.PresentationClockEvent;
	import ispring.presenter.player.events.PresentationPlaybackEvent;
	import ispring.presenter.presentation.ITimestamp;
	import ispring.presenter.presentation.slides.ISlides;
	import ispring.presenter.ISlidePlayer;
	import ispring.presenter.ISlidePlayerContainer;
	
	
	import mx.containers.Canvas;
	import mx.controls.SWFLoader;
	import mx.core.Container;
	import mx.core.UIComponent;
	
	import sban.flexStudy.avm1to2.AVM1MvoieProxy;
	
	/**存放所有board layer的class*/
	public class boardMainClass extends MovieClip
	{
		/*
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="imgBoard")]
		private var imgDrarBoard:Class;
		public var eMc_imgDrarBoard:* = new imgDrarBoard();
		*/
		/**用來找相對應的畫板的橋樑**/
		public var parentName:String = "";
		/**useType 使用的版面型態  用來設定背景圖大小( ppt 要放大到相同尺寸 )**/
		public var parentType:String = "";
		/****/
		private var skinsLoader:Loader;
		
		/**板子大小*/
		private var theBoardWidth:int ;
		private var theBoardHeight:int ;
		
		/**元件點下去的x y**/
		private var theLibraryX:int ;
		private var theLibraryY:int ;
		
		/**video 的容器**/
		private var _loader:Loader;
		private var videoUiComo:UIComponent;
		private var _playerObject:DisplayObject;
		private var _flashVars:String;
		private var _playerURL:String = "assets/player/player.swf";
		private var _jwPlayerHack:RootReference;
		
		/**the backGroundLayer*/
		private var theBackGroundLayer:backGroundLayer;
		/**the Library Layer**/
		private var theLibraryLayer:libearyLayer;
		/**the Draw Layer*/
		private var thePenDrawLayer:penDrawLayer;
		
		/**投影片ispring需要用的**/
		
		private var pptloader:Loader ;
		private var m_presentation:DisplayObject ;
		private var m_playerContainer:IPresentationPlayerContainer;
		private var m_player:IPresentationPlayer;
		public var m_playbackController:IPresentationPlaybackController;
		
		public var container:ISlidePlayerContainer ;
		
		/*  這兩個變數是ppt檔案轉成 as2的時候要用的變數
		private var m_player:IPlayer;
		private var m_loader:PresentationLoader;
		*/
		
		/**as3的影片片段要用的**/
		private var mcControlTarget:MovieClip ;
		
		/**目前的flash放進的影片格式**/
		public var currentFlashMcVersion:String = "";
		
		/**遮色片**/
		private var roundedMask:Sprite = new Sprite();
		
		/****/
		private var as2MovicProxy:AVM1MvoieProxy = new AVM1MvoieProxy();
		
		/**由於FLASH 的 ppt 需要用不同的loader 所以先記錄路徑**/
		private var flashPptUrl:String = "";
		
		/**當前投影片的step*/
		public var iSliderCurrentStepNum:int = 0;
		
		/**外面會因為不同的情況丟進不同的SIZE 比方說PPT之類的**/
		public function boardMainClass(boardWidth:int,boardHeigh:int)
		{
			super();
			theBoardWidth = boardWidth;
			theBoardHeight = boardHeigh;
			//
			this.theBackGroundLayer = new backGroundLayer(boardWidth,boardHeigh);
			this.theLibraryLayer = new libearyLayer(boardWidth,boardHeigh);
			this.thePenDrawLayer = new penDrawLayer(boardWidth,boardHeigh);
			//
//			thePenDrawLayer.addEventListener(MouseEvent.CLICK,onclic);
//			theLibraryLayer.addEventListener(MouseEvent.CLICK,onAddLibraryClick);
//			theBackGroundLayer.addEventListener(MouseEvent.CLICK,onclic);
			//
			this.addChild( theBackGroundLayer );
			this.addChild( theLibraryLayer );
			this.addChild( thePenDrawLayer );
			/**加入遮色片 這樣移動元件才不會穿幫**/
			this.addChild(roundedMask);
			boardMask();
			
			this.addEventListener("aaa",aaa);
		}
		
		private function aaa(ev:Event):void
		{
			theBackGroundLayer.stopAllChildMovieClips( as2MovicProxy );
			//setBackGroundInAnimation_as2( as2MovicProxy );
			this.removeEventListener("aaa",aaa);
		}
		
		private function boardMask():void 
		{
			roundedMask.graphics.clear();
			roundedMask.graphics.beginFill(0xFF0000);
			roundedMask.graphics.drawRect(0 , 0 , theBoardWidth , theBoardHeight );
			roundedMask.graphics.endFill();
			this.mask = roundedMask;
		}
		
		/**修改階層   'penLayer' 'libraryLayer'  'backGroundLayer' **/
		public function activeLayer(tagetLayer:String):void
		{
			if( tagetLayer == "penLayer" )
			{
				this.setChildIndex( thePenDrawLayer , this.numChildren - 1 );
			}
			
			if( tagetLayer == "libraryLayer" )
			{
				this.setChildIndex( theLibraryLayer , this.numChildren - 1 );
			}
			
			if( tagetLayer == "backGroundLayer" )
			{
				this.setChildIndex( theBackGroundLayer , this.numChildren - 1 );
				//lockPneLayer();
			}
		}
		
		/**回到原始階層  最底層背景 再來元件 最後畫板**/
		public function resetActiveLayer():void
		{
			this.setChildIndex( thePenDrawLayer , 0 );
			this.setChildIndex( theLibraryLayer , 0 );
			this.setChildIndex( theBackGroundLayer , 0 );
		}
		
		/**在元件版上點下去 要求增加元件在場景**/
		private function onAddLibraryClick(ev:MouseEvent):void
		{
			//trace( ev.localX );
			//trace( ev.target.name );
			/**如果點到的是刪除紐 就不進行動作 由刪除紐的事件去跑***/
			if( ( ev.target.name as String ).indexOf("closeBtn") != -1 )
			{
				return;
			}
			/**轉換座標 轉成local的***/
			var r:Point = new Point();
			r = this.parent.globalToLocal(new Point(ev.stageX,ev.stageY) );
			theLibraryX = r.x ;
			theLibraryY = r.y ;
			/**先抓到有紅框的原件**/
			for( var i:int =0 ; i< GameData.loaderReference.arAllTileInformation.length ; i++ )
			{
				if( (GameData.loaderReference.arAllTileInformation[i] as AdvanceUIComponent ).theVoType == "library" )
				{
					if( (GameData.loaderReference.arAllTileInformation[i] as AdvanceUIComponent ).librarySmallFrame.visible == true )
					{
						libraryLoader( (GameData.loaderReference.arAllTileInformation[i] as AdvanceUIComponent ).loadPathInEnglish );
					}
				}
			}
		}
		
		/** set back ground*/
		private function setBackGround(backGroungBitmap:Bitmap):void
		{
			this.theBackGroundLayer.setBackGroundFromImage( backGroungBitmap );
		}
		
		/**set background in animation _ as3**/
		private function setBackGroundInAnimation_as3(backGroungMC:MovieClip):void
		{
			this.theBackGroundLayer.setBackGroundFromAnimation( backGroungMC );
		}
		
		/**set background in animation _ as2**/
		private function setBackGroundInAnimation_as2(backGroungMC:*):void
		{
			this.theBackGroundLayer.setBackGroundFromAnimation_as2( backGroungMC );
		}
		
		/**set background in video**/
		private function setBackGroundInVideo(Video:*):void
		{
			this.theBackGroundLayer.setBackGroundFromVideo( Video );
		}
		
		/**set background in 投影片**/
		private function setBackGroundInPPT(backGroungMC:*   ):void
		{
			this.theBackGroundLayer.setBackGroundFromPPT( backGroungMC );
		}
		
		/** set library**/
		public function setLibrary(libraryImage:Bitmap,theLibraryX:int,theLibraryY:int):void
		{
			this.theLibraryLayer.addLibrary(libraryImage,theLibraryX,theLibraryY);
		}
		
		/**set penSize*/
		public function setPenSize(penSize:int):void
		{
			this.thePenDrawLayer.changePenSize( penSize );
		}
		
		/**set penColor**/
		public function setPenColor(penColor:uint):void
		{
			this.thePenDrawLayer.changeColor( penColor );
		}
		
		/**set pen state**/
		public function setPenState(penState:Boolean):void
		{
			this.thePenDrawLayer.setPenState( penState );
		}
		
		/**set erase state**/
		public function setEraserState(eraserState:Boolean):void
		{
			this.thePenDrawLayer.setEraserState( eraserState );
		}
		
		/**clear draw **/
		public function clearDrawBoard():void
		{
			this.thePenDrawLayer.clearBoard();
		}
		
		/**change transparent (是否半透明)**/
		public function setTransparent(bool:Boolean):void
		{
			this.thePenDrawLayer.setTransparent( bool );
		}
		
		/**刪除版面上所有的原件**/
		public function deleteAllLibrary():void
		{
			this.theLibraryLayer.deleteAllLibrary();
		}
		
		/**顯示所有刪除紐**/
		public function setAllCloseBtnShow():void
		{
			this.theLibraryLayer.showAllCloseBtn();
		}
		
		/**關閉所有刪除紐**/
		public function setAllCloseBtnVisible():void
		{
			this.theLibraryLayer.visibleAllCloseBtn();
		}
		
		/**控制當前頁面元件 開啟旋轉功能**/
		public function setLibraryRotate():void
		{
			this.theLibraryLayer.setLibraryRotate();
		}
		
		/**控制當前頁面元件 開啟縮放功能**/
		public function setLibraryZoomOpen():void
		{
			this.theLibraryLayer.setLibraryZoomOpen();
		}
		
		/**控制當前頁面元件 開啟複製功能**/
		public function setLibraryCopyOpen():void
		{
			theLibraryLayer.addEventListener(MouseEvent.CLICK,onAddLibraryClick);
		}
		
		/**關閉複製功能***/
		public function setLibraryCopyClose():void
		{
			theLibraryLayer.removeEventListener(MouseEvent.CLICK,onAddLibraryClick);
		}
		
		/**關閉所有元件功能**/
		public function setRemoveAllAction():void
		{
			this.theLibraryLayer.setRemoveAllAction();
		}
		
		/**進行背景的LOADER 這樣自己的背景就LOAD給自己用*/
		public function backGroundLoader(backGroundPath:String):void
		{
			/***給ppt使用**/
			flashPptUrl = backGroundPath;
			//
			skinsLoader = new Loader;
			skinsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,FileLoaderComplete);
			var context:LoaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = backGroundPath;
			skinsLoader.load(urlRequest,context);
			/*
			m_loader = new PresentationLoader();
			m_loader.addEventListener(PlayerEvent.PLAYER_INIT, onPlayerInit);
			m_loader.load(new URLRequest( backGroundPath) , new ApplicationDomain(ApplicationDomain.currentDomain) );
			*/
			//as2MovicProxy.load( backGroundPath );
			//as2MovicProxy.load( backGroundPath );
//			ev.target.content.width = theBoardWidth ; 
//			ev.target.content.height = theBoardHeight;
//			setBackGroundInAnimation_as2( as2MovicProxy );
		}
		
		/**LOAD好之後塞值**/
		private function FileLoaderComplete(ev:Event):void
		{
			if( this.parentType == "ppt")
			{
				ev.target.content.width = theBoardWidth ; 
				ev.target.content.height = theBoardHeight;
				setBackGround( ev.target.content );
			}
			
			if( this.parentType == "imageBaord")
			{
				setBackGround( setTheBackGroundSize( ev.target.content ) );
			}
			
			if( this.parentType == "flash" )
			{
				if( (ev.target.content is AVM1Movie) )
				{
					trace(" this file is avm1" );
					
					/**因為找不到屬性可以判別下載下來的東西是不是ppt的檔案 所以用width來判別 **/
					/*
					if( ev.target.content.width == 0 )
					{
						m_loader = new PresentationLoader();
						m_loader.addEventListener(PlayerEvent.PLAYER_INIT, onPlayerInit);
						m_loader.load(new URLRequest( flashPptUrl) , new ApplicationDomain(ApplicationDomain.currentDomain) );
					}
					*/
					/**anm1的要把畫布拿掉  然後點下畫筆就要可以開啟畫布**/
					//onPptLoadeComplete(ev);
//					ev.target.content.width = theBoardWidth ; 
//					ev.target.content.height = theBoardHeight;
					//trace( ev.target.content.width );
					//trace(ev.target.content.height  );
					//ev.target.loader.width = 1290;
					//trace( ev.target.loader.width );
					//trace( ev.target.loader.height );
					
					//ev.target.content.width = 1290 ; 
					//ev.target.content.height = 728;
					
//					trace( skinsLoader.width ); // 2445.9 total width
//					trace(skinsLoader. contentLoaderInfo.width ); // 1600 stage width
//					trace( skinsLoader. contentLoaderInfo.content );
//					trace( skinsLoader. contentLoaderInfo.content.width );
//					var tw:Number = 1290 / ev.target.content.width ; 
					//var sw = ev.target.width/ldr.width;
					
					//trace( (ev.target as Loader).contentLoaderInfo.width);
					setBackGroundInAnimation_as2( ev.target.loader );
					//this.activeLayer('backGroundLayer');
					/**as2的時候 要把右下方控制項移除**/
					currentFlashMcVersion = "as2Control" ;
					dispatch("as2Control");
				}
				else
				{
					//trace("aaaaa");
					/**如果 (ev.target.content.player) === null表示有這個屬性 所以是投影片 如果等於 undefined = 表示其他影片 **/
					//trace( (ev.target.content.player) )
					if( (ev.target.content.player) === undefined )
					{
						//trace( "undefined" );
						//ev.target.content.width = theBoardWidth ; 
						//ev.target.content.height = theBoardHeight;
						//ev.target.content.width = 1290 ; 
						//ev.target.content.height = 728;
						/**給參照  因為需要控制**/
						mcControlTarget = ev.target.content;
						setBackGroundInAnimation_as3( ev.target.content );
						/**as3 要跑as3 的控制項 並且移掉其他種類控制項**/
						currentFlashMcVersion = "as3Control" ;
						dispatch("as3Control");
						//SoundMixer.stopAll(); 
					}
					else
					{
						/**跑投影片成功事件  跑他的控制項 並且移除其他控制項**/
						//onPptLoadeComplete(ev);
						//currentFlashMcVersion = "pptControl" ;
						//dispatch("pptControl");
						//SoundMixer.stopAll(); 
					}
				}
			}
			if( this.parentType == "ispring" )
			{
				/**跑投影片成功事件  跑他的控制項 並且移除其他控制項**/
				onPptLoadeComplete(ev);
				currentFlashMcVersion = "pptControl" ;
				iSliderCurrentStepNum = 0;
				//dispatch("pptControl");
			}
		}
		
		
		/**此函示是ppt轉成as2的時候使用的**/
		private function onPlayerInit(e:PlayerEvent):void
		{
			//trace("p init");
			/*
			m_player = m_loader.player;
			m_player.playbackController.addEventListener(SlidePlaybackEvent.CURRENT_SLIDE_INDEX_CHANGED, onSlideChange);
			setBackGroundInPPT_( m_loader );
			currentFlashMcVersion = "pptControl" ;
			dispatch("pptControl");
			*/
		}
		
		/**按照目前flash的類型改發送EVENT**/
		private function dispatch(evType:String):void
		{
			var a:Event = new Event(evType,true,true);
			this.dispatchEvent( a );
		}
		
		/**如果是要使用ispring的話 就用這個跑**/
		public function iSpringBackGoundLoader( backGroundPath:String ):void
		{
			/*
			setBackGroundInPPT( target );
			var loader:BridgeLoader = new BridgeLoader(target);
			loader.addEventListener(BridgeEvent.PLAYER_INIT, playerInit);
			player = loader.loadPresentation("ispring/as3bridge/as3bridge.swf",backGroundPath);
			*/
			//var a:UIComponent = new UIComponent();
			//a.addChild( this.pptloader )
			//GameData.flashCavShow.addChild( a );
			/*
			pptloader = new Loader();
			//pptloader.contentLoaderInfo.addEventListener(Event.INIT, onPptLoade);
			pptloader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPptLoadeComplete);
			var context:LoaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));			
			pptloader.load(new URLRequest(backGroundPath), context);
			*/
			/*
			setBackGroundInPPT( pptloader );
			pptloader.addEventListener(PlayerEvent.PLAYER_INIT, playerInit);
			pptloader.load(new URLRequest(backGroundPath));
			*/
			//player = pptloader.player;
			//this.activeLayer("backGroundLayer");
		}
		
		private function onPptLoadeComplete(e:Event):void
		{
//			var contentInfo:LoaderInfo = LoaderInfo(e.target);
//			//trace( contentInfo.width)//567
//			//trace( contentInfo.height)//362
//			//trace( contentInfo.content );
//			m_presentation = contentInfo.content;
//			//trace( m_presentation .width);
//			//trace( m_presentation.height);
//			setBackGroundInPPT( contentInfo.content );
//			m_playerContainer = IPresentationPlayerContainer(m_presentation);
//			//setBackGroundInPPT( m_playerContainer );
//			m_playerContainer.addEventListener(PlayerContainerEvent.PLAYER_IS_AVAILABLE, onPlayerAvailable);
			container = e.target.content as ISlidePlayerContainer;
			/**因為比例有問題 所以才這樣改**/
			e.target.content.width = this.theBoardWidth;
			setBackGroundInPPT( e.target.content );
			/**通知ispringComp投影片下載完畢  可以更換紅綠框**/
			this.dispatchEvent( new Event( "sliderLoadComplete" , true, true ) );
		}
		
		private function onPlayerAvailable(e:PlayerContainerEvent):void 
		{
			m_player = m_playerContainer.player;
			m_playbackController = m_player.presentationView.playbackController;
			m_playbackController.addEventListener(PresentationPlaybackEvent.SLIDE_CHANGE, onSlideChange);
			//m_presentation.width = 1150;
			//trace( m_presentation.width );
			//trace( m_presentation.height);
			//m_presentation.height = 724;
			//setBackGroundInPPT( m_presentation );
		}
		
		private function onSlideChange(e:PresentationPlaybackEvent):void
		{
			//trace("current slide: " + e.slideIndex);
			//const currentIndex:uint = m_playbackController.currentSlideIndex + 1;
			//const count:uint = m_slides.count;
			//m_slideLabel.text = "Slide: " + currentIndex + " of " + count;
			//trace( m_playbackController.currentSlideIndex );
			/**當有換頁時候才丟事件 通知有更改**/
			this.dispatchEvent( new Event( "sliderChange" , true, true ) );
		}
		
		/*
		private function onSlideChange(e:PresentationPlaybackEvent):void
		{
			//trace("current slide: " + e.slideIndex);
		}
		*/
		/**投影片切換下個動作**/
		public function onPlaySliderClickNext():void
		{
			if( container )
			{
				container.player.view.playbackController.gotoNextStep();
				this.iSliderCurrentStepNum++;
				if( iSliderCurrentStepNum > (container.player.slide.animationSteps.count - 1) )
				{
					/**表示是最後一張投影片了**/
					if( GameData.iCurrentPresentSlideCount == container.player.slide.index )
					{
						return;
					}
					/**換下一張投影片*/
					this.dispatchEvent( new Event( "sliderChangeToNext" , true, true ) );
				}
				clearDrawBoard();
				//trace( (container.player.slide.animationSteps.count) );
				//trace( container.player.view.clock.timestamp.stepIndex)
				/*
				if( m_playbackController != null )
				{
				m_playbackController.gotoNextStep();
				clearDrawBoard();
				}
				*/
				/* 轉出as2的時候要使用的
				if( m_player != null )
				{
				m_player.playbackController.gotoNextStep();
				clearDrawBoard();
				}
				*/
			}
		}
		
		/**投影片切換上個動作**/
		public function onPlaySliderClickPrevious():void
		{
			if( container )
			{
				container.player.view.playbackController.gotoPreviousStep();
				//trace( container.player.view.clock.timestamp.stepIndex)
				//trace( (container.player.slide.index) );
				//trace( (container.player.view.) );
				this.iSliderCurrentStepNum--;
				if( iSliderCurrentStepNum < 0 )
				{
					if( container.player.slide.index == 0 )
					{
						return;
					}
					/**換上一張投影片*/
					this.dispatchEvent( new Event( "sliderChangeToPre" , true, true ) );
				}
				clearDrawBoard();
				/*
				if( m_playbackController != null )
				{
				m_playbackController.gotoPreviousStep();
				clearDrawBoard();
				}
				*/
				/* 轉出as2的時候要使用的
				if( m_player != null )
				{
				m_player.playbackController.gotoPreviousStep();
				clearDrawBoard();
				}
				*/
			}
		}
		
		/**投影片的某一頁**/
		public function gotoSlider(sliderNumber:int):void
		{
			if( m_playbackController != null )
			{
				m_playbackController.gotoSlide( sliderNumber );
				//m_playbackController.gotoLastSlide(false);
				//trace( m_playbackController.currentSlideIndex );
				clearDrawBoard();
			}
		}
		
		/**as3的影片片段的上一個frame**/
		public function onAs3McNextFrame():void
		{
			if( this.mcControlTarget != null )
			{
				mcControlTarget.nextFrame();
			}
		}
		
		/**as3的影片片段的下一個frame**/
		public function onAs3McPrevFrame():void
		{
			if( this.mcControlTarget != null )
			{
				mcControlTarget.prevFrame();
			}
		}
		
		
		/**進行video的load load給自己用**/
		public function videoLoader(url:String):void
		{
			if( videoUiComo != null )
			{
				var a:int = videoUiComo.numChildren;
				for( var i:int = 0 ; i< a ; i++ )
				{
					videoUiComo.removeChildAt( 0 );
				}
			}
			
			if( videoUiComo == null )
			{
				videoUiComo = UIComponent( GameData.videoCavShow.addChild(new UIComponent()) );
			}
			_flashVars = "";
			_jwPlayerHack = null;
			_playerObject = null;
			RootReference._playerUI = null;
			RootReference._stageInstance = null;
			RootReference.container = null;
			RootReference.instance = null;
			RootReference.root = null;
			RootReference.stage = null;
			SoundMixer.stopAll();
			if (url != "") 
			{
				videoUiComo.width = this.theBoardWidth;
				videoUiComo.height = this.theBoardHeight;
				_jwPlayerHack = new RootReference(videoUiComo);
				//
				_flashVars = "file=/" + url + "&autostart=false&height=100%&width=100%&mute=false&stretching=exactfit";//exactfit
				_flashVars += "&t=" + getTimer().toString();
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadInit);
				var ldrContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
				var request:URLRequest = new URLRequest(_playerURL);
				var urlVars:URLVariables = new URLVariables();
				urlVars.decode(_flashVars);
				request.data = urlVars;
				_loader.load(request, ldrContext);
			}
		}
		
		private function onLoadInit(ev:Event):void
		{   
			_playerObject = _loader.content as DisplayObject;
			RootReference.root = _playerObject.root;
			_playerObject.addEventListener( "jwplayerReady", onPlayerReady );
			videoUiComo.addChild( _loader );
			this.setBackGroundInVideo( videoUiComo );
			
			/**要再發一個事件去通知筆的問題**/
			var a:Event = new Event("videoShow",true,true);
			this.dispatchEvent( a );
		}
		
		private function onPlayerReady(event:*=null):void 
		{
			_jwPlayerHack.fixMaskIssue();
		}
		
		/**進行元件的load load給自己用**/
		private function libraryLoader(libraryPath:String):void
		{
			skinsLoader = new Loader;
			skinsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,LibraryLoaderComplete);
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = libraryPath;
			skinsLoader.load(urlRequest);
		}
		
		/**Library load 好之後塞值**/
		private function LibraryLoaderComplete(ev:Event):void
		{
			setLibrary(setTheLibrarySize(ev.target.content),this.theLibraryX,this.theLibraryY);
		}
		
		/**修改圖片大小( 符合場景 )  20121101改成滿版大小且不能控制*/
		private function setTheBackGroundSize(imageBitmap:Bitmap):Bitmap
		{
			while ( imageBitmap.width > theBoardWidth)
			{
				imageBitmap.width *= 0.99;
				imageBitmap.height *= 0.99;
			}
			
			while ( imageBitmap.height > theBoardHeight)
			{
				imageBitmap.width *= 0.99;
				imageBitmap.height *= 0.99;
			}
			
//			imageBitmap.width = this.theBoardWidth
//			imageBitmap.height = this.theBoardHeight;
			
			return imageBitmap;
		}
		
		/**修改圖片大小( 符合場景 ) **/
		private function setTheLibrarySize(imageBitmap:Bitmap):Bitmap
		{
			while ( imageBitmap.width > theBoardWidth)
			{
				imageBitmap.width *= 0.99;
				imageBitmap.height *= 0.99;
			}
			
			while ( imageBitmap.height > theBoardHeight)
			{
				imageBitmap.width *= 0.99;
				imageBitmap.height *= 0.99;
			}
			
			return imageBitmap;
		}
	}
}