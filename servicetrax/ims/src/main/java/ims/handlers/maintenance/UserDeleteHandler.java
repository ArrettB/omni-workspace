package ims.handlers.maintenance;

import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;


public class UserDeleteHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("UserDeleteHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("UserDeleteHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{

		boolean result = true;
		ConnectionWrapper conn = null;
		Diagnostics.debug2("UserDeleteHandler.handleEnvironment()");

		try
		{
			conn = (ConnectionWrapper)ic.getResource("SQLServer");
			conn.setAutoCommit(false);

			String delUserID = ic.getParameter("user_id");
			String currentUserID = ic.getSessionDatum("user_id").toString();

			//change the users active flag
			StringBuffer update = new StringBuffer();
			update.append("UPDATE users ");
			update.append("SET active_flag = 'N' ");
			update.append(", date_modified = GetDate() ");
			update.append(", modified_by = ").append(currentUserID);
			update.append(" WHERE user_id = ").append(delUserID);
			conn.updateExactlyEx(update, 1);

			//Remove any unnecessary rows in user_roles
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM user_roles");
			delete.append(" WHERE user_id = ").append(delUserID);
			conn.updateEx(delete);

			//Remove any unnecessary rows in user_organizations
			delete = new StringBuffer();
			delete.append("DELETE FROM user_organizations");
			delete.append(" WHERE user_id = ").append(delUserID);
			conn.updateEx(delete);


			conn.commit();

			ic.setHTMLTemplateName(ic.getParameter("nextTemplate"));
		}
		catch (Exception e)
		{
			 ErrorHandler.handleException(ic, e, "Exception in UserDeleteHandler");
		}
		finally
		{
			if (conn != null)
			{
				try
				{
					conn.setAutoCommit(true);
				}
				catch (SQLException ignore){}
				conn.release();
			}
		}
		return result;
	}
}
