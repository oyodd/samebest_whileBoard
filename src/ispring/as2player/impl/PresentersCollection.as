
package ispring.as2player.impl
{
	import ispring.as2player.IPresentersCollection;
	import ispring.as2player.IPresenterInfo;
	
	public class PresentersCollection implements IPresentersCollection
	{
		private var m_obj:Object;
		private var m_presenters:Array;
		
		public function PresentersCollection(obj:Object)
		{
			m_obj = obj;
			m_presenters = new Array();
		}
		
		public function get count():Number
		{
			return m_obj.count;
		}
		
		public function getPresenter(index:Number):IPresenterInfo
		{
			if (!m_presenters[index] && m_obj.presenters && m_obj.presenters[index])
			{
				m_presenters[index] = new PresenterInfo(m_obj.presenters[index]);
			}
			return m_presenters[index];
		}
	}
}
