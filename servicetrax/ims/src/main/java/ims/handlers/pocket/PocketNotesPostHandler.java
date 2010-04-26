/*
 * Created on Nov 21, 2003
 * 
 * To change the template for this generated file go to Window - Preferences -
 * Java - Code Generation - Code and Comments
 */
package ims.handlers.pocket;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase
 * 
 * To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Generation - Code and Comments
 */
public class PocketNotesPostHandler extends BaseHandler
{
	private static String statusQuery;
	
	static
	{
		StringBuffer temp = new StringBuffer();
		temp.append("SELECT lookup_id");
		temp.append(" FROM lookups_v");
		temp.append(" WHERE type_code = ").append(StringUtil.toSQLString("workorder_status_type"));
		temp.append(" AND lookup_code = ").append(StringUtil.toSQLString("closed"));
	
		statusQuery = temp.toString();

	}
	
	public void setUpHandler()
	{
		Diagnostics.debug2("PocketNotesPostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("PocketNotesPostHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("PocketNotesPostHandler.handleEnvironment()");
		boolean result = true;

		/*
		 * Note: Because this is PostHandler with SmartFormHandler, we do
		 * NOT catch the exception or release the resource ourselves
		 */
		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
		try
		{

			//make sure that we are actually supposed to be saving.
			String button = ic.getParameter(SmartFormComponent.BUTTON);
			String mode = ic.getParameter(SmartFormComponent.MODE);
			
			if (button != null && button.equals(SmartFormComponent.Save))
			{
				if (mode != null && mode.equalsIgnoreCase(SmartFormComponent.Insert))
				{
					String reqComplete = ic.getParameter("req_complete");
					Diagnostics.debug("req_complete = " + reqComplete);

					if (StringUtil.toBoolean(reqComplete))
					{	
						Diagnostics.debug("Setting request status to complete");
						
						String serviceID = ic.getParameter("service_id");
						String closedStatusID = conn.queryEx(statusQuery);
						
						StringBuffer update = new StringBuffer();
						update.append("UPDATE requests");
						update.append(" SET request_status_type_id = ").append(closedStatusID);
						update.append(" FROM requests r, services s");
						update.append(" WHERE r.request_id = s.request_id");
						update.append(" AND s.service_id = ").append(serviceID);
		
						conn.updateEx(update);
					}

				}
			}
			else if (button != null && button.equals(SmartFormComponent.Cancel))
			{
			}
		}
		catch (Exception e)
		{
			Diagnostics.debug("Exception in PocketNotesPostHandler.handleEnvironment()", e);
		}

		Diagnostics.debug2("PocketNotesPostHandler.handleEnvironment() is returning " + result);
		return result;

	}
}
