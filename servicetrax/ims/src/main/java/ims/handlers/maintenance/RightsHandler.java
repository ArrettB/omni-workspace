package ims.handlers.maintenance;

import ims.dataobjects.User;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * Handler for setting the user rights session datum
 *
 * @version $Header: RightsHandler.java, 6, 4/1/2004 1:46:41 PM, Greg Case$
 */

public class RightsHandler extends BaseHandler
{
	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = false;
		try
		{
			Diagnostics.trace("RightsHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();
			User user = (User)ic.getSessionDatum("user");
			user.fetchRights(conn);
			ic.setSessionDatum("rights", user.getRights());
			result = true;
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Problem Setting Rights");
		}
		finally
		{
			if (conn != null) conn.release();
		}

		return result;
	}
}

