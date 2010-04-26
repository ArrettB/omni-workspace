package ims.daemons;

import ims.helpers.MapUtil;

import java.io.File;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.ApplicationContext;
import dynamic.intraframe.engine.BaseApplicationContext;
import dynamic.intraframe.engine.Daemon;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.mail.MailSender;
import dynamic.util.resources.ResourceManager;
import dynamic.util.xml.XMLUtils;

/**
 * @version $Id: StatusDaemon.java, 12, 3/27/2006 5:42:18 PM, Blake Von Haden$
 */
public class StatusDaemon implements Daemon
{
	private ResourceManager resourceManager = null;
	private String name = null;
	private Thread tid = null;
	private java.util.Date lastRun;
	private static Map workorderStatusTypes;
	private static Map jobStatusTypes;
	private static Map serviceStatusTypes;
	private String emailHost;
	private String emailPort;
	private String emailFrom;

	private final static int SLEEP_TIME = 1 * 60 * 60 * 1000; // every 1 hour
	
	public static final String SET_SCHEDULED_STATUS
		= "UPDATE requests SET request_status_type_id = ? " 
		+ "  FROM requests r INNER JOIN "
		+ "       request_vendors rv WITH (NOLOCK) ON r.request_id = rv.request_id "
		+ " WHERE r.request_status_type_id <> ? "
		+ "   AND r.request_status_type_id <> ? "
		+ "   AND r.request_status_type_id <> ? "
		+ "   AND r.request_status_type_id <> ? "
		+ "   AND rv.sch_start_date IS NOT NULL";
	
	public static final String SET_INSTALL_COMPLETE_STATUS
		= "UPDATE requests SET request_status_type_id = ? " 
		+ "  FROM requests r INNER JOIN "
		+ "       request_vendors rv WITH (NOLOCK) ON r.request_id = rv.request_id "
		+ " WHERE r.request_status_type_id <> ? "
		+ "   AND r.request_status_type_id <> ? "
		+ "   AND r.request_status_type_id <> ? "
		+ "   AND rv.act_end_date IS NOT NULL "
		+ "   AND rv.act_end_date < getdate()";
	
	public static final String SET_INVOICED_STATUS
		= "UPDATE requests SET request_status_type_id = ? " 
		+ "  FROM requests r INNER JOIN "
		+ "       request_vendors rv WITH (NOLOCK) ON r.request_id = rv.request_id "
		+ " WHERE r.request_status_type_id <> ? "
		+ "   AND r.request_status_type_id <> ? "
		+ "   AND rv.invoice_date IS NOT NULL";
	
	public static final String UPDATE_PENDING_JOBS
	 	= "UPDATE jobs "
		+ "   SET job_status_type_id = ? " 
		+ " WHERE job_id IN (SELECT DISTINCT job_id FROM job_services_v WHERE service_id is NOT NULL) "
		+ "   AND job_status_type_id <> ? " 
		+ "   AND job_status_type_id <> ? " 
		+ "   AND (getDate() < ALL (SELECT est_start_date FROM services s WHERE s.job_id = jobs.job_id) "
		+ "        OR (getDate() >= ANY (SELECT est_start_date FROM services s WHERE s.job_id = jobs.job_id) "
		+ "            AND CONVERT(VARCHAR(12), getDate(), 101) <= ANY (SELECT ISNULL(est_end_date,'01/01/2020') FROM services s WHERE s.job_id = jobs.job_id) "
		+ "            AND ? <> ANY (SELECT serv_status_type_id FROM services WHERE jobs.job_id = services.job_id)"
		+ "            AND ? <> ALL (SELECT serv_status_type_id FROM services WHERE jobs.job_id = services.job_id))) "
		+ " OPTION (MAXDOP 1)";


	/**
	 * Initializer called by iFrame when running as an iFrame Daemon. Diagnostics and ResourceManager are already initialized.
	 */
	public void initialize(ApplicationContext ac, String name) throws Exception
	{
		Diagnostics.trace("StatusDaemon.initialize(ac,\"" + name + "\")");
		this.name = name;
		this.resourceManager = ((BaseApplicationContext) ac).getResourceManager();
		Document d = ac.getConfigDocument();
		initialize(d);

	}

	/**
	 * Initializer called by main() method when running standalone. Needs to initialize Diagnostics and ResourceManager manually.
	 */
	public void initialize(String path, String name) throws Exception
	{
		Diagnostics.trace("StatusDaemon.initialize(\"" + path + "\",\"" + name + "\")");
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
		ConnectionWrapper conn = null;
		if (workorderStatusTypes == null || jobStatusTypes == null) {
			try	{
				conn = (ConnectionWrapper) resourceManager.getResource();
				
				if (workorderStatusTypes == null) {
					workorderStatusTypes = MapUtil.getTypeMap(conn, "workorder_status_type");
				}
				
				if (jobStatusTypes == null) {
					jobStatusTypes = MapUtil.getTypeMap(conn, "job_status_type");
				}
				
				if (serviceStatusTypes == null) {
					serviceStatusTypes = MapUtil.getTypeMap(conn, "service_status_type");
				}
				
			} catch (Exception e) {
				Diagnostics.error("Exception in StatusDaemon.initialize Status Maps", e);
			} finally {
				try	{
					if (conn != null) conn.release(true);
				} catch (Exception e) {
				} // throw away
			}
		}
		emailHost = XMLUtils.getValue(d, "mail:host").trim();
		emailPort = XMLUtils.getValue(d, "mail:port").trim();
		emailFrom = XMLUtils.getValue(d, "mail:from").trim();
	}

	private void updateStatuses(ConnectionWrapper conn) throws Exception
	{
		Diagnostics.debug("StatusDaemon.updateStatuses()");
		StringBuffer update = new StringBuffer();
		int count = 0;

		// if current request status <> "Install Complete" nor "Invoiced" nor "Closed"
		// AND all request vendors have a schedule start date
		// then set the request status to "Scheduled"
		count = setStatusScheduled(conn, (String) workorderStatusTypes.get("scheduled"), (String) workorderStatusTypes.get("install_complete"), (String) workorderStatusTypes.get("invoiced"), (String) workorderStatusTypes.get("closed"));
		Diagnostics.debug3("Updated " + count + " request records to status of 'scheduled'");

		// if current request status <> "Invoiced" nor "Closed" AND all the request vendor have an act_end_date
		// AND today is the day after all the request vendors' actual end dates
		// then set the request status to "Install Complete"
		count = setStatusInstallComplete(conn, (String) workorderStatusTypes.get("install_complete"), (String) workorderStatusTypes.get("invoiced"), (String) workorderStatusTypes.get("closed"));
		Diagnostics.debug3("Updated " + count + " request records to status of 'install_complete'");

		// if current request status <> "Closed" AND all request vendors have an invoice date
		// then set the request status to "Invoiced"
		count = setStatusInvoiced(conn, (String) workorderStatusTypes.get("invoiced"), (String) workorderStatusTypes.get("closed"));
		Diagnostics.debug3("Updated " + count + " request records to status of 'invoiced'");


		// if current req status <> "Fully Scheduled", if current req status <> "Closed"
		// if today is before the start date of the req, if there is at least one person scheduled to the req
		// then set the req status to "Pending"
		update.setLength(0);
		update.append("UPDATE services");
		update.append(" SET services.serv_status_type_id = " + conn.toSQLString((String) serviceStatusTypes.get("pending")));
		update.append(" WHERE services.serv_status_type_id <> " + conn.toSQLString((String) serviceStatusTypes.get("closed")));
		update.append(" AND services.serv_status_type_id <> "
				+ conn.toSQLString((String) serviceStatusTypes.get("fully_scheduled")));
		update.append(" AND services.serv_status_type_id <> " + conn.toSQLString((String) serviceStatusTypes.get("pending")));
		update.append(" AND getDate() < services.est_start_date");
		update.append(" AND services.service_id in (SELECT distinct service_id FROM sch_resources)");
		count = conn.updateEx(update);
		Diagnostics.debug3("Updated " + count + " service records to status of pending");

		// if current req status <> "Closed", if today >= start date of the req,
		// if today <= end date of the req, if there is no end date on the service, default '01/01/2020'
		// then set the req status to "In Progress"
		update.setLength(0);
		update.append("UPDATE services");
		update.append(" SET services.serv_status_type_id = " + conn.toSQLString((String) serviceStatusTypes.get("in_progress")));
		update.append(" WHERE services.serv_status_type_id <> " + conn.toSQLString((String) serviceStatusTypes.get("closed")));
		update.append(" AND services.serv_status_type_id <> " + conn.toSQLString((String) serviceStatusTypes.get("in_progress")));
		update.append(" AND getDate() >= est_start_date");
		update.append(" AND convert(varchar(12), getDate(), 101) <= ISNULL(est_end_date,'01/01/2020')");
		count = conn.updateEx(update);
		Diagnostics.debug3("Updated " + count + " service records to status of in_progress");

		// if current req status <> "Closed", if current req status <> "Invoiced",
		// if today > end date of the req, if there is no end date on the service, default '01/01/2020'
		// then set the req status to "Install Complete"
		update.setLength(0);
		update.append("UPDATE services");
		update.append(" SET services.serv_status_type_id = "
				+ conn.toSQLString((String) serviceStatusTypes.get("install_complete")));
		update.append(" WHERE services.serv_status_type_id <> " + conn.toSQLString((String) serviceStatusTypes.get("closed")));
		update.append(" AND services.serv_status_type_id <> " + conn.toSQLString((String) serviceStatusTypes.get("invoiced")));
		update.append(" AND services.serv_status_type_id <> "
				+ conn.toSQLString((String) serviceStatusTypes.get("install_complete")));
		update.append(" AND convert(varchar(12), getDate(), 101) > ISNULL(est_end_date,'01/01/2020')");
		count = conn.updateEx(update);
		Diagnostics.debug3("Updated " + count + " service records to status of install_complete");

		// if current req status is "Install Complete"
		// if all time captured lines have been "Posted" for the req, if all invoices have been sent to great plains
		// then set req status to "Invoiced"
		update.setLength(0);
		update.append("UPDATE services");
		update.append(" SET services.serv_status_type_id = " + conn.toSQLString((String) serviceStatusTypes.get("invoiced")));
		update.append(" WHERE services.job_id in (SELECT DISTINCT iv.job_id FROM invoices_v iv)");
		update.append(" AND services.serv_status_type_id = "
				+ conn.toSQLString((String) serviceStatusTypes.get("install_complete")));
		update.append(" AND services.service_id in (");
		update.append(" SELECT DISTINCT bill_service_id FROM (");
		update.append(" SELECT slb.bill_service_id FROM service_lines slb UNION SELECT slt.tc_service_id FROM service_lines slt) x)");
		update.append(" AND services.service_id not in (SELECT DISTINCT slv.bill_service_id FROM service_lines slv WHERE slv.status_id < 5)");
		count = conn.updateEx(update);
		Diagnostics.debug3("Updated " + count + " service records to status of invoiced");

		// HANDLE JOB STATUSES

		// if the job has at least one service, if current job status <> "Closed", if current job status <> "fully_scheduled",
		// if today is before the start date of all requisitions, if all the job's reqs are not "closed"
		// then set the job status to "pending
//		update.setLength(0);
//		update.append("UPDATE jobs");
//		update.append(" SET jobs.job_status_type_id = " + conn.toSQLString((String) jobStatusTypes.get("pending")));
//		update.append(" WHERE jobs.job_id in (SELECT distinct job_id FROM job_services_v WHERE service_id is not null)");
//		update.append(" AND jobs.job_status_type_id <> " + conn.toSQLString((String) jobStatusTypes.get("closed")));
//		update.append(" AND jobs.job_status_type_id <> " + conn.toSQLString((String) jobStatusTypes.get("fully_scheduled")));
//		update.append(" AND ");
//		update.append(" (getDate() < ALL (SELECT est_start_date FROM services s WHERE s.job_id = jobs.job_id)");
//		update.append("  OR ");
//		update.append("  (getDate() >= ANY (SELECT est_start_date FROM services s WHERE s.job_id = jobs.job_id)");
//		update.append("   AND convert(varchar(12), getDate(), 101) <= ANY (SELECT ISNULL(est_end_date,'01/01/2020') FROM services s WHERE s.job_id = jobs.job_id)");
//		update.append("   AND " + conn.toSQLString((String) serviceStatusTypes.get("in_progress"))
//				+ " != ANY (SELECT serv_status_type_id FROM services WHERE jobs.job_id = services.job_id)");
//		update.append("   AND " + conn.toSQLString((String) serviceStatusTypes.get("closed"))
//				+ " != ALL (SELECT serv_status_type_id FROM services WHERE jobs.job_id = services.job_id)");
//		update.append("  )");
//		update.append(" )");
//		count = conn.updateEx(update);
		count = setPendingJobStatus(conn);
		Diagnostics.debug3("Updated " + count + " job records to status of pending");

		// if the job has at least one service, if current job status <> "Closed", if today >= start date of any of the job's
		// requisitions,
		// if today <= end date of any of the job's requisitions, if there is no end date on a service, default '01/01/2020'
		// then set the job status to "In Progress"
		update.setLength(0);
		update.append("UPDATE jobs");
		update.append(" SET jobs.job_status_type_id = " + conn.toSQLString((String) jobStatusTypes.get("in_progress")));
		update.append(" WHERE jobs.job_id in (SELECT distinct job_id FROM job_services_v WHERE service_id is not null)");
		update.append(" AND jobs.job_status_type_id <> " + conn.toSQLString((String) jobStatusTypes.get("closed")));
		update.append(" AND getDate() >= ANY (SELECT est_start_date FROM services s WHERE s.job_id = jobs.job_id)");
		update.append(" AND convert(varchar(12), getDate(), 101) <= ANY (SELECT ISNULL(est_end_date,'01/01/2020') FROM services s WHERE s.job_id = jobs.job_id)");
		update.append(" AND " + conn.toSQLString((String) serviceStatusTypes.get("in_progress"))
				+ " = ANY (SELECT serv_status_type_id FROM services WHERE jobs.job_id = services.job_id)");
		count = conn.updateEx(update);
		Diagnostics.debug3("Updated " + count + " job records to status of in_progress");

		// if the job has at least one service, if current job status <> "Closed",
		// if today > end date of all of the job's requisitions, if there is no end date on a service, default '01/01/2020'
		// then set the job status to "Install Complete"
		update.setLength(0);
		update.append("UPDATE jobs");
		update.append(" SET jobs.job_status_type_id = " + conn.toSQLString((String) jobStatusTypes.get("install_complete")));
		update.append(" WHERE jobs.job_id in (SELECT job_id FROM job_services_v WHERE service_id is not null)");
		update.append(" AND jobs.job_status_type_id <> " + conn.toSQLString((String) jobStatusTypes.get("closed")));
		update.append(" AND jobs.job_status_type_id <> " + conn.toSQLString((String) jobStatusTypes.get("invoiced")));
		update.append(" AND convert(varchar(12), getDate(), 101) > ALL (SELECT ISNULL(est_end_date,'01/01/2020') FROM services s WHERE s.job_id = jobs.job_id)");
		count = conn.updateEx(update);
		Diagnostics.debug3("Updated " + count + " job records to status of install_complete");

		// if the job has at least one invoice, if current job status <> "Closed", if current job status is "Install Complete",
		// if all time captured lines have been "Posted", if all invoices have been sent to great plains
		// then set job_status to "Invoiced"
		update.setLength(0);
		update.append("UPDATE jobs");
		update.append(" SET jobs.job_status_type_id = " + conn.toSQLString((String) jobStatusTypes.get("invoiced")));
		update.append(" WHERE jobs.job_id in (SELECT DISTINCT iv.job_id FROM invoices_v iv)");
		update.append(" AND jobs.job_status_type_id <> " + conn.toSQLString((String) jobStatusTypes.get("closed")));
		update.append(" AND jobs.job_status_type_id = " + conn.toSQLString((String) jobStatusTypes.get("install_complete")));
		update.append(" AND jobs.job_id not in (SELECT DISTINCT slv.bill_job_id job_id FROM service_lines slv WHERE slv.status_id < 5)");
		update.append(" AND jobs.job_id not in (SELECT DISTINCT iv.job_id FROM invoices_v iv WHERE iv.status_id < 4)");
		count = conn.updateEx(update);
		Diagnostics.debug3("Updated " + count + " job records to status of invoiced");
	}

	/**
	 * Shut down and destroy the Daemon (cleanup)
	 */
	public void destroy()
	{
		Diagnostics.trace("StatusDaemon.destroy()");
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
		Diagnostics.trace("StatusDaemon.toHTML()");
		if (true)
		// if (showDetail)
		{
			StringBuffer result = new StringBuffer();
			result.append("<table>");
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
		Diagnostics.trace("StatusDaemon.start()");
		tid = new Thread(this, name);
		Diagnostics.registerThread(tid);
		tid.start();
	}

	/**
	 * Stop the Daemon gracefully
	 */
	public void stop()
	{
		Diagnostics.trace("StatusDaemon.stop()");
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
			Diagnostics.trace("StatusDaemon.run() starting");
			while (tid == Thread.currentThread())
			{
				lastRun = new java.util.Date();
				Diagnostics.trace("StatusDaemon.run()");
				ConnectionWrapper conn = null;
				try
				{
					conn = (ConnectionWrapper) resourceManager.getResource();
					updateStatuses(conn);
				}
				catch (Exception e)
				{
					Diagnostics.error("Exception in StatusDaemon", e);
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
					Diagnostics.trace("StatusDaemon is sleeping for " + SLEEP_TIME / 1000 + " seconds...");
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
			Diagnostics.error("Exception in StatusDaemon", t);
		}

		Diagnostics.debug("StatusDaemon() complete");
	}
	
	private int setStatusScheduled(ConnectionWrapper conn, String scheduledStatusId, String installCompleteStatusId, String invoicedStatusId, String closedStatusId) throws Exception {
		PreparedStatement stmt = null;
		int updated = 0;
		try {
			stmt = conn.prepareStatement(SET_SCHEDULED_STATUS);

			stmt.setString(1, scheduledStatusId);
			stmt.setString(2, scheduledStatusId);
			stmt.setString(3, installCompleteStatusId);
			stmt.setString(4, invoicedStatusId);
			stmt.setString(5, closedStatusId);
	
			updated = stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception in StatusDaemon.setStatusScheduled:" + e);
			String errorMsg = new SimpleDateFormat("MM/dd/yyyy h:mm:ss a").format(new Date()) + ": Exception in StatusDaemon.setStatusScheduled:" + e.getLocalizedMessage();
			sendMail(errorMsg);
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return updated;
	}
	
	private int setStatusInstallComplete(ConnectionWrapper conn, String installCompleteStatusId, String invoicedStatusId, String closedStatusId) throws Exception {
		PreparedStatement stmt = null;
		int updated = 0;
		try {
			stmt = conn.prepareStatement(SET_INSTALL_COMPLETE_STATUS);

			stmt.setString(1, installCompleteStatusId);
			stmt.setString(2, installCompleteStatusId);
			stmt.setString(3, invoicedStatusId);
			stmt.setString(4, closedStatusId);
	
			updated = stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception in StatusDaemon.setStatusInstallComplete:" + e);
			String errorMsg = new SimpleDateFormat("MM/dd/yyyy h:mm:ss a").format(new Date()) + ": Exception in StatusDaemon.setStatusInstallComplete:" + e.getLocalizedMessage();
			sendMail(errorMsg);
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return updated;
	}
	
	private int setStatusInvoiced(ConnectionWrapper conn, String invoicedStatusId, String closedStatusId) throws Exception {
		PreparedStatement stmt = null;
		int updated = 0;
		try {
			stmt = conn.prepareStatement(SET_INVOICED_STATUS);

			stmt.setString(1, invoicedStatusId);
			stmt.setString(2, invoicedStatusId);
			stmt.setString(3, closedStatusId);
	
			updated = stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception in StatusDaemon.setStatusInvoiced:" + e);
			String errorMsg = new SimpleDateFormat("MM/dd/yyyy h:mm:ss a").format(new Date()) + ": Exception in StatusDaemon.setStatusInvoiced:" + e.getLocalizedMessage();
			sendMail(errorMsg);
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return updated;
	}
	
	private int setPendingJobStatus(ConnectionWrapper conn) throws Exception {
		int count = 0;
		PreparedStatement stmt = null;
		
		try {
			stmt = conn.prepareStatement(UPDATE_PENDING_JOBS);
			stmt.setString(1, (String) jobStatusTypes.get("pending"));
			stmt.setString(2, (String) jobStatusTypes.get("closed"));
			stmt.setString(3, (String) jobStatusTypes.get("fully_scheduled"));
			stmt.setString(4, (String) serviceStatusTypes.get("in_progress"));
			stmt.setString(5, (String) serviceStatusTypes.get("closed"));
			
			count = stmt.executeUpdate();
			
		} catch (Exception e) {
			Diagnostics.error("Exception in StatusDaemon.setPendingJobStatus:" + e);
			String errorMsg = new SimpleDateFormat("MM/dd/yyyy h:mm:ss a").format(new Date()) + ": Exception in StatusDaemon.setPendingJobStatus:" + e.getLocalizedMessage();
			sendMail(errorMsg);
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return count;
		
	}
	
	private void sendMail(String message) throws Exception
	{
		Date now = new Date();
		String to = "david.zhao@apexit.com";
		String subject = "ServiceTRAX StatusDaemon Exception";
		MailSender ms = new MailSender(to, emailFrom, subject, now, message);
		ms.setServerInfo(emailHost, emailPort);
		ms.send();
	}

}