package com.longtailvideo.jwplayer.utils
{
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import spark.components.WindowedApplication;
	
	/**
	 * This is a workaroud to made Longtail FLV Player 5 (http://www.longtailvideo.com/players/jw-flv-player/), work within Adobe Flex.
	 * 
	 * This class is overlaps original class com.longtailvideo.jwplayer.utils.RootReference compiled in Player.
	 * 
	 * WARNING: This class MUST be placed strictly in com.longtailvideo.jwplayer.utils class path.
	 *
	 * Usage example:
	 * 
	 * <?xml version="1.0" encoding="utf-8"?>
	 * <mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" xmlns:com="com.*"
	 *					layout="vertical"
	 *					verticalAlign="middle" horizontalAlign="center" 
	 *					creationComplete="handleCreationComplete()">
	 *	
	 *	<mx:Script>
	 *		<![CDATA[
	 *			import com.longtailvideo.jwplayer.utils.RootReference;
	 *			
	 *			import mx.core.UIComponent;
	 *			import mx.events.FlexEvent;
	 *			
	 *			private var _loader			: Loader;
	 *			private var _playerObject	: DisplayObject;
	 *			private var _flashVars		: String;
	 *			private var _autoStart		: Boolean = true;
	 *			private var _playerURL		: String = "player.swf";
	 *			
	 *			private var _videoURL		: String = "someVideo.flv";
	 *			
	 *			private var _uic			: UIComponent;
	 *			private var _jwPlayerHack	: RootReference;
	 *
	 *			protected function handleCreationComplete () : void
	 *			{
	 * 				// You can add Player container not only in some UIComponent but also on stage.
	 *				_uic = UIComponent( canv.addChild ( new UIComponent () ) );
	 *				
	 *				_uic.width = 400;
	 *				_uic.height = 300;
	 *				
	 *				_jwPlayerHack = new RootReference( _uic );
	 *				
	 *				videoSource = _videoURL;
	 *			}
	 *			
	 *			public function set videoSource( url : String ) : void
	 *			{
	 *				if ( ! url ) url = "";
	 *				
	 *				// Here you can set any FlashVars supported by player
	 *				// see http://developer.longtailvideo.com/trac/wiki/Player5FlashVars
	 *				_flashVars = "file=" + url + "&autostart=true";
	 *				_flashVars += "&t=" + getTimer().toString();
	 *				
	 *				_loader = new Loader();
	 *			
	 *				_loader.contentLoaderInfo.addEventListener( Event.INIT, onLoadInit );
	 *				
	 *				var ldrContext	: LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain );
	 *				var request		: URLRequest = new URLRequest( _playerURL );
	 *				var urlVars		: URLVariables = new URLVariables();
	 *				
	 *				urlVars.decode( _flashVars );
	 *				
	 *				request.data = urlVars;
	 *				
	 *				_loader.load( request, ldrContext );
	 *			}
	 *			
	 *			private function onLoadInit ( event:Event ) : void
	 *			{	
	 *				_playerObject = _loader.content as DisplayObject;
	 *				_playerObject.addEventListener( "jwplayerReady", onPlayerReady );
	 *				
	 *				RootReference.root = _playerObject.root;
	 *				
	 *				_uic.addChild( _loader );
	 *			}
	 *			
	 *			private function onPlayerReady ( event:* = null ) : void
	 *			{
	 *				_jwPlayerHack.fixMaskIssue();
	 *			}
	 *
	 *		]]>
	 *	</mx:Script>	
	 *	
	 *	<mx:Canvas id="canv" width="400" height="300" backgroundColor="0xffffff" />
     *	
	 * </mx:Application>
	 *
	 * @author Dmitry 'Reijii' Kochetov, Marat '7thsky' Atayev
	 * 
	 * @version Jan 14, 2010
	 * @skype kodjii
	 *
	 * This work is licensed under a Creative Commons Attribution-Share Alike 3.0 Unported
	 * @see http://creativecommons.org/licenses/by-sa/3.0/
	 */
	
	public class RootReference extends EventDispatcher
	{
		public static var root				: DisplayObject;
		public static var stage				: RootReference;
		public static var container			: UIComponent;
		
		public static var instance			: RootReference;
		
		public static var _stageInstance	: Stage;
		public static var _playerUI			: MovieClip;
		
		public function RootReference ( $displayObj : DisplayObject ) : void
		{
			if ( ! RootReference.instance )
			{
				RootReference.instance	= this;
				RootReference.container = $displayObj as UIComponent;
				RootReference.stage		= RootReference.instance;
				
				try
				{
					Security.allowDomain( "*" );
				}
				catch ( e : Error )
				{
					// This may not work in the AIR testing suite
				}
				
				if ( container.stage )
				{
					_stageInstance = container.stage;
					_stageInstance.addEventListener( Event.ADDED, handleAdded );
				}
				else
				{
					container.addEventListener( Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true );
				}
			}
		}
		
		private function handleAddedToStage ( event:Event ) : void
		{
			container.removeEventListener( Event.ADDED_TO_STAGE, handleAddedToStage );
			
			_stageInstance = container.stage;
			_stageInstance.addEventListener( Event.ADDED, handleAdded );
		}
		
		private function handleAdded ( event:Event ) : void
		{
			if ( event.target is Video )
			{
				enterDebugger();
			}
		}
		
		public function fixMaskIssue () : void
		{
			var i		: int;
			var parent	: MovieClip; 
			var child	: DisplayObject;
			var mask	: DisplayObject;
			var tl		: Point; 
			var br		: Point;
			
			if ( ( parent = _playerUI ) != null )
			{
				for ( i = 0; i < parent.numChildren; i++ )
				{
					if ( parent.getChildAt( i ).mask)
					{
						mask = parent.getChildAt( i ).mask;
						break;
					}
				}
			}
			
			if ( mask )
			{
				tl = container.localToGlobal( new Point( 0, 0 ) );
				br = container.localToGlobal( new Point( container.width, container.height ) );
				
				mask.x = tl.x;
				mask.y = tl.y;
				mask.width = br.x - tl.x;
				mask.height = br.y - tl.y;	
			}
		}
		
		// STAGE EMULATION ;)
		public var stage		: Object = {};
		
		public function get stageWidth () : int
		{
			return container.width;
		}
		
		public function get stageHeight () : int
		{
			return container.height;
		}
		
		override public function addEventListener ( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ) : void
		{
			_stageInstance.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		override public function removeEventListener ( type:String, listener:Function, useCapture:Boolean = false ) : void
		{
			_stageInstance.removeEventListener( type, listener, useCapture );
		}
		
		override public function hasEventListener ( type:String ) : Boolean
		{
			return _stageInstance.hasEventListener( type );
		}
		
		override public function willTrigger ( type:String ) : Boolean
		{
			return _stageInstance.willTrigger( type );
		}
		
		override public function dispatchEvent ( event:Event ) : Boolean
		{
			return _stageInstance.dispatchEvent( event );
		}
		
		public function addChildAt ( $child:DisplayObject, $index:int ) : DisplayObject
		{
			if ( $child is MovieClip )
			{
				_playerUI = MovieClip( $child );
			}
			
			return container.addChildAt( $child, $index );
		}
		
		public function addChild ( $child:DisplayObject ) : DisplayObject
		{
			return addChildAt( $child, container.numChildren ); 
		}
		
		public function removeChild ( $child:DisplayObject ) : DisplayObject
		{
			return container.removeChild( $child );
		}
		
		public function get numChildren () : uint
		{
			return container.numChildren;
		}
		
		public function get displayState () : String
		{
			return _stageInstance ? _stageInstance.displayState : '';
		}
		
		private var _savedParent	: DisplayObjectContainer;
		private var _savedLayout	: String;
		private var _savedWidth		: Number;		
		private var _savedHeight	: Number;		
		private var _savedX			: Number;		
		private var _savedY			: Number;
		private var _savedIndex		: Number;
		private var _isLocked		: Boolean = false;		
		
		public function set displayState ( $value:String ) : void
		{
			if ( $value == StageDisplayState.FULL_SCREEN )
			{
				_isLocked = false;
				
				setFullScreen();
			}
			else if ( _stageInstance.displayState == StageDisplayState.FULL_SCREEN )
			{
				_isLocked = true;
				
				setNormalScreen();
			}
		}
		
		private function handleFullScreen ( event:FullScreenEvent ) : void
		{
			if ( event.fullScreen == false && _isLocked == false  )
			{
				setNormalScreen();
			}
		}
		
		//private var ifFull:Boolean = false;
		/*
		private function handleNormalScreen ( ) : void
		{
			if( !ifFull )
			{
				setNormalScreen();
			}
		}
		*/
		private function setFullScreen () : void
		{
			_savedWidth		= container.width;
			_savedHeight	= container.height;//mx.core.FlexGlobals.topLevelApplication
			//_savedLayout    = mx.core.FlexGlobals.topLevelApplication.layout;//Application.application.layout;
			_savedParent	= container.parent;
			
			//mx.core.FlexGlobals.topLevelApplication.layout = "absolute";//Application.application.layout = "absolute";
			
			_savedIndex = _savedParent.getChildIndex( container );
			
			mx.core.FlexGlobals.topLevelApplication.stage.addChild( _savedParent.removeChild( container ) );//Application.application.addChild( _savedParent.removeChild( container ) );
			_savedX = container.x;
			_savedY = container.y;
			
			container.x = 0;
			container.y = 0;
			
			_stageInstance.addEventListener( FullScreenEvent.FULL_SCREEN, handleFullScreen );
			
			_stageInstance.fullScreenSourceRect = new Rectangle( 0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY );
			
			//_stageInstance.displayState = StageDisplayState.FULL_SCREEN;
			/*
			if( ifFull )
			{
				ifFull = false;
			}
			else
			{
				ifFull = true;
			}
			*/
			container.width = Capabilities.screenResolutionX;
			container.height = Capabilities.screenResolutionY;
			
			Object( RootReference.root ).redraw();
			
			fixMaskIssue();
			//handleNormalScreen();
		}
		
		private function setNormalScreen () : void
		{
			//_stageInstance.displayState = StageDisplayState.NORMAL;
			
			//mx.core.FlexGlobals.topLevelApplication.layout = _savedLayout;//Application.application.layout = _savedLayout;
			
			_savedParent.addChildAt( mx.core.FlexGlobals.topLevelApplication.stage.removeChild( container ),	_savedIndex );//_savedParent.addChildAt( Application.application.removeChild( container ),	_savedIndex );
			
			container.width		= _savedWidth;
			container.height	= _savedHeight;
			container.x			= _savedX;
			container.y			= _savedY;
			
			Object( RootReference.root ).redraw();
			
			fixMaskIssue();
			
			_stageInstance.removeEventListener( FullScreenEvent.FULL_SCREEN, handleFullScreen );
		}
		
		public function get scaleMode () : String
		{
			return _stageInstance ? _stageInstance.scaleMode : '';
		}
		
		public function set scaleMode ( $value:String ) : void
		{
			_stageInstance.scaleMode = $value;
		}
	}
}
