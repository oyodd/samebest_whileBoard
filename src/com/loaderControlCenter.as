package com
{
	import VoCollection.imageVoCollection.pptFolderVo;
	
	import com.LoaderEvent;
	import com.LoaderX;
	import com.customeURLloader;
	
	import flash.desktop.Clipboard;
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.*;
	import flash.net.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.utils.*;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	/**進行LOADER 的地方 還有保存LOADER回來的所有資料存放*/
	public class loaderControlCenter
	{
		/***********參數**************/
		private var arPptFile:Array;
		private var arPptFileForImage:Array;
		private var arImageBoardFile:Array ;
		private var arLibraryFile:Array;
		private var arFlashImage:Array;
		private var arVideoImage:Array;
		private var arIspring:Array; 
		private var arIspringItem:Array;
		
		/******************************/
		
		/**特別參數  由於IMAGE的素材只需要LOAD一次 所以特別設定一個判斷***/
		private var isImageLoadered:Boolean = false;
		
		/** all tile UiSkin**/
		public var arAllTileInformation:Array = new Array();
		
		/**ppt folder Vo content*/
		public var pptFolderVoCollection:Array = new Array();
		
		/**存放什麼樣的圖檔 對應到的 下載資料路徑  [BaseAssetSource] = reallyAssetsSource **/
		/**中文檔名 新增 刪除問題  也可以用此字典來存放**/
		public var filePathDictionary:Dictionary = new Dictionary();
		
		/**處理副檔名辨別問題的字典  [檔案檔名(不包含副檔名)] = 相對應的圖片檔(包含附檔名)**/
		public var fileNameComparativeImage_flash:Dictionary = new Dictionary();
		
		/**處理副檔名辨別問題的字典 [檔案檔名(不包含副檔名)] = 相對應的圖片檔(包含附檔名  此為video的圖片檔案對應字典  因為兩個使用圖片當索引的資料夾都是一樣的附檔名  所以必須分開 **/
		public var fileNameComparativeImage_video:Dictionary = new Dictionary();
		
		/**處理副檔名辨別問題的字典  [檔案檔名(不包含副檔名)] = 相對應的影片或動畫檔(包含附檔名)**/
		public var fileNameComparativeAssets_flash:Dictionary = new Dictionary();
		
		/**處理副檔名辨別問題的字典  [檔案檔名(不包含副檔名)] = 相對應的影片或動畫檔(包含附檔名) 此為video的影片檔案對應字典  因為兩個使用圖片當索引的資料夾都是一樣的附檔名  所以必須分開**/
		public var fileNameComparativeAssets_video:Dictionary = new Dictionary();
		
		public function loaderControlCenter()
		{
			arPptFile = [];
			arPptFileForImage = [];
			arImageBoardFile = [];
			arLibraryFile = [];
			arFlashImage = [];
			arVideoImage = [];
			arAllTileInformation = [];
			pptFolderVoCollection = [];
			arIspring = [];
			arIspringItem = [];
		}
		
		/**由不同的TYPE進行LOADER*/
		public function fileLoader(fileType:String,pptLoadFolderName:String=""):void
		{
			if( fileType == "pptFolder" )
			{
				var pptDirectory:File = File.applicationDirectory ; 
				pptDirectory = pptDirectory.resolvePath( pathConst.PPT_FOLDER_PATH );
				if( pptDirectory.exists )
				{
					arPptFile = pptDirectory.getDirectoryListing();
				}
				//this is folder
				if(arPptFile != null)
				{
					if(arPptFile.length > 0)
					{
						/**loade for pptFolder*/
						pptFolderUISetUp(arPptFile);
					}
				}
			}
			
			if(fileType == "pptImage" )
			{
				/**loader for ppt's Image**/
				var pptDirectory_:File = File.applicationDirectory ; 
				pptDirectory_ = pptDirectory_.resolvePath( pathConst.PPT_FOLDER_PATH );
				if( pptDirectory_.exists )
				{
					arPptFileForImage = pptDirectory_.getDirectoryListing();
				}
				
				if(arPptFileForImage != null)
				{
					if(arPptFileForImage.length > 0)
					{
						/**loade for pptFolder*/
						/**多一個pptFolderName是因為當點下pptFolder的時候會有folder的名稱 用那個名稱去抓資料就不用全部都實作了**/
						pptImageSetUp(arPptFileForImage,pptLoadFolderName);
					}
				}
			}
			
			if(fileType == "imageBoardImage" )
			{
				if( isImageLoadered ) 
				{
					return;
				}
				isImageLoadered = true;
				/**loader for ppt's Image**/
				var pptDirectory_image:File = File.applicationDirectory ; 
				pptDirectory_image = pptDirectory_image.resolvePath( pathConst.GALLERY_FOLDER_PATH );
				if( pptDirectory_image.exists )
				{
					arImageBoardFile = pptDirectory_image.getDirectoryListing();
				}
				if( arImageBoardFile != null)
				{
					if( arImageBoardFile.length > 0 )
					{
						/**loade for imageBoardFolder*/
						imageBoardImageSetUp(arImageBoardFile);
					}
				}
			}
			
			if(fileType == "library" )
			{
				var pptDirectory_library:File = File.applicationDirectory ; 
				pptDirectory_library = pptDirectory_library.resolvePath( pathConst.LIBRARY_FOLDER_PATH );
				if( pptDirectory_library.exists )
				{
					arLibraryFile = pptDirectory_library.getDirectoryListing();
				}
				if( arLibraryFile != null )
				{
					if( arLibraryFile.length > 0 )
					{
						/**loade for library*/
						libraryAssetsSetUp(arLibraryFile);
					}
				}
			}
			
			if(fileType == "flashImage" )
			{
				//ANIMATION_FOLDER_PATH
				var pptDirectory_flashImage:File = File.applicationDirectory ; 
				pptDirectory_flashImage = pptDirectory_flashImage.resolvePath( pathConst.ANIMATION_FOLDER_PATH );
				if( pptDirectory_flashImage.exists )
				{
					arFlashImage = pptDirectory_flashImage.getDirectoryListing();
				}
				if( arFlashImage != null )
				{
					if( arFlashImage.length > 0 )
					{
						/**loade for library*/
						flashImageAssetsSetUp(arFlashImage);
					}
				}
			}
			
			if(fileType == "videoImage" )
			{
				var pptDirectory_videoImage:File = File.applicationDirectory ; 
				pptDirectory_videoImage = pptDirectory_videoImage.resolvePath( pathConst.VIDEO_FOLDER_PATH );
				if( pptDirectory_videoImage.exists )
				{
					arVideoImage = pptDirectory_videoImage.getDirectoryListing();
				}
				
				if( arVideoImage != null )
				{
					if( arVideoImage.length > 0 )
					{
						/**loade for video*/
						videoImageAssetsSetUp(arVideoImage);
					}
				}
			}
			
			if( fileType == "ispring" )
			{
				var pptDirectory_ispring:File = File.applicationDirectory ; 
				pptDirectory_ispring = pptDirectory_ispring.resolvePath( pathConst.ISPRING_PATH );
				
				if( pptDirectory_ispring.exists )
				{
					arIspringItem = pptDirectory_ispring.getDirectoryListing();
				}
				
				if(arIspringItem != null)
				{
					if(arIspringItem.length > 0)
					{
						/**loade for pptFolder*/
						/**多一個pptFolderName是因為當點下pptFolder的時候會有folder的名稱 用那個名稱去抓資料就不用全部都實作了**/
						ispringSetUp(arIspringItem);
					}
				}
			}
			
			if( fileType == "ispringItem" )
			{
				var pptDirectory_ispringItem:File = File.applicationDirectory ; 
				pptDirectory_ispringItem = pptDirectory_ispringItem.resolvePath( pathConst.ISPRING_PATH );
				
				if( pptDirectory_ispringItem.exists )
				{
					arIspringItem = pptDirectory_ispringItem.getDirectoryListing();
				}
				
				if(arIspringItem != null)
				{
					if(arIspringItem.length > 0)
					{
						/**loade for pptFolder*/
						/**多一個pptFolderName是因為當點下pptFolder的時候會有folder的名稱 用那個名稱去抓資料就不用全部都實作了**/
						ispringItemSetUp(arIspringItem,pptLoadFolderName);
					}
				}
			}
		}
		
		private var fileStream:FileStream = new FileStream();;
		private var bytes:ByteArray = new ByteArray();
		//private var loader:URLLoader = new URLLoader();
		//紀錄每個科目有幾題得地方 索引值當作紀錄點 對應到該科目的值-1
		private var arSubjectNumCollection:Array = [0,0,0,0,0];
		//
		private var againTime:Timer ;
		//
		private var targetSubject:int = 0;
		//
		private var iCount:int = 0;
		private function pptFolderUISetUp(pptFolderArr:Array):void
		{
			for( var i:int = 0; i < pptFolderArr.length ; i++ )
			{
				/**避免他種檔案載入**/
				if(  pptFolderArr[i].type == ".cfg" )
				{
					var stri:String = pptFolderArr[i].url.toString();
					var arName:Array = stri.split("/");
					// this is image
					var directory_:File = File.applicationDirectory ; 
					directory_ = directory_.resolvePath(arName[1] + "/" + arName[2] + "/" + pptFolderArr[i].name );
					
					//fileStream.addEventListener(Event.COMPLETE, completeHandler); 
					//fileStream.openAsync(directory_, FileMode.READ); 
					//var bytes:ByteArray = new ByteArray();
					//trace(arName[1] + "/" + arName[2] + "/" + pptFolderArr[i].name)
					
					//判斷是哪個科目 由ques1101的ques'1'101來判斷  1=國語  2=數學  3=生活  4=自然與生活科技  5=社會
					//strSubjectName == subj
					// charAt 從0開始算字元
					var strSubjectName:String = String(pptFolderArr[i].name).charAt(4);
					targetSubject = (int(strSubjectName) - 1);
					//
					var request:URLRequest = new URLRequest(arName[1] + "/" + arName[2] + "/" + pptFolderArr[i].name);
					//
					var loader:customeURLloader  = new customeURLloader(targetSubject);
					//trace((loader as Object));
					//var request:URLRequest = new URLRequest(arName[1] + "/" + arName[2] + "/" + pptFolderArr[i].name);
					//var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
					loader.addEventListener(Event.COMPLETE,completeHandler0);
					loader.load( request );
					//var loader:LoaderX = new LoaderX( targetSubject );
					//
					//var loader:URLLoader = new URLLoader();    
					//loader.dataFormat = URLLoaderDataFormat.BINARY;
					//loader.addEventListener(IOErrorEvent.IO_ERROR, imgIOErrorHandler);
					//trace( arName[1] + "/" + arName[2] + "/" + pptFolderArr[i].name )
					
					
//					else
//					{
//						trace("againTimeagainTimeagainTime")
//						againTime = null;
//						againTime = new Timer(150,1);
//						againTime.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
//						againTime.start();
//						i--;
//					}
					//var arPptFileImg:Array = new Array();
					//arPptFileImg = directory_.getDirectoryListing();
//					//
//					/**資料夾裡面如果沒有圖片就不要讀取**/
//					if( arPptFileImg[0] != undefined)
//					{
//						var arPptSource:Array = (arPptFileImg[0].url as String).split("/");
//						//trace("aaa" + arPptSource[1] + "/" +  arPptSource[2] + "/" + arPptSource[3] + "/" + arPptSource[4] )
//						/**ppt folder TILE的實體  0-> 只需要第一張封面**/
//						var pptUiSkin:AdvanceUIComponent = new AdvanceUIComponent( arPptSource[1] + "/" +  arPptSource[2] + "/" + arPptSource[3] + "/" + toLowCaseForFileName(arPptSource[4]) ,"pptFolder");
//						pptUiSkin.folderName = arPptFile[i].name;
//						pptUiSkin.folderPath = arPptSource[1] + "/" +  arPptSource[2] + "/" + arPptSource[3] ;
//						arAllTileInformation.push( pptUiSkin );
//					}
					
				}
			}
		}
		
		private function completeHandler0(event:Event):void  
		{ 
			var a:String = new String();
			a = String(event.target.data); 
			var b:Array = [];
			var myPattern:RegExp = /[0-9]=\[/g;
			a = a.replace(myPattern,"*****");
			b = a.split("*****");
			//trace(event.target.index);
			var iSubjectNum:int = arSubjectNumCollection[ event.target.index ] ;
			iSubjectNum += b.length - 1;
			arSubjectNumCollection[ event.target.index ] = iSubjectNum;
			iCount += 1;
			if( iCount== 144 )
			{
				trace( "共  "+arSubjectNumCollection[ this.targetSubject ] +"  提");
			}
		} 
		
		private function pptImageSetUp(pptFolderArr:Array,pptFolderName:String = ""):void
		{
			/**避免ppt的頁面load太多 造成記憶體不夠 所以只有在這邊進行load 而不一次全部都載好**/
			clearPptImageCollection();
			
			for( var i:int = 0; i < pptFolderArr.length ; i++ )
			{
				if(  pptFolderArr[i].type == null && pptFolderName == pptFolderArr[i].name)
				{
					var stri:String = pptFolderArr[i].url.toString();
					var arName:Array = stri.split("/");
					/**儲存資料夾中文對照**/
					GameData.chineseDictionary[ arName[3] ] = pptFolderArr[i].name ;
					
					var directory_:File = File.applicationDirectory ; 
					directory_ = directory_.resolvePath(arName[1] + "/" + arName[2] + "/" + pptFolderArr[i].name );
					var arPptFileImg:Array = new Array();
					arPptFileImg = directory_.getDirectoryListing();
					//
					for( var j:int = 0 ; j< arPptFileImg.length ; j++)
					{
						//trace(arPptFileImg[j].name);
						var stri_:String = arPptFileImg[j].url.toString();
						var arName_:Array = stri_.split("/");
						/**儲存ppt圖片的中文檔名對照**/
						GameData.chineseDictionary[ arName[4] ] = arPptFileImg[j].name ;
						//PPT的每張圖片
						var pptUiSkin:AdvanceUIComponent = new AdvanceUIComponent( arName_[1] + "/" + arName_[2] + "/" + arPptFile[i].name + "/" + toLowCaseForFileName(arName_[4])
							,"pptImage");
						pptUiSkin.pptPageOrderNumber = j;
						/***ppt的 pptForlderName 是要用資料夾名稱**/
						pptUiSkin.folderName = pptFolderArr[i].name;
						pptUiSkin.folderPath = arName_[1] + "/" + arName_[2] + "/" + arPptFile[i].name ;
						//trace( arPptFile[i].name );
						arAllTileInformation.push( pptUiSkin );
						/**實作PPT畫板 在這邊做是因為 PPT每張圖片都要一個畫板**/
						//var boardNew:boardMainClass = new boardMainClass(1140,724);
						var boardNew:boardMainClass = new boardMainClass(1150,724);
						GameData.allBoardCollection.push( boardNew );
						boardNew.parentName = pptUiSkin.name;
						boardNew.parentType = "ppt";
					}
				}
			}
		}
		
		private function imageBoardImageSetUp(imageFolderArr:Array):void
		{
			for( var i:int = 0; i < imageFolderArr.length ; i++ )
			{
				for( var j:int = 0 ; j< GameData.arTileSupportImageFormat.length ; j++)
				{
					if( String(imageFolderArr[i].type) == GameData.arTileSupportImageFormat[j] )
					{
						var stri:String = imageFolderArr[i].url.toString();
						var arName:Array = stri.split("/");
						/**儲存圖檔的中文檔名**/
						GameData.chineseDictionary[ arName[3] ] = imageFolderArr[i].name ;
						//
						var imageUiSkin:AdvanceUIComponent = new AdvanceUIComponent( arName[1] + "/" + arName[2] + "/" + toLowCaseForFileName(arName[3]) ,"imageBoardImage");
						arAllTileInformation.push( imageUiSkin );
					}
				}
			}
		}
		
		private function libraryAssetsSetUp(libraryFolderArr:Array):void
		{
			for( var i:int = 0; i < libraryFolderArr.length ; i++ )
			{
				for( var j:int = 0 ; j< GameData.arTileSupportImageFormat.length ; j++)
				{
					if( String(libraryFolderArr[i].type) == GameData.arTileSupportImageFormat[j] )
					{
						var stri:String = libraryFolderArr[i].url.toString();
						var arName:Array = stri.split("/");
						/**儲存元件的中文檔名**/
						GameData.chineseDictionary[ arName[3] ] = libraryFolderArr[i].name ;
						var libraryUiSkin:AdvanceUIComponent = new AdvanceUIComponent( arName[1] + "/" + arName[2] + "/" + toLowCaseForFileName(arName[3]) ,"library");
						arAllTileInformation.push( libraryUiSkin );
					}
				}
			}
		}
		
		private function flashImageAssetsSetUp(animationFolderArr:Array):void
		{
			/**要先把檔名先比對出來 才知道副檔名不一樣的檔案的副檔名是啥**/
			analyzeFile( animationFolderArr , "flash");
			
			for( var i:int = 0; i < animationFolderArr.length ; i++ )
			{
				//trace(animationFolderArr[i].name)//aa_AS3.png  aa_AS3.swf
				//trace(animationFolderArr[i].type)//.png  .swf
				//trace( animationFolderArr[i].url )//app:/assets/animation/aa_AS3.png
				
				/**這邊只有圖供圖片檔案下載  素材不做下載 只給路徑**/
				/**找到有支援的圖檔副檔名**/
				//if( animationFolderArr[i].type == GameData.arTileSupportImageFormat[j] )
				/**比對副檔名和大小寫問題**/
				if( checkFileIsLicitForImage( animationFolderArr[i].name ) )
				{
					/**到這表示該檔案為圖檔**/
					var stri:String = animationFolderArr[i].url.toString();
					var arName:Array = stri.split("/");
					//這邊多一個flash影片檔名
					//GameData.chineseDictionary [ arName[3] ] = animationFolderArr[i].name ;
					//trace( getFileName(animationFolderArr[i].name) )
					
					var strAnimationFileName:String = fileNameComparativeAssets_flash[ getFileName(animationFolderArr[i].name) ] ;
					//var strImageFileName:String = this.fileNameComparativeImage_flash[  ]
					//GameData.chineseDictionary [ arName[3] ] = strAnimationFileName ;
					
					//trace( arName[1] + "/" + arName[2] + "/" + strAnimationFileName )
					var flashUiSkin:AdvanceUIComponent = new AdvanceUIComponent( arName[1] + "/" + arName[2] + "/" + toLowCaseForFileName(animationFolderArr[i].name) ,
						"flash",
						arName[1] + "/" + arName[2] + "/" + strAnimationFileName);
					arAllTileInformation.push( flashUiSkin );
				}
			}
		}
		
		private function videoImageAssetsSetUp(videoFolderArr:Array):void
		{
			/**要先把檔名先比對出來 才知道副檔名不一樣的檔案的副檔名是啥**/
			analyzeFile( videoFolderArr , "video");
			
			for( var i:int = 0; i < videoFolderArr.length ; i++ )
			{
				/**這邊只有圖供圖片檔案下載  素材不做下載 只給路徑**/
				/**比對副檔名和大小寫問題**/
				if( checkFileIsLicitForImage( videoFolderArr[i].name ) )
				{
					/**到這表示該檔案為圖檔**/
					var stri:String = videoFolderArr[i].url.toString();
					var arName:Array = stri.split("/");
					//這邊多一個video影片檔名
					var strAnimationFileName:String = fileNameComparativeAssets_video[ getFileName(videoFolderArr[i].name) ] ;
					//trace( arName[1] + "/" + arName[2] + "/" + strAnimationFileName )
					var flashUiSkin:AdvanceUIComponent = new AdvanceUIComponent( arName[1] + "/" + arName[2] + "/" + toLowCaseForFileName(videoFolderArr[i].name) ,
						"video",
						arName[1] + "/" + arName[2] + "/" + strAnimationFileName);
					arAllTileInformation.push( flashUiSkin );
				}
			}
		}
		
		private function ispringSetUp(pptFolderArr:Array):void
		{
			for( var i:int = 0; i < pptFolderArr.length ; i++ )
			{
				/**避免他種檔案載入**/
				if(  pptFolderArr[i].type == null )
				{
					//trace( pptFolderArr[i].type );
					//var stri:String = pptFolderArr[i].url.toString();
					//var arName:Array = stri.split("/");
					// this is image
					var directory_:File = File.applicationDirectory ; 
					directory_ = directory_.resolvePath( "assets/ispring/" + pptFolderArr[i].name );
					var arPptFileImg:Array = new Array();
					arPptFileImg = directory_.getDirectoryListing();
					//
					/**資料夾裡面如果沒有圖片就不要讀取**/
					if( arPptFileImg[0] != undefined)
					{
						//var arPptSource:Array = (arPptFileImg[0].url as String).split("/");
						//trace("aaa" + arPptSource[1] + "/" +  arPptSource[2] + "/" + arPptSource[3] + "/" + arPptSource[4] )
						/**ppt folder TILE的實體  0-> 只需要第一張封面**/
						var pptUiSkin:AdvanceUIComponent = new AdvanceUIComponent( "assets/ispring/" + pptFolderArr[i].name + "/slide1.swf" ,"ispring");
						//var pptUiSkin:AdvanceUIComponent = new AdvanceUIComponent( "assets/ispring/" + pptFolderArr[i].name + "/inOne/ppt1.swf" ,"ispring");
						pptUiSkin.folderName = pptFolderArr[i].name;
						pptUiSkin.folderPath = "assets/ispring/" + pptFolderArr[i].name ;
						arAllTileInformation.push( pptUiSkin );
					}
				}
			}
		}
		
		private function ispringItemSetUp(ispringFolderArr:Array,folderName:String):void
		{
			clearIspringCollection();
			var boolNull:Boolean = false;
			
			for( var i_:int = 0; i_ < ispringFolderArr.length ; i_++ )
			{
				if(  ispringFolderArr[i_].type == null && folderName == ispringFolderArr[i_].name)
				{
					var directory:File = File.applicationDirectory ; 
					directory = directory.resolvePath( "assets/ispring/" + folderName  );
					var arPptFileImg_:Array = new Array();
					arPptFileImg_ = directory.getDirectoryListing();
					
					for( var j_:int = 0 ; j_< arPptFileImg_.length ; j_++)
					{
						if( arPptFileImg_[j_].type == null )
						{
							boolNull = true;
						}
					}
				}
				
			}	
			
			for( var i:int = 0; i < ispringFolderArr.length ; i++ )
			{
				if(  ispringFolderArr[i].type == null && folderName == ispringFolderArr[i].name)
				{
					//var stri:String = ispringFolderArr[i].url.toString();
					//var arName:Array = stri.split("/");
					///**儲存資料夾中文對照**/
					//GameData.chineseDictionary[ arName[3] ] = ispringFolderArr[i].name ;
					//
					var directory_:File = File.applicationDirectory ; 
					directory_ = directory_.resolvePath( "assets/ispring/" + folderName  );
					var arPptFileImg:Array = new Array();
					arPptFileImg = directory_.getDirectoryListing();
					/**要開始load投影片的時候先把數字歸零**/
					GameData.iCurrentPresentSlideCount = -1;
					//
					for( var j:int = 0 ; j< arPptFileImg.length ; j++)
					{
						//trace( arPptFileImg[j].type )
						if( arPptFileImg[j].type != null )
						{
							//trace( folderName );
							//trace("count");
							//trace(arPptFileImg[j].name);
							//var stri_:String = arPptFileImg[j].url.toString();
							//var arName_:Array = stri_.split("/");
							///**儲存ppt圖片的中文檔名對照**/
							//GameData.chineseDictionary[ arName[4] ] = arPptFileImg[j].name ;
							//PPT的每張圖片
							if( boolNull )
							{
								var ispringUiSkin:AdvanceUIComponent = new AdvanceUIComponent( "assets/ispring/" + folderName + "/slide" + j + ".swf"
									,"ispringItem");
								ispringUiSkin.pptPageOrderNumber = j;
								/***ppt的 pptForlderName 是要用資料夾名稱**/
								ispringUiSkin.folderName = folderName;
								arAllTileInformation.push( ispringUiSkin );
							}
							else
							{
								var ispringUiSkin_:AdvanceUIComponent = new AdvanceUIComponent( "assets/ispring/" + folderName + "/slide" + (j+1) + ".swf"
									,"ispringItem");
								ispringUiSkin_.pptPageOrderNumber = j;
								/***ppt的 pptForlderName 是要用資料夾名稱**/
								ispringUiSkin_.folderName = folderName;
								arAllTileInformation.push( ispringUiSkin_ );
							}
						}
					}
				}
			}
		}
		
		/**swf and ma4 或是圖檔等等 檔案因為附檔名不一定 所以需要一個對照表才方便下載或刪除 **/
		private function analyzeFile(FolderArr:Array,type:String=""):void
		{
			if( type == "flash" )
			{
				/**處理圖檔的索引***/
				for( var i:int = 0 ; i<FolderArr.length ; i++)
				{
					for( var j:int = 0 ; j< GameData.arTileSupportImageFormat.length ; j++)
					{
						/**找到有支援的圖檔副檔名**/
						//if( FolderArr[i].type == GameData.arTileSupportImageFormat[j] )
						if( checkFileIsLicitForImage( FolderArr[i] ) )
						{
							/**到這表示該檔案為圖檔  這邊就可以找到亂碼中文的對應**/
							fileNameComparativeImage_flash[ getFileName(FolderArr[i].name) ] = FolderArr[i].name;
						}
					}
				}
				
				/**處理影片檔的索引***/
				for( var k:int = 0; k<FolderArr.length ; k++)
				{
					for( var g:int = 0 ; g< GameData.arSupportPlayFormat.length ; g++)
					{
						//checkFileIsLicitForVideo( FolderArr[k].name )
						//if( FolderArr[k].type == GameData.arSupportPlayFormat[g] )
						if( checkFileIsLicitForVideo( FolderArr[k].name ) )
						{
							/**到這表示該檔案不是圖檔  這邊就可以找到亂碼中文的對應**/
							fileNameComparativeAssets_flash[ getFileName(FolderArr[k].name) ] = FolderArr[k].name;
						}
					}
				}
			}
			
			if( type == "video" )
			{
				for( var w:int = 0 ; w<FolderArr.length ; w++)
				{
					for( var r:int = 0 ; r< GameData.arTileSupportImageFormat.length ; r++)
					{
						/**找到有支援的圖檔副檔名**/
						//checkFileIsLicitForImage( FolderArr[w].name );
						if( checkFileIsLicitForImage( FolderArr[w].name ) )
						{
							/**到這表示該檔案為圖檔  這邊就可以找到亂碼中文的對應**/
							fileNameComparativeImage_video[ getFileName(FolderArr[w].name) ] = FolderArr[w].name;
						}
					}
				}
				
				/**處理影片檔的索引***/
				for( var x:int = 0; x<FolderArr.length ; x++)
				{
					for( var f:int = 0 ; f< GameData.arSupportPlayFormat.length ; f++)
					{
						//checkFileIsLicitForVideo(FolderArr[x].name)
						//if( FolderArr[x].type == GameData.arSupportPlayFormat[f] )
						if( checkFileIsLicitForVideo(FolderArr[x].name) )
						{
							/**到這表示該檔案不是圖檔  這邊就可以找到亂碼中文的對應**/
							fileNameComparativeAssets_video[ getFileName(FolderArr[x].name) ] = FolderArr[x].name;
						}
					}
				}
			}
		}
		
		/**確認該檔案是否有符合的副檔名  因為用字串比對會有大小寫問題 所以有indexOf  圖片類使用**/
		private function checkFileIsLicitForImage(fileName:String):Boolean
		{
			/**轉換成小寫後再過去比對**/
			fileName = fileName.toLowerCase();
			for( var f:int = 0 ; f < GameData.arTileSupportImageFormat.length ; f++)
			{
				if( fileName.indexOf( GameData.arTileSupportImageFormat[f] ) != -1  )
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**確認該檔案是否有符合的副檔名  因為用字串比對會有大小寫問題 所以有indexOf  影片類使用**/
		private function checkFileIsLicitForVideo(fileName:String):Boolean
		{
			/**轉換成小寫後再過去比對**/
			fileName = fileName.toLowerCase();
			for( var f:int = 0 ; f < GameData.arSupportPlayFormat.length ; f++)
			{
				if( fileName.indexOf( GameData.arSupportPlayFormat[f] ) != -1  )
				{
					return true;
				}
			}
			
			return false;
		}
		
		
		/**去掉副檔名 只取出檔名**/
		private function getFileName(fileNmaeAll:String):String
		{
			var arName:Array = fileNmaeAll.split(".");
			return ( arName[0] as String );
		}
		
		/**清除所有pptImage的board和tileCollection**/
		private function clearPptImageCollection():void
		{
			for( var i:int = 0; i<GameData.allBoardCollection.length ; i++)
			{
				if( (GameData.allBoardCollection[i] as boardMainClass).parentType == "ppt" )
				{
					GameData.allBoardCollection.splice( i );
					i--;
				}
			}
			
			for( var f:int = 0 ; f < arAllTileInformation.length ; f++)
			{
				if( ( arAllTileInformation[f] as AdvanceUIComponent ).theVoType == "pptImage" )
				{
					arAllTileInformation.splice( f );
					f--;
				}
			}
		}
		
		/**清除所有ispringImage和tileCollection**/
		private function clearIspringCollection():void
		{
			for( var f:int = 0 ; f < arAllTileInformation.length ; f++)
			{
				if( ( arAllTileInformation[f] as AdvanceUIComponent ).theVoType == "ispringItem" )
				{
					arAllTileInformation.splice( f );
					f--;
				}
			}
		}
		
		/**將丟入的檔案名稱(包含副檔名) 對副檔名進行轉小寫動作**/
		private function toLowCaseForFileName(fileName:String):String
		{
			/**先分離出副檔名**/
			var _arFileName:Array = fileName.split(".");
			
			/**轉換成小寫副檔名後再過接回去回傳**/
			//trace( (String(_arFileName[0]) + "." + String(_arFileName[1]).toLowerCase()) );
			
			return (String(_arFileName[0]) + "." + String(_arFileName[1]).toLowerCase());
			
		}
		
		//取得中文名稱
//		private function getVoChineseName(arVo:Array,url:String,type:String):void
//		{
//			if( type == "ppt" )
//			{
//				var stri:String = arVo[i].url.toString();
//				var arName:Array = stri.split("/");
//			}
//		}
		
	}
}