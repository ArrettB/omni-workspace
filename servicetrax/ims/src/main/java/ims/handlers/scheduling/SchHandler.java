package ims.handlers.scheduling;

import ims.helpers.IMSUtil;
import ims.helpers.MapUtil;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * SchHandler validates job info, in particular job_no and quote_no
 * if hit the Reload Item Rates button, then reload item rates and redisplay without saving
 *	Note: if orig_quote_id status is cancelled, do not change it to printed.
 */
public class SchHandler extends BaseHandler
{
	public void setUpHandler(){}

	public void destroy(){}

	private void showMessageWindow(InvocationContext ic, String message)
	{
		Diagnostics.debug2("SchHandler.showMessageWindow(), message = " + message);
		ic.setHTMLTemplateName("sch/message.html");
		ic.setTransientDatum("SchedulingMessage", message);
	}


  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("SchHandler.handleEnvironment()");
		boolean bRet = false;
		ConnectionWrapper conn = null;

		String action = ic.getRequiredParameter("sch_action");

		try
		{
			conn = (ConnectionWrapper)ic.getResource();
			conn.setAutoCommit(false);
			if( action == null )
			{
				Diagnostics.error("Missing required parameter 'action' in SchHandler.handleEnvironment()");
				SmartFormHandler.addSmartFormError(ic, "SchHandler.handleEnvironment() Missing required parameter 'sch_action'.");
			}
			else if( action.equalsIgnoreCase("redisplay") )
			{
				//do nothing, equivalent to a bRet=false;
			}
			else if( action.equalsIgnoreCase("add") || action.equalsIgnoreCase("remove")
					|| action.equalsIgnoreCase("update"))
			{
				bRet = this.editSchResource(ic, conn, action);
				if( bRet )
				{
					ic.setParameter("reload_frames","true"); //refreshes windows
					ic.setHTMLTemplateName("sch/sch_res_edit.html");
				}
			}
			else if( action.equalsIgnoreCase("watch") )
			{
				bRet = this.updateWatchFlag(ic, conn, action);
			//	ic.setParameter("reload_frames","true"); //refreshes windows
				bRet = false; //always want to refresh
			}
			else if( action.equalsIgnoreCase("fully_schedule") )
			{
				bRet = this.fullySchedule(ic, conn, action);
				bRet = false; //always want to refresh
			}
			else if( action.equalsIgnoreCase("add_vacation") )
			{
				bRet = this.handleVacation(ic, conn, action);
				if( bRet )
				{//successfully added
					ic.setHTMLTemplateName("sch/sch_vacation.html");
				}
			}
			else if( action.equalsIgnoreCase("remove_vacation") )
			{
				bRet = this.handleVacation(ic, conn, action);
				if( bRet )
				{//successly removed
					ic.setParameter("sch_resource_id", ""); //so mode goes back to insert
					ic.setHTMLTemplateName("sch/sch_vacation.html");
				}
			}
			else if( action.equalsIgnoreCase("add_weekend") || action.equalsIgnoreCase("remove_weekend"))
			{
				bRet = this.handleWeekend(ic, conn, action);
				if( bRet )
				{//successfully added or removed
					ic.setParameter("reload_frames","true"); //refreshes windows
					ic.setHTMLTemplateName("sch/sch_weekend.html");
				}
			}
			else
			{
				Diagnostics.error("SchHandler.handleEnvironment() Unrecognized action='"+action+"'");
				SmartFormHandler.addSmartFormError(ic, "Unrecognized action='"+action+"'");
			}
			conn.commit();
		}
		catch (Exception e)
		{
			conn.rollback();
			Diagnostics.error("Exception in SchHandler.handleEnviroment()" ,e);
			SmartFormHandler.addSmartFormError(ic, "SchHandler.handleEnvironment() Failed performing the action = '"+action+"'.");
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

		//reverse bRet, if success, then expected a new template to be set and hence SmartForm should not run: so return false.
		//if a problem, then redisplay SmartForm with an ERROR message so return true;
		if( bRet == false)
			bRet = true; //ERROR so SmartForm should run
		else
			bRet = false;  //do not display SmartForm

		return bRet;
	}

  /**
	*	Update table jobs or requisition, and sch_resources.
	*/

	public boolean fullySchedule(InvocationContext ic, ConnectionWrapper conn, String action) throws Exception
	{
		Diagnostics.trace("SchHandler.fullySchedule()");
		boolean result = false;

		String job_id = (String)ic.getRequiredSessionDatum("job_id");
		String service_id = (String)ic.getSessionDatum("service_id");
		String role_code = (String)ic.getRequiredSessionDatum("role_code");
		String new_status = null;

		Map<String, String> job_status_types = MapUtil.getTypeMap(conn,"job_status_type");
		Map<String, String> service_status_types = MapUtil.getTypeMap(conn,"service_status_type");
		if( role_code != null && role_code.equalsIgnoreCase("scheduler") )
		{//
			new_status = job_status_types.get("fully_scheduled");
			if( new_status != null )
			{//found status

				//could set modified_by and modify date too, but I didn't.
		  		String query = "UPDATE jobs set job_status_type_id=? WHERE job_id=?";
			    Diagnostics.debug3("Updating job's status to fully_scheduled for Scheduler.");
				long rows = conn.update(query, new String[] {new_status, job_id});
				if( rows != 1)
				{//failed to update
					conn.rollback();
					Diagnostics.error("SchHandler.fullySchedule() Failed to update job's status where job_id = '"+job_id+"'");
				}
				else
				{//successfully updated job
			   		result = true;
			   		conn.commit();
				}
			}
		}
		if( role_code != null && role_code.equalsIgnoreCase("major_acct_coord") )
		{//
			new_status = service_status_types.get("fully_scheduled");
			if( new_status != null )
			{//found status
		  		String query = "UPDATE services set serv_status_type_id=? WHERE service_id=?";
		  		Diagnostics.debug3("Updating req's status to fully_scheduled for MAC.");
				long rows = conn.update(query, new String[] {new_status, service_id});
				if( rows != 1)
				{//failed to update
					conn.rollback();
					Diagnostics.error("SchHandler.fullySchedule() Failed to update req's status where service_id = '"+service_id+"'");
				}
				else
				{//successfully updated service
			   		result = true;
			   		conn.commit();
				}
			}
		}

		return result;
	}

  /**
	*	Update table jobs or requisition, and sch_resources.
	*/

	public boolean updateWatchFlag(InvocationContext ic, ConnectionWrapper conn, String action) throws Exception
	{
		Diagnostics.trace("SchHandler.updateWatchFlag()");
		boolean result = true;

		String job_id = (String)ic.getRequiredSessionDatum("job_id");
		String service_id = (String)ic.getSessionDatum("service_id");
		String watch_flag = ic.getRequiredParameter("watch_flag");

		if( StringUtil.hasAValue(watch_flag) )
		{
			//update watch flag

			String new_value = null;

			if( watch_flag.equalsIgnoreCase("Y") )
				new_value = "Y";
			else
				new_value = "N";

			if ( StringUtil.hasAValue(service_id) && new_value.equalsIgnoreCase("Y") )
			{
				//begin to watch, at the service level
				conn.updateExactlyEx("UPDATE services SET watch_flag = 'Y' WHERE service_id = " + service_id, 1);
			}
			else if (StringUtil.hasAValue(job_id))
			{
				//update watch at the job level
				conn.updateExactlyEx("UPDATE jobs SET watch_flag = " + StringUtil.toSQLString(new_value) + " WHERE job_id = " + job_id, 1);

				if( new_value.equalsIgnoreCase("N") )
				{
					//also remove watch from all services of that job
					conn.update("UPDATE services SET watch_flag = ? WHERE job_id = ?", new String[]{new_value, job_id});
				}
			}
		}
		return result;
	}


  /**
	*	add new resource to schedule
	*/




	public boolean editSchResource(InvocationContext ic, ConnectionWrapper conn, String action) throws Exception
	{
		Diagnostics.trace("SchHandler.editSchResource()");
		boolean result = false;
		ic.setParameter("reload_frames","false"); //don't update the other windows unless successful.

		String role_code		= (String)ic.getRequiredSessionDatum("role_code");
		String job_type_id 		= (String)ic.getSessionDatum("job_type_id");
		String resource_id 		= ic.getParameter("resource_id");
		String sch_resource_id 	= ic.getParameter("sch_resource_id");
		String weekend_sch_resource_id = ic.getParameter("weekend_sch_resource_id");
		String weekend_flag 		= ic.getParameter("weekend_flag");
		String res_status_type_id = ic.getRequiredParameter("res_status_type_id");
		String reason_type_id 	= ic.getRequiredParameter("reason_type_id");
		String cur_job_id 		= ic.getParameter("job_id");
		String cur_service_id 	= ic.getParameter("service_id");
		String new_job_id 		= ic.getParameter("new_job_id");
		if( action.equalsIgnoreCase("update") )
			new_job_id = cur_job_id;
		String new_service_id 	= ic.getParameter("new_service_id");
		if( action.equalsIgnoreCase("update") )
			new_service_id = cur_service_id;
		String foreman_flag 	= ic.getParameter("foreman_flag");
		String sch_foreman_flag = ic.getParameter("sch_foreman_flag");
		if( StringUtil.hasAValue(sch_resource_id) )
			foreman_flag = sch_foreman_flag;
		boolean send_to_pda = false;
		String send_to_pda_flag = ic.getParameter("send_to_pda_flag");
		if( StringUtil.hasAValue(send_to_pda_flag) && send_to_pda_flag.equalsIgnoreCase("Y"))
			send_to_pda = true;
Diagnostics.debug("send_to_pda_flag = "+send_to_pda_flag);
		String resource_qty = ic.getRequiredParameter("resource_qty");
		String sch_notes = ic.getRequiredParameter("sch_notes");
		String report_to_type_id = ic.getRequiredParameter("report_to_type_id");
		String created_by = (String)ic.getRequiredSessionDatum("user_id");
		StdDate date_created = new StdDate();
		String modified_by = created_by;
		StdDate date_modified = new StdDate();

		//next 3 lines sets the date to redisplay if there is an error
		ic.setTransientDatum("res_start_date", ic.getParameter("res_start_date"));
		ic.setTransientDatum("res_end_date", ic.getParameter("res_end_date"));
		ic.setTransientDatum("res_start_time", ic.getParameter("res_start_time"));

		StdDate res_start_date = null, res_start_time = null, res_end_date = null, res_end_time = null, date_confirmed = null;
		boolean datesGood = true;
		try
		{
			//required, so we auto-ding them
			res_start_date	= new StdDate(ic.getRequiredParameter("res_start_date"));
		}
		catch (ParseException e)
		{
			datesGood = false;
			SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the starting date.");
			ic.setTransientDatum("err@res_start_date", "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
			ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
		}
		try
		{
			//not required, check only if non-blank
			String temp = ic.getParameter("res_start_time"); // changed the name of the field so we only grab the time from the DB
			if (temp != null && temp.length() > 0)
				res_start_time 	= new StdDate(temp);
		}
		catch (ParseException e)
		{
			datesGood = false;
			SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the starting time and date.");
			ic.setTransientDatum("err@res_start_time", "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
			ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
		}

		try
		{
			//not required, check only if non-blank
			String temp = ic.getParameter("res_end_date");
			if (temp != null && temp.length() > 0)
				res_end_date 	= new StdDate(temp);

		}
		catch (ParseException e)
		{
			datesGood = false;
			SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the ending date.");
			ic.setTransientDatum("err@res_end_date", "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
			ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
		}

		try
		{
			//not required, check only if non-blank
			String temp = ic.getParameter("res_end_time"); // changed the name of the field so we only grab the time from the DB
			if (temp != null && temp.length() > 0)
				res_end_time 	= new StdDate(temp);
		}
		catch (ParseException e)
		{
			datesGood = false;
			SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the end time and date.");
			ic.setTransientDatum("err@res_end_time", "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
			ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
		}

		try
		{
			//not required, check only if non-blank
			String temp = ic.getParameter("date_confirmed");
			if (temp != null && temp.length() > 0)
				date_confirmed 	= new StdDate(temp);
		}
		catch (ParseException e)
		{
			datesGood = false;
			SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the confirmation date.");
			ic.setTransientDatum("err@date_confirmed", "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
			ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
		}

		if( datesGood )
		{
			String est_start_date = ic.getParameter("res_start_date");
			String est_end_date = ic.getParameter("res_end_date");
			if( StringUtil.hasAValue(est_start_date) && StringUtil.hasAValue(est_end_date) )
			{
				StdDate start_date = new StdDate(est_start_date);
				StdDate end_date = new StdDate(est_end_date);
				if( start_date.after(end_date) )
				{//user defined error, start_date > end_date not allowed.
					datesGood = false;
					SmartFormHandler.addSmartFormError(ic, "Start Date is after End Date, please ensure Start Date is before End Date.");
					ic.setTransientDatum("err@res_start_date", "false");
					ic.setTransientDatum("err@res_end_date", "false");
				}
			}
		}

		Map<String, String> res_status_types = MapUtil.getTypeMap(conn,"resource_status_type");
		Map<String, String> reason_types = MapUtil.getTypeMap(conn,"reason_type");
		Map<String, String> job_types = MapUtil.getTypeMap(conn,"job_type");
		String project_job_type_id = job_types.get("project");
		String sa_job_type_id = job_types.get("service_account");

  		StringBuffer query = new StringBuffer();
		int rows = 0;

		if( action.equalsIgnoreCase("add") || action.equalsIgnoreCase("update"))
		{
			Diagnostics.debug2("SchHandler - Adding");

			//check if job_id exists for scheduler
			boolean has_job_id = false;
			if( StringUtil.hasAValue(new_job_id) )
				has_job_id = true;

			//check if new_service_id exists for major_acct_coord
			boolean has_service_id = false;
			if( StringUtil.hasAValue(new_service_id) )
				has_service_id = true;

			//check if status is available
			boolean is_available_status = false;
			String available_status_id = res_status_types.get("available");
			if( res_status_type_id == null ) //case when there is no current schedule and adding
				res_status_type_id = available_status_id;
			if( StringUtil.hasAValue(available_status_id) && res_status_type_id.equals(available_status_id) )
			{//status is available
				is_available_status = true;
			}

			QueryResults rs = null;
			//check if reason is an 'Available' reason
			//in case when reason_type_id is null, null is_available_reason=true;.
			boolean is_available_reason = true;
			if (StringUtil.hasAValue(reason_type_id))
			{
				Diagnostics.debug3("Action = 'check if reason_type is available status'");
				rs = conn.select("SELECT available_flag FROM reason_types_v WHERE lookup_id=?", reason_type_id);
				if( rs.next() )
				{//
					if( rs.getString(1).equalsIgnoreCase("N") )
						is_available_reason = false;
				}
				rs.close();
			}

			//test to insure two foremans are not added to same job, only affects scheduler
			query.setLength(0);
			String job_has_foreman = "N";
			if( role_code.equalsIgnoreCase("scheduler") && foreman_flag.equalsIgnoreCase("Y") && has_job_id )
			{
				//test if there is foreman already on job
				query.append("SELECT sr.foreman_flag");
				query.append(" FROM sch_resources sr");
				query.append(" WHERE sr.job_id="+conn.toSQLString(new_job_id));
				query.append("   AND sr.foreman_flag='Y'");
				query.append("   AND sr.sch_resource_id <> ");
				if( StringUtil.hasAValue(sch_resource_id) )
					query.append(conn.toSQLString(sch_resource_id));
				else
					query.append("-1"); //can't allow null because <> null always returns nothing.
				query.append("   AND (ISNULL(sr.res_start_date,'1/1/1901') <= ");
				
				if (res_end_date != null && StringUtil.hasAValue(res_end_date.toString()) )
					query.append(res_end_date+")");
				else
					query.append("'1/1/2101')");
				
				query.append("        AND ISNULL(sr.res_end_date,'1/1/2101') >= " + conn.toSQLString(res_start_date.toString()) );

				Diagnostics.debug3("Action = 'adding new foreman, check if there is a foreman already on job. query="+query.toString());
				rs = conn.resultsQueryEx(query);
				if( rs.next() )
				{//get service's status
					job_has_foreman = rs.getString(1);
				}
				IMSUtil.closeQueryResultSet(rs);
			}

			StdDate weekend_start_date = null;
			StdDate weekend_end_date = null;
			StdDate temp_res_start_date = null;
			//test to insure that user is not scheduling a weekend start date. Not allowed unless weekend_flag=Y
			if( weekend_flag.equalsIgnoreCase("N") )
			{
			    //since has no weekend availability, double check if attempting to scheule a weekend date.

				Diagnostics.debug3("Action = 'getDateTypeCols'");
				rs = conn.select("SELECT attribute2, attribute3 FROM weekend_date_types_v WHERE type_code='date_type' AND lookup_code='this_weekend'");
				if( rs.next() )
				{
				    //found date_type

					query.setLength(0);
					query.append("SELECT ").append(rs.getString(1)).append(",").append(rs.getString(2)).append(" FROM dates_v");
					Diagnostics.debug3("Action = 'getDates'");
					IMSUtil.closeQueryResultSet(rs);	// close as early as possible
					rs = null;

					QueryResults rs2 = conn.select(query);
					if( rs2.next() )
					{
					    //found dates
						try
						{
							weekend_start_date = new StdDate( rs2.getString(1) ); //note: weekend starts at 4:00 PM Friday, db value is set that way
							weekend_end_date = new StdDate( rs2.getString(2) );
							if( res_start_time != null )
								temp_res_start_date = res_start_time;
							else temp_res_start_date = res_start_date;
						}
						catch (ParseException e)
						{
							SmartFormHandler.addSmartFormError(ic, "ERROR, could not retrieve weekend dates.  See your System Admin.");
							Diagnostics.error("SchHandler.handleWeekend() failed to create StdDates for date_type_code = 'this_weekend', weekend_start_date='"+rs.getString(1)+"', weekend_end_date='"+rs.getString(2)+"', temp_res_start_date+time='"+ic.getParameter("res_start_date") + ic.getParameter("res_start_time")+"'.");
						}
					}
					IMSUtil.closeQueryResultSet(rs2);
				}
				else
				{
					SmartFormHandler.addSmartFormError(ic, "ERROR, failed in checking if start date is a weekend date.  See your System Admin.");
					Diagnostics.error("SchHandler.handleWeekend() failed to determine dates for date_type_code = 'this_weekend'.");
				}
				IMSUtil.closeQueryResultSet(rs);
			}

			//validate
			if( !datesGood )
			{
				//already handled, need this to avoid adding
			}
			else if( !has_job_id && is_available_status )
			{//to schedule with status='available', the new_job_id must have value
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nYou must select a Job in order to schedule with Status 'Available'.");
				ic.setTransientDatum("err@res_status_type_id", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else if( is_available_status && !is_available_reason )
			{//reason must be one of the available reasons
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nWrong Reason.\nThat reason is used only with the 'Unavailable' Status. Please choose a different 'Reason'.");
				ic.setTransientDatum("err@reason_type_id", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else if( !is_available_status && is_available_reason )
			{//reason must be one of the available reasons
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nWrong Reason.\nThat reason is used only with the 'Available' Status. Please choose a different 'Reason'.");
				ic.setTransientDatum("err@reason_type_id", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else if(role_code.equalsIgnoreCase("scheduler") && !has_job_id )
			{
				//scheduler can't schedule with a new_job_id
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nAs a Scheduler you must select a 'Add to Job#' by choosing a job from the Job List.");
				ic.setTransientDatum("err@new_job_id", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else if(action.equalsIgnoreCase("add") && role_code.equalsIgnoreCase("scheduler") && job_type_id.equalsIgnoreCase(project_job_type_id) && !has_service_id )
			{
				//scheduler can't schedule a project job without a new_service_id
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nAs a Scheduler you must schedule at the Req level for Project Jobs.\nPlease select a Project Job with a Req# from the Job List.\nNote: this job may not currently have a Requisition.");
				ic.setTransientDatum("err@new_job_id", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else if(action.equalsIgnoreCase("add") && role_code.equalsIgnoreCase("major_acct_coord") && !job_type_id.equalsIgnoreCase(sa_job_type_id) && !has_service_id )
			{
				//the MAC can only schedule service accounts and only at the requisition level
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nAs a MAC you cannot schedule Project jobs,\nand you must schedule at the Req level.\nPlease select a Service Account Job with a Requisition from the Job List.");
			}
			else if( job_has_foreman.equalsIgnoreCase("Y") )
			{
				//this job already has a forman, can't have two foremans on same job
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nA Foreman is already assigned.\nEither Change this Resource's foreman flag to 'No', or change foreman_flag on existing foreman to 'No'.");
				ic.setTransientDatum("err@foreman_flag", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else if( (weekend_flag != null && weekend_flag.equalsIgnoreCase("N") ) &&
						(temp_res_start_date.after(weekend_start_date) && temp_res_start_date.before(weekend_end_date)) )
			{//only test is the resource does not have a weekend_flag set to "Y"
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource. Start Date is for this weekend and the Resource does not have Weekend Availability.  Please Add Resource to the Weekend List first, or choose a non-weekend Start Date.");
				ic.setTransientDatum("err@res_start_date", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else
			{
				//passed validation
				query = new StringBuffer();

				//reason type could be light_duty or unconfirmed, so only if null set to scheduled
				if( !StringUtil.hasAValue(reason_type_id) )
					reason_type_id = (String)reason_types.get("scheduled");

				//if role_code is scheduler and job_type is service_account, then insure service_id is null,
				//but remember which service so we can email them during DistributeSchedules operation for the job_location
				String hidden_service_id = null;
				if(action.equalsIgnoreCase("add") &&  role_code.equalsIgnoreCase("scheduler") && job_type_id.equalsIgnoreCase(sa_job_type_id) )
				{
					hidden_service_id = new_service_id;
					new_service_id = null;
				}

				//handle scheduling of a weekend person
				if( weekend_flag.equalsIgnoreCase("Y") )
				{
					if( !StringUtil.hasAValue(weekend_sch_resource_id) )
					{//first time scheduling of a weekend resource so copy sch_resource_id so can remove weekend availability in the future
						weekend_sch_resource_id = sch_resource_id;
					}
				}

				//determine if this is a insert or an update
				if (StringUtil.hasAValue(sch_resource_id) && action.equalsIgnoreCase("update") )
				{
					query.append("UPDATE sch_resources");
					query.append(" SET foreman_flag = ").append(conn.toSQLString(foreman_flag));
					query.append(", res_status_type_id = ").append(conn.toSQLString(res_status_type_id));
					query.append(", reason_type_id = ").append(conn.toSQLString(reason_type_id));
					query.append(", res_start_date = ").append(conn.toSQLString(res_start_date));
					query.append(", res_start_time = ").append(conn.toSQLString(res_start_time));
					query.append(", res_end_date = ").append(conn.toSQLString(res_end_date));
					query.append(", resource_qty = ").append(conn.toSQLString(resource_qty));
					query.append(", sch_notes = ").append(conn.toSQLString(sch_notes));
					query.append(", send_to_pda_flag = ").append(conn.toSQLString(send_to_pda_flag));
					query.append(", date_modified = ").append(conn.toSQLString(date_modified));
					query.append(", modified_by = ").append(conn.toSQLString(modified_by));
					query.append(", report_to_type_id = ").append(conn.toSQLString(report_to_type_id));
					query.append(" WHERE sch_resource_id=").append(conn.toSQLString(sch_resource_id) );
				}
				else if( action.equalsIgnoreCase("add") )
				{
					if( has_job_id && !is_available_status )
					{//not scheduling against job, rather setting unavailable status
						query = new StringBuffer();
		   				query.append("INSERT INTO sch_resources (resource_id, foreman_flag, res_status_type_id, reason_type_id, res_start_date, res_start_time, res_end_date, res_end_time, date_confirmed, resource_qty, sch_notes, date_created, created_by, weekend_sch_resource_id, weekend_flag, report_to_type_id, send_to_pda_flag)");
						query.append(" VALUES (").append(conn.toSQLString(resource_id));
						query.append(", ").append(conn.toSQLString(foreman_flag));
						query.append(", ").append(conn.toSQLString(res_status_type_id));
						query.append(", ").append(conn.toSQLString(reason_type_id));
						query.append(", ").append(conn.toSQLString(res_start_date));
						query.append(", ").append(conn.toSQLString(res_start_time));
						query.append(", ").append(conn.toSQLString(res_end_date));
						query.append(", ").append(conn.toSQLString(res_end_time));
						query.append(", ").append(conn.toSQLString(date_confirmed));
						query.append(", ").append(conn.toSQLString(resource_qty));
						query.append(", ").append(conn.toSQLString(sch_notes));
						query.append(", ").append(conn.toSQLString(date_created));
						query.append(", ").append(conn.toSQLString(created_by));
						query.append(", ").append(conn.toSQLString(weekend_sch_resource_id));
						query.append(", ").append(conn.toSQLString(weekend_flag));
						query.append(", ").append(conn.toSQLString(report_to_type_id));
						query.append(", ").append(conn.toSQLString(send_to_pda_flag));
						query.append(")");
					}
					else
					{//schedule resource to a job
						query = new StringBuffer();
		   			query.append("INSERT INTO sch_resources (job_id, service_id, hidden_service_id, resource_id, foreman_flag, res_status_type_id, reason_type_id, res_start_date, res_start_time, res_end_date, res_end_time, date_confirmed, resource_qty, sch_notes, date_created, created_by, weekend_sch_resource_id, weekend_flag, report_to_type_id, send_to_pda_flag)");
						query.append(" VALUES (").append(conn.toSQLString(new_job_id));
						query.append(", ").append(conn.toSQLString(new_service_id));
						query.append(", ").append(conn.toSQLString(hidden_service_id));
						query.append(", ").append(conn.toSQLString(resource_id));
						query.append(", ").append(conn.toSQLString(foreman_flag));
						query.append(", ").append(conn.toSQLString(res_status_type_id));
						query.append(", ").append(conn.toSQLString(reason_type_id));
						query.append(", ").append(conn.toSQLString(res_start_date));
						query.append(", ").append(conn.toSQLString(res_start_time));
						query.append(", ").append(conn.toSQLString(res_end_date));
						query.append(", ").append(conn.toSQLString(res_end_time));
						query.append(", ").append(conn.toSQLString(date_confirmed));
						query.append(", ").append(conn.toSQLString(resource_qty));
						query.append(", ").append(conn.toSQLString(sch_notes));
						query.append(", ").append(conn.toSQLString(date_created));
						query.append(", ").append(conn.toSQLString(created_by));
						query.append(", ").append(conn.toSQLString(weekend_sch_resource_id));
						query.append(", ").append(conn.toSQLString(weekend_flag));
						query.append(", ").append(conn.toSQLString(report_to_type_id));
						query.append(", ").append(conn.toSQLString(send_to_pda_flag));
						query.append(")");
					}
				}
				Diagnostics.debug2("query = " + query);
				rows = conn.updateEx(query);
				boolean commit = true;
				if( rows != 1)
				{
						commit = false;
						SmartFormHandler.addSmartFormError(ic,"ERROR, did not schedule resource.\nPlease see your Administrator.");
						Diagnostics.error("SchHandler.editSchResource() Failed to create new sch_resource where resource_id = '"+resource_id+"'");
				}
				else
				{//successfully inserted sch_resource

					result = true;

			      	//need inserted sch_resource_id to create job_distribution row.
					String new_sch_resource_id = "-1";
			      	QueryResults x = conn.select("SELECT SCOPE_IDENTITY()");
			      	if( x.next() )
			      		new_sch_resource_id = x.getString(1);
					x.close();

					//now handle weather we send this to the resource's pda
					sendToPDA(ic, conn, new_job_id, resource_id, new_sch_resource_id, res_end_date, send_to_pda);

					if( foreman_flag != null && foreman_flag.equalsIgnoreCase("Y") )
					{
						//update job to have this forman
						query.setLength(0);
						query.append("UPDATE jobs SET foreman_resource_id=? WHERE job_id=?");
						Diagnostics.debug3("Action = '"+action+"' query="+query.toString());
						rows = (int)conn.update(query, new String[] {resource_id, new_job_id});
						if( rows != 1)
						{
							commit = false;
							SmartFormHandler.addSmartFormError(ic,"ERROR, did not schedule resource.\nPlease see your Administrator.");
							Diagnostics.error("SchHandler.editSchResource() Failed to create new sch_resource where resource_id = '"+resource_id+"'");
							result = false;
						}
					}
				}
				if (commit)
					conn.commit();
				else
					conn.rollback();
			}
		}

		else if( action.equalsIgnoreCase("remove") )
		{
			Diagnostics.debug2("SchHandler - Removing");
			query = new StringBuffer();

			//validate
			if( role_code.equalsIgnoreCase("major_acct_coord") && (!job_type_id.equalsIgnoreCase(sa_job_type_id) || !StringUtil.hasAValue(cur_service_id) ) )
			{//the MAC can remove resources only from the requisition level on service accounts
				SmartFormHandler.addSmartFormError(ic,"Can't Remove resource.\nAs a MAC you cannot remove resources from Project jobs\nand you can only remove resources at the Req level.\nPlease select a Service Account and a Requisition.");
			}
			else
			{
				//remove resource
				Diagnostics.debug3("Action = '"+action+"'");
				rows = (int)conn.update("DELETE FROM sch_resources WHERE sch_resource_id=?", sch_resource_id);
				boolean commit = true;
				if( rows != 1)
				{//
					commit = false;
					SmartFormHandler.addSmartFormError(ic,"ERROR, did not remove scheduled resource.\nPlease see your Administrator.");
					Diagnostics.error("SchHandler.editSchResource() Failed to remove sch_resource where sch_resource_id = '"+sch_resource_id+"'");
				}
				else
				{
					//update job by removing foreman_resource_id
					if (foreman_flag != null && foreman_flag.equalsIgnoreCase("Y"))
					{

						Diagnostics.debug3("Action = '"+action+"'");
						rows = (int)conn.update("UPDATE jobs SET foreman_resource_id = NULL WHERE job_id=?", cur_job_id);
						if( rows != 1)
						{
							commit = false;
							SmartFormHandler.addSmartFormError(ic,"ERROR, failed to update job's foreman flag.\nPlease see your Administrator.");
							Diagnostics.error("SchHandler.editSchResource() Failed to update job's foreman flag to null when resource_id = '"+resource_id+"' was removed from job.");
							result = false;
						}
						else
						{
							result = true;
						}
					}
					if (commit)
						conn.commit();
					else
						conn.rollback();
					
					//attempt to remove job_distribution if there is one
					sendToPDA(ic, conn, new_job_id, resource_id, sch_resource_id, res_end_date, false);

					//successfully removed sch_resource, if it was a foreman and role_code is scheduler, alert user, that there are no foreman on job.
					if( result && role_code.equalsIgnoreCase("scheduler") && foreman_flag != null && foreman_flag.equalsIgnoreCase("Y") )
					{
						showMessageWindow(ic, "You have removed the foreman.\nThere is no foreman on the job now.<br><br>Please assign a new Foreman in order to allow Distribute Schedules and Time Capture to work.");
						result = false;
					}
					else
						ic.setParameter("reload_frames","true");
				}
			}
		}
		return result;
	}

	public boolean handleVacation(InvocationContext ic, ConnectionWrapper conn, String action) throws Exception
	{
		Diagnostics.trace("SchHandler.handleVacation()");
		boolean result = false;

		String res_sch_id = (String)ic.getParameter("res_sch_id");
		String resource_id = (String)ic.getParameter("resource_id");
		String sch_resource_id = (String)ic.getParameter("sch_resource_id");
		if( StringUtil.hasAValue(res_sch_id) && (!StringUtil.hasAValue(resource_id) || !StringUtil.hasAValue(sch_resource_id)) )
		{
			resource_id = res_sch_id.substring(0,res_sch_id.indexOf(":"));
			sch_resource_id = res_sch_id.substring(res_sch_id.indexOf(":")+1);
//Diagnostics.error("resource_id='"+resource_id+"' sch_resource_id='"+sch_resource_id+"'");
		}
		String role_code = (String)ic.getSessionDatum("role_code");
		String created_by = (String)ic.getRequiredSessionDatum("user_id");
		String date_created = "getDate()";

		Map res_status_types = MapUtil.getTypeMap(conn,"resource_status_type");
		Map reason_types = MapUtil.getTypeMap(conn,"reason_type");

   	StringBuffer query = null;
		int rows = 0;

		if( action.equalsIgnoreCase("add_vacation") )
		{
			//validate dates stuff
			StdDate res_start_date = null, res_end_date = null;
			boolean datesGood = true;
			try
			{
				//required, so we auto-ding them
				res_start_date	= new StdDate(ic.getParameter("res_start_date"));
			}
			catch (ParseException e)
			{
				datesGood = false;
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the Start Date.");
				ic.setTransientDatum("err@res_start_date", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}

			try
			{
				//required, so we auto-ding them
				res_end_date	= new StdDate(ic.getParameter("res_end_date"));
			}
			catch (ParseException e)
			{
				datesGood = false;
				SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the End Date.");
				ic.setTransientDatum("err@res_end_date", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}

			if( datesGood )
			{
				String est_start_date = ic.getParameter("res_start_date");
				String est_end_date = ic.getParameter("res_end_date");
				if( StringUtil.hasAValue(est_start_date) && StringUtil.hasAValue(est_end_date) )
				{
					StdDate start_date = new StdDate(est_start_date);
					StdDate end_date = new StdDate(est_end_date);
					if( start_date.after(end_date) )
					{//user defined error, start_date > end_date not allowed.
						datesGood = false;
						SmartFormHandler.addSmartFormError(ic, "Start Date is after End Date, please ensure Start Date is before End Date.");
						ic.setTransientDatum("err@res_start_date", "false");
						ic.setTransientDatum("err@res_end_date", "false");
					}
				}
			}

			if( !datesGood )
			{
				//already handled error message
			}
			else if( !StringUtil.hasAValue(resource_id) )
			{//invalid date
				SmartFormHandler.addSmartFormError(ic, "Please select a Name from the droplist before hitting any buttons.");
				ic.setTransientDatum("err@resource_id", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else
			{//valid dates, now test pin

				String pin = ic.getParameter("user_pin");
				boolean found_pin = false;
				if( pin != null && pin.equalsIgnoreCase("no_pin_required") )
					found_pin = true;
				else
				{
				    //must validate pin
					found_pin = validatePin(resource_id, pin, conn, ic);
				}

				if( found_pin )
				{
				    //every thing is valid so update sch_resources

					//set resource status to unavailable
					String res_status_type_id = (String)res_status_types.get("unavailable");

					//set reason type to vacation
					String reason_type_id = (String)reason_types.get("vacation");

					//insert into sch_resources table
					query = new StringBuffer();
			   		query.append("INSERT INTO sch_resources (resource_id, res_status_type_id, reason_type_id, res_start_date, res_end_date, date_created, created_by)");
					query.append(" VALUES (").append(StringUtil.toSQLString(resource_id));
					query.append(", ").append(conn.toSQLString(res_status_type_id));
					query.append(", ").append(conn.toSQLString(reason_type_id));
					query.append(", ").append(conn.toSQLString(res_start_date));
					query.append(", ").append(conn.toSQLString(res_end_date));
					//note no toSQLString on date_created by because the value is getDate(), if in quotes, function won't run :-)
					query.append(", ").append(date_created);
					query.append(", ").append(conn.toSQLString(created_by));
					query.append(")");
			      	Diagnostics.debug3("Action = '"+action+"' query="+query.toString());
					rows = conn.updateEx(query);
				   	if (rows != 1)
                    {
                        conn.rollback();
                        SmartFormHandler.addSmartFormError(ic, "ERROR, Failed to add vacation.\nPlease see your Administrator.");
                        Diagnostics.error("SchHandler.editSchResource() Failed to create new vacation sch_resource where resource_id = '" + resource_id + "'");
                    }
                    else
                    {
                        //successfully inserted sch_resource
                        result = true;
                        conn.commit();
                    }
				}
			}
		}
		else if( action.equalsIgnoreCase("remove_vacation") )
		{
			if( !StringUtil.hasAValue(sch_resource_id) )
			{//missing sch_resource_id
				SmartFormHandler.addSmartFormError(ic, "You must select a your Name from the List and enter your pin to delete a vacation.");
				ic.setTransientDatum("err@res_sch_id2", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else
			{//valid
				boolean found_pin = true;
				boolean isScheduler = false;
				if( role_code != null && role_code.equalsIgnoreCase("scheduler") )
					isScheduler = true ;
				if( !isScheduler )
				{
				    //not scheduler so validate pin
					String pin = ic.getParameter("user_pin");
					found_pin = validatePin(resource_id, pin, conn, ic);
				}

				if( found_pin )
				{
				    //every thing is valid so update sch_resources

					//insert into sch_resources table
					Diagnostics.debug3("Action = '"+action+"'");
					rows = (int)conn.update("DELETE FROM sch_resources WHERE sch_resource_id = ?", sch_resource_id);
				   	if( rows != 1)
				   	{
							conn.rollback();
							SmartFormHandler.addSmartFormError(ic,"ERROR, valid to add vacation.\nPlease see your Administrator.");
							Diagnostics.error("SchHandler.editSchResource() Failed to create new vacation sch_resource where resource_id = '"+resource_id+"'");
					}
					else
					{
					    //successfully inserted sch_resource
				   		result = true;
				   		conn.commit();
				   	}
				}
			}
		}

		return result;
	}

	private boolean validatePin(String resource_id, String pin, ConnectionWrapper conn, InvocationContext ic) throws SQLException
	{
		boolean found_pin = true;
		String select = "SELECT resources.name FROM resources INNER JOIN users ON resources.user_id = users.user_id"
			+ " WHERE resources.resource_id = ? AND users.pin = ?";
		Diagnostics.debug3("Action = 'check pin'");
		QueryResults rs = conn.select(select, new String[] {resource_id, pin});
		if( !rs.next() )
		{		
			//pin did not match resource pin
			SmartFormHandler.addSmartFormError(ic,"Invalid PIN. Please enter a valid PIN number...");
			ic.setTransientDatum("err@user_pin", "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
			ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
		    found_pin = false;
		}
		rs.close();
		return found_pin;
	}

	public boolean handleWeekend(InvocationContext ic, ConnectionWrapper conn, String action) throws Exception
	{
		Diagnostics.trace("SchHandler.handleWeekend()");
		boolean result = false;

		String resource_id = (String)ic.getParameter("resource_id");
		String sch_resource_id = (String)ic.getParameter("sch_resource_id");
		String weekend_sch_resource_id = (String)ic.getParameter("weekend_sch_resource_id");
		//note, if adding, and weekend_sch_resource_id is null, a DB trigger on sch_resources sets weekend_sch_resource_id=sch_resource_id which is only known after insert.
		String date_type_id = ic.getParameter("date_type_id");
		String created_by = (String)ic.getRequiredSessionDatum("user_id");
		String date_created = "getDate()";

		Map res_status_types = MapUtil.getTypeMap(conn,"resource_status_type");

   		StringBuffer query = null;
		int rows = 0;

		if( action.equalsIgnoreCase("add_weekend") )
		{
			StdDate res_start_date = null, res_start_time = null, res_end_date = null, res_end_time = null;

			boolean dateTypeGood = false;
			boolean datesGood = true;

			//selected dates override date_type, since selected dates_invalid (or missing), use date_type
			if( StringUtil.hasAValue(date_type_id) )
			{
				String select = "SELECT attribute2, attribute3 FROM weekend_date_types_v WHERE lookup_id=?";
				Diagnostics.debug3("Action = 'getDateTypeCols'");
				QueryResults rs = conn.select(select, date_type_id);
				if( rs.next() )
				{
				    //found date_type
					query = new StringBuffer();
					query.append("SELECT ").append(rs.getString(1)).append(",").append(rs.getString(2)).append(" FROM dates_v");
					Diagnostics.debug3("Action = 'getDates'");
					QueryResults rs2 = conn.select(query);
					if( rs2.next() )
					{
					    //found dates
						dateTypeGood = true;
						res_start_date = new StdDate(rs2.getString(1));
						res_end_date = new StdDate(rs2.getString(2));
					}
					IMSUtil.closeQueryResultSet(rs2);
				}
				else
				{
					SmartFormHandler.addSmartFormError(ic, "ERROR, failed to determine dates.  See your System Admin.");
					Diagnostics.error("SchHandler.handleWeekend() failed to determine dates for date_type_id = '"+ date_type_id +"'.");
				}
				IMSUtil.closeQueryResultSet(rs);
				if( !dateTypeGood )
				{
					SmartFormHandler.addSmartFormError(ic, "You must first select a Date Type or enter in specific dates to make a Resource available for this weekend's schedule...");
					ic.setTransientDatum("err@date_type_id", "false");
					ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
					ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
				}
			}

			if( !dateTypeGood )
			{
				try
				{//required, so we auto-ding them
					res_start_date	= new StdDate(ic.getParameter("res_start_date"));
				}
				catch (ParseException e)
				{
					datesGood = false;
					SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the Start Date, or select a Date Type.");
					ic.setTransientDatum("err@res_start_date", "false");
					ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
					ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
				}

				try
				{
					//not required, check only if non-blank
					String temp = ic.getParameter("res_start_time"); // changed the name of the field so we only grab the time from the DB
					if (temp != null && temp.length() > 0)
						res_start_time 	= new StdDate(temp);
				}
				catch (ParseException e)
				{
					datesGood = false;
					SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the Start Time, or select a Date Type");
					ic.setTransientDatum("err@res_start_time", "false");
					ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
					ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
				}

				try
				{
					//not required, check only if non-blank
					String temp = ic.getParameter("res_end_date");
					if ( StringUtil.hasAValue(temp) )
						res_end_date 	= new StdDate(temp);

				}
				catch (ParseException e)
				{
					datesGood = false;
					SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the End Date, or select a Date Type.");
					ic.setTransientDatum("err@res_end_date", "false");
					ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
					ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
				}

				try
				{
					//not required, check only if non-blank
					String temp = ic.getParameter("res_end_time"); // changed the name of the field so we only grab the time from the DB
					if (temp != null && temp.length() > 0)
						res_end_time 	= new StdDate(temp);
				}
				catch (ParseException e)
				{
					datesGood = false;
					SmartFormHandler.addSmartFormError(ic,"Can't schedule resource.\nPlease check the format of the End Time, or select a Date Type.");
					ic.setTransientDatum("err@res_end_time", "false");
					ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
					ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
				}

				if( datesGood )
				{
					String est_start_date = ic.getParameter("res_start_date");
					String est_end_date = ic.getParameter("res_end_date");
					if( StringUtil.hasAValue(est_start_date) && StringUtil.hasAValue(est_end_date) )
					{
						StdDate start_date = new StdDate(est_start_date);
						StdDate end_date = new StdDate(est_end_date);
						if( start_date.after(end_date) )
						{//user defined error, start_date > end_date not allowed.
							datesGood = false;
							SmartFormHandler.addSmartFormError(ic, "Start Date is after End Date, please ensure Start Date is before End Date.");
							ic.setTransientDatum("err@res_start_date", "false");
							ic.setTransientDatum("err@res_end_date", "false");
						}
					}
				}
			}

			if( !dateTypeGood && !datesGood)
			{
				//do nothing, error message already created
			}
			else if( !StringUtil.hasAValue(resource_id) )
			{//missing resource
				SmartFormHandler.addSmartFormError(ic, "Please select a Name from the droplist before hitting any buttons.");
				ic.setTransientDatum("err@resource_id", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else
			{//validation passed

				//if not using the date_type_id because user entered valid start and end dates, set to null
				if( datesGood )
					date_type_id = null;

				//set the resource status to available
				String res_status_type_id = (String)res_status_types.get("available");

				//set the reason type to...
				//String reason_type_id = (String)reason_types.get("vacation");
				String reason_type_id = null;

				//insert into sch_resources table
				query = new StringBuffer();
		   		query.append("INSERT INTO sch_resources (resource_id, res_status_type_id, reason_type_id, res_start_date, res_start_time, res_end_date, res_end_time, date_created, created_by, weekend_flag, date_type_id) ");
				query.append(" VALUES (").append(StringUtil.toSQLString(resource_id));
				query.append(",").append(conn.toSQLString(res_status_type_id));
				query.append(",").append(conn.toSQLString(reason_type_id));
				query.append(",").append(conn.toSQLString(res_start_date));
				query.append(",").append(conn.toSQLString(res_start_time));
				query.append(",").append(conn.toSQLString(res_end_date));
				query.append(",").append(conn.toSQLString(res_end_time));
				//note no toSQLString on date_created by because the value is getDate(), if in quotes, function won't run :-)
				query.append(",").append(date_created);
				query.append(",").append(conn.toSQLString(created_by));
				query.append(",'Y'"); //weekend_flag
				query.append(",").append(conn.toSQLString(date_type_id));
				query.append(")");
				Diagnostics.debug3("Action = '"+action+"' query="+query.toString());
				rows = conn.updateEx(query);
			   	if( rows != 1)
			   	{
					conn.rollback();
					SmartFormHandler.addSmartFormError(ic,"ERROR, failed to add weekend sch resource.\nPlease see your Administrator.");
					Diagnostics.error("SchHandler.handleWeekend() Failed to create new weekend sch_resource where resource_id = '"+resource_id+"'");
				}
				else
				{//successfully inserted sch_resource
			   		result = true;
			   		conn.commit();
					ic.setParameter("updated_res","true");
				}
			}
		}
		else if( action.equalsIgnoreCase("remove_weekend") )
		{
			if( !StringUtil.hasAValue(sch_resource_id) )
			{
				//missing sch_resource_id
				SmartFormHandler.addSmartFormError(ic, "You must select a Resource's 'Weekend' link from the weekend list to remove a resource's weekend availability.");
				ic.setTransientDatum("err@resource_id", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG,"false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG,"false");
			}
			else if( !StringUtil.hasAValue(weekend_sch_resource_id) )
			{
				//missing weekend_sch_resource_id
				SmartFormHandler.addSmartFormError(ic, "ERROR, missing weekend_sch_resource_id.  Is is required to remove the weekend availability.  Please see your System Administrator.");
			}
			else
			{//valid

				//insert into sch_resources table
				Diagnostics.debug3("Action = '"+action+"'");
				rows = (int)conn.update("DELETE FROM sch_resources WHERE sch_resource_id = ?", weekend_sch_resource_id);
				if( rows != 1)
				{
					conn.rollback();
					SmartFormHandler.addSmartFormError(ic,"You already removed the weekend schedule.  To remove this job's schedule click on the Resource Name and remove like normal.  Click the 'Cancel' button to continue.");
				}
				else
				{//successfully deleted sch_resource
			   		result = true;
			   		conn.commit();
					ic.setParameter("updated_res","true");
				}
			}
		}
		return result;
	}


  /**
	*	Returns current status_code of job for scheduler, req for mac.
	*/

	public String getStatusCode(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("SchHandler.getStatusCode()");
		String cur_status = null;

		String job_id = (String)ic.getRequiredSessionDatum("job_id");
		String service_id = (String)ic.getSessionDatum("service_id");
		String role_code = (String)ic.getRequiredSessionDatum("role_code");

		if( role_code != null && role_code.equalsIgnoreCase("scheduler") )
		{//retrieve job status
	  		String query = "SELECT job_status_type_code FROM jobs_v WHERE job_id=?";
		    Diagnostics.debug3("Retrieving job's status for Scheduler.");
			QueryResults rs = conn.select(query, job_id);
			while( rs.next() )
			{//get service's status
				cur_status = rs.getString(1);
			}
			rs.close();
		}
		else if( role_code != null && role_code.equalsIgnoreCase("major_acct_coord") )
		{//retrieve req status
	  		String query ="SELECT serv_status_type_code FROM services_v WHERE service_id=?";
		    Diagnostics.debug3("Retrieving req's status for MAC.");
			QueryResults rs = conn.select(query, service_id);
			while( rs.next() )
			{//get service's status
				cur_status = rs.getString(1);
			}
			rs.close();
		}

		return cur_status;
	}


  /**
	*	Sends this info to the resource's PDA
	*/

	public void sendToPDA(InvocationContext ic, ConnectionWrapper conn, String job_id, String resource_id, String sch_resource_id, Date sch_end_date, boolean send_to_pda ) throws Exception
	{
		//Determine if resource has a user and that user has a imobile_login for a pda
		String userQuery = "SELECT u.user_id FROM resources r, user_organizations_v u"
		+ " WHERE r.user_id = u.user_id AND u.organization_id = ?"
		+ " AND u.imobile_login is NOT NULL"
		+ " AND r.resource_id = ?";

		QueryResults rs = conn.select(userQuery, new String[] {(String)ic.getRequiredSessionDatum("org_id"),resource_id});
		if( rs.next() )
		{
			String user_id = rs.getString("user_id");
			IMSUtil.closeQueryResultSet(rs);	// close as soon as possible
			rs = null;

			if( send_to_pda )
			{//insert
				//and now insert this new user
				StringBuffer insert = new StringBuffer();
				insert.append("INSERT INTO job_distributions (job_id, user_id, sch_resource_id, remove_date, date_created, created_by)");
				insert.append(" VALUES (?, ?, ?,");
				if( sch_end_date != null )
					insert.append("CONVERT(datetime,"+conn.toSQLString(sch_end_date)+",101)+1, ");
				else
					insert.append("getDate()+365, "); //in case no end date, end after 1 year
				insert.append("getDate(), ?)");
				conn.update(insert, new String[] {job_id, user_id, sch_resource_id, (String)ic.getRequiredSessionDatum("user_id")});
			}
			else //delete
			{
				String delete = "DELETE FROM job_distributions"
					+ " WHERE job_id = ?"
					+ " AND user_id = ?"
					+ " AND sch_resource_id = ?";
				conn.update(delete, new String[] {job_id, user_id, sch_resource_id});
			}
		}
		IMSUtil.closeQueryResultSet(rs);
	}

}
