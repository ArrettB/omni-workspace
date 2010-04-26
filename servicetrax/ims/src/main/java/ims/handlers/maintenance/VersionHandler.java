package ims.handlers.maintenance;

import ims.Version;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;

/**
 * Handler for putting version information to transient datum
 *
 * @version $Header: VersionHandler.java, 1, 6/28/2007 1:46:41 PM, David Zhao$
 */

public class VersionHandler extends BaseHandler
{
	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		boolean result = true;
		try
		{
			ic.setTransientDatum("version", Version.getFullVersion());
		}
		finally
		{}
		
		return result;
	}
}

