package ims.handlers.maintenance;

import ims.dataobjects.User;

import java.util.Enumeration;
import java.util.StringTokenizer;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;

/**
 * Updates the asset rights for roles in the database
 *
 * @version $Header: HandleRoleDetail.java, 9, 1/27/2006 1:58:08 PM, Blake Von Haden$
 */
public class HandleRoleDetail extends BaseHandler
{
	public void setUpHandler(){};
	public void destroy(){};

	public boolean handleEnvironment(InvocationContext ic)
	{
		boolean bRet = true;
		ConnectionWrapper conn = null;
		String button = null;
		try
		{
			Diagnostics.debug("Entered HandleRoleDetail()");

			conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
			button = ic.getParameter(SmartFormComponent.BUTTON);

			if ( button == null )
			{
				bRet = false;
				ErrorHandler.handleError(ic, "Problem with Role Detail.", "Button not specified");
			}
			else if (button.equals(SmartFormComponent.Save))
			{
				handleSave(ic, conn);
			}

		}
		catch  (Exception e)
		{
		  	bRet = false;
		  	ErrorHandler.handleException(ic, e, "Problems in role information. Button: " + button);
		}
		finally
		{
			//because this is a Pre/PostHandler, we do NOT release the connection

			Diagnostics.debug("Exiting HandleRoleDetail()");
		}
		return bRet;

	}

	/**
	 *  Delete all rights for the role and then insert updated rights for the role.
	 */
	private void handleSave(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		String role_id = ic.getRequiredParameter("role_id");
		Diagnostics.trace("HandleRoleDetail.handleSave() for role_id='"+role_id+"'");
		User user = (User)ic.getRequiredSessionDatum("user");
		String user_id = ""+user.userID;
		String query = "DELETE FROM role_function_rights WHERE role_id = " + conn.toSQLString(role_id);
		conn.updateEx(query);
		Enumeration parameters = ic.getParameterKeys();
		while (parameters.hasMoreElements())
		{
			String name = (String)parameters.nextElement();

			if (name.startsWith("right"))
			{

				StringTokenizer st = new StringTokenizer(name,"_");
				st.nextToken();  // Drop "right"

				query = "INSERT INTO role_function_rights (function_id, right_type_id, role_id, created_by, date_created) values ("
				      + conn.toSQLString(st.nextToken()) + ", "
				      + conn.toSQLString(st.nextToken()) + ", "
				      + conn.toSQLString(role_id) + ", "
				      + conn.toSQLString(user_id) + ", "
				      + conn.now()
				      + ")";
				conn.updateEx(query);
			}
		}

		// refresh the rights for this user
		user.fetchRights(conn);
		
		ic.setSessionDatum("rights", user.getRights());
	}
}
