package ims.handlers.nav;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class UpdateSearchDisplayHandler extends BaseHandler
{

	public void setUpHandler()
	{
		Diagnostics.debug2("UpdateSearchDisplayHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("UpdateSearchDisplayHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("UpdateSearchDisplayHandler.handleEnvironment()");
		boolean result = true;
		try
		{
			ic.setSessionDatum("display_table", ic.getParameter("display_table"));
			ic.setHTMLTemplateName("nav/search_results.html");
		}
		catch(Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in UpdateSearchDisplayHandler");
		}
		finally
		{
		}
		return result;
	}


}
