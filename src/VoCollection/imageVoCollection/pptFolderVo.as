package VoCollection.imageVoCollection
{
	/**每個ppt的folderVo 存放每個folder*/
	/**資料在LOAE完之後才會進來**/
	public class pptFolderVo
	{
		/**folder name*/
		public var folderName:String = "";
		/**folder path*/
		public var folderPath:String = "";
		/**folder chinese path**/
		public var folderChinesePath:String = "";
		/**folder page Num**/
		/**folder chinese name**/
		public var folderChineseName:String = "";
		/**folder Front cover(封面) content( bitMap )**/
		/**folder background content ( 黃色資料夾  )**/
		/**folder order number**/
		/**type**/
		public var theVoType:String = "pptFolder";
		
		public function pptFolderVo()
		{
		}
	}
}