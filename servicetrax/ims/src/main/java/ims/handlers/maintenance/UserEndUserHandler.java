package ims.handlers.maintenance;

import ims.helpers.MergeTableUtil;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class UserEndUserHandler extends BaseHandler
{

	public void destroy()
	{

	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception {

		Diagnostics.debug("UserEndUserHandler.handleEnvironment()");
		boolean result = true;
		boolean prePostHandler = false;
		ConnectionWrapper conn = null;
		String button = null;
		try
		{
			button = ic.getRequiredParameter(SmartFormComponent.BUTTON);
			conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
			if (conn == null)
			{
				conn = (ConnectionWrapper) ic.getResource();
				prePostHandler = false;
			}
			else
			{
				prePostHandler = true;
			}

			if (button.equalsIgnoreCase("save"))
			{
				result = handleEndUserSave(ic, conn);
			}

		}
		catch (Exception e)
		{
			SmartFormHandler.handleException(ic, e, conn, button);
			result = false;
		}
		finally
		{
			if (!prePostHandler && conn != null)
				conn.release();
		}

		return result;

	}

	private boolean handleEndUserSave(InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		boolean result = true;
		try
		{
			String customerIDs = ic.getParameter("customer_id_list");
			String userID = ic.getRequiredParameter("user_id");
			List customerIDList = null;
			if (customerIDs != null && customerIDs.length() > 0)
			{
				customerIDList = StringUtil.stringToVector(customerIDs);
			}
			else
			{
				customerIDList = new ArrayList();
			}
			MergeTableUtil.updateJoinTable("user_id", "customer_id", userID, customerIDList, "user_end_user", "customers", conn);
			ic.setHTMLTemplateName("close_refresh_parent.html");

		}
		catch (Exception e)
		{
			ic.setHTMLTemplateName("mnt/user_end_user.html");
			ic.setTransientDatum("error", "An unknown error occured: " + e.getMessage());

		}

		return result;
	}

	public void setUpHandler() throws Exception {

	}
}
