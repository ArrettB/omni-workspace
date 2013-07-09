package ims.handlers.proj;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import ims.helpers.IMSUtil;
import microsoft.exchange.webservices.data.*;

import java.net.URI;
import java.text.SimpleDateFormat;
import java.util.*;

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
public class PDSCalendarHandler extends BaseHandler
{
	private final static String NEWLINE = "\r\n";

	public enum CalendarTemplate {
		APPOINTMENT(
				"BEGIN:VCALENDAR" + NEWLINE
				+ "VERSION: 2.0" + NEWLINE
				+ "PRODID: -//ServiceTRAX//CalDAV Client//EN" + NEWLINE
                + "METHOD: REQUEST" + NEWLINE
                + "BEGIN: VEVENT" + NEWLINE
				+ "DTSTART:   ${est_start_date}" + NEWLINE
				+ "DTEND: ${est_end_date}" + NEWLINE
                + "ORGANIZER: mailto:${calendar_email_address}" + NEWLINE
				+ "SUMMARY: Project #: ${project_no}, job name ${job_name} for customer ${customer_name}, end user ${end_user_name} located at ${job_location_name}" + NEWLINE
				+ "END: VEVENT" + NEWLINE
                + "END: VCALENDAR" + NEWLINE);
		
		private final String msg;
		
        CalendarTemplate(String msg)
		{
			this.msg = msg;
		}
		
		public String getMessage()
		{
			return msg;
		}
	
	}

	private static Map<String, String> calendarTemplates;

	public void setUpHandler() throws Exception	{
		Diagnostics.debug2("PDSCalendarHandler.setUpHandler()");
	}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic) throws Exception	{
		Diagnostics.trace("PDSCalendarHandler.handleEnvironment()");
		
		ConnectionWrapper conn = null;
		boolean result = true;
		List<String> vendorContactList = new ArrayList<String>();	
		conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

		if (conn == null) {
			conn = (ConnectionWrapper) ic.getResource();
		}

		// IMPORTANT DATA BELOW
        String recordId = (String) ic.getTransientDatum("record_id");
        String request_id = ic.getParameter("request_id");
        String jobLocationId = ic.getParameter("job_location_id");
        String jobName = "";
        String jobLocationName = "";
        String recordNumber = "";
        String customerName = "";
        String endUserName = "";
        String calendarName = "";
        String calendarEmailAddress = "";
        String calendarPassword = "";
		String est_start_date = ic.getParameter("est_start_date");
        String est_start_time = ic.getParameter("est_start_time");
        String est_end_date = ic.getParameter("est_end_date");
        String description = "";
		if (est_start_date != null && est_start_date.length() == 0) est_start_date = null;
        if (est_end_date != null && est_end_date.length() == 0) est_end_date = null;
        if (est_start_time == null || est_start_time.length() == 0) est_start_time = "9:00 AM";
		// IMPORTANT DATA ABOVE

        if(est_start_date == null ) {
            return true;
        }

        StringBuffer sch_message = null; // used for scheduler emails
		String query = null;
        // get info we can't from the parameters
        query = "SELECT record_no, customer_name, end_user_name, job_name, description FROM projects_all_requests_v WHERE request_id = ?";
    	QueryResults rs = conn.select(query,request_id);
        if(rs.next()) {
            recordNumber = rs.getString("record_no");
            customerName = rs.getString("customer_name");
            endUserName = rs.getString("end_user_name");
            jobName = rs.getString("job_name");
            description = rs.getString("description");
        }
        IMSUtil.closeQueryResultSet(rs);

        // get calendar information
		StringBuffer queryRequest = new StringBuffer();
        queryRequest.append("SELECT JL.JOB_LOCATION_NAME, JL.JOB_LOCATION_CALENDAR_ID, JLC.CODE, JLC.DESCRIPTION, JLC.EMAIL_ADDRESS, JLC.PASSWORD\n" +
                "  FROM JOB_LOCATIONS JL INNER JOIN JOB_LOCATION_CALENDARS JLC ON JL.JOB_LOCATION_CALENDAR_ID = JLC.CALENDAR_ID\n" +
                " WHERE JL.JOB_LOCATION_ID = ?");
		rs = conn.select(queryRequest, jobLocationId);
		if( rs.next() )
		{
            jobLocationName = rs.getString("job_location_name");
            calendarName = rs.getString("code");
            calendarEmailAddress = rs.getString("email_address");
            calendarPassword = rs.getString("password");
		} else {
            Diagnostics.status("No calendar defined for this job location - skipping event creation");
            IMSUtil.closeQueryResultSet(rs);

            ic.setSessionDatum("calendar_results", false);
            return true;
        }
		IMSUtil.closeQueryResultSet(rs);


        String workOrderCatcherEmail = ic.getAppGlobalDatum("workOrderCatcherEmail").toString();
        String moveManagerEmail = ic.getAppGlobalDatum("moveManagerEmail").toString();

        HashMap <String,String> myMap = new HashMap<String,String>();
        myMap.put("est_start_date", est_start_date);
        myMap.put("est_start_time", est_start_time);
        myMap.put("est_end_date", est_end_date);
        myMap.put("project_no",recordNumber);
        myMap.put("job_name", jobName);
        myMap.put("customer_name",customerName);
        myMap.put("end_user_name",endUserName);
        myMap.put("job_location_name", jobLocationName);
        myMap.put("description", description);
        myMap.put("workorderCatcher", workOrderCatcherEmail);
        myMap.put("moveManager", moveManagerEmail);

        Diagnostics.status("Sending calendar request for project # " + recordNumber + " to calendar for " + calendarEmailAddress + " start date is " + est_start_date + ", start time is " + est_start_time);

        try {
            String exchangeUrl = ic.getAppGlobalDatum("exchangeCalendarUrl").toString();
            Diagnostics.status("Using calendar URL " + exchangeUrl);

            ExchangeClient client = new ExchangeClient(exchangeUrl, calendarEmailAddress, calendarPassword);
            client.sendAppointmentForRequest(myMap);

//            String moveManagerEmail = ic.getAppGlobalDatum("moveManagerEmail").toString();
//            String moveManagePassword = ic.getAppGlobalDatum("moveManagerPassword").toString();
//            ExchangeClient clientForMoveManager = new ExchangeClient(exchangeUrl, moveManagerEmail, moveManagePassword);
//            clientForMoveManager.sendAppointmentForRequest(myMap);

        } catch( Exception e ) {
            Diagnostics.error("Unable to send calendar request : " + e.getMessage());

            ic.setSessionDatum("calendar_results", false);

            return false;
        }

	    ic.setSessionDatum("calendar_results", true);

		Diagnostics.debug2("PDSCalendarHandler.handleEnvironment() result = " + result);

		return true;
	}

    public static void main(String[] args) {
        HashMap <String,String> myMap = new HashMap<String,String>();
        myMap.put("est_start_date", "06/13/2013 12:00:00");
        myMap.put("est_end_date", "06/13/2013 17:00:00");
//        myMap.put("est_start_time", "10:00:00");
        myMap.put("project_no", "1192305-6.1");
        myMap.put("job_name", "NATIONAL RELOCATION");
        myMap.put("customer_name","TARGET COMMERCIAL INTERIORS");
        myMap.put("end_user_name","UNITED HEALTH GROUP FMC");
        myMap.put("job_location_name", "MN010 - GOLDEN VALLEY");

        try {
            // internal
            String exchangeCalendarUrl = "https://mpls2.omniworkspace.com/ews/exchange.asmx";
            // external
            //String exchangeCalendarUrl = "https://mail.omniworkspace.com/ews/exchange.asmx";
            ExchangeClient exchange = new ExchangeClient(exchangeCalendarUrl, "goldenvalleyuhg@ambis.com", "teamuhg");

            exchange.sendAppointmentForRequest(myMap);
        } catch( Exception err ) {
            err.printStackTrace();
        }

        System.out.println("calling ExchangeService");
    }

    static class ExchangeClient {
        ExchangeService service;

        public ExchangeClient(String calendarUrl, String emailAddress, String password) throws Exception {
            service = new ExchangeService(ExchangeVersion.Exchange2010);

            ExchangeCredentials credentials = new WebCredentials(emailAddress, password);
           	service.setCredentials(credentials);
            service.setUrl(new URI(calendarUrl));
        }

        public void sendAppointmentForRequest(Map<String, String> parameters) throws Exception {
            Appointment appointment = new Appointment(service);

            // Project #: ${project_no}, job name ${job_name} for customer ${customer_name}, end user ${end_user_name} located at ${job_location_name}
            String summary = "Project #: " + parameters.get("project_no") +
                    ", job name " + parameters.get("job_name") +
                    " for customer " + parameters.get("customer_name") +
                    " , end user " + parameters.get("end_user_name") +
                    " located at " + parameters.get("job_location_name") + "<br/>" +
                    "Description: <br/>" +
                    parameters.get("description");

            appointment.setSubject("Project # " + parameters.get("project_no"));
            appointment.setBody(MessageBody.getMessageBodyFromText(summary));
            appointment.getBody().setBodyType(BodyType.HTML);
            appointment.getRequiredAttendees().add(parameters.get("workorderCatcher"));
            appointment.getRequiredAttendees().add(parameters.get("moveManager"));

            // format date in the XML format
            Calendar startCalendar  = new GregorianCalendar(TimeZone.getTimeZone("UTC"));
            Date startDate = parseStartDate(parameters.get("est_start_date"), parameters.get("est_start_time"));
            startCalendar.setTimeInMillis(startDate.getTime());

            int year = startCalendar.get(Calendar.YEAR);
            int month = startCalendar.get(Calendar.MONTH);
            int day = startCalendar.get(Calendar.DAY_OF_MONTH);
            int hour = startCalendar.get(Calendar.HOUR_OF_DAY);
            int minute = startCalendar.get(Calendar.MINUTE);
            int second = startCalendar.get(Calendar.SECOND);

            Diagnostics.debug2("Project # " + parameters.get("project_no") + ", start time: " + (month + 1) + "/" + day + "/" + year + " " + hour + ":" + minute + ":" + second);
            appointment.setStart(new Date(year - 1900, month, day, hour, minute, second));
            StringList categories = new StringList();
            categories.add( "Red Category");
            appointment.setCategories(categories);

            hour += 1;
            Diagnostics.debug2("Project # " + parameters.get("project_no") + ", end time: " + (month+1) + "/" + day + "/" + year + " " + hour + ":" + minute + ":" + second);
            appointment.setEnd(new Date(year - 1900, month, day, hour, minute, second));

            appointment.save();
        }

        public Date parseStartDate(String est_start_date, String est_start_time) throws Exception {
            Date startDate;
            SimpleDateFormat startDateFormatter = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
            if( est_start_time != null && est_start_time.length() > 0 && est_start_time.contains("/")) {
                startDate = startDateFormatter.parse(est_start_time);
                return startDate;
            } else if(est_start_date != null && est_start_date.length() > 0 ) {
                String date = est_start_date + " 09:00 AM";

                startDate = startDateFormatter.parse(date);
                return startDate;
            } else {
                throw new Exception("Attempting to set an appointment with no date or time - this just won't work");
            }
        }
    }

}
