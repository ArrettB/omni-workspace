package ims.handlers.job_processing;

import ims.handlers.proj.NewContactHandler;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * This class is responsible for maintaining the job-user mapping for PDA distribution
 * 
 * @version $Id: ContactPostHandler, 1, 5/7/2004 2:09:07 PM, Lee A. Gunderson$
*/
public class ContactPostHandler extends BaseHandler {
	
	public void setUpHandler()
	{ 
		Diagnostics.debug2("ContactPostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("ContactPostHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("ContactPostHandler.handleEnvironment()");
		boolean result = true;

		/*
		Note:
		Because this is PostHandler with SmartFormHandler, we do NOT
		catch the exception or release the resource ourselves
		*/

		//make sure that we are actually supposed to be saving.
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		String mode = ic.getParameter(SmartFormComponent.MODE);
		String isJobLocatioNCotnact = ic.getParameter("is_job_location_contact");
		String contact_id = (String)ic.getParameter("contact_id");
		if( !StringUtil.hasAValue(contact_id) )
			contact_id = (String)ic.getTransientDatum("contact_id");

		if( StringUtil.hasAValue(button) && button.equals(SmartFormComponent.Save) )
		{  
			ConnectionWrapper conn = (ConnectionWrapper)ic.getTransientDatum(SmartFormHandler.CONNECTION);
			String user_id = ic.getSessionDatum("user_id").toString();
			
			if (StringUtil.hasAValue(isJobLocatioNCotnact) && "Y".equalsIgnoreCase(isJobLocatioNCotnact)) {
				String jobLocationid = ic.getParameter("job_location_id");
				if ("Insert".equalsIgnoreCase(mode) && StringUtil.hasAValue(jobLocationid)) {
					saveJobLocationContact(conn, jobLocationid, contact_id, user_id);
				}
				
			} else {
				InClause type_clause = new InClause();
				type_clause.add(ic.getParameterValues("contact_group_id"));

				//First delete anything that has not been checked
				StringBuffer delete = new StringBuffer();
				delete.append("DELETE FROM contact_groups ");
				delete.append("WHERE contact_id = ").append(contact_id);
				conn.updateEx(delete);

				//and now create everything that has been checked,
				StringBuffer insert = new StringBuffer();
				insert.append("INSERT INTO contact_groups (contact_id, contact_type_id, created_by, date_created)");
				insert.append(" SELECT ").append( conn.toSQLString(contact_id) );
				insert.append(", lookup_id");
				insert.append(", ").append(user_id);
				insert.append(", ").append(conn.now());
				insert.append(" FROM lookups");
				insert.append(" WHERE ").append(type_clause.getInClause("lookup_id"));
				conn.updateEx(insert);
			}
		}
		else if( StringUtil.hasAValue(button) && button.equals(SmartFormComponent.Save) )
		{
			ic.setParameter("contact_id", contact_id);
		}
		return result;
	}
  	
	private void saveJobLocationContact(ConnectionWrapper conn, String jobLocationId, String contactId, String userId) throws SQLException {
		
		PreparedStatement stmt = null;
		
		try {
				stmt = conn.prepareStatement(NewContactHandler.INSERT_JOB_LOCATION_CONTACT);
				
				stmt.setString(1, jobLocationId);
				stmt.setString(2, contactId);
				stmt.setString(3, userId);
				
				stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception saving new job location contact: " + e);				
		} finally {
			if (stmt != null) stmt.close();
		}
	}
}
