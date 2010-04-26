package ims.handlers.job_processing;

import ims.dataobjects.User;

import org.w3c.dom.Document;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.mail.MailSender;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;

/**
 * A handler to send emails.
 * 
 * @version $Id: EmailHandler.java, 13, 1/20/2006 3:21:49 PM, Blake Von Haden$
 */
public class EmailHandler extends BaseHandler
{
	private String host;
	private String port;

	public void setUpHandler() throws Exception
	{
		Diagnostics.debug2("EmailHandler.setUpHandler()");
		Document d = getConfigDocument();
		host = XMLUtils.getValue(d, "mail:host").trim();
		port = XMLUtils.getValue(d, "mail:port").trim();
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("EmailHandler.handleEnvironment()");
		boolean result = true;
		ConnectionWrapper conn = null;

		try
		{
			String mode = (String) ic.getParameter(SmartFormComponent.MODE);
			String button = (String) ic.getParameter(SmartFormComponent.BUTTON);

			if (mode.equalsIgnoreCase(SmartFormComponent.Insert) && button.equalsIgnoreCase(SmartFormComponent.Save))
			{
				conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
				Diagnostics.debug2("Attempting to send email...");

				User user = (User) ic.getSessionDatum("user");
				String from_email = null;
				StringBuffer query = new StringBuffer();
				query.append("SELECT email ");
				query.append("FROM contacts ");
				query.append("WHERE contact_id = ").append(conn.toSQLString("" + user.getContactID()));
				Diagnostics.debug2("Query = " + query.toString());

				QueryResults rs = conn.resultsQueryEx(query);
				if (rs.next())
				{
					from_email = rs.getString("email");
				}
				rs.close();

				String to_contact_id = (String) ic.getRequiredParameter("to_contact_id");

				query = new StringBuffer();
				query.append("SELECT c.email to_email, c.contact_name to_name, j.job_no ");
				query.append("FROM contacts c");
				query.append("WHERE c.contact_id = ").append(conn.toSQLString(to_contact_id));

				Diagnostics.debug2("Query = " + query.toString());

				rs = conn.resultsQueryEx(query);
				if (rs.next())
				{
					String to_email = rs.getString("to_email");
					String to_name = rs.getString("to_name");
					String subject = "ServiceTRAX Alert";

					String message = "[ ServiceTRAX Alert to " + to_name + " ]\n\n" + (String) ic.getRequiredParameter("notes");

					String testEmail = (String)ic.getAppGlobalDatum("testEmail");
					if (StringUtil.hasAValue(testEmail))
					{
						subject = to_email + ":" + subject;
						to_email = testEmail;
					}

					MailSender ms = new MailSender(to_email, from_email, subject, new java.util.Date(), message.toString());
					ms.setServerInfo(host, port);
					ms.send();
				}
				else
				{
					Diagnostics.error("No rows returned!");
				}
				rs.close();
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in EmailHandler action=newJob, send email failed.");
		}
		finally
		{
			// because this is a Pre/PostHandler, we do NOT release the connection

			Diagnostics.debug2("EmailHandler completed the email.");
		}
		return result;

	}
}
