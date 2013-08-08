package com
{
	import flash.events.Event;
	
	public class LoaderEvent extends Event
	{
		public static const LOADER_COMPLETE :String = "loaderComplete";
		public static const LOADER_PROGRESS :String = "loaderProgress";
		public static const LOADER_ERROR :String = "loaderError";
		
		public function LoaderEvent(p_type:String , p_percentage:Number = 0)
		{
			super( p_type );
		}
	}
}