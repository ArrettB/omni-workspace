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

public class UserCustomerEndUserHandler extends BaseHandler
{

	public void destroy()
	{

	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception {

		Diagnostics.debug("UserCustomerEndUserHandler.handleEnvironment()");
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
				result = handleSave(ic, conn);
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

	private boolean handleSave(InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		boolean result = true;
		try
		{
			String userCustomerId = ic.getParameter("user_customer_id");
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
			MergeTableUtil.updateJoinTable("user_customer_id", "customer_id", userCustomerId, customerIDList, "user_customer_end_users", "customers", conn);
			ic.setHTMLTemplateName("close_refresh_parent.html");

		}
		catch (Exception e)
		{
			ic.setHTMLTemplateName("mnt/user_customer_end_users.html");
			ic.setTransientDatum("error", "An unknown error occured: " + e.getMessage());

		}

		return result;
	}

	public void setUpHandler() throws Exception {

	}
}
