package ims.handlers.maintenance;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.util.diagnostics.Diagnostics;


public class ResEstPostHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("ResEstPostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("ResEstPostHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("ResEstPostHandler.handleEnvironment()");
		boolean result = true;

		/*
		Note:
		Because this is PostHandler with SmartFormHandler, we do NOT
		catch the exception or release the resource ourselves
		*/

		//remember start_date for subsequent resource estimates entry, saves time
		String start_date = ic.getParameter("start_date");
		if( start_date != null )
		{
			ic.setParameter("est_start_date", start_date);
		}
		return result;
	}
}
