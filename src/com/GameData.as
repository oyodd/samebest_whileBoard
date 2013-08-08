package com
{
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.containers.TabNavigator;
	import mx.controls.Button;
	
	import spark.components.*;

	public class GameData
	{
		/**頁面的索引*/
		public static var arTabCollection:Array ; 
		
		/**loader */
		public static var loaderReference:loaderControlCenter;
		
		/**current page name**/
		public static var currentPageName:String = "TabNavContent_0";
		
		/** all board collection**/
		public static var allBoardCollection:Array = new Array();
		
		/**current board**/
		public static var currentBaord:boardMainClass ; 
		
		/** all page Comp**/
		public static var allPageComp:Array = new Array();
		
		/**tile 支援的圖檔格式**/
		public static var arTileSupportImageFormat:Array = [".jpg",".png"];
		
		/**我們有支援的影片格式**/
		public static var arSupportPlayFormat:Array = [".mp4",".swf",".flv"];
		
		/****/
		public static var videoCavShow:Canvas ;
		
		/*****/
		public static var pptControlBtnPlay:mx.controls.Button = new mx.controls.Button();
		
		/****/
		public static var flashCavShow:Canvas ;
		
		/***鉛筆 橡皮擦  顏色 大小 參數設定***/
		public static var isPenUse:Boolean = true;
		public static var isEraserUse:Boolean = false;
		public static var currentPenColor:uint = 0x000000; 
		public static var currentPnnSize:int = 5;
		public static var currentPenTransparent:Boolean = false; 
		/**************************/
		
		/**中文字集對照表**/
		/** [中文亂碼] = 原始中文字**/
		public static var chineseDictionary:Dictionary = new Dictionary();
		
		/**當前投影片的總數**/
		public static var iCurrentPresentSlideCount:int = 0;
		
		/**get page**/
		public static function getTabNav():NavigatorContent // TabNavContent_0
		{
			var tmpNC:NavigatorContent;
			var arStr:Array = GameData.currentPageName.split("_");
			for (var i:int; i < 6;i++)
			{
				if( int( arStr[1] ) == i )
				{
					tmpNC = arTabCollection[i] as NavigatorContent ;
				}
			}
			
			return tmpNC;
			//return (arTabCollection[1] as NavigatorContent)
		}
		
		/**get current tabNav comp**/
		public static function getCurrentTabNavComp():*
		{
			return GameData.getTabNavComp( GameData.currentPageName );
		}
		
		/**取回tabNav的comp**/
		public static function getTabNavComp(tabNavName:String):*
		{
			for (var i:int; i < GameData.arTabCollection.length ;i++)
			{
				if( GameData.arTabCollection[i].name == tabNavName )
				{
					return ( GameData.arTabCollection[i] as NavigatorContent ) .getElementAt( 0 );
				}
			}
		}
			
		
		/**get board use parent name**/
		public static function getBoard(parentName:String):boardMainClass
		{
			for( var i:int = 0 ; i< allBoardCollection.length ; i++ )
			{
				if( (allBoardCollection[i] as boardMainClass).parentName == parentName )
				{
					return (allBoardCollection[i] as boardMainClass) ;
				}
			}
			return null;
		}
		
		
		public function GameData()
		{
		}
	}
}