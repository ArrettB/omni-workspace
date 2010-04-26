package ims.handlers.scheduling;

import org.w3c.dom.Document;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.mail.MailSender;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;

/**
 * Handler for setting the user rights session datum
 *
 * @version $Header: EmailScheduleHandler.java, 9, 1/20/2006 3:21:49 PM, Blake Von Haden$
 */

public class EmailScheduleHandler extends BaseHandler
{
	private String host;
	private String port;
	private String from = "ServiceTRAX";

	public void setUpHandler() throws Exception
	{
		Diagnostics.debug2("EmailScheduleHandler.setUpHandler()");

		//grab xml files for the mailing host
		Document d = getConfigDocument();
		host = XMLUtils.getValue(d, "mail:host").trim();
		port = XMLUtils.getValue(d, "mail:port").trim();

	}

	public void destroy()
	{
		Diagnostics.debug2("EmailScheduleHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("EmailScheduleHandler.handleEnvironment()");
		ConnectionWrapper conn = null;
		boolean result = false;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();

			String resultPage = ic.getParameter("return_page");
			ic.setHTMLTemplateName(resultPage);

			//test if we should only distribute one job's schedule
			String distribute_job = ic.getParameter("distribute_job");
			String job_id = "like '%'";
			if( StringUtil.hasAValue(distribute_job) && distribute_job.equalsIgnoreCase("true") )
			{
				job_id = "="+conn.toSQLString((String)ic.getSessionDatum("job_id"));
			}

			//determine all foreman with jobs that have been scheduled for today
			StringBuffer query = new StringBuffer();
			query.append("SELECT distinct job_id, job_no, job_name, customer_name, resource_name foreman_name, email");
			query.append(" FROM sch_email_v");
			query.append(" WHERE sch_foreman_flag = 'Y' AND job_id " + job_id + " AND organization_id="+conn.toSQLString( (String)ic.getSessionDatum("org_id") ) );
			Diagnostics.debug2("foreman query = "+ query.toString() );

			StringBuffer message;
			String jobID, todayJobNo, todayJobName, todayCustomerName, foremanName, emailTo;
			String resourceName, reportToTypeName, newStartTime, newJobNo, newJobName,  newReqNo, newCustomerName, newJobLocationName, street1, street2, street3, city, state, zip;

			QueryResults rs = conn.resultsQueryEx(query);
			while (rs.next())
			{
				jobID = rs.getString("job_id");
				todayJobNo = rs.getString("job_no");
				todayJobName = rs.getString("job_name");
				todayCustomerName = rs.getString("customer_name");
				foremanName = rs.getString("foreman_name");
				emailTo = rs.getString("email");

				message = new StringBuffer();
				message.append(foremanName).append(",\n");
				message.append("Today's Customer: ").append(todayCustomerName).append("\n");
				message.append("Today's Job#/Name: ").append(todayJobNo).append(" " + todayJobName + "\n");
				message.append("Tomorrow's Installer Schedule is...\n\n");

				//now select the foreman's current resources job informatio for the next day
				query = new StringBuffer();
				query.append("SELECT resource_name, report_to_type_name, CONVERT(varchar, new_res_start_time) AS new_start_time");
				query.append(", new_job_no, new_job_name, new_service_no, new_customer_name, new_foreman_resource_name");
				query.append(", job_location_name, street1, street2, street3, city, state, zip");
				query.append(" FROM sch_email_v");
				query.append(" WHERE job_id = ").append(jobID).append(" AND organization_id="+conn.toSQLString( (String)ic.getSessionDatum("org_id") ) );
				Diagnostics.debug2("Email schedules query = " + query );
				QueryResults rs2 = conn.resultsQueryEx(query);
				boolean has_people = false;

				while(rs2.next())
				{
					has_people = true;
					resourceName = rs2.getString("resource_name");
					reportToTypeName = rs2.getString("report_to_type_name");
					newStartTime = rs2.getString("new_start_time");
					newJobNo = rs2.getString("new_job_no");
					newJobName = rs2.getString("new_job_name");
					newReqNo = rs2.getString("new_service_no");
					newCustomerName = rs2.getString("new_customer_name");
					newJobLocationName = rs2.getString("job_location_name");
					street1 = rs2.getString("street1");
					street2 = rs2.getString("street2");
					street3 = rs2.getString("street3");
					city = rs2.getString("city");
					state = rs2.getString("state");
					zip = rs2.getString("zip");

					message.append(resourceName).append(", report to "+reportToTypeName);
					if( newStartTime == null )
						message.append(", call scheduler for start time.\n");
					else
						message.append(" at " + newStartTime + ".\n");
					if( newReqNo != null )
						newJobNo = newJobNo +":"+ newReqNo;
					message.append("  New Job#/Req and Name: ").append(newJobNo).append(" "+newJobName+"\n");
					message.append("  New Customer: ").append(newCustomerName).append("\n");
					if (newJobLocationName != null && newJobLocationName.length() > 0)
					{
						message.append("  Job Location: ").append(newJobLocationName).append("\n");

						//throw together whatever parts of the address we have available
						if (street1 != null && street1.length() > 0)
						{
							message.append("               ").append(street1).append("\n");
						}
						if (street2 != null && street2.length() > 0)
						{
							message.append("               ").append(street2).append("\n");
						}
						if (street3 != null && street3.length() > 0)
						{
							message.append("               ").append(street3).append("\n");
						}
						if (city != null && city.length() > 0)
						{
							message.append("               ").append(city);
						}
						if (state != null && state.length() > 0)
						{
							message.append(", ").append(state);
						}
						if (zip != null && zip.length() > 0)
						{
							message.append(" ").append(zip);
						}
						message.append("\n\n");
					}
					else
					{
						message.append("  Job Location: ").append("Unknown, call scheduler").append("\n");
						message.append("\n");
					}
				}
				if( !has_people )
					message.append("This job has a foreman only.");

				rs2.close();

				String title = null;
				if( !StringUtil.hasAValue(emailTo) )
				{
					emailTo = "scheduler@ambis.com";
					title = "FAILED TO DISTRIBUTE SCHEDULE FOR JOB#"+todayJobNo;
					message = new StringBuffer("FOREMAN ("+foremanName+") IS MISSING EMAIL ON HIS CONTACT.\n\n"+message.toString());
				}
				else
					title = "ServiceTRAX Alert";
			
				Diagnostics.debug("Sending email to '" + emailTo + "' from '"+from+"'");

				String testEmail = (String)ic.getAppGlobalDatum("testEmail");
				if (StringUtil.hasAValue(testEmail ))
				{
					title = emailTo + ":" + title;
					emailTo = testEmail;
				}
				
				MailSender ms = new MailSender(emailTo, from, title, new java.util.Date(), message.toString());
				ms.setServerInfo(host, port);
				ms.send();
			}
			rs.close();

			result = true;
		}
		catch (Exception e)
		{
			result = true;
			ErrorHandler.handleException(ic, e,  "Exception in EmailScheduleHandler");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}

		return result;
	}
}

