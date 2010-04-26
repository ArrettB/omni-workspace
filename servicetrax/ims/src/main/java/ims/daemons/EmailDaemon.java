package ims.daemons;

import java.io.File;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.ApplicationContext;
import dynamic.intraframe.engine.BaseApplicationContext;
import dynamic.intraframe.engine.Daemon;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.mail.MailSender;
import dynamic.util.resources.ResourceManager;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;

/**
 * Send the queued e-mail.
 * 
 * @version $Header: EmailDaemon.java, 14, 4/4/2006 4:50:25 PM, Blake Von Haden$
 */
public class EmailDaemon implements Daemon
{
	private ResourceManager resourceManager = null;
	private String name = null;
	private Thread tid = null;

	private String host;
	private String port;
	private java.util.Date lastRun;
	private int messagesSent;
	
	private String testEmail;

	private final static int SLEEP_TIME = 2 * 60 * 1000; // every 2 minutes

	/**
	 * Initializer called by iFrame when running as an iFrame Daemon. Diagnostics and ResourceManager are already initialized.
	 */
	public void initialize(ApplicationContext ac, String name) throws Exception
	{
		Diagnostics.trace("EmailDaemon.initialize(ac,\"" + name + "\")");
		this.name = name;
		this.resourceManager = ((BaseApplicationContext) ac).getResourceManager();
		Document d = ac.getConfigDocument();
		testEmail = (String)ac.getAppGlobalDatum("testEmail");
		initialize(d);
	}

	/**
	 * Initializer called by main() method when running standalone. Needs to initialize Diagnostics and ResourceManager manually.
	 */
	public void initialize(String path, String name) throws Exception
	{
		Diagnostics.trace("EmailDaemon.initialize(\"" + path + "\",\"" + name + "\")");
		this.name = name;
		Document d = XMLUtils.parse(new File(path));
		Element diagnosticsElement = XMLUtils.getSingleElement(d, "diagnostics");
		if (diagnosticsElement != null)
		{
			Diagnostics.initialize(diagnosticsElement);
		}
		Element resourceManagerElement = XMLUtils.getSingleElement(d, "resourceManager");
		if (resourceManagerElement != null)
		{
			String className = resourceManagerElement.getAttribute("class");
			resourceManager = (ResourceManager) Class.forName(className).newInstance();
			resourceManager.initialize(resourceManagerElement);
		}
		initialize(d);
	}

	/**
	 * Internal initialize method
	 */
	protected void initialize(Document d) throws Exception
	{
		messagesSent = 0;
		host = XMLUtils.getValue(d, "mail:host").trim();
		port = XMLUtils.getValue(d, "mail:port").trim();

	}

	private void sendTrackingEmails(ConnectionWrapper conn) throws Exception
	{
		Diagnostics.debug("EmailDaemon.sendTrackingEmails()");
		QueryResults rs = conn.resultsQueryEx("SELECT type, tracking_id, notes, to_email, from_email, job_no, record_no, job_name, date_created FROM pending_tracking_v");
		while (rs.next())
		{
			String type = rs.getString("type");
			String to_email = rs.getString("to_email");
			String from_email = rs.getString("from_email");
			String trackingID = rs.getString("tracking_id");

			Diagnostics.debug("Sending Email to: '" + to_email + "', from: '" + from_email + "'");

			StringBuffer message = new StringBuffer();
			message.append("There has been a tracking note added.\n");
			message.append("Job No: ").append(rs.getString("job_no")).append("\n");
			message.append("Job Name: ").append(rs.getString("job_name")).append("\n");
			if (StringUtil.hasAValue(type) && type.equalsIgnoreCase("invoice"))
				message.append("Invoice No: ").append(rs.getString("record_no")).append("\n");
			else
				// must be a tracking note or PDA note instead
				message.append("Service No: ").append(rs.getString("record_no")).append("\n");

			message.append("Date: ").append(rs.getString("date_created")).append("\n");
			message.append("\n");
			message.append(rs.getString("notes")).append("\n");
			;

			if (!StringUtil.hasAValue(from_email))
			{
				from_email = "serviceTRAX@omniworkspace.com";
				message.insert(0, "Note: the user who sent this message does not have an email address in the system you cannot reply to them using this message.\n\n");
			}
			if (!StringUtil.hasAValue(to_email))
			{
				to_email = from_email;
				message.insert(0, "Error: the contact you selected does not have an email address.  Please correct the contact on your tracking note and Save again to resend.\n\n");
			}
			
			String subject = "ServiceTRAX Alert";
			if (StringUtil.hasAValue(testEmail))
			{
				subject = to_email + ":" + subject;
				to_email = testEmail;
			}

			MailSender ms = new MailSender(to_email, from_email, subject, new java.util.Date(), message.toString());
			ms.setServerInfo(host, port);
			ms.send();
			messagesSent++;
			if (StringUtil.hasAValue(type) && type.equalsIgnoreCase("invoice"))
				conn.updateExactlyEx("UPDATE invoice_tracking SET email_sent_flag = 'Y' WHERE invoice_tracking_id = "
						+ conn.toSQLString(trackingID), 1);
			else
				conn.updateExactlyEx("UPDATE tracking SET email_sent_flag = 'Y' WHERE tracking_id = "
						+ conn.toSQLString(trackingID), 1);
		}
		rs.close();
	}

	private void sendExtranetEmails(ConnectionWrapper conn) throws Exception
	{
		Diagnostics.debug("EmailDaemon.sendExtranetEmails()");
		QueryResults rs = conn.select("SELECT email_id, from_email, to_email, subject, body FROM emails WHERE email_sent_flag = 'N'");
		while (rs.next())
		{
			String to_email = rs.getString("to_email");
			String subject = rs.getString("subject");
			if (StringUtil.hasAValue(testEmail))
			{
				subject = to_email + ":" + subject;
				to_email = testEmail;
			}
			
			MailSender ms = new MailSender(to_email, rs.getString("from_email"), subject,
					new java.util.Date(), rs.getString("body"));
			ms.setServerInfo(host, port);
			ms.send();
			conn.update("UPDATE emails SET email_sent_flag = 'Y' WHERE email_id = ?", rs.getString("email_id"));
		}
		rs.close();
	}

	private void removePDADistributions(ConnectionWrapper conn) throws Exception
	{
		Diagnostics.debug("EmailDaemon.removePDADistributions()");
		int rows = conn.updateEx("DELETE FROM job_distributions WHERE remove_date < getDate()");
		Diagnostics.debug("Removed (" + rows + ") from job_distributions that have expired.");
	}

	/**
	 * Shut down and destroy the Daemon (cleanup)
	 */
	public void destroy()
	{
		Diagnostics.trace("EmailDaemon.destroy()");
		stop();
	}

	/**
	 * The name of the Daemon
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * Show information about this Daemon
	 */
	public String toHTML(String href, boolean showDetail)
	{
		Diagnostics.trace("EmailDaemon.toHTML()");
		if (true)
		// if (showDetail)
		{
			StringBuffer result = new StringBuffer();
			result.append("<table>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Host</font></td>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">").append(host).append("</font></td>");
			result.append("</tr>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Port</font></td>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">").append(port).append("</font></td>");
			result.append("</tr>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Messages Sent</font></td>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">").append(messagesSent).append("</font></td>");
			result.append("</tr>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Last Run</font></td>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">").append(lastRun).append("</font></td>");
			result.append("</tr>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">Sleep Time (seconds)</font></td>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\">").append(SLEEP_TIME / 1000).append("</font></td>");
			result.append("</tr>");
			result.append("</table>");
			return result.toString();
		}
		else
		{
			StringBuffer result = new StringBuffer();
			result.append("<table>");
			result.append("<tr>");
			result.append("<td bgcolor=\"#DCDCDC\"><font size=\"1\"><a href=\"" + href);
			result.append("&daemon=" + getName());
			result.append("\">" + getName() + "</a></font></td>");
			result.append("</tr>");
			result.append("</table");
			return result.toString();
		}
	}

	/**
	 * Start the Daemon
	 */
	public void start()
	{
		Diagnostics.trace("EmailDaemon.start()");
		tid = new Thread(this, name);
		Diagnostics.registerThread(tid);
		tid.start();
	}

	/**
	 * Stop the Daemon gracefully
	 */
	public void stop()
	{
		Diagnostics.trace("EmailDaemon.stop()");
		if (tid == null)
			return;
		Thread tmp = tid;
		tid = null;
		tmp.interrupt();
	}

	/**
	 * Run the Daemon (the main loop)
	 */
	public void run()
	{
		try
		{
			Diagnostics.trace("EmailDaemon.run() starting");
			while (tid == Thread.currentThread())
			{
				lastRun = new java.util.Date();
				Diagnostics.trace("EmailDaemon.run()");
				ConnectionWrapper conn = null;
				try
				{
					conn = (ConnectionWrapper) resourceManager.getResource();
					sendTrackingEmails(conn);
					sendExtranetEmails(conn);
					removePDADistributions(conn);
				}
				catch (Exception e)
				{
					Diagnostics.error("Exception in EmailDaemon", e);
				}
				finally
				{
					try
					{
						conn.release(true);
					}
					catch (Exception e)
					{
					} // throw away
				}

				try
				{
					Diagnostics.trace("EmailDaemon is sleeping for " + SLEEP_TIME / 1000 + " seconds...");
					Thread.sleep(SLEEP_TIME);
				}
				catch (InterruptedException ie)
				{
					Diagnostics.debug("Sleep interrupted");
				}
			}
		}
		catch (Throwable t)
		{
			Diagnostics.error("Exception in EmailDaemon", t);
		}

		Diagnostics.debug("EmailDaemon() complete");
	}

}
