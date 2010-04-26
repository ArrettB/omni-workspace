package ims.handlers.job_processing;

import ims.helpers.IMSUtil;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * @version $Id: StatusHandler.java, 4, 1/26/2006 4:43:09 PM, Blake Von Haden$
 */
public class StatusHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.trace("StatusHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.trace("StatusHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("StatusHandler.handleEnvironment()");
		boolean result = true;

		String object_type = ic.getParameter("object_type");
		String new_status = ic.getParameter("new_status");
		String[] object_id = ic.getParameterValues("object_id");

		ConnectionWrapper conn = (ConnectionWrapper)ic.getTransientDatum(SmartFormHandler.CONNECTION);
		boolean close_connection = false;
		if( conn == null )
		{
			conn = (ConnectionWrapper)ic.getResource();
			close_connection = true;
		}
			
		try
		{
			result = IMSUtil.changeStatus(ic, conn, object_type, new_status, object_id);
			String next_template = ic.getParameter("next_template");
			String prev_template = ic.getParameter("prev_template");
			if( result )
			{
				if( next_template == null )
					ic.setHTMLTemplateName( prev_template );
				else
					ic.setHTMLTemplateName( next_template );
			}
			else if( prev_template == null )
				ic.setHTMLTemplateName( next_template );
			else
				ic.setHTMLTemplateName( prev_template );
		}
		catch(Exception e)
		{
			Diagnostics.error("StatusHandler.changeStatus() Failed to change status review error message below:\n"+e.toString());
			result = false;
		}
		finally
		{
			if( conn != null && close_connection )
				conn.release();
		}

		Diagnostics.debug2("StatusHandler.handleEnvironment() result = "+result);

		return result;
	}
	

}
