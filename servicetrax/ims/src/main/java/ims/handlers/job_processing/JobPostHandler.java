package ims.handlers.job_processing;

import ims.helpers.MapUtil;

import java.util.Map;

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
 * @version $Id: JobPostHandler.java, 10, 4/1/2004 1:46:31 PM, Greg Case$
*/
public class JobPostHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("JobPostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("JobPostHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("JobPostHandler.handleEnvironment()");
		boolean result = true;

		/*
		Note:
		Because this is PostHandler with SmartFormHandler, we do NOT
		catch the exception or release the resource ourselves
		*/

		//make sure that we are actually supposed to be saving.
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		String mode = (String)ic.getParameter("mode");
		if (button != null && button.equals(SmartFormComponent.Save) &&
			mode != null && mode.equalsIgnoreCase(SmartFormComponent.Update) )
		{
			ConnectionWrapper conn = (ConnectionWrapper)ic.getTransientDatum(SmartFormHandler.CONNECTION);

			String currentUserID = ic.getSessionDatum("user_id").toString();
			String jobID = ic.getSessionDatum("job_id").toString();

			InClause userClause = new InClause();
			userClause.add(ic.getParameterValues("jd_user_id"));

			//First delete anything that has not been checked
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM job_distributions ");
			delete.append("WHERE job_id = ").append(jobID);
			delete.append(" AND ").append(userClause.getNotInClause("user_id"));
			delete.append(" AND sch_resource_id is null");
			Diagnostics.debug("Deleting from job_distributions, statement = " + delete);
			conn.updateEx(delete);

			//and now create everything that has been checked,
			StringBuffer insert = new StringBuffer();
			insert.append("INSERT INTO job_distributions (job_id, user_id, created_by, date_created)");
			insert.append(" SELECT ").append(jobID);
			insert.append(", u.user_id ");
			insert.append(", ").append(currentUserID);
			insert.append(", ").append(conn.now());
			insert.append(" FROM users u");
			insert.append(" WHERE ").append(userClause.getInClause("u.user_id"));
			insert.append(" AND u.user_id NOT IN (SELECT user_id FROM job_distributions WHERE job_id = ").append(jobID).append(")");

			Diagnostics.debug("Inserting into job_distributions, statement = " + insert);
			conn.updateEx(insert);

			String new_status = ic.getParameter("new_status");
			//handle case of closing or opening requisition
			if( result && StringUtil.hasAValue(new_status) )
				result = ic.dispatchHandler("ims.handlers.job_processing.StatusHandler");

			// distribute the update to the requests table for the CSC_WO_FIELD_FLAG.
			String query = "UPDATE requests SET csc_wo_field_flag = " + conn.toSQLString(ic.getParameter("csc_wo_field_flag"))
			+ " FROM request_max_version_v v, jobs j"
			+ " WHERE requests.request_id = v.request_id"
			+ " AND v.project_id = j.project_id"
			+ " AND j.job_id = " + jobID;
			conn.updateEx(query);
			
			// Set the short or long view depending on whether the scheduler should see this.
			// The scheduler will see it if it is long view.
			Map<String, String> service_types = MapUtil.getTypeMap(conn, "service_type");
			boolean viewScheduleFlag = StringUtil.toBoolean(ic.getParameter("view_schedule_flag"));
			String serviceType = "short_view";
			if (viewScheduleFlag)
				serviceType = "long_view";
			String service_type_id = (String)service_types.get(serviceType);

			query = "UPDATE services"
				+ " SET service_type_id = ?"
				+ " WHERE job_id = ?";
			String[] params = new String[] {service_type_id, jobID}; 
			long updated = conn.update(query, params);
			Diagnostics.debug("Set " + updated + " services entries to " + serviceType + " for job_id = " + jobID);
		}
		Diagnostics.trace("JobPostHandler.handleEnvironment("+result+")");
		
		return result;
	}
}
