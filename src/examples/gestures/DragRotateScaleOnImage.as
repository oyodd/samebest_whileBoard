package examples.gestures
{
//	import DrawboardSrc.AirDrawBoardClass;
	
	import com.GameData;
	import com.greensock.*;
	import com.libearyLayer;
	
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GestureEvent;
	import flash.events.MouseEvent;
	import flash.events.PressAndTapGestureEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.*;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flashx.textLayout.events.ModelChange;
	
	import mx.controls.Image;
	
	import org.tuio.TuioTouchEvent;

	public class DragRotateScaleOnImage extends MovieClip
	{
		public var minScale:Number = 0.1;
		public var maxScale:Number = 2.5;
		public var curID:int = -1;
		//前一個移動的X座標
		private var mouseMoveBefore:Number = 0;
		//移動的量
		public var mouseMoveValue:Number;
		//達到門檻 就刪除
		public var mouseMoveCheckValue:Number = 130;
		//可能需要一個TIMER 0.5秒要清一次 mouseMoveValue 和  mouseMoveCheckValue
		private var recoverTimer:Timer = new Timer(500);
		//timer開啟的按鈕 當圖片放到定位才開始計算時間
		private var startTimer:Boolean = false;
		//紀錄連點兩下的時間間個用
		private var getClickTimerFirst:uint;
		//圖片的路徑
		public var strImgPath:String = "";
		//圖片被COPY的數量 點下右鍵就重算
		//初始直給1是因為  寬度*1 還是原本的 所以不能是0  要給1
		public var imgCopyCount:int = 0;
		//
		//
		private var closeBtnName:String;
		//
		private var copyBtnName:String;
		//
		private var closeBtnWidth:Number;
		//
		private var CopyBtnWidth:Number;
		
		////////////////////////////////////////////
		//紀錄按下之後 沒有移動 停留的時間 兩秒就會出現XX
		//private var mouseDownTimer:Timer;
		//紀錄XX是否要移除
		//private var boolImgCloseShow:Boolean = true;
		////////////////////////////////////////////
		//
		private var mcRightPoint:MovieClip ;
		
		//關閉的按鈕
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="imageCloseBtn")]
		private var CloseBtn:Class;
		public var eMc_CloseBtn:* = new CloseBtn();
		
		//copy按鈕
		[Embed(source='assets/Drawboard/DrawingApp.swf' , symbol="imageCopyBtn")]
		private var cpoyBtn:Class;
		public var eMc_cpoyBtn:* = new cpoyBtn();
		
		private var imgSourceName:String = "";
		/**新增個角度 如果需要旋轉就需要**/
		/**useType -> 表示這個物件是被什麼東西使用 依照不同的使用型態改變偵聽**/
		public function DragRotateScaleOnImage(x:Number, y:Number,dataSource:*,angle:Number = 0,useType:String = "")
		{
			this.addChild(dataSource);
			this.addEventListener(TransformGestureEvent.GESTURE_PAN, handleDrag);
			//
			//this.addEventListener(MouseEvent.CLICK,onImgClickToDeleteCloseBtn);
			//
			//圖片連點兩下的TIMER偵聽
			//this.addEventListener(MouseEvent.MOUSE_UP,onDoubleClickImg);
			/**按右鍵 表示顯示XX紐和複製紐**/
			//this.addEventListener(MouseEvent.RIGHT_CLICK,onCloseBtn);
			/*
			mcRightPoint = new MovieClip();
			this.addChild(mcRightPoint);
			mcRightPoint.x = ( this.getChildByName(this.imgSourceName).width );
			*/
			//trace(mcRightPoint.x)
			
			//trace(mcRightPoint.x)
			
			if(angle != 0)
			{
				TweenLite.to(this, 0, {x:this.x, y:this.y,rotation:angle});
			}
			/**設定初始偵聽**/
			setaddEventListener(useType);
		}
		
		private function setaddEventListener(useType:String):void
		{
			/**背景圖片沒有旋轉**/
			if( useType == "backGround" )
			{
				this.addEventListener(TransformGestureEvent.GESTURE_PAN, handleDrag);
				//this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, handleScale);
			}
			
			if( useType == "library" )
			{
				this.addEventListener(TransformGestureEvent.GESTURE_PAN, handleDrag);
				//this.addEventListener(TransformGestureEvent.GESTURE_ROTATE, handleRotate);
				//this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, handleScale);
			}
		}
		
		/**移除所有偵聽**/
		public function removeMyEventListener():void
		{
			//this.removeEventListener(TransformGestureEvent.GESTURE_PAN, handleDrag);
			this.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, handleRotate);
			this.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, handleScale);
		}
		
		/**增加旋轉偵聽***/
		public function setRotateEvent():void
		{
			this.addEventListener(TransformGestureEvent.GESTURE_ROTATE, handleRotate);
		}
		
		/**增加縮放偵聽***/
		public function setZoomEvetn():void
		{
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, handleScale);
		}
		
		/**加入該有的原件(比方 刪除紐 )**/
		public function setFrame(useType:String):void
		{
			if( useType == "library" )
			{
				/**加入刪除紐**/
				setCloseBtn();
			}
		}
		
		/**加入close button**/
		private function setCloseBtn():void
		{
			this.parent .addChild(eMc_CloseBtn);
			eMc_CloseBtn.x = this.x - 15;
			eMc_CloseBtn.y = this.y - 15;
			/**用 "-" 號分開  用name 標示是屬於哪個元件的刪除紐**/
			eMc_CloseBtn.name = "closeBtn-"+this.name;
			/**把刪除的事件寫在parent 由 parent刪除**/
			eMc_CloseBtn.addEventListener(MouseEvent.CLICK, ( this.parent as libearyLayer ).deleteDesignationLibrary);
			setCloseButtonVilible(false);
		}
		
		/**控制關閉按鈕顯示**/
		public function setCloseButtonVilible(bool:Boolean):void
		{
			for( var i:int = 0 ; i< this.parent.numChildren ; i++ )
			{
				if( ( this.parent.getChildAt( i ) .name as String).indexOf("closeBtn") != -1 )
				{
					if( bool )
					{
						this.parent.getChildAt( i ).visible = true;
					}
					else
					{
						this.parent.getChildAt( i ).visible = false;
					}
				}
			}
		}
		
		/**加入copy button**/
		private function setCopyBtn():void
		{
			
		}
		
		/**調整closeBtn的位置**/
		private function changeCloseBtnPosition():void
		{
			eMc_CloseBtn.x = this.x - 15;
			eMc_CloseBtn.y = this.y - 15;
		}
		
		//
		private function onDoubleClickImg(ev:MouseEvent):void
		{
			//所以要偵測 連續點兩下的時間差
			/*
			if( (getTimer() - getClickTimerFirst) < 300 )
			{
				//置中
				this.x = 300;
				this.y = 0;
				
				//角度歸零
				TweenLite.to(this, 0, {x:this.x, y:this.y,rotation:0});
				//放大
				if( this.height < GameData.app_height )
				{
					while ( this.height < GameData.app_height )
					{
						this.width *= 1.01;
						this.height *= 1.01;
					}
				}
				//如果圖片過大 縮小
				else if( this.height > GameData.app_height)
				{
					while ( this.height > GameData.app_height + 50)
					{
						this.width *= 0.99;
						this.height *= 0.99;
					}
				}
				
				//
				eMc_CloseBtn.x = this.x;
				eMc_CloseBtn.y = this.y;
				//修改圖片位置
				var a:Point =new Point();
				a = localToGlobal(new Point(mcRightPoint.x,mcRightPoint.y) );
				eMc_cpoyBtn.x = a.x;
				eMc_cpoyBtn.y = a.y-35;
			}
			*/
			getClickTimerFirst = getTimer();
			// 拿起來後就取消"左移"刪除圖片
			mouseMoveValue = 0;
			mouseMoveBefore = 0;
			recoverTimer.stop();
			//移除EVENT 等到DOWN 再加上去
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveToDeleteImage);
		}
		
		
		//當圖片被點到 有DOWN事件 才處理移動 不然會聯下面的圖片都一起刪除
		private function onMouseDownAddListen(ev:MouseEvent):void
		{
			//抓的到MOUSEMOVE的事件 NICE~ (手勢不會影響)
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveToDeleteImage);
			//抓的到MOUSEUP 
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUpToStopMoveDel);
				
			//計時器開始
			recoverTimer.start();
			recoverTimer.addEventListener(TimerEvent.TIMER, timerToRecove);
		}
		
		//
		//確認跑TIMER 開始了沒
		private function timerToCheckStart(ev:TimerEvent):void
		{
			
			//加入偵聽 DOWN 使用於圖片開始偵測移動
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownAddListen);
		}
		
		private function timerToRecove(ev:TimerEvent):void
		{
			mouseMoveValue = 0;
			mouseMoveBefore = 0;
		}
		
		// 拿起來後就取消"左移"刪除圖片
		private function onMouseUpToStopMoveDel(ev:MouseEvent):void
		{
			mouseMoveValue = 0;
			mouseMoveBefore = 0;
			recoverTimer.stop();
			//移除EVENT 等到DOWN 再加上去
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveToDeleteImage);
			//抓的到MOUSEUP 
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpToStopMoveDel);
		}
		
		//判斷快速"往左邊移動" 刪除該圖片 
		//規則1 : 快速往左移 (0.5秒內偏移量高於定值) 就進行刪除
		//規則2: 手指拿起來之前 偏移量高於定值 
		private function onMouseMoveToDeleteImage(ev:MouseEvent):void
		{
			recoverTimer.start();
			if(mouseMoveBefore != 0)
			{
				//表示往左
				if( mouseMoveBefore - ev.stageX > 0)
				{
					mouseMoveValue = mouseMoveBefore - ev.stageX;
					if( mouseMoveValue >= mouseMoveCheckValue )
					{
						//確定移除 就不用在跑MOVE
						this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveToDeleteImage);
						//進行刪除圖片
						//trace(this.parent .name)
						//刪除FUNC
						/*
						GameData.deleteImageHandle(this.name,this.parent as MovieClip);
						//
						//刪除自己的XX
						GameData.deleteImageCloseBtn(this.parent as MovieClip);
						//清空 表示場上沒有任何的 XX
						GameData.deleteTargetName = "";
						*/
					}
				}
			}
			else
			{
				mouseMoveBefore = ev.stageX;
			}
		}
		
		//移除自己的CLOSE_BTN 只有在最上層的才會有刪除按鈕其餘的會刪除
		public function removeCloseBtn():void
		{
			if(eMc_CloseBtn)
			{
				//trace( GameData.deleteTargetName ) //dragImg
				/*
				if(this.name == GameData.deleteTargetName)
				{
					//trace("aaaaa")
				}
				*/
				this.parent .removeChild(eMc_CloseBtn);
				this.parent .removeEventListener(MouseEvent.CLICK,onImgClickToDeleteCloseBtn);
			}
			if(this.eMc_cpoyBtn)
			{
				this.parent .removeChild(eMc_cpoyBtn);
				this.parent .removeEventListener(MouseEvent.CLICK,onImgClickToDeleteCloseBtn);
			}
		}
		
		
		
		//顯示 XX
		private function onCloseBtn(ev:MouseEvent):void
		{
			/*
			//取消圖片的XX (上一張的 如果有的話)
			GameData.deleteImageCloseBtn(this.parent as MovieClip);
			
			//把圖片移到最上面
			GameData.swapImageToFirst(this.name,this.parent as MovieClip);
			
			//設定圖片NAME 表示有圖被長按
			GameData.deleteTargetName = this.name;
			*/
			
			//應該要先顯示XX
//			eMc_CloseBtn.width = 100;
//			eMc_CloseBtn.height = 100;
//			
			//顯示COPY
			//this.eMc_cpoyBtn .width = 30;
			
			//
			this.parent .addChild(eMc_CloseBtn);
			eMc_CloseBtn.x = this.x - 15;
			eMc_CloseBtn.y = this.y - 15;
			
			//
			/*
			mcRightPoint.graphics.lineStyle(2);
			mcRightPoint.graphics.beginFill(0xFFFFEE);
			mcRightPoint.graphics.moveTo(0,0);
			mcRightPoint.graphics.lineTo(10,0);
			mcRightPoint.graphics.lineTo(10,10);
			mcRightPoint.graphics.lineTo(0,10);
			mcRightPoint.graphics.lineTo(0,0);
			*/
			//
			//trace( mcRightPoint.x)
			//trace( mcRightPoint.y)
			
			var a:Point =new Point();
			a = localToGlobal(new Point(mcRightPoint.x,mcRightPoint.y) );
	
			//trace( a.x)
			//trace(a.y)
			//trace(this.width)
			//trace(a.x - this.width)
			//trace(a.x - (a.x - this.width)) // 662
			//trace(  this.width -( (a.x - this.width))   )
			//trace(this.x)
			
			//X 要扣掉顯示畫面與左方邊界的距離
			eMc_cpoyBtn.x = a.x - (a.x - this.width) + this.x - 15;
			eMc_cpoyBtn.y = a.y - 57;
			//eMc_cpoyBtn.x = 0 ;
			//eMc_cpoyBtn.y = a.y-35;
			//trace(eMc_cpoyBtn.x)
			
			this.parent. addChild(eMc_cpoyBtn);
			//
			//複製圖片
			//重新LOAD一張圖片 位置在現在這張圖片的右方 
			//角度就已目前的角度 繼續擺放
			eMc_cpoyBtn.addEventListener(MouseEvent.CLICK,onCopyImg);
			//
			eMc_CloseBtn.addEventListener(MouseEvent.CLICK,onCloseImg);
			//點下右鍵 就歸零 表示會從你點下的那張開始COPY
			imgCopyCount = 0;
			//
			/*
			GameData.nextCopyX = 0;
			GameData.nextCopyY = 0;
			*/
		}
		
		
		//複製圖片
		private function onCopyImg(ev:MouseEvent):void
		{
			
			//發送一個自訂的EVENT出去
//			var myEevent:MyEventDispatchImgName = new MyEventDispatchImgName(MyEventDispatchImgName.CUSTOM_EVENT);
//			myEevent.imgPath = this.strImgPath;
//			/**圖片的資訊*/
//			var a:Point = new Point();
//			a = localToGlobal(new Point(mcRightPoint.x,mcRightPoint.y) );
//			myEevent.imgX = a.x;
//			myEevent.imgY = a.y - 35;
//			myEevent.imgX = a.x - (a.x - this.width) + this.x - 15;
//			myEevent.imgY = a.y - 57;
//			myEevent.imgCopyAngle = this.rotation;
//			//傳送圖片真正的大小 被縮放過的
//			myEevent.imgWidth = this.getChildByName(imgSourceName).width * this.scaleX;
//			myEevent.imgHeight = this.getChildByName(imgSourceName).height * this.scaleY;
//			myEevent.imgCopyCount = (imgCopyCount++);
//			myEevent.imgCopyrootName = this.parent.parent.parent.parent.parent.parent.parent.parent.name;
			
//			trace(this.parent.parent.parent.parent) // [object AirDrawBoardClass]
//			trace(this.parent.parent.parent.parent.parent)
//			//trace(this.parent.parent.parent.parent.parent.parent.parent.parent) // teachBoardInAir5.WindowedApplicationSkin7.Group8.contentGroup.sss.abd
//			trace(this.parent.parent.parent.parent.parent.parent.parent.parent.name) //abd
			//trace(this.parent.parent) //teachBoardInAir0.WindowedApplicationSkin2.Group3.contentGroup.sss.abd.SkinnableContainerSkin12.contentGroup.compTeachBoard69.appImgShowSV.instance320.AirDrawBoardClass_drarBoard146
			//trace(this.parent) // [object MovieClip]
			//this.parent.parent.parent.dispatchEvent(myEevent);
//			trace("a");
//			
//			var a:Event = new Event("copyTheImage",true,true);
			
			//表示PPT
			/*
			if( this.parent.parent.parent.parent.parent.parent.parent.parent.name == "abd" )
			{
				
			}
			*/
//			this.dispatchEvent( myEevent );
		}
		
		//取消XX (會觸發這事件 表示她有XX 沒有XX的不會聽到 )
		private function onImgClickToDeleteCloseBtn(ev:MouseEvent):void
		{
//			//刪除自己的XX
//			GameData.deleteImageCloseBtn(this.parent as MovieClip);
//				
//			//清空 表示場上沒有任何的 XX
//			GameData.deleteTargetName = "";
		}
		
		//刪除IMG
		private function onCloseImg(ev:MouseEvent):void
		{
			//刪除 TIMER 
			if(recoverTimer)
			{
				recoverTimer.stop();
				recoverTimer.removeEventListener(TimerEvent.TIMER, timerToRecove);
				recoverTimer = null;
			}
			
			//刪除FUNC
//			GameData.deleteImageHandle(this.name,this.parent as MovieClip);
//			//
//			//刪除自己的XX
//			GameData.deleteImageCloseBtn(this.parent as MovieClip);
//			
//			//清空 表示場上沒有任何的 XX
//			GameData.deleteTargetName = "";
		}
		
		//縮放
		private function handleScale(e:TransformGestureEvent):void 
		{
			var p:Point  = this.localToGlobal(new Point(e.localX, e.localY));
			p = parent.globalToLocal(p);
			
			var m:Matrix = this.transform.matrix;
			m.translate( -p.x, -p.y);
			m.scale(e.scaleX, e.scaleY);
			m.translate(p.x, p.y);
			this.transform.matrix = m;
			
			if (this.scaleX > maxScale) 
			{
				m = this.transform.matrix;
				m.translate( -p.x, -p.y);
				m.scale(maxScale/this.scaleX, maxScale/this.scaleY);
				m.translate(p.x, p.y);
				this.transform.matrix = m;
			}
			else if (this.scaleX < minScale) 
			{
				m = this.transform.matrix;
				m.translate( -p.x, -p.y);
				m.scale(minScale/this.scaleX, minScale/this.scaleY);
				m.translate(p.x, p.y);
				this.transform.matrix = m;
			}
			
			changeCloseBtnPosition();
		}
		
		//旋轉
		private function handleRotate(e:TransformGestureEvent):void 
		{
			var p:Point  = this.localToGlobal(new Point(e.localX, e.localY));
			p = parent.globalToLocal(p);
			var m:Matrix = this.transform.matrix;
			m.translate(-p.x, -p.y);
			m.rotate(e.rotation * (Math.PI / 180));
			m.translate(p.x, p.y);
			this.transform.matrix = m;
			
			changeCloseBtnPosition();
		}
		
		//移動
		private function handleDrag(e:TransformGestureEvent):void 
		{
			this.x += e.offsetX;
			this.y += e.offsetY;
			
			changeCloseBtnPosition();
		}
		/*
		private function handleDown(e:TuioTouchEvent):void 
		{
			if (curID == -1) 
			{
				stage.setChildIndex(this,stage.numChildren - 1);
				this.curID = e.tuioContainer.sessionID;
				stage.addEventListener(TuioTouchEvent.TOUCH_UP, handleUp);
			}
		}
		
		private function handleUp(e:TuioTouchEvent):void 
		{
			if(e.tuioContainer.sessionID == this.curID)
			{
				this.curID = -1;
				stage.removeEventListener(TuioTouchEvent.TOUCH_UP, handleUp);
			}
		}
		*/
	}
}