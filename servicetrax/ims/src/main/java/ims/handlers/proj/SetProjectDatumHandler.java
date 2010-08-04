/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001-2006, Dynamic Information Systems, LLC
 * $Header: SetProjectDatumHandler.java, 25, 3/10/2006 4:45:36 PM, Blake Von Haden$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */
package ims.handlers.proj;

import ims.Constants;
import ims.dataobjects.User;
import ims.helpers.IMSUtil;

import java.sql.SQLException;
import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 *
 * @version $Id: SetProjectDatumHandler.java 1678 2009-09-01 16:22:03Z bvonhaden $
 */
public class SetProjectDatumHandler extends BaseHandler {
    public static final String SELECT_LOOKUPS
            = "SELECT lt.code lookup_type, l.lookup_id "
            + "  FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id "
            + " WHERE ((lt.code='delivery_type' OR (lt.code='furniture_line_type' AND l.attribute2='system')) AND l.code='n_a') "
            + "    OR (lt.code='yes_no_type' AND l.code='N')";

    public static final String SELECT_CUSTOMER
            = "SELECT c.customer_name,"
            + "       c.parent_customer_id,"
            + "       c.ext_dealer_id,"
            + "       c.ext_customer_id,"
            + "       l.code customer_type,"
            + "       c.end_user_parent_id,"
            + "       c_p.customer_name end_user_parent_name "
            + "  FROM customers c JOIN "
            + "       lookups l ON c.customer_type_id = l.lookup_id LEFT JOIN "
            + "       customers c_p ON c.end_user_Parent_id = c_p.customer_id "
            + " WHERE c.customer_id = ?";


    private static final String NOID = "-1";

    public void setUpHandler() {
    }

    public void destroy() {
    }

    public boolean handleEnvironment(InvocationContext ic) {
        Diagnostics.debug2("SetProjectDatumHandler.handleEnvironment()");
        boolean result = true;

        ConnectionWrapper conn = null;
        String query = null;
        QueryResults rs = null;
        QueryResults rs2 = null;

        try {
            conn = (ConnectionWrapper) ic.getResource();

            setLookupValues(ic, conn);
            setCommissionMarkupPermissionValues(ic, conn);

            String jobLocationId = (String) ic.getSessionDatum("job_location_id");
            String jobLocationContactId = (String) ic.getSessionDatum("job_location_contact_id");
            String userDealerId = ((User) ic.getSessionDatum("user")).extDealerID;
            String clearProjectId = ic.getParameter("clear_project_id");

            if (StringUtil.hasAValue(jobLocationId)) {
                ic.setTransientDatum("job_location_id", jobLocationId);
            }

            if (StringUtil.hasAValue(jobLocationContactId)) {
                ic.setTransientDatum("job_location_contact_id", jobLocationContactId);
            }


            ic.removeSessionDatum("job_location_id");
            ic.removeSessionDatum("job_location_contact_id");
            ic.removeSessionDatum("quote_request_id");
            ic.removeSessionDatum("user_ext_dealer_id");

            String projectID = ic.getParameter("project_id");

            if (StringUtil.hasAValue(clearProjectId) && "true".equalsIgnoreCase(clearProjectId)) {
                ic.removeSessionDatum("project_id");
                projectID = null;
            }
            String requestID = ic.getParameter("request_id");
            String quoteID = ic.getParameter("quote_id");
            String customerID = ic.getParameter("customer_id");
            String endUserId = ic.getParameter("end_user_id");
            if (endUserId == null && ic.getSessionDatum("end_user_id") != null) {
                endUserId = (String) ic.getSessionDatum("end_user_id");
            }
            String dealerID = ic.getParameter("ext_dealer_id");
            String parentCustomerID = ic.getParameter("parent_customer_id");
            String quoteRequestId = ic.getParameter("quote_request_id");

            ic.setSessionDatum("user_ext_dealer_id", userDealerId);
            ic.setSessionDatum("quote_request_id", quoteRequestId);

            String effectiveCustomerID = customerID;

			if (effectiveCustomerID == null || effectiveCustomerID.length() == 0)
                effectiveCustomerID = (String) ic.getSessionDatum("customer_id");

            if (effectiveCustomerID != null && effectiveCustomerID.length() > 0) {
                try {
                    rs = conn.select(SELECT_CUSTOMER, effectiveCustomerID);
                    if (rs.next()) {
                        ic.setTransientDatum("effective_parent_customer_id", rs.getString("parent_customer_id"));

                        String customerType = rs.getString("customer_type");
                        ic.setTransientDatum("ext_customer_id", rs.getString("ext_customer_id"));
						if ("dealer".equalsIgnoreCase(customerType))
						{
							if (StringUtil.hasAValue(endUserId))
                                effectiveCustomerID = endUserId;
                            ic.setTransientDatum("effective_ext_dealer_id", rs.getString("ext_customer_id"));
                        }
                        else {
                            ic.setTransientDatum("effective_ext_dealer_id", rs.getString("ext_dealer_id"));
                        }
                    }
                    else {
                        Diagnostics.error("Error: failed to find customer from customers table where customer_id = '" + customerID
                                + "'");
                        result = false;
                    }
                }
				finally
				{
					if (rs != null)
                        rs.close();
                    }
                }
			else
			{
                effectiveCustomerID = NOID;
            }
            ic.setTransientDatum("effective_customer_id", effectiveCustomerID);

            // grab from session if not set
			if (!StringUtil.hasAValue(projectID))
                projectID = (String) ic.getSessionDatum("project_id");
			if (!StringUtil.hasAValue(requestID))
                requestID = (String) ic.getSessionDatum("request_id");
			if (!StringUtil.hasAValue(quoteID))
                quoteID = (String) ic.getSessionDatum("quote_id");

            String clear_session = ic.getParameter("clear_session");
            String clear_request_id = ic.getParameter("clear_request_id");
			if (clear_request_id != null && clear_request_id.equalsIgnoreCase("true"))
                requestID = null;
            String clear_quote_id = ic.getParameter("clear_quote_id");
			if (clear_quote_id != null && clear_quote_id.equalsIgnoreCase("true"))
                quoteID = null;
            String quoting = ic.getParameter("quoting");

            if (StringUtil.hasAValue(clear_session) && clear_session.equalsIgnoreCase("true")) {
                Diagnostics.debug2("Removed project and request and quote session data.");
                // project
                ic.removeSessionDatum("project_id");
                ic.removeSessionDatum("project_no");
                ic.removeSessionDatum("project_type_id");
                ic.removeSessionDatum("project_type_code");
                ic.removeSessionDatum("project_type_name");
                ic.removeSessionDatum("project_status_type_code");
                ic.removeSessionDatum("project_status_type_name");
                ic.removeSessionDatum("ext_dealer_id");
                ic.removeSessionDatum("user_ext_dealer_id");
                ic.removeSessionDatum("dealer_name");
                ic.removeSessionDatum("customer_id");
                ic.removeSessionDatum("end_user_id");
                ic.removeSessionDatum("parent_customer_id");
                ic.removeSessionDatum("customer_name");
                ic.removeSessionDatum("job_name");
                // request
                ic.removeSessionDatum("customer_id"); // for workorder
                ic.removeSessionDatum("parent_customer_id"); // for workorder
                ic.removeSessionDatum("request_id");
                ic.removeSessionDatum("request_no");
                ic.removeSessionDatum("version_no");
                ic.removeSessionDatum("request_status_type_code");
                ic.removeSessionDatum("request_type_code");
                ic.removeSessionDatum("request_is_sent");
                ic.removeSessionDatum("request_readonly");
                ic.removeSessionDatum("quoting");
                // quote
                ic.removeSessionDatum("quote_id");
                ic.removeSessionDatum("quote_status_type_code");
                ic.removeSessionDatum("quote_type_code");
                ic.removeSessionDatum("quote_is_sent");
                ic.removeSessionDatum("quote_readonly");
            }
            else if (!StringUtil.hasAValue(projectID)) {// no project_id, special case when called by the project_header.html so must be in insert mode for a new project

                String project_type_id = ic.getParameter("project_type_id");
                String dealer_name = null;
                String customer_name = null;
                String gp_org = null;

                // special case when inserting a workorder and there is no project id
				if ((StringUtil.hasAValue(quoting) && quoting.equalsIgnoreCase("true")))
                    ic.setSessionDatum("quoting", "true");
				else
                    ic.removeSessionDatum("quoting");

                ConnectionWrapper gp_conn = null;
                try {
                    gp_org = (String) ic.getRequiredSessionDatum("org_resource");
                    gp_conn = (ConnectionWrapper) ic.getResource(gp_org);

                    // get customer name and dealer id
                    if (StringUtil.hasAValue(customerID)) {
                        query = SELECT_CUSTOMER;

                        rs = conn.select(query, customerID);
                        if (rs.next()) {// found customer_name
                            customer_name = rs.getString("customer_name");
                            parentCustomerID = rs.getString("parent_customer_id");
                            if ("dealer".equalsIgnoreCase(rs.getString("customer_type"))) {
                                dealerID = rs.getString("ext_customer_id");
                            }
                            else {
                                dealerID = rs.getString("ext_dealer_id");
                            }
                        }
                        else {
                            Diagnostics.error("Error: failed to find customer from customers table where customer_id = '"
                                    + customerID + "'");
                            result = false;
                        }
                        rs.close();
                    }

                    if (StringUtil.hasAValue(dealerID)) {
                        query = "SELECT RTRIM(shrtname) dealer_name FROM RM00101 WHERE custnmbr = ?";
                        rs = gp_conn.select(query, dealerID);
                        if (rs.next()) {// found dealer_name
                            dealer_name = rs.getString("dealer_name");
                        }
                        else {
                            Diagnostics.error("Error: failed to find dealer in Great Plains from users ext_dealer_id of '"
                                    + dealerID + "'");
                            result = false;
                        }
                        rs.close();
                    }
                    else {// special case if no ext_dealer_id, default to users ext_dealer_id only if that dealer exists in the
                        // organization we are in
                        String tempDealerID = ((User) ic.getSessionDatum("user")).extDealerID;

                        query = "SELECT rtrim(shrtname) dealer_name FROM RM00101 WHERE userdef1='DEALER' AND custnmbr = ?";
                        rs = gp_conn.select(query, tempDealerID);
                        if (rs.next()) {// found dealer_name
                            dealerID = tempDealerID;
                            dealer_name = rs.getString("dealer_name");
                        }
                        else {
                            Diagnostics.error("Error: failed to find dealer in Great Plains from users ext_dealer_id of '"
                                    + tempDealerID + "'");
                            result = false;
                        }
                        rs.close();

                    }
                }
                catch (Exception e) {
                    Diagnostics.error("org_id='" + gp_org + "', gp_conn='" + gp_conn + "'");
                    Diagnostics.error("Exception: failed to determine dealer_name from Great Plains where ext_dealer_id = '"
                            + dealerID + "'\nOR " + "failed to determine customer_name from CUSTOMERS table where customer_id = '"
                            + customerID + "'\n" + e.toString());
                    result = false;
                }
				finally
				{
					if (gp_conn != null)
                        gp_conn.release();
                    }

                // need each of these to repeat when refreshing the screen in insert mode
                ic.setSessionDatum("project_type_id", project_type_id);
                if (dealerID == null) {
                    ic.setSessionDatum("ext_dealer_id", userDealerId);
                }
                else {
                    ic.setSessionDatum("ext_dealer_id", dealerID);
                }

                ic.setSessionDatum("dealer_name", dealer_name);
                ic.setSessionDatum("customer_id", customerID);
                ic.setSessionDatum("end_user_id", endUserId);
                ic.setSessionDatum("parent_customer_id", parentCustomerID);
                ic.setSessionDatum("customer_name", customer_name);
                ic.setSessionDatum("job_name", ic.getParameter("job_name"));
            }
            else if (StringUtil.hasAValue(projectID)) {// we are in a project

                query = "SELECT TOP 1 p.project_no,"
                        + "       p.project_type_id,"
                        + "       p.project_type_code,"
                        + "       p.project_type_name,"
                        + "       p.project_status_type_code,"
                        + "       p.project_status_type_name,"
                        + "       p.parent_customer_id,"
                        + "       p.customer_id,"
                        + "       p.end_user_id,"
                        + "       RTRIM(p.ext_dealer_id) ext_dealer_id,"
                        + "       RTRIM(p.dealer_name) dealer_name,"
                        + "       RTRIM(p.customer_name) customer_name,"
                        + "       RTRIM(p.end_user_name) end_user_name,"
                        + "       p.job_name,"
                        + "       p.ext_end_user_id "
                        + "  FROM projects_v2 p "
                        + " WHERE p.project_id = ?";

                rs = conn.select(query, projectID);

                if (!rs.next()) {// most likely create request failed and project_id did not get removed, so remove it now.
                    ic.removeSessionDatum("project_id");
                    ic.removeParameter("project_id");
                    Diagnostics.error("Error: Failed to find project_id in view projects_v, so removed session data for missing project_id = '"
                            + projectID + "'");
                }
                else {
                    Diagnostics.debug("Setting project_id to " + projectID);
                    ic.setSessionDatum("project_id", projectID);
                    ic.setSessionDatum("project_no", rs.getString("project_no"));
                    ic.setSessionDatum("project_type_id", rs.getString("project_type_id"));
                    ic.setSessionDatum("project_type_code", rs.getString("project_type_code"));
                    ic.setSessionDatum("project_type_name", rs.getString("project_type_name"));
                    ic.setSessionDatum("project_status_type_code", rs.getString("project_status_type_code"));
                    ic.setSessionDatum("project_status_type_name", rs.getString("project_status_type_name"));
                    ic.setSessionDatum("customer_id", rs.getString("customer_id"));
                    ic.setSessionDatum("parent_customer_id", rs.getString("parent_customer_id"));
                    ic.setSessionDatum("ext_dealer_id", rs.getString("ext_dealer_id"));
                    ic.setSessionDatum("dealer_name", rs.getString("dealer_name"));
                    ic.setSessionDatum("customer_name", rs.getString("customer_name"));
                    ic.setSessionDatum("job_name", rs.getString("job_name"));
                    ic.setSessionDatum("end_user_name", rs.getString("end_user_name"));

                    ic.setSessionDatum("end_user_id", rs.getString("end_user_id"));
                    ic.setTransientDatum("ext_end_user_id", rs.getString("ext_end_user_id"));

                    // HANDLE CASE OF VIEWING REQUEST OR QUOTE
                    String record_id = null;
                    String record_status_type_code = null;
                    String record_type_code = null;
                    String record_is_sent = null;
                    String is_quoted = null;
                    String quote_request_id = null;
                    String record_readonly = "false";
                    String show_next = "false";
                    int num_workorder_lock_days = Integer.parseInt((String) ic.getAppGlobalDatum("num_workorder_lock_days"));
                    int num_service_req_lock_days = Integer.parseInt((String) ic.getAppGlobalDatum("num_service_req_lock_days"));

                    // HANDLE REQUEST_ID
                    if (StringUtil.hasAValue(requestID)) {
                        record_id = requestID;
                        query = "SELECT r.request_no,"
                                + "       r.version_no,"
                                + "       r.request_type_id,"
                                + "       getdate() cur_date,"
                                + "       ISNULL(r.est_start_date,getDate()+100) - ? wo_lock_date,"
                                + "       ISNULL(r.est_start_date,getDate()+100) - ? sr_lock_date,"
                                + "       l1.code record_status_type_code,"
                                + "       r.is_sent,"
                                + "       l2.code record_type_code,"
                                + "       r.quote_request_id,"
                                + "       r.is_quoted,"
                                + "       r.job_location_id,"
                                + "       r.job_location_contact_id,"
                                + "       c1.contact_name contact_name1, "
                                + "       dbo.sp_contact_phone(r.customer_contact_id) contact_phone1,"
                                + "       c1.email contact_email1,"
                                + "       c2.contact_name contact_name2, "
                                + "       dbo.sp_contact_phone(r.customer_contact2_id) contact_phone2,"
                                + "       c2.email contact_email2,"
                                + "       c3.contact_name contact_name3, "
                                + "       dbo.sp_contact_phone(r.customer_contact3_id) contact_phone3,"
                                + "       c3.email contact_email3,"
                                + "       c4.contact_name contact_name4, "
                                + "       dbo.sp_contact_phone(r.customer_contact4_id) contact_phone4,"
                                + "       c4.email contact_email4,"
                                + "       (SELECT COUNT(po.po_id) "
                                + "                 FROM purchase_orders po INNER JOIN "
                                + "                      lookups l ON po.po_status_id = l.lookup_id "
                                + "                WHERE l.code IN ('released', 'received') "
                                + "                  AND po.request_id = ?) po_count "
                                + "  FROM requests r INNER JOIN "
                                + "       lookups l1 ON r.request_status_type_id = l1.lookup_id INNER JOIN "
                                + "       lookups l2 ON r.request_type_id = l2.lookup_id LEFT OUTER JOIN "
                                + "       contacts c1 ON r.customer_contact_id = c1.contact_id LEFT OUTER JOIN "
                                + "       contacts c2 ON r.customer_contact2_id = c2.contact_id LEFT OUTER JOIN "
                                + "       contacts c3 ON r.customer_contact3_id = c3.contact_id LEFT OUTER JOIN "
                                + "       contacts c4 ON r.customer_contact4_id = c4.contact_id "
                                + " WHERE l2.code <> 'quote' "
                                + "   AND r.request_id = ?";

                        rs2 = conn.select(query, new Integer[]{num_workorder_lock_days, num_service_req_lock_days, Integer.parseInt(record_id), Integer.parseInt(record_id)});

                        if (rs2.next()) {// found request
                            record_status_type_code = rs2.getString("record_status_type_code");
                            record_is_sent = rs2.getString("is_sent");
                            record_type_code = rs2.getString("record_type_code");
                            quote_request_id = rs2.getString("quote_request_id");
                            is_quoted = rs2.getString("is_quoted");
                            Date cur_date = rs2.getDate("cur_date");
                            Date sr_lock_date = rs2.getDate("sr_lock_date");
                            // handle readonly state of form and whether we are quoting a mac
							if (record_status_type_code.equalsIgnoreCase("closed"))
                                record_readonly = "true";

                            if (("quote_request".equalsIgnoreCase(record_type_code) || "service_request".equalsIgnoreCase(record_type_code)) && "sent".equalsIgnoreCase(record_status_type_code)) {
                                record_is_sent = "Y";
                            }
                            /*
                                    * Not locking down workorders because Scott Anderson told Chad Ryan (7/22/03) if(
                                    * record_type_code.equalsIgnoreCase("workorder") && cur_date.after( wo_lock_date ) ) { record_readonly =
                                    * "true"; ic.setTransientDatum("is_lock_date","true"); }
                                    */
                            if ("quote_request".equalsIgnoreCase(record_type_code)) {
                                if ("Y".equalsIgnoreCase(record_is_sent) && "Y".equalsIgnoreCase(is_quoted)) {
                                    record_readonly = "true";
                                }
                            }
                            else if (record_type_code.equalsIgnoreCase("service_request")) {
                                if ("sent".equalsIgnoreCase(record_status_type_code) && cur_date.after(sr_lock_date)) {
                                    record_readonly = "true";
                                    ic.setTransientDatum("is_lock_date", "true");
                                }
                            }
                            else {
                                if ("Y".equalsIgnoreCase(is_quoted)) {
                                    record_readonly = "true";
                                }
                            }

                            if (quote_request_id != null || (StringUtil.hasAValue(quoting) && quoting.equalsIgnoreCase("true"))) {
                                ic.setSessionDatum("quoting", "true");
                            }
                            else {
                                ic.removeSessionDatum("quoting");
                            }

                            if (!record_status_type_code.equalsIgnoreCase("closed") && quote_request_id != null
                                    || (StringUtil.hasAValue(quoting) && quoting.equalsIgnoreCase("true"))
                                    && record_readonly.equalsIgnoreCase("true")) {
                                show_next = "true";
                            }




                            Diagnostics.debug2("Setting request_id to '" + record_id + "', request_status_type_code='"
                                    + record_status_type_code + "', request_type_code='" + record_type_code
                                    + "', request_is_sent='" + record_is_sent + "', request_readonly='" + record_readonly + "'");

                            ic.setSessionDatum("request_id", record_id);
                            ic.setSessionDatum("request_type_id", rs2.getString("request_type_id"));
                            ic.setSessionDatum("request_no", rs2.getString("request_no"));
                            ic.setSessionDatum("version_no", rs2.getString("version_no"));
                            ic.setSessionDatum("request_status_type_code", record_status_type_code);
                            ic.setSessionDatum("request_type_code", record_type_code);
                            ic.setSessionDatum("request_is_sent", record_is_sent);
                            ic.setSessionDatum("request_readonly", record_readonly);
                            ic.setSessionDatum("show_next", show_next);

                            ic.setTransientDatum("job_location_id", rs2.getString("job_location_id"));
                            ic.setTransientDatum("job_location_contact_id", rs2.getString("job_location_contact_id"));

                            ic.setTransientDatum("contact_name1", rs2.getString("contact_name1"));
                            ic.setTransientDatum("contact_phone1", rs2.getString("contact_phone1"));
                            ic.setTransientDatum("contact_email1", rs2.getString("contact_email1"));
                            ic.setTransientDatum("contact_name2", rs2.getString("contact_name2"));
                            ic.setTransientDatum("contact_phone2", rs2.getString("contact_phone2"));
                            ic.setTransientDatum("contact_email2", rs2.getString("contact_email2"));
                            ic.setTransientDatum("contact_name3", rs2.getString("contact_name3"));
                            ic.setTransientDatum("contact_phone3", rs2.getString("contact_phone3"));
                            ic.setTransientDatum("contact_email3", rs2.getString("contact_email3"));
                            ic.setTransientDatum("contact_name4", rs2.getString("contact_name4"));
                            ic.setTransientDatum("contact_phone4", rs2.getString("contact_phone4"));
                            ic.setTransientDatum("contact_email4", rs2.getString("contact_email4"));

                            ic.setTransientDatum("po_count", "" + rs2.getInt("po_count"));
                        }
                        else {
                            Diagnostics.error("Failed to locate request_id '" + record_id + "' to set session data.");
                        }
                        IMSUtil.closeQueryResultSet(rs2);
                    }
                    else {
                        Diagnostics.debug("Removing request_id, request_status_type_code, request_type_code, request_is_sent, request_readonly");
                        ic.removeSessionDatum("request_id");
                        ic.removeSessionDatum("request_no");
                        ic.removeSessionDatum("version_no");
                        ic.removeSessionDatum("request_type_id");
                        ic.removeSessionDatum("request_status_type_code");
                        ic.removeSessionDatum("request_type_code");
                        ic.removeSessionDatum("request_is_sent");
                        ic.removeSessionDatum("request_readonly");
                        ic.removeSessionDatum("show_next");
                        ic.removeSessionDatum("can_send_sr");
						if (StringUtil.hasAValue(quoting) && quoting.equalsIgnoreCase("true"))
                            ic.setSessionDatum("quoting", quoting);
						else
                            ic.removeSessionDatum("quoting");
                        }

                    // HANDLE QUOTE_ID

                    if (StringUtil.hasAValue(quoteID)) {
                        record_id = quoteID;

                        query = "SELECT getDate() cur_date,"
                                + "       isnull(est_start_date,getDate()+100)-? wo_lock_date,"
                                + "       isnull(est_start_date,getDate()+100)-? sr_lock_date,"
                                + "       record_status_type_code,"
                                + "       record_is_sent,"
                                + "       record_type_code,"
                                + "       quote_request_id,"
                                + "       is_quoted "
                                + "  FROM projects_all_requests_v "
                                + " WHERE"
                                + " record_type_code = 'quote' AND record_id = ?";

                        rs2 = conn.select(query, new Integer[]{num_workorder_lock_days, num_service_req_lock_days, Integer.parseInt(record_id)});

                        if (rs2.next()) {// found request
                            record_status_type_code = rs2.getString("record_status_type_code");
                            record_is_sent = rs2.getString("record_is_sent");
                            record_type_code = rs2.getString("record_type_code");
							if (record_status_type_code.equalsIgnoreCase("closed") || record_is_sent.equalsIgnoreCase("Y"))
                                record_readonly = "true";
							else
                                record_readonly = "false";

                            Diagnostics.debug("Setting quote_id to '" + record_id + "', quote_status_type_code='"
                                    + record_status_type_code + "', quote_type_code='" + record_type_code + "', quote_is_sent='"
                                    + record_is_sent + "', quote_readonly='" + record_readonly + "'");
                            ic.setSessionDatum("quote_id", record_id);
                            ic.setSessionDatum("quote_status_type_code", record_status_type_code);
                            ic.setSessionDatum("quote_type_code", record_type_code);
                            ic.setSessionDatum("quote_is_sent", record_is_sent);
                            ic.setSessionDatum("quote_readonly", record_readonly);
                        }
                        else {
                            Diagnostics.error("Failed to locate quote_id '" + record_id + "' to set session data.");
                        }
                        IMSUtil.closeQueryResultSet(rs2);
                    }
                    else {
                        Diagnostics.debug("Removing quote_id, quote_status_type_code, quote_type_code, quote_is_sent, quote_readonly.");
                        ic.removeSessionDatum("quote_id");
                        ic.removeSessionDatum("quote_status_type_code");
                        ic.removeSessionDatum("quote_type_code");
                        ic.removeSessionDatum("quote_is_sent");
                        ic.removeSessionDatum("quote_readonly");
                    }
                }
                IMSUtil.closeQueryResultSet(rs);
            }
        }
        catch (Exception e) {
            ErrorHandler.handleException(ic, e, "Exception in SetProjectDatumHandler");
        }
        finally {
            if (conn != null) {
                conn.release();
            }
        }

        // set template if available
        String template_name = ic.getParameter("templateName");
		if (StringUtil.hasAValue(template_name))
            ic.setHTMLTemplateName(template_name);

        return result;
    }

    private static final String CHECK_FOR_INVOICES =
            "SELECT COUNT(*) as NUMBER_OF_INVOICES FROM INVOICES, JOBS WHERE INVOICES.JOB_ID = JOBS.JOB_ID AND JOBS.PROJECT_ID = ?";

    private void setCommissionMarkupPermissionValues(InvocationContext ic, ConnectionWrapper conn) {

        ic.setParameter(Constants.DISPLAY_MARKUP_WIDGETS, "false");
        ic.setParameter(Constants.HAS_EXISTING_INVOICES, "false");

        String projectId = (String) ic.getSessionDatum("project_id");
        QueryResults queryResults = null;

        User user = (User) ic.getSessionDatum("user");
        String organizationId = (String) ic.getSessionDatum("org_id");

        if (hasMarkupPermissions(user, organizationId)) {

            ic.setParameter(Constants.DISPLAY_MARKUP_WIDGETS, "true");
            if (projectId != null && projectId.trim().length() != 0) {
                try {
                    queryResults = conn.select(CHECK_FOR_INVOICES, projectId);
                    if (queryResults.next()) {
                        Integer count = queryResults.getInt("NUMBER_OF_INVOICES");
                        if (count > 0) {
                            ic.setParameter(Constants.HAS_EXISTING_INVOICES, "true");
                        }
                    }
                }
                catch (SQLException e) {
                    Diagnostics.error("SQLException in setCommissionMarkupValues projectId'" + projectId, e);
                    ErrorHandler.handleException(ic, e, "Exception in setCommissionMarkupValues");
                }
                finally {
                    if (queryResults != null) {
                        try {
                            queryResults.close();
                        }
                        catch (SQLException ignore) {
                            Diagnostics.error("SQLException closing setCommissionMarkupPermissionValuesqueryResults'", ignore);
                        }
                    }
                }
            }
        }
    }

    private boolean hasMarkupPermissions(User user, String organizationId) {
        return user != null && user.getRights() != null && user.getRights().containsKey("enet/req/ecms_commission")
                && organizationId != null && organizationId.trim().length() > 0 && organizationId.equals("14");
    }


    private boolean setLookupValues(InvocationContext ic, ConnectionWrapper conn) throws Exception {
        boolean result = true;
        QueryResults rs = null;

        try {
            rs = conn.select(SELECT_LOOKUPS);
            while (rs.next()) {
                if ("furniture_line_type".equals(rs.getString("lookup_type"))) {
                    ic.setTransientDatum("furniture_line_type_na", rs.getString("lookup_id"));
                }
                else if ("delivery_type".equals(rs.getString("lookup_type"))) {
                    ic.setTransientDatum("delivery_type_na", rs.getString("lookup_id"));
                }
                else if ("yes_no_type".equals(rs.getString("lookup_type"))) {
                    ic.setTransientDatum("yes_no_type_no", rs.getString("lookup_id"));
                }
            }
        }
        catch (Exception e) {
            ErrorHandler.handleException(ic, e, "Problem in SetProjectDatumHandler.setLookupValues");
            result = false;
		} finally {
			if (rs != null) rs.close();
        }

        return result;

    }

}
