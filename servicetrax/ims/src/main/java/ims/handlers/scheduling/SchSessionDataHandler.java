package ims.handlers.scheduling;

import ims.helpers.IMSUtil;

import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: SchSessionDataHandler.java, 23, 3/6/2006 3:46:57 PM, Blake Von Haden$
 */
public class SchSessionDataHandler extends BaseHandler
{
	public void setUpHandler(){}

	public void destroy(){}

	private void setParameter(InvocationContext ic, String name)
	{
		String value = ic.getParameter(name);
		Diagnostics.debug2("SchSessionDataHandler.setParameter() " + name + " = \"" + value + "\"");

		if (StringUtil.hasAValue(value))
			ic.setSessionDatum(name, value);
		else
			ic.removeSessionDatum(name);
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.trace("SchSessionDataHandler.handleEnvironment()");

		boolean bRet = true;
		String action = ic.getParameter("sch_action");

		try
		{
			Diagnostics.debug2("action='" + action + "'");
			if (action == null)
			{
				Diagnostics.error("Missing required parameter 'sch_action' in SchSessionDataHandler.handleEnvironment()");
				bRet = false;
			}
			else if (action.equalsIgnoreCase("setup_date_type"))
			{
				// this is first to get called by main_sch, so cleanup session
				// clear all session data
				this.clearSchSessionData(ic);

				bRet = setRoleCode(ic);
				if (bRet)
					bRet = setDateType(ic);
				else
					setDateType(ic);
				//
				ic.setSessionDatum("cur_template", "sch/sch_body.html"); // used to remember default page to refresh when dates
                                                                            // are reset, used in sch_head.html
			}
			else if (action.equalsIgnoreCase("set_date_type"))
			{
				bRet = setDateType(ic);
				ic.setHTMLTemplateName("sch/sch_head.html");
			}
			else if (action.equalsIgnoreCase("set_template"))
			{// used to remember default page to refresh when dates are reset, used in sch_head.html
				setParameter(ic, "cur_template");
			}
			else if (action.equalsIgnoreCase("set_dates"))
			{
				testDates(ic);
				ic.setHTMLTemplateName("sch/sch_head.html");
			}
			else if (action.equalsIgnoreCase("set_job_req"))
			{
				setParameter(ic, "job_id");
				setParameter(ic, "job_no");
				setParameter(ic, "service_id");
				setParameter(ic, "service_no");
				setParameter(ic, "job_service_id");
			}
			else if (action.equalsIgnoreCase("set_job_dates"))
			{
				setParameter(ic, "est_start_date");
				setParameter(ic, "est_start_time");
				setParameter(ic, "est_end_date");
				setParameter(ic, "job_type_id");
			}
			else if (action.equalsIgnoreCase("set_sch_filter"))
			{// used to remember what view is currently being viewed if they modify resource's schedule
				setParameter(ic, "sch_filter");
				setParameter(ic, "weekend_filter");
				setParameter(ic, "rotation");
			}
			else if (action.equalsIgnoreCase("set_res_type_id"))
			{// used to remember what view is currently being viewed if they modify resource's schedule
				setParameter(ic, "sch_res_type_id");
			}
			else if (action.equalsIgnoreCase("set_res_id"))
			{// used to remember what view is currently being viewed if they modify resource's schedule
				setParameter(ic, "sch_list_res_id");
			}
			else if (action.equalsIgnoreCase("sch_reports"))
			{// used to remember what view is currently being viewed if they changes the dates
				setParameter(ic, "sch_report");
			}
			else
				Diagnostics.error("Unrecognized action='" + action + "'");
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Problem in SchSessionDataHandler sch_action='" + action + "'");
			bRet = false;
		}

		return bRet;
	}

	private boolean testDates(InvocationContext ic)
	{
		Diagnostics.trace("SchSessionDataHandler.testDates()");
		boolean result = true;
		String sch_from_date = ic.getParameter("sch_from_date");
		String sch_to_date = ic.getParameter("sch_to_date");
		if (sch_from_date != null)
			sch_from_date += " 00:00:00"; // set to beginning of day
		if (sch_to_date != null)
			sch_to_date += " 23:59:59"; // set to end of day
		try
		{
			sch_from_date = ic.format(new StdDate(sch_from_date), "datetime");
			sch_to_date = ic.format(new StdDate(sch_to_date), "datetime");
		}
		catch (Exception e)
		{
			Diagnostics.error("Failed to format sch_from_date (" + sch_from_date + ") or sch_to_date (" + sch_to_date
					+ ") as a 'date'.");
		}
		ic.setSessionDatum("sch_from_date", sch_from_date);
		ic.setSessionDatum("sch_to_date", sch_to_date);

		return result;
	}

	private boolean setRoleCode(InvocationContext ic)
	{
		Diagnostics.trace("SchSessionDataHandler.setRoleCode()");
		ConnectionWrapper conn = null;
		String role_code = null;
		String function_code = null;
		StringBuffer query = null;
		boolean result = true;
		QueryResults rs = null;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			String user_id = (String) ic.getRequiredSessionDatum("user_id");

			query = new StringBuffer();
			query.append("SELECT distinct function_code FROM user_org_function_rights_v");
			query.append(" WHERE organization_id = " + conn.toSQLString((String) ic.getSessionDatum("org_id")));
			query.append("   AND user_id=" + StringUtil.toSQLString(user_id));
			query.append("   AND function_code='SCHEDULER'");
			query.append("   AND has_right='Y'");
			Diagnostics.debug3("Action = 'setRoleCode' query=" + query.toString());
			rs = conn.resultsQueryEx(query);
			if (rs.next()) // yes a scheduler
			{
				role_code = "scheduler";
				function_code = rs.getString(1);
			}
			else
			{// not a scheduler check if major account coordinator
				IMSUtil.closeQueryResultSet(rs);
				query = new StringBuffer();
				query.append("SELECT distinct function_code FROM user_org_function_rights_v");
				query.append(" WHERE organization_id = " + conn.toSQLString((String) ic.getSessionDatum("org_id")));
				query.append("   AND user_id=" + StringUtil.toSQLString(user_id));
				query.append("   AND function_code='MAC'");
				query.append("   AND has_right='Y'");
				Diagnostics.debug3("Action = 'setRoleCode' query=" + query.toString());
				rs = conn.resultsQueryEx(query);
				if (rs.next()) // yes a scheduler
				{
					role_code = "major_acct_coord";
					function_code = rs.getString(1);
					while (rs.next()); // run out cursor
				}
				else
				{// not a mac nor a scheduler
					role_code = "not sch, nor a mac";
					function_code = "neither";
				}
			}
		}
		catch (Exception e)
		{
			Diagnostics.debug2("Error in SchSessionDataHandler.setRoleCode()...please read error output:\n" + e.toString());
			result = false;
		}
		finally
		{
			try
			{
				IMSUtil.closeQueryResultSet(rs);
			}
			catch (SQLException ignore) {}
			if (conn != null)
			{
				conn.release();
			}
		}
		ic.setSessionDatum("role_code", role_code);
		ic.setSessionDatum("function_code", function_code);
		Diagnostics.debug2("SchSessionDataHandler.handleEnvironment() Role = \"" + role_code + "\"");
		return result;
	}

	private boolean setDateType(InvocationContext ic)
	{
		Diagnostics.trace("SchSessionDataHandler.handleEnvironment()");
		ConnectionWrapper conn = null;
		StringBuffer query = new StringBuffer();
		boolean result = false;
		QueryResults rs = null;
		try
		{
			String date_type_code = ic.getRequiredParameter("date_type_code");
			conn = (ConnectionWrapper) ic.getResource();
			query.append("SELECT attribute2, attribute3 FROM lookups_v WHERE type_code='date_type' AND lookup_code="
					+ StringUtil.toSQLString(date_type_code));
			Diagnostics.debug3("Action = 'getDateTypeCols' query=" + query.toString());
			rs = conn.resultsQueryEx(query);
			if (rs.next())
			{// found date_type
				query = new StringBuffer();
				query.append("SELECT CONVERT(VARCHAR(12)," + rs.getString(1) + ",101) from_date, CONVERT(VARCHAR(12),"
						+ rs.getString(2) + ",101) to_date FROM dates_v");
				IMSUtil.closeQueryResultSet(rs);
				Diagnostics.debug3("Action = 'getDates' query=" + query.toString());
				rs = conn.resultsQueryEx(query);
				if (rs.next())
				{// found dates
					String sch_from_date = rs.getString("from_date");
					if (sch_from_date != null)
						sch_from_date += " 00:00:00"; // set to beginning of day
					ic.setParameter("sch_from_date", sch_from_date);

					String sch_to_date = rs.getString("to_date");
					if (sch_to_date != null)
						sch_to_date += " 23:59:59"; // set to end of day
					ic.setParameter("sch_to_date", sch_to_date);
					result = true;
				}
			}
		}
		catch (Exception e)
		{
			Diagnostics.debug2("Error in SchSessionDataHandler.setDateType():\n" + e.toString());
		}
		finally
		{
			try
			{
				IMSUtil.closeQueryResultSet(rs);
			}
			catch (SQLException ignore) {}
			if (conn != null)
			{
				conn.release();
			}
		}
		setParameter(ic, "date_type_code");
		setParameter(ic, "sch_from_date");
		setParameter(ic, "sch_to_date");
		return result;
	}

	public void clearSchSessionData(InvocationContext ic)
	{
		ic.setSessionDatum("job_service_id", null);
		ic.setSessionDatum("job_id", null);
		ic.setSessionDatum("job_no", null);
		ic.setSessionDatum("service_id", null);
		ic.setSessionDatum("service_no", null);
		ic.setSessionDatum("est_start_date", null);
		ic.setSessionDatum("est_start_time", null);
		ic.setSessionDatum("est_end_date", null);
		ic.setSessionDatum("job_type_id", null);
		ic.setSessionDatum("sch_filter", null);
		ic.setSessionDatum("sch_res_type_id", null);
		ic.setSessionDatum("sch_list_res_id", null);
	}
}
