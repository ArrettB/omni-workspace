package ims.handlers.job_processing;

import ims.helpers.IMSUtil;
import ims.helpers.MapUtil;

import java.util.Date;
import java.util.Map;

import org.w3c.dom.Document;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.mail.MailSender;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;

/**
 * Handles emailing Requisition Details
 * 
 * @version $Id: ReqHandler.java, 1098, 3/6/2008 9:28:04 AM, David Zhao$
 */
public class ReqHandler extends BaseHandler
{
	private String host;
	private String port;
	private String from;

	public void setUpHandler() throws Exception
	{
		Diagnostics.trace("ReqHandler.setUpHandler()");
		Document d = getConfigDocument();
		host = XMLUtils.getValue(d, "mail:host").trim();
		port = XMLUtils.getValue(d, "mail:port").trim();
		from = XMLUtils.getValue(d, "mail:from").trim();
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("ReqHandler.handleEnvironment()");
		boolean result = true;
		ConnectionWrapper conn = null;

		String button = (String) ic.getParameter(SmartFormComponent.BUTTON);
		ic.setTransientDatum("action", "loadrates");
		boolean isNew = "Y".equalsIgnoreCase((String) ic.getSessionDatum("is_new")) ? true : false;
		
		try
		{
			conn = (ConnectionWrapper) ic.getResource("SQLServer");
			String serv_status_type_id = ic.getParameter("serv_status_type_id");
			Map service_statuses = MapUtil.getTypeMap(conn, "service_status_type");
			String closed_status_type_id = (String) service_statuses.get("closed");

			if (button.equalsIgnoreCase(SmartFormComponent.Save) && !closed_status_type_id.equalsIgnoreCase(serv_status_type_id))
			{
				Diagnostics.debug2("Attempting to send email...");

//				User user = (User) ic.getSessionDatum("user");
				String service_id = (String) ic.getTransientDatum("service_id");// Transient id passed after Insert
				if (service_id != null)
					ic.setSessionDatum("service_id", service_id);
				service_id = (String) ic.getRequiredSessionDatum("service_id");// session should exist for Update

				if (service_id != null)
				{
					service_id = (String) ic.getRequiredParameter("service_id");// Parameter id passed after Update
					if (service_id != null)
						ic.setSessionDatum("service_id", service_id);
				}
				else
				{
					Diagnostics.error("Failed to find service_id in ReqHandler.");
				}

				StringBuffer emailList = new StringBuffer();
				
				if (isNew) {
					if (ic.getRequiredParameter("email_idm").equalsIgnoreCase("Y"))	{
						addContactToEmailList(ic.getRequiredParameter("idm_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_am_sales").equalsIgnoreCase("Y")) {
						addContactToEmailList(ic.getRequiredParameter("a_m_sales_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_job_location").equalsIgnoreCase("Y")) {
						addContactToEmailList(ic.getRequiredParameter("job_location_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_customer").equalsIgnoreCase("Y")) {
						addContactToEmailList(ic.getRequiredParameter("customer_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_customer2").equalsIgnoreCase("Y")) {
						addContactToEmailList(ic.getRequiredParameter("customer_contact2_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_customer3").equalsIgnoreCase("Y")) {
						addContactToEmailList(ic.getRequiredParameter("customer_contact3_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_customer4").equalsIgnoreCase("Y")) {
						addContactToEmailList(ic.getRequiredParameter("customer_contact4_id"), emailList, conn);
					}
				} else {
					if (ic.getRequiredParameter("email_idm").equalsIgnoreCase("Y"))
					{
						addContactToEmailList(ic.getRequiredParameter("idm_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_customer").equalsIgnoreCase("Y"))
					{
						addContactToEmailList(ic.getRequiredParameter("customer_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_sales").equalsIgnoreCase("Y"))
					{
						addContactToEmailList(ic.getRequiredParameter("sales_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_support").equalsIgnoreCase("Y"))
					{
						addContactToEmailList(ic.getRequiredParameter("support_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_designer").equalsIgnoreCase("Y"))
					{
						addContactToEmailList(ic.getRequiredParameter("designer_contact_id"), emailList, conn);
					}
					if (ic.getRequiredParameter("email_project_mgr").equalsIgnoreCase("Y"))
					{
						addContactToEmailList(ic.getRequiredParameter("project_mgr_contact_id"), emailList, conn);
					}
				}


				if (emailList.length() > 0)
				{
					Diagnostics.warning("Emails are being sent out to the following addresses:" + emailList);
					String query = "SELECT job_no, service_no, customer_name, job_name, job_location_name, CONVERT(varchar,est_start_date,101) start_date, est_start_time start_time, description FROM services_v WHERE service_id = "
							+ conn.toSQLString(service_id);
					QueryResults rs = conn.resultsQueryEx(query);
					if (rs.next())
					{
//						String fromEmail = null;
//						String query2 = "SELECT email"
//						              +  " FROM contacts"
//						              + " WHERE contact_id = " + user.getContactID();
//						Diagnostics.debug2("Query = " + query.toString());
//
//						QueryResults rs2 = conn.resultsQueryEx(query2);
//						if (rs2.next())
//						{
//							fromEmail = rs2.getString("email");
//						}
//						rs2.close();
//
//						if (fromEmail == null || fromEmail.length() == 0)
//						{
//							Diagnostics.warning("Could not find a email address for current user, contact_id = "
//									+ user.getContactID());
//							fromEmail = from;
//						}
						// at the moment only want to say ServiceTrax instead of user who created or updated
//						fromEmail = "david.zhao@apexit.com";

						String job_no = rs.getString("job_no");
						String service_no = rs.getString("service_no");
						String customer_name = rs.getString("customer_name");
						String job_name = rs.getString("job_name");
						String job_location_name = rs.getString("job_location_name");
						String est_start_date = rs.getString("start_date");
						Date start_time = rs.getDate("start_time");
						String est_start_time = ic.format(start_time, "time");
						String message = "Job #: " + StringUtil.isNull(job_no, "None")
						               + "\nReq #: " + StringUtil.isNull(service_no, "None")
						               + "\nCustomer Name: " + StringUtil.isNull(customer_name, "None")
						               + "\nJob Name: " + StringUtil.isNull(job_name, "None")
						               + "\nJob Location: " + StringUtil.isNull(job_location_name, "None")
						               + "\nEstimated Start Date: " + StringUtil.isNull(est_start_date, "None")
						               + "\nEstimated Start Time: " + StringUtil.isNull(est_start_time, "None")
						               + "\n\nDescription:\n" + StringUtil.isNull(rs.getString("description"), "None");

						Diagnostics.debug2("to:" + emailList + " from:" + from + " message:" + message);

                        String subject = IMSUtil.formatEmailSubject(customer_name, job_name);
						String to_email = emailList.toString();
						String testEmail = (String)ic.getAppGlobalDatum("testEmail");
						if (StringUtil.hasAValue(testEmail ))
						{
							subject = to_email + ":" + subject;
							to_email = testEmail;
						}

						MailSender ms = new MailSender(to_email, from, subject, new java.util.Date(),
								message.toString());
						ms.setServerInfo(host, port);
						ms.send();
					}
					else
					{
						Diagnostics.error("No rows returned!");
					}
					rs.close();
				}
				else
				{
					Diagnostics.warning("No emails are being sent out for this requisition");
				}
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ReqHandler action=newReq, send email failed.");
		}
		finally
		{
			if (conn != null)
				conn.release();
		}
		Diagnostics.debug2("ReqHandler completed the email.");

		return result;
	}

	private void addContactToEmailList(String contactID, StringBuffer emailList, ConnectionWrapper conn) throws Exception
	{
		String emailAddress = conn.queryEx("SELECT email FROM contacts WHERE contact_id = " + conn.toSQLString(contactID));
		if (emailAddress != null && emailAddress.length() > 0)
		{
			if (emailList.length() == 0)
			{
				emailList.append(emailAddress);
			}
			else
			{
				emailList.append(";").append(emailAddress);
			}
		}
	}

}
