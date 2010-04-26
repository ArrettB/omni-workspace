package ims.handlers.maintenance;

import java.util.Hashtable;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * Handler for setting the user rights session datum
 *
 * @version $Header: LookupsHandler.java, 2, 3/6/2003 11:05:04 AM, Chad Ryan$
 */

public class LookupsHandler extends BaseHandler
{
	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = false;
		try
		{
			Diagnostics.trace("LookupsHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();
			Hashtable lookups = (Hashtable)ic.getAppGlobalDatum("lookups");
			if( lookups == null )
			{//create lookups
				Diagnostics.trace("LookupsHandler.handleEnvironment() Reloading Lookups");
			}
			result = true;
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e, "Problem Creating Lookups Hashtable for AppGlobalDatum");
		}
		finally
		{
			if (conn != null) conn.release();
		}

		return result;
	}
}

