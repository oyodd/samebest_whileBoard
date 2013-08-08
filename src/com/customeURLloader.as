package com
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class customeURLloader extends URLLoader
	{
		public var index:int;
		
		public function customeURLloader(index:int=0)
		{
			//super(request);
			this.index = index;
		}
	}
}