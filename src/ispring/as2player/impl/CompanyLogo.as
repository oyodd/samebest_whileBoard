
package ispring.as2player.impl
{
	import ispring.as2player.ICompanyLogo;
	
	public class CompanyLogo implements ICompanyLogo
	{
		private var m_obj:Object;
		
		public function CompanyLogo(obj:Object)
		{
			m_obj = obj;
		}
		
		public function get hyperlinkUrl():String
		{
			return m_obj.hyperlinkUrl;
		}
		
		public function get hyperlinkTarget():String
		{
			return m_obj.hyperlinkTarget;
		}
	}
}
