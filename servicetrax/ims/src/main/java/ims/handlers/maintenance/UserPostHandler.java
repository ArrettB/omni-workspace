package ims.handlers.maintenance;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;


public class UserPostHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("UserPostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("UserPostHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("UserPostHandler.handleEnvironment()");
		boolean result = true;

		/*
		Note:
		Because this is PostHandler with SmartFormHandler, we do NOT
		catch the exception or release the resource ourselves
		*/

		//make sure that we are actually supposed to be saving.
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		if (button != null && button.equals(SmartFormComponent.Save))
		{
			ConnectionWrapper conn = (ConnectionWrapper)ic.getTransientDatum(SmartFormHandler.CONNECTION);

			String userID = ic.getParameter("user_id");

			InClause roleClause = new InClause();
			roleClause.add(ic.getParameterValues("role_id"));


			InClause orgClause = new InClause();
			orgClause.add(ic.getParameterValues("org_id"));

			//First delete anything that has not been checked
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM user_roles ");
			delete.append("WHERE user_id = ").append(userID);
			delete.append(" AND ").append(roleClause.getNotInClause("role_id"));

			conn.updateEx(delete);

			//and now create everything that has been checked,
			StringBuffer insert = new StringBuffer();
			insert.append("INSERT INTO user_roles (user_id, role_id, created_by, date_created)");
			insert.append(" SELECT ").append(userID);
			insert.append(", r.role_id ");
			insert.append(", ").append(ic.getSessionDatum("user_id"));
			insert.append(", ").append(conn.now());
			insert.append(" FROM roles r");
			insert.append(" WHERE ").append(roleClause.getInClause("r.role_id"));
			insert.append(" AND r.role_id NOT IN (SELECT role_id FROM user_roles WHERE user_id = ").append(userID).append(")");

			conn.updateEx(insert);

			//now, do the same thing for user_organizations

			//First delete anything that has not been checked
			delete = new StringBuffer();
			delete.append("DELETE FROM user_organizations ");
			delete.append("WHERE user_id = ").append(userID);
			delete.append(" AND ").append(orgClause.getNotInClause("organization_id"));

			conn.updateEx(delete);

			//and now create everything that has been checked,
			insert = new StringBuffer();
			insert.append("INSERT INTO user_organizations (user_id, organization_id, created_by, date_created)");
			insert.append(" SELECT ").append(userID);
			insert.append(", o.organization_id ");
			insert.append(", ").append(ic.getSessionDatum("user_id"));
			insert.append(", ").append(conn.now());
			insert.append(" FROM organizations o");
			insert.append(" WHERE ").append(orgClause.getInClause("o.organization_id"));
			insert.append(" AND o.organization_id NOT IN (SELECT organization_id FROM user_organizations WHERE user_id = ").append(userID).append(")");


			conn.updateEx(insert);
		}

		return result;

	}
}
