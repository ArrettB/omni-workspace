package ims.handlers.proj;

import ims.dataobjects.Contact;
import ims.helpers.IMSUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.w3c.dom.Document;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;

/**
 * Send out multiple e-mail messages to multiple people depending on what 
 * is being processed.
 * 
 * For example:
 * 
 * Create workorder
 * 	APPROVER_NOTIFY
 * 
 * Approve workorder
 *  CUSTOMER_WORKORDER_APPROVAL
 *	VENDOR_NOTIFY
 * 
 * 
 * Quote Request
 *  QR_SR_SENT
 * 
 * Quote Request new version
 *  VENDOR_NEW_VERSION
 * 
 * Service Request
 *  QR_SR_SENT
 *
 * Service Request new version
 *  VENDOR_NEW_VERSION
 *  SCHEDULER_NEW_VERSION
 * 
 * 
 * @version $Id: PDSEmailHandler.java, 1076, 2/27/2008 3:38:10 PM, David Zhao$
 */
public class PDSEmailHandler extends BaseHandler
{
	private static final String from = "ServiceTRAX@omniworkspace.com";
	private final static char NEWLINE = Character.LINE_SEPARATOR;

	private final static String A_M = "a_m_contact_id";
	private final static String A_M_SALES = "a_m_sales_contact_id";
	private final static String CUSTOMER = "customer_contact_id";
	private final static String CUSTOMER2 = "customer_contact2_id";
	private final static String CUSTOMER3 = "customer_contact3_id";
	private final static String CUSTOMER4 = "customer_contact4_id";
	private final static String APPROVER = "approver_contact_id";
	private final static String FURNITURE1 = "furniture1_contact_id";
	private final static String FURNITURE2 = "furniture2_contact_id";
	private final static String ALT_CUSTOMER = "alt_customer_contact_id";
	private final static String D_SALES_REP = "d_sales_rep_contact_id";
	private final static String D_SALES_SUP = "d_sales_sup_contact_id";
	private final static String D_PROJ_MGR = "d_proj_mgr_contact_id";
	private final static String D_DESIGNER = "d_designer_contact_id";
//	private final static String A_M_INSTALL_SUP = "a_m_install_sup_contact_id";
	private final static String A_D_DESIGNER = "a_d_designer_contact_id";
	private final static String GEN_CONTRACTOR = "gen_contractor_contact_id";
	private final static String ELECTRICIAN = "electrician_contact_id";
	private final static String DATA_PHONE = "data_phone_contact_id";
	private final static String PHONE = "phone_contact_id";
	private final static String CARPET_LAYER = "carpet_layer_contact_id";
//	private final static String BLDG_MGR = "bldg_mgr_contact_id";
//	private final static String SECURITY = "security_contact_id";
	private final static String MOVER = "mover_contact_id";
	private final static String OTHER = "other_contact_id";
	private final static String SCHEDULER = "scheduler_contact_id";


	public enum EmailTemplate {
		SENT(
				"To: ${contact_name} on ${todays_date}" + NEWLINE
				+ "A ${record_type_name} has been sent." + NEWLINE
				+ "Please use ServiceTRAX Extranet to review." + NEWLINE
				+ "Project #: ${project_no}" + NEWLINE
				+ "Request #: ${record_no}" + NEWLINE
				+ "Customer: ${customer_name}" + NEWLINE
				+ "End User: ${end_user_name}" + NEWLINE
				+ "Job Name: ${job_name}" + NEWLINE
                + "Quote Amount: $${quote_total}" + NEWLINE
				+ "Description: ${description}" + NEWLINE),
		QR_SR_SENT(
				"To: ${contact_name} on ${todays_date}" + NEWLINE
				+ "A ${record_type_name} has been sent." + NEWLINE
				+ "Please use ServiceTRAX Extranet to review." + NEWLINE
				+ "Project #: ${project_no}" + NEWLINE
				+ "Request #: ${record_no}" + NEWLINE
				+ "Customer: ${customer_name}" + NEWLINE
				+ "End User: ${end_user_name}" + NEWLINE
				+ "Job Name: ${job_name}" + NEWLINE
				+ "Est Start Date: ${est_start_date}" + NEWLINE
				+ "Description: ${description}" + NEWLINE),
		A_M_WORKORDER_QUOTE_REQUEST(
				"To: ${contact_name} on ${todays_date}" + NEWLINE
				+ "A ${record_type_name} Quote Request has been sent to you." + NEWLINE
				+ "Please use ServiceTRAX Extranet to review." + NEWLINE
				+ "Project #: ${project_no}" + NEWLINE
				+ "Workorder #: ${record_no}" + NEWLINE
				+ "Customer: ${customer_name}" + NEWLINE),
		APPROVER_NOTIFY(
				"To: ${contact_name} on ${todays_date}" + NEWLINE
				+ "A Workorder has been sent to you for approval." + NEWLINE
				+ "Project #: ${project_no}" + NEWLINE
				+ "Workorder #: ${record_no}" + NEWLINE
				+ "Description: ${description}" + NEWLINE
				+ "Requested By: ${customer_contact_name}" + NEWLINE
				+ "Est Start Date: ${est_start_date}" + NEWLINE),
		CUSTOMER_WORKORDER_REFUSAL(
				"To: ${contact_name} on ${todays_date}" + NEWLINE
        		+ "Your Workorder has been refused." + NEWLINE
        		+ "Project #: ${project_no}" + NEWLINE
        		+ "Workorder #: ${record_no}" + NEWLINE
        		+ "Reason For Refusal: ${refusal_reason}" + NEWLINE
        		+ "Appeal Policy: ${refusal_email_info}" + NEWLINE),
        CUSTOMER_WORKORDER_APPROVAL(
        		"To: ${contact_name} on ${todays_date}" + NEWLINE
        		+ "Your Workorder has been approved." + NEWLINE
        		+ "Project #: ${project_no}" + NEWLINE
        		+ "Workorder #: ${record_no}" + NEWLINE
        		+ "Description: ${description}" + NEWLINE
        		+ "You will be contacted concerning the work schedule." + NEWLINE),
        VENDOR_NOTIFY(
        		"To: ${contact_name} on ${todays_date}" + NEWLINE
        		+ "A Workorder has been sent to you." + NEWLINE
        		+ "Project #: ${project_no}" + NEWLINE
        		+ "Workorder #: ${record_no}" + NEWLINE
        		+ "Description: ${description}" + NEWLINE
        		+ "Approved by: ${approver_contact_name}" + NEWLINE
        		+ "Est Start Date: ${est_start_date}" + NEWLINE),
        CUSTOMER_NEW_SCHEDULE(
        		"To: ${contact_name} on ${todays_date}" + NEWLINE
        		+ "Scheduled dates have been added to your Workorder." + NEWLINE
        		+ "Project #: ${project_no}" + NEWLINE
        		+ "Workorder #: ${record_no}" + NEWLINE
        		+ "Description: ${description}" + NEWLINE
        		+ "Vendor: ${vendor_contact_name}" + NEWLINE
        		+ "Start Date: ${sch_start_date}" + NEWLINE),
        VENDOR_NEW_VERSION(
        		"To: ${contact_name} on ${todays_date}" + NEWLINE
        		+ "A new version of this request has been created." + NEWLINE
        		+ "Project #: ${project_no}" + NEWLINE
        		+ "Workorder #: ${record_no}" + NEWLINE
        		+ "Description: ${description}" + NEWLINE
        		+ "Customer: ${customer_name}" + NEWLINE
        		+ "Job Name: ${job_name}" + NEWLINE
        		+ "Est Start Date: ${est_start_date}" + NEWLINE),
        SCHEDULER_NEW_VERSION(
        		"To: ${contact_name} on ${todays_date}" + NEWLINE
        		+ "Scheduler: A new version of this request has been created." + NEWLINE
        		+ "Project #: ${project_no}" + NEWLINE
        		+ "Workorder #: ${record_no}" + NEWLINE
        		+ "Description: ${description}" + NEWLINE
        		+ "Customer: ${customer_name}" + NEWLINE
        		+ "Job Name: ${job_name}" + NEWLINE),
        CUSTOMER_SURVEY(
        		"To: ${contact_name} on ${todays_date}" + NEWLINE 
        		+ "Thank you for your business." + NEWLINE 
        		+ "Our goal is to provide you with high quality furniture installation, delivery, moving, warehouse and asset management services.  To ensure we continually improve, we would appreciate your input on the services we have provided you over the past year.  The survey takes only 5 to 10 minutes to complete. Your input will help us tailor our improvements to best fit your needs." 
        		+ NEWLINE + NEWLINE
        		+ "You can complete the survey either on-line or on paper." + NEWLINE + NEWLINE
        		+ "Clicking to the link below will get you to our customer survey form." + NEWLINE
        		+ "Responses to the survey questions are included in drop down menus adjacent" + NEWLINE + NEWLINE
        		+ "to each question.  We appreciate any additional comments you'd like to make and have included a space for these." + NEWLINE
        		+ "If you'd prefer, you can print the form, complete it long hand and mail it back" + NEWLINE
        		+ "to us (sorry, but we can't email you a self addressed stamped envelope)." + NEWLINE
        		+ "Our email address and our mailing address are included below for your convenience." + NEWLINE + NEWLINE
        		+ "As a thank you, we will make a contribution to the United Way for each response we receive.  Thanks for your time and feedback." + NEWLINE + NEWLINE
        		+ "Jim Wickoren" + NEWLINE
        		+ "jwickoren@ambis.com" + NEWLINE + NEWLINE
        		+ "A&M Business Interior Services" + NEWLINE
        		+ "1300 Washington Avenue North" + NEWLINE
        		+ "Minneapolis, MN  55411" + NEWLINE + NEWLINE);
		
		private final String msg;
		
		EmailTemplate(String msg)
		{
			this.msg = msg;
		}
		
		public String getMessage()
		{
			return msg;
		}
	
	}
	
	
	public static final String SELECT 
		= " SELECT convert(varchar(17), getDate(), 113) todays_date,"
		+ "        customer_name,"
		+ "        job_name,"
		+ "        project_no,"
		+ "        record_no,"
		+ "        record_id,"
		+ "        record_type_code,"
		+ "        record_type_name,"
		+ "        record_status_type_code,"
		+ "        isnull(refusal_email_info,'None') refusal_email_info,"
		+ "        customer_contact_name,"
		+ "        approver_contact_name,"
		+ "        ISNULL(description, '') description,"
		+ "        survey_location,"
		+ "        customer_contact_id,"
		+ "        furniture1_contact_id,"
		+ "        furniture2_contact_id,"
		+ "        a_m_contact_id,"
		+ "        approver_contact_id,"
		+ "        alt_customer_contact_id,"
		+ "        d_sales_rep_contact_id,"
		+ "        d_sales_sup_contact_id,"
		+ "        d_proj_mgr_contact_id,"
		+ "        d_designer_contact_id,"
		+ "        a_m_install_sup_contact_id,"
		+ "        a_d_designer_contact_id,"
		+ "        gen_contractor_contact_id,"
		+ "        electrician_contact_id,"
		+ "        data_phone_contact_id,"
		+ "        phone_contact_id,"
		+ "        carpet_layer_contact_id,"
		+ "        bldg_mgr_contact_id,"
		+ "        security_contact_id,"
		+ "        mover_contact_id,"
		+ "        other_contact_id,"
		+ "        scheduler_contact_id,"
		+ "       ? vendor_contact_name,"
		+ "       ? sch_start_date,"
		+ "       ISNULL(?, convert(varchar(10), est_start_date, 101)) est_start_date,"
		+ "       ISNULL(?,'None') refusal_reason,"
		+ "       is_new ";
	
	public static final String WHERE = " WHERE record_id = ? AND record_type_code = ?";
	
	public static final String QUOTE_SELECT_FROM
		= ", end_user_name, description, a_m_sales_contact_id, customer_contact2_id, customer_contact3_id, customer_contact4_id, quote_total "
		+ " FROM extranet_email_quote_v ";
	
	public static final String SELECT_QR_SR
		= "SELECT CONVERT(VARCHAR(17), getDate(), 113) todays_date, "
		+ "       customer_name,"
		+ "       end_user_name,"
		+ "       job_name,"
		+ "       ISNULL(description, '') description,"
		+ "       project_no,"
		+ "       record_no,"
		+ "       record_id,"
		+ "       record_type_code,"
		+ "       record_type_name,"
		+ "       record_status_type_code,"
		+ "       a_m_contact_id,"
		+ "       a_m_sales_contact_id,"
		+ "       customer_contact_id,"
		+ "       customer_contact2_id,"
		+ "       customer_contact3_id,"
		+ "       customer_contact4_id,"
		+ "       d_sales_rep_contact_id,"
		+ "       d_sales_sup_contact_id,"
		+ "       record_status_type_code,"
		+ "       d_designer_contact_id,"
		+ "       d_proj_mgr_contact_id,"
		+ "       scheduler_contact_id,"
		+ "       ? vendor_contact_name,"
		+ "       ? sch_start_date,"
		+ "       ISNULL(?, convert(varchar(10), est_start_date, 101)) est_start_date,"
		+ "       ISNULL(?,'None') refusal_reason,"
		+ "       is_new "
		+ "  FROM ";

	public static final String UPDATE_REQUEST_VENDORS
		= "UPDATE request_vendors SET emailed_date = getDate() WHERE request_id = ? AND vendor_contact_id= ?";
	
	private static Map<String, String> emailTemplates;
	private static String[] vendorContacts;

	public void setUpHandler() throws Exception	{
		Diagnostics.debug2("PDSEmailHandler.setUpHandler()");


		if (vendorContacts == null) {
			vendorContacts = new String[] { A_M, FURNITURE1, FURNITURE2, A_D_DESIGNER, GEN_CONTRACTOR, ELECTRICIAN, DATA_PHONE, PHONE,
					CARPET_LAYER, MOVER, OTHER };
		}

	}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic) throws Exception	{
		Diagnostics.trace("PDSEmailHandler.handleEnvironment()");
		
		ConnectionWrapper conn = null;
		boolean result = true;
		List<String> vendorContactList = new ArrayList<String>();	
		conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

		if (conn == null) {
			conn = (ConnectionWrapper) ic.getResource();
		}

		// IMPORTANT DATA BELOW
		String recordId = (String) ic.getTransientDatum("record_id");
		String record_type = (String) ic.getTransientDatum("record_type_code");
		String request_vendor_id = (String) ic.getTransientDatum("request_vendor_id");
		String vendor_contact_name = (String) ic.getTransientDatum("vendor_contact_name");
		String sch_start_date = (String) ic.getTransientDatum("sch_start_date");
		String est_start_date = ic.getParameter("est_start_date");
		if (est_start_date != null && est_start_date.length() == 0) est_start_date = null;
		String new_version = (String) ic.getTransientDatum("new_version");
		boolean is_new_version = false;
		if (StringUtil.hasAValue(new_version) && new_version.equalsIgnoreCase("true"))
			is_new_version = true;
		String survey = (String) ic.getTransientDatum("survey");
		boolean send_survey = false;
		if (StringUtil.hasAValue(survey) && survey.equalsIgnoreCase("true"))
			send_survey = true;
		String refusal_reason = ic.getParameter("refusal_reason");
		// IMPORTANT DATA ABOVE

		StringBuffer sch_message = null; // used for scheduler emails
		String query = null;
		
		if ("quote_request".equalsIgnoreCase(record_type) || "service_request".equalsIgnoreCase(record_type))
		{
			query = SELECT_QR_SR + "extranet_email_v2 " + WHERE;
		}
		else if ("quote".equalsIgnoreCase(record_type))
		{
			query = SELECT + QUOTE_SELECT_FROM + WHERE;
		}
		else
		{
			query = SELECT + "FROM extranet_email_none_quote_v " + WHERE;
		}

		Object[] params = new Object[] {vendor_contact_name, sch_start_date, est_start_date, refusal_reason, recordId, record_type};
		QueryResults rs = conn.select(query, params);

		if (rs.next())
		{// returned record of request or quote

			ic.setSessionDatum("project_no", rs.getString("project_no"));
			// Determine messages to send
			String record_type_code = rs.getString("record_type_code");
			String record_status_type_code = rs.getString("record_status_type_code");
			Hashtable<String,EmailTemplate> emails = new Hashtable<String,EmailTemplate>();

			if (StringUtil.hasAValue(record_type_code))
			{
				if (!record_type_code.equalsIgnoreCase("workorder"))
				{// is a service, quote request or a quote.

					if (is_new_version)
					{
						emails.put(D_SALES_REP, EmailTemplate.VENDOR_NEW_VERSION);
						emails.put(D_SALES_SUP, EmailTemplate.VENDOR_NEW_VERSION);
						emails.put(D_PROJ_MGR, EmailTemplate.VENDOR_NEW_VERSION);
						emails.put(D_DESIGNER, EmailTemplate.VENDOR_NEW_VERSION);
						emails.put(A_M, EmailTemplate.VENDOR_NEW_VERSION);
						if (is_new_version)
						{
							sch_message = emailSchedulerTest(ic, conn);
							if (sch_message != null)
								emails.put(SCHEDULER, EmailTemplate.SCHEDULER_NEW_VERSION);
						}
					}
					else if (record_type_code.equalsIgnoreCase("service_request"))
					{
						if ("Y".equalsIgnoreCase(rs.getString("is_new"))) {
							emails.put(A_M, EmailTemplate.QR_SR_SENT);
							emails.put(A_M_SALES, EmailTemplate.QR_SR_SENT);
							emails.put(CUSTOMER, EmailTemplate.QR_SR_SENT);
							emails.put(CUSTOMER2, EmailTemplate.QR_SR_SENT);
							emails.put(CUSTOMER3, EmailTemplate.QR_SR_SENT);
							emails.put(CUSTOMER4, EmailTemplate.QR_SR_SENT);
						} else {
							emails.put(D_SALES_REP, EmailTemplate.SENT);
							emails.put(D_SALES_SUP, EmailTemplate.SENT);
							emails.put(D_PROJ_MGR, EmailTemplate.SENT);
							emails.put(D_DESIGNER, EmailTemplate.SENT);
							emails.put(A_M, EmailTemplate.SENT);
						}
						
						if (is_new_version)
						{
							sch_message = emailSchedulerTest(ic, conn);
							if (sch_message != null)
								emails.put(SCHEDULER, EmailTemplate.SCHEDULER_NEW_VERSION);
						}
					}
					else if (record_type_code.equalsIgnoreCase("quote_request"))
					{
						if ("Y".equalsIgnoreCase(rs.getString("is_new"))) {
							emails.put(A_M, EmailTemplate.QR_SR_SENT);
							emails.put(A_M_SALES, EmailTemplate.QR_SR_SENT);
							emails.put(CUSTOMER, EmailTemplate.QR_SR_SENT);
							emails.put(CUSTOMER2, EmailTemplate.QR_SR_SENT);
							emails.put(CUSTOMER3, EmailTemplate.QR_SR_SENT);
							emails.put(CUSTOMER4, EmailTemplate.QR_SR_SENT);
						} else {
							emails.put(D_SALES_REP, EmailTemplate.SENT);
							emails.put(D_SALES_SUP, EmailTemplate.SENT);
							emails.put(D_PROJ_MGR, EmailTemplate.SENT);
							emails.put(A_M, EmailTemplate.SENT);							
						}
					}
					else if (record_type_code.equalsIgnoreCase("quote"))
					{
						Boolean oldQuoteStyle = (Boolean)ic.getTransientDatum(QuotePostHandler.OLD_QUOTE_STYLE);
						if (oldQuoteStyle == null)	oldQuoteStyle = Boolean.FALSE;
						if ("Y".equalsIgnoreCase(rs.getString("is_new")) && !oldQuoteStyle) {
							emails.put(A_M, EmailTemplate.SENT);
							emails.put(A_M_SALES, EmailTemplate.SENT);
							emails.put(CUSTOMER, EmailTemplate.SENT);
							emails.put(CUSTOMER2, EmailTemplate.SENT);
							emails.put(CUSTOMER3, EmailTemplate.SENT);
							emails.put(CUSTOMER4, EmailTemplate.SENT);
						} else {
							emails.put(D_SALES_REP, EmailTemplate.SENT);
							emails.put(D_SALES_SUP, EmailTemplate.SENT);
							emails.put(D_PROJ_MGR, EmailTemplate.SENT);
							emails.put(A_M, EmailTemplate.SENT);
							// added per Scott's request
							emails.put(CUSTOMER, EmailTemplate.SENT);
							emails.put(ALT_CUSTOMER, EmailTemplate.SENT);						
						}
					}
				}
				else
				{// must be a workorder

					if (send_survey)
					{// need to send A&M survey to customer
						emails.put(CUSTOMER, EmailTemplate.CUSTOMER_SURVEY);
						emails.put(ALT_CUSTOMER, EmailTemplate.CUSTOMER_SURVEY);
					}
					else
					{

						if (record_status_type_code.equalsIgnoreCase("unapproved"))
						{
							emails.put(APPROVER, EmailTemplate.APPROVER_NOTIFY);
						}
						else if (record_status_type_code.equalsIgnoreCase("refused"))
						{
							emails.put(CUSTOMER, EmailTemplate.CUSTOMER_WORKORDER_REFUSAL);
							emails.put(ALT_CUSTOMER, EmailTemplate.CUSTOMER_WORKORDER_REFUSAL);
						}
						else if (record_status_type_code.equalsIgnoreCase("needs_quote"))
						{// notify a_m of new workorder quote request
							emails.put(A_M, EmailTemplate.A_M_WORKORDER_QUOTE_REQUEST);
						}
						else if (record_status_type_code.equalsIgnoreCase("approved"))
						{// notify customer of approval if not a vendor update

							if (StringUtil.hasAValue(request_vendor_id))
							{// vendor updated his schedule

								emails.put(CUSTOMER, EmailTemplate.CUSTOMER_NEW_SCHEDULE);
								emails.put(ALT_CUSTOMER, EmailTemplate.CUSTOMER_NEW_SCHEDULE);
							}
							else if (is_new_version)
							{// notify vendors/scheduler/customer of new version

								emails.put(CUSTOMER, EmailTemplate.VENDOR_NEW_VERSION);
								emails.put(ALT_CUSTOMER, EmailTemplate.VENDOR_NEW_VERSION);

								for (int i = 0; i < vendorContacts.length; i++)
								{
									emails.put(vendorContacts[i], EmailTemplate.VENDOR_NEW_VERSION);
								}

								sch_message = emailSchedulerTest(ic, conn);
								if (sch_message != null)
									emails.put(SCHEDULER, EmailTemplate.SCHEDULER_NEW_VERSION);
							}
							else
							{// normal customer/vendor approval notification

								emails.put(CUSTOMER, EmailTemplate.CUSTOMER_WORKORDER_APPROVAL);
								emails.put(ALT_CUSTOMER, EmailTemplate.CUSTOMER_WORKORDER_APPROVAL);

								for (int i = 0; i < vendorContacts.length; i++)
								{
									emails.put(vendorContacts[i], EmailTemplate.VENDOR_NOTIFY);
								}
							}
						}
					}
				}
			}

			Enumeration<String> email_enum = emails.keys();
			boolean is_vendor = false;
			String contact_id = null;
			String contact_email = null;
			String contact_column = null;
			String email_message = null;
			EmailTemplate template = null;
			Vector<Contact> contact_results = new Vector<Contact>();
			Contact a_contact = null;
			while (email_enum.hasMoreElements())
			{
				contact_column = (String) email_enum.nextElement();
				template = emails.get(contact_column);
				Diagnostics.debug("emailing contact='" + contact_column + "'");
				if (StringUtil.hasAValue(contact_id = rs.getString(contact_column)))
				{// contact column has a value so we should email them

					a_contact = Contact.fetch(contact_id, conn);
					contact_results.add(a_contact); // to be used by the acknowledgment screen
					// now see if contact has an email
					if (a_contact != null && StringUtil.hasAValue(contact_email = a_contact.getEmail()))
					{
						// create email message by setting variable in message with values
						ResultSetMetaData meta = rs.getMetaData();
						HashMap<String,String> myMap = new HashMap<String,String>();
						myMap.put("contact_name", a_contact.getContactName());
						for (int i = 1, n = meta.getColumnCount(); i <= n; i++)
						{
							String colName = meta.getColumnName(i);
							String value = rs.getString(colName);
							if (value == null)
								value = "";
							myMap.put(colName.toLowerCase(), rs.getString(colName));
						}
						email_message = performSubstitutions(template.getMessage(), myMap);

						// perform any last second email_message changes
                        String subject = "ServiceTRAX Alert";
                        if ("quote_request".equalsIgnoreCase(record_type) ||
                                "service_request".equalsIgnoreCase(record_type) ||
                                "quote".equalsIgnoreCase(record_type))
                        {
                            String end_user_name = rs.getString("end_user_name");
                            String job_name = rs.getString("job_name");
                            subject = IMSUtil.formatEmailSubject(end_user_name, job_name);
                        }

						if (template == EmailTemplate.CUSTOMER_SURVEY) {
							email_message += getURLString(rs.getString("survey_location"));
                        } else if (template == EmailTemplate.SCHEDULER_NEW_VERSION) {
							email_message += sch_message.toString();
                        }

						is_vendor = false;
						if (template == EmailTemplate.VENDOR_NOTIFY || template == EmailTemplate.VENDOR_NEW_VERSION)
							is_vendor = true;
						queueEmail(ic, conn, recordId, from, contact_id, contact_email, subject, email_message,
								is_vendor);

						if (is_vendor)
							vendorContactList.add(contact_id);
					}
					else
					{
						Diagnostics.error("There is no email for contact column = '" + contact_column + "' where contact_id = '"
								+ rs.getString(contact_column) + "'");
					}
				}
			}
			ic.setSessionDatum("email_results", contact_results);
		}
		else
		{
			Diagnostics.error("Could not find record data for record_id = '" + recordId + "' in PROJECTS_ALL_REQUESTS_V");
			result = false;
		}
		IMSUtil.closeQueryResultSet(rs);
		
		updateVendors(ic, conn,recordId, vendorContactList);

		Diagnostics.debug2("PDSEmailHandler.handlEnvironment() result = " + result);

		return result;
	}

	public String getEmailTemplate(String emailCode)
	{
		return (String) emailTemplates.get(emailCode);
	}

	public String performSubstitutions(String template, Map<String, String> m)
	{
		for (Iterator<String> iter = m.keySet().iterator(); iter.hasNext();)
		{
			String key = iter.next();
			template = StringUtil.replaceString(template, "${" + key + "}", m.get(key));
		}
		return template;
	}

	private void queueEmail(InvocationContext ic, ConnectionWrapper conn, String id, String from_email, String to_contact_id,
			String to_email, String subject, String body, boolean is_vendor) throws Exception
	{
		Diagnostics.trace("PDSEmailHandler.queueEmail()");
		Diagnostics.debug("Queueing email to " + to_email);
		StringBuffer query = new StringBuffer();
		query.append("INSERT INTO emails (project_id, request_id, from_email, to_contact_id, to_email, subject, body, created_by) values ( ");
		query.append(ic.getSessionDatum("project_id"));
		query.append(", ").append(id);
		query.append(", ").append(conn.toSQLString(from_email));
		query.append(", ").append(to_contact_id);
		query.append(", ").append(conn.toSQLString(to_email));
		query.append(", ").append(conn.toSQLString(subject));
		query.append(", ").append(conn.toSQLString(body));
		query.append(", ").append(conn.toSQLString((String) ic.getSessionDatum("user_id")));
		query.append(")");
		Diagnostics.debug("query=" + query);
		conn.updateEx(query);
	}

//	private void updateVendor(ConnectionWrapper conn, String request_id, String vendor_contact_id) throws Exception
//	{
//		Diagnostics.trace("PDSEmailHandler.updateVendor()");
//		conn.updateEx("UPDATE request_vendors SET emailed_date = getDate() WHERE request_id = " + conn.toSQLString(request_id)
//				+ " AND vendor_contact_id=" + conn.toSQLString(vendor_contact_id));
//	}
	
	private void updateVendors(InvocationContext ic, ConnectionWrapper conn, String requestId, List<String> vendorContactIdList) throws Exception
	{
		Diagnostics.trace("PDSEmailHandler.updateVendors()");
		PreparedStatement stmt = null;
		String host = null;
		int port = 0;
		String from = null;
		String subject = "IMS deadlock alert";
		String alertToEmail = null;
		
		try {
			Document d = ic.getConfigDocument();
			host = XMLUtils.getValue(d, "mail:host").trim();
			port = Integer.valueOf(XMLUtils.getValue(d, "mail:port").trim()).intValue();
			from = host = XMLUtils.getValue(d, "mail:from").trim();
			alertToEmail = (String) ic.getAppGlobalDatum("deadlockAlter");
			stmt = conn.prepareStatement(UPDATE_REQUEST_VENDORS);
			
			for (String contactId: vendorContactIdList)
			{
				stmt.setString(1, requestId);
				stmt.setString(2, contactId);
				stmt.addBatch();
			}
			
			stmt.executeBatch();
		} catch (SQLException se) {
			if (se.getErrorCode() == 1205) {
				IMSUtil.sendEmail(host, port, alertToEmail, from, subject, se.getMessage() + " Failed SQL Statement = (" + UPDATE_REQUEST_VENDORS + ")");
			}
			Diagnostics.error("SQLException in PDSEmailHandler.updateVendors(): " + se);
		} catch (Exception e) {
			Diagnostics.error("Exception in PDSEmailHandler.updateVendors(): " + e);
		} finally {
			if (stmt != null) stmt.close();
		}
	}

	private StringBuffer emailSchedulerTest(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("PDSEmailHandler.emailSchedulerTest()");
		StringBuffer result = new StringBuffer();
		String old_version_request_id = (String) ic.getTransientDatum("old_version_request_id");
		String request_id = ic.getParameter("request_id");
		String query = "SELECT schedule_type_name, schedule_type_name_b,"
		+ " EST_START_DATE, EST_START_DATE_B, EST_START_TIME, EST_START_TIME_B, EST_END_DATE, EST_END_DATE_B,"
		+ " DESCRIPTION, DESCRIPTION_B, OTHER_CONDITIONS, OTHER_CONDITIONS_B,"
		+ " cust_contact_mod_date, cust_contact_mod_date_b, CONTACT_NAME_B, PHONE_WORK_B, PHONE_CELL_B,"
		+ " job_location_mod_date, job_location_mod_date_b, JOB_LOCATION_NAME_B, STREET1_B, STREET2_B, STREET3_B, CITY_B, STATE_B, ZIP_B"
		+ " FROM request_schedule_diff_v"
		+ " WHERE request_id = ?"
		+ " AND request_id_b = ?"
		+ " AND NOT ("
		+ "     schedule_type_id = schedule_type_id_b"
		+ " AND est_start_date = est_start_date_b"
		+ " AND est_start_time = est_start_time_b"
		+ " AND est_end_date = est_end_date_b"
		+ " AND description = description_b"
		+ " AND other_conditions = other_conditions_b"
		+ " AND cust_contact_mod_date = cust_contact_mod_date_b"
		+ " AND job_location_mod_date = job_location_mod_date_b"
		+ " )";
		QueryResults rs = conn.select(query, new String[] {old_version_request_id, request_id});
		if (rs.next())
		{// they are not equal so notify scheduler of only the fields that have changed
			result.append(NEWLINE);
			if (!rs.getString("schedule_type_name").equalsIgnoreCase(rs.getString("schedule_type_name_b")))
				result.append("Schedule Type: ").append(rs.getString("schedule_type_name") + " / ").append(
						rs.getString("schedule_type_name_b")).append(NEWLINE);
			if (!rs.getString("EST_START_DATE").equalsIgnoreCase(rs.getString("EST_START_DATE_B")))
				result.append("Est Start Date: ").append(rs.getString("EST_START_DATE") + " / ").append(
						rs.getString("EST_START_DATE_B")).append(NEWLINE);
			if (!rs.getString("EST_START_TIME").equalsIgnoreCase(rs.getString("EST_START_TIME_B")))
				result.append("Est Start Time: ").append(rs.getString("EST_START_TIME") + " / ").append(
						rs.getString("EST_START_TIME_B")).append(NEWLINE);
			if (!rs.getString("EST_END_DATE").equalsIgnoreCase(rs.getString("EST_END_DATE_B")))
				result.append("Est End Date: ").append(rs.getString("EST_END_DATE") + " / ").append(rs.getString("EST_END_DATE_B"))
						.append(NEWLINE);
			if (!rs.getString("DESCRIPTION").equalsIgnoreCase(rs.getString("DESCRIPTION_B")))
			{
				result.append("Old Description: ").append(rs.getString("DESCRIPTION")).append(NEWLINE);
				result.append("New Description: ").append(rs.getString("DESCRIPTION_B")).append(NEWLINE);
			}
			if (!rs.getString("OTHER_CONDITIONS").equalsIgnoreCase(rs.getString("OTHER_CONDITIONS_B")))
			{
				result.append("Old Other Conditions: ").append(rs.getString("OTHER_CONDITIONS")).append(NEWLINE);
				result.append("New Other Conditions: ").append(rs.getString("OTHER_CONDITIONS_B")).append(NEWLINE);
			}
			if (!rs.getString("cust_contact_mod_date").equalsIgnoreCase(rs.getString("cust_contact_mod_date_b")))
			{
				result.append("New Customer Contact: ").append(rs.getString("CONTACT_NAME_B")).append(NEWLINE);
				result.append("New Work Phone: ").append(rs.getString("PHONE_WORK_B")).append(NEWLINE);
				result.append("New Cell Phone: ").append(rs.getString("PHONE_CELL_B")).append(NEWLINE);
			}
			if (!rs.getString("job_location_mod_date").equalsIgnoreCase(rs.getString("job_location_mod_date")))
			{
				result.append("Job Location: ").append(rs.getString("JOB_LOCATION_NAME_B")).append(NEWLINE);
				result.append("Street1: ").append(rs.getString("STREET1_B")).append(NEWLINE);
				result.append("Street2: ").append(rs.getString("STREET2_B")).append(NEWLINE);
				result.append("Street3: ").append(rs.getString("STREET3_B")).append(NEWLINE);
				result.append("City: ").append(rs.getString("CITY_B")).append(NEWLINE);
				result.append("State: ").append(rs.getString("STATE_B")).append(NEWLINE);
				result.append("Zip: ").append(rs.getString("ZIP_B")).append(NEWLINE);
			}
		}
		else
		{// they are not equal notify scheduler
			result = null;
		}

		IMSUtil.closeQueryResultSet(rs);

		// now color the service red in scheduling by setting watchflag = 'Y' if criteria met above
		if (result != null)
		{
			conn.update("UPDATE services SET watch_flag = 'Y' WHERE request_id = ?", request_id);
		}

		return result;
	}

	private String getURLString(String url) throws Exception
	{
		Diagnostics.trace("PDSEmailHandler.getURLString()");
		String new_url = "";
		if (StringUtil.hasAValue(url))
		{
			if (url.startsWith("www"))
				new_url = "http://" + url.trim();
			else
				new_url = url.trim();
		}
		return new_url;
	}

}
