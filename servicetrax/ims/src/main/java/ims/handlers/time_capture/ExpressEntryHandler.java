package ims.handlers.time_capture;

import ims.helpers.IMSUtil;
import ims.TimeUtils;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import org.w3c.dom.Document;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;

/**
 * @version $Id: ExpressEntryHandler.java, 18, 2/10/2006 4:46:22 PM, Blake Von Haden$
 */
public class ExpressEntryHandler extends BaseHandler {
    private Hashtable statusHash;
    private static String[] addParameters = {"resource_id", "tc_service_id", "line_date", "item_id", "num_hours", "pay_code", "tc_qty", "tc_rate", "bill_rate"};

    public static final String SUBMIT_LINES
            = "UPDATE service_lines SET status_id = ?,"
            + "       date_modified = getDate() "
            + " WHERE service_line_id = ?";

    public void setUpHandler() {
    }

    public void destroy() {
    }

    private synchronized void loadStatusHash(ConnectionWrapper conn) throws SQLException {
        if (statusHash == null) {
            statusHash = new Hashtable();
            QueryResults rs = conn.resultsQueryEx("SELECT status_id, LOWER(code) code FROM service_line_statuses");
            while (rs.next()) {
                statusHash.put(rs.getString("code"), rs.getString("status_id"));
            }
            rs.close();
        }
    }

    private String getStatusID(String statusCode) throws Exception {
        String result = null;
        if (statusHash == null) {
            Diagnostics.error("Error in ExpressEntryHandler.getStatusID(), Could not find a matching statusCode for " + statusCode + " in statusHash.  Hashtable contents are " + statusHash);
        }
        else {
            result = (String) statusHash.get(statusCode.toLowerCase());
            if (result == null) {
                Diagnostics.error("Error in ExpressEntryHandler.getStatusID(), Could not find a matching statusCode for " + statusCode + " in statusHash.  Hashtable contents are " + statusHash);
            }
        }
        return result;
    }

    private void performRedirect(InvocationContext ic) throws IOException {
        String redirect = ic.getParameter("redirect");
        if (StringUtil.hasAValue(redirect)) {
            StringBuffer url = new StringBuffer();
            url.append(redirect);
            url.append("?prev_template=time/job_tc_main.html");

            String paramValue;
            for (int i = 0; i < addParameters.length; i++) {
                paramValue = ic.getParameter(addParameters[i]);
                if (StringUtil.hasAValue(paramValue)) {
                    url.append("&" + addParameters[i] + "=" + paramValue);
                }
            }

            ic.sendRedirect(url.toString());
        }
    }

    private void performRedirectAfterSubmit(InvocationContext ic) throws IOException {
        ic.sendRedirect(ic.getSessionDatum("showPage") + "time/job_tc_main.html?loc=job_tc_list");
    }


    public boolean handleEnvironment(InvocationContext ic) throws Exception {
        Diagnostics.debug2("ExpressEntryHandler.handleEnvironment()");
        ConnectionWrapper conn = null;
        boolean result = true;
        boolean submitting = false;
        try {
            ic.removeSessionDatum("pay_code_warning");
            conn = (ConnectionWrapper) ic.getResource();
            loadStatusHash(conn);
            String button = ic.getRequiredParameter("button");
            if (button.equalsIgnoreCase("Add")) {
                result = updateLines(ic, conn);
                result = addLines(ic, conn);
            }
            else if (button.equalsIgnoreCase("Delete Selected")) {
                result = deleteLines(ic, conn);
                result = updateLines(ic, conn);
            }
            else if (button.equalsIgnoreCase("Submit Records")) {
                result = updateLines(ic, conn);
                result = submitLines(ic, conn);
                submitting = true;
            }
            else if (button.equalsIgnoreCase("Update")) {
                result = updateLines(ic, conn);
            }
            else {
                Diagnostics.error("Unrecognized button in ExpressEntryHandler, button = " + button);
            }

            if (result) {
                if (submitting) {
                    performRedirectAfterSubmit(ic);
                }
                else {
                    performRedirect(ic);
                    performRedirect(ic);
                }
            }
            else {
                SmartFormHandler.copyParametersToTransient(ic);
            }

        }
        catch (Exception e) {
            result = false;
            ErrorHandler.handleException(ic, e, "Exception in ExpressEntryHandler");
        }
        finally {
            if (conn != null) {
                conn.release();
            }
        }

        return result;
    }

    private boolean addLines(InvocationContext ic, ConnectionWrapper conn) throws Exception {
        Diagnostics.debug2("ExpressEntryHandler.addLines()");
        boolean valid = true;

        String jobID = ic.getSessionDatum("job_id").toString();
        String userID = ic.getSessionDatum("user_id").toString();
        String[] serviceIDs = ic.getParameterValues("tc_service_id");

        String itemID = ic.getParameter("item_id");
        String lineDate = ic.getParameter("line_date");
        String payCode = ic.getParameter("pay_code");
        String[] resourceIDs = ic.getParameterValues("resource_id");
        StdDate now = new StdDate();
        StdDate lineDateParsed = null;
        String tempStatusID = getStatusID("temp");
        boolean billing = false;
        String module = ic.getParameter("module");
        if (StringUtil.hasAValue(module) && module.equalsIgnoreCase("bill")) {
            billing = true;
        }

        String itemTypeCode = ic.getParameter("item_type_code");
        boolean isExpense = "expense".equals(itemTypeCode);

        if (resourceIDs == null || resourceIDs.length == 0) {
            valid = false;
            ic.setTransientDatum("err@resource_id", "Please choose at least one resource.");
        }
        else {
            for (int i = 0; i < resourceIDs.length && valid == true; i++) {
                if (!StringUtil.hasAValue(resourceIDs[i])) {
                    valid = false;
                    ic.setTransientDatum("err@resource_id", "Please choose at least one resource.");
                }
            }
        }
        if (serviceIDs == null || serviceIDs.length == 0) {
            valid = false;
            ic.setTransientDatum("err@service_id", "Please choose a requisition.");
        }
        else {
            for (int i = 0; i < serviceIDs.length && valid == true; i++) {
                if (!StringUtil.hasAValue(serviceIDs[i])) {
                    valid = false;
                    ic.setTransientDatum("err@service_id", "Please choose a requisition.");
                }
            }
        }
        if (itemID == null || itemID.length() == 0) {
            valid = false;
            ic.setTransientDatum("err@item_id", "Please choose an item.");
        }
        if (StringUtil.hasAValue(lineDate)) {
            try {
                lineDateParsed = new StdDate(lineDate);
            }
            catch (ParseException e) {
                valid = false;
                ic.setTransientDatum("err@line_date", "The date entered could not be understood.  Please enter again.");
            }
            catch (NumberFormatException e) {
                valid = false;
                ic.setTransientDatum("err@line_date", "The date entered could not be understood.  The valid format is MM/DD/YYYY.");
            }
        }
        else {
            valid = false;
            ic.setTransientDatum("err@line_date", "Please enter the date.");
        }

        if (!isExpense && (payCode == null || payCode.length() == 0)) {
            valid = false;
            ic.setTransientDatum("err@pay_code", "Please choose a pay code.");
        }

        String qty = null;
        String tcRateField = null;
        String fieldCode = null;
        String errMessage = null;
        if (isExpense) {
            qty = ic.getParameter("tc_qty");
            tcRateField = ic.getParameter("tc_rate");
            fieldCode = "tc_qty";
            errMessage = "TC Qty";
        }
        else {
            qty = getNumberOfHours(ic);
            fieldCode = "num_hours";
            errMessage = "amount of hours";
        }
        if (qty == null || qty.length() == 0) {
            valid = false;
            ic.setTransientDatum("err@" + fieldCode, "Please enter the " + errMessage + ".");
        }
        else {
            try {
                Double.parseDouble(qty);
            }
            catch (NumberFormatException e) {
                valid = false;
                ic.setTransientDatum("err@" + fieldCode, "The " + errMessage + " entered could not be understood.  Please enter again.");
            }
        }

        double tcRate = 0;    // zero if hours entry.
        if (isExpense) {
            if (!StringUtil.hasAValue(tcRateField)) {
                valid = false;
                ic.setTransientDatum("err@tc_rate", "Please enter the Cost $.");
            }
            else {
                try {
                    tcRate = Double.parseDouble(tcRateField);
                }
                catch (NumberFormatException e) {
                    valid = false;
                    ic.setTransientDatum("err@tc_rate", "The Cost $ entered could not be understood.  Please enter again.");
                }

            }
        }


        if (!isExpense && valid) {
            if (!TimeCapturePreHandler.validPayCodeForItem(itemID, payCode.trim(), conn, ic)) {
                ic.setSessionDatum("pay_code_warning", "true.");
            }
        }

        String billRateField = ic.getParameter("bill_rate");
        double billRate = 0;    // zero if hours entry.
        if (isExpense) {
            if (!StringUtil.hasAValue(billRateField)) {
                valid = false;
                ic.setTransientDatum("err@bill_rate", "Please enter the Sell $.");
            }
            else {
                try {
                    billRate = Double.parseDouble(billRateField);
                }
                catch (NumberFormatException e) {
                    valid = false;
                    ic.setTransientDatum("err@bill_rate", "The Sell $ entered could not be understood.  Please enter again.");
                }
            }
        }

        if (valid) {
            for (int i = 0; i < resourceIDs.length; i++) {
                for (int j = 0; j < serviceIDs.length; j++) {
                    StringBuffer insert = new StringBuffer();
                    insert.append("INSERT INTO service_lines (");
                    insert.append(" service_line_date");
                    insert.append(", tc_job_id");
                    insert.append(", tc_service_id");
                    insert.append(", status_id");
                    insert.append(", item_id");
                    if (isExpense) {
                        insert.append(", item_type_code");
                    }
                    insert.append(", resource_id");
                    insert.append(", bill_rate");
                    if (billing) {
                        insert.append(", bill_qty");
                    }
                    else {
                        insert.append(", tc_rate");
                        insert.append(", tc_qty");
                    }
                    insert.append(", ext_pay_code");
                    insert.append(", entered_date");
                    insert.append(", entered_by");
                    insert.append(", entry_method");
                    insert.append(", billable_flag");
                    insert.append(", start_time");
                    insert.append(", end_time");
                    insert.append(", break_time_minutes");
                    insert.append(", date_created");
                    insert.append(", created_by");
                    insert.append(") VALUES (");
                    insert.append("  ").append(conn.toSQLString(lineDateParsed));
                    insert.append(", ").append(jobID);
                    insert.append(", ").append(serviceIDs[j]);
                    insert.append(", ").append(tempStatusID);
                    insert.append(", ").append(itemID);
                    if (isExpense) {
                        insert.append(", ").append(conn.toSQLString(itemTypeCode));
                    }
                    insert.append(", ").append(resourceIDs[i]);
                    insert.append(", ").append(billRate);
                    if (billing) {
                        insert.append(", ").append(qty);
                    }
                    else {
                        insert.append(", ").append(tcRate);
                        insert.append(", ").append(qty);
                    }
                    insert.append(", ").append(conn.toSQLString(payCode));
                    insert.append(", ").append(conn.toSQLString(now));
                    insert.append(", ").append(userID);
                    insert.append(", ").append(conn.toSQLString("WEB"));
                    insert.append(", ").append(conn.toSQLString("Y"));
                    insert.append(", ").append(getStartTimeInMilitaryTime(ic));
                    insert.append(", ").append(getEndTimeInMilitaryTime(ic));
                    insert.append(", ").append(getBreakTimeMinutes(ic));
                    insert.append(", ").append(conn.toSQLString(now));
                    insert.append(", ").append(userID);
                    insert.append(")");
                    Diagnostics.debug("insert = " + insert);
                    conn.updateExactlyEx(insert, 1);
                }
            }
        }

        return valid;


    }

    private boolean deleteLines(InvocationContext ic, ConnectionWrapper conn) throws Exception {
        Diagnostics.debug2("ExpressEntryHandler.deleteLines()");
        InClause slClause = new InClause();
        slClause.add(ic.getParameterValues("checked_sl"));
        String delete = "DELETE FROM service_lines WHERE " + slClause.getInClause("service_line_id");
        Diagnostics.debug("delete = " + delete);
        int deleted = conn.updateEx(delete);
        Diagnostics.debug("Deleted " + deleted + " service_lines ");
        return true;
    }

    private boolean submitLines(InvocationContext ic, ConnectionWrapper conn) throws Exception {
        boolean result = true;
        PreparedStatement stmt = null;

        Diagnostics.debug2("ExpressEntryHandler.submitLines()");
        String host = null;
        int port = 0;
        String from = null;
        String subject = "IMS deadlock alert";
        String alertToEmail = null;
//		InClause slClause = new InClause();	
//		slClause.add(ic.getParameterValues("checked_sl"));
//		String update = "UPDATE service_lines SET status_id = " + submittedStatusId +  " WHERE " + slClause.getInClause("service_line_id");
        try {
            Document d = ic.getConfigDocument();
            host = XMLUtils.getValue(d, "mail:host").trim();
            port = Integer.valueOf(XMLUtils.getValue(d, "mail:port").trim()).intValue();
            from = host = XMLUtils.getValue(d, "mail:from").trim();
            String[] ids = ic.getParameterValues("checked_sl");
            String submittedStatusId = getStatusID("submitted");
            alertToEmail = (String) ic.getAppGlobalDatum("deadlockAlter");
            stmt = conn.prepareStatement(SUBMIT_LINES);
            for (int i = 0; i < ids.length; i++) {
                stmt.setString(1, submittedStatusId);
                stmt.setString(2, ids[i]);
                stmt.addBatch();
            }
            Diagnostics.debug("update = " + SUBMIT_LINES);
            int[] updatedArray = stmt.executeBatch();
            int updated = 0;
            for (int i = 0; i < updatedArray.length; i++) {
                updated += updatedArray[i];
            }
            Diagnostics.debug("Updating " + updated + " service_lines ");

        }
        catch (SQLException e) {
            if (e.getErrorCode() == 1205) {
                IMSUtil.sendEmail(host, port, alertToEmail, from, subject, e.getMessage() + " Failed SQL Statement = (" + SUBMIT_LINES + ")");
            }
            Diagnostics.error("Exception in ExpressEntryHandler.submitLines(): ", e);
            //result = false;

        }
        finally {
            if (stmt != null) {
                stmt.close();
            }
        }


        return result;
    }


    private boolean updateLines(InvocationContext ic, ConnectionWrapper conn) throws Exception {
        Diagnostics.debug2("ExpressEntryHandler.updateLines()");

        //which service_lines need to be updated?
        String[] serviceLineIDs = ic.getParameterValues("service_line_id");

        String userID = ic.getSessionDatum("user_id").toString();
        StdDate now = new StdDate();

        boolean billing = false;
        String module = ic.getParameter("module");
        if (StringUtil.hasAValue(module) && module.equalsIgnoreCase("bill")) {
            billing = true;
        }

        String itemTypeCode = ic.getParameter("item_type_code");
        boolean isExpense = "expense".equals(itemTypeCode);

        boolean valid = true;

        if (serviceLineIDs != null) {
            List updateStatements = new ArrayList();
            String jobID = (String) ic.getSessionDatum("job_id");

            for (int i = 0; i < serviceLineIDs.length; i++) {
                String serviceLineID = serviceLineIDs[i];

                String changed = ic.getParameter(serviceLineID + "_changed");

                if (!StringUtil.hasAValue(changed) || "N".equals(changed)) {
                    continue;
                }

                String serviceID = ic.getParameter(serviceLineID + "_service_id");
                String itemID = ic.getParameter(serviceLineID + "_item_id");
                String lineDate = ic.getParameter(serviceLineID + "_line_date");
                String payCode = ic.getParameter(serviceLineID + "_pay_code");
                String numHours = ic.getParameter(serviceLineID + "_num_hours");
                String tcQty = ic.getParameter(serviceLineID + "_tc_qty");
                String tcRate = ic.getParameter(serviceLineID + "_tc_rate");
                String billRate = ic.getParameter(serviceLineID + "_bill_rate");
                StdDate hoursDateParsed = null;

                if (lineDate == null || lineDate.length() == 0) {
                    valid = false;
                    ic.setTransientDatum("err@line_date_update", "You must enter the date.");
                }
                else {
                    try {
                        hoursDateParsed = new StdDate(lineDate);
                    }
                    catch (ParseException e) {
                        valid = false;
                        ic.setTransientDatum("err@line_date_update", "The date you entered could not be understood.  Please enter again.");
                    }
                }
                String qty = null;
                String fieldCode = null;
                String errMessage = null;
                if (isExpense) {
                    qty = tcQty;
                    fieldCode = "tc_qty_update";
                    errMessage = "TC Qty";
                }
                else {
                    qty = numHours;
                    fieldCode = "num_hours_update";
                    errMessage = "amount of hours";
                }

                if (qty == null || qty.length() == 0) {
                    valid = false;
                    ic.setTransientDatum("err@" + fieldCode, "Please enter the " + errMessage + ".");
                }
                else {
                    try {
                        Double.parseDouble(qty);
                    }
                    catch (NumberFormatException e) {
                        valid = false;
                        ic.setTransientDatum("err@" + fieldCode, "The " + errMessage + " entered could not be understood.  Please enter again.");
                    }
                }

                if (isExpense) {
                    if (!StringUtil.hasAValue(tcRate)) {
                        valid = false;
                        ic.setTransientDatum("err@tc_rate_update", "Please enter the rate.");
                    }
                    else {
                        try {
                            Double.parseDouble(tcRate);
                        }
                        catch (NumberFormatException e) {
                            valid = false;
                            ic.setTransientDatum("err@tc_rate_update", "The rate entered could not be understood.  Please enter again.");
                        }
                    }
                }

                if (isExpense) {
                    if (!StringUtil.hasAValue(billRate)) {
                        valid = false;
                        ic.setTransientDatum("err@tc_bill_rate_update", "Please enter the bill rate.");
                    }
                    else {
                        try {
                            Double.parseDouble(billRate);
                        }
                        catch (NumberFormatException e) {
                            valid = false;
                            ic.setTransientDatum("err@tc_bill_rate_update", "The bill rate entered could not be understood.  Please enter again.");
                        }
                    }
                }

                if (!isExpense && valid) {
                    if (!TimeCapturePreHandler.validPayCodeForItem(itemID, payCode.trim(), conn, ic)) {
                        ic.setSessionDatum("pay_code_warning", "true.");
                    }
                }

                if (valid) {
                    String rate = null;
                    if (isExpense) {
                        rate = tcRate;
                    }
                    else {
                        rate = conn.selectFirst("SELECT rate FROM job_item_rates WHERE job_id = ? and item_id = ?", new String[]{jobID, itemID});
                    }

                    StringBuffer update = new StringBuffer();
                    update.append("UPDATE service_lines ");
                    update.append("SET tc_service_id = ").append(serviceID);
                    update.append(", item_id = ").append(itemID);
                    update.append(", ext_pay_code = ").append(conn.toSQLString(payCode));
                    update.append(", service_line_date = ").append(conn.toSQLString(hoursDateParsed));

                    if (billing) {
                        update.append(", bill_qty = ").append(qty);
                    }
                    else {
                        update.append(", tc_qty = ").append(qty);
                    }

                    if (isExpense) {
                        update.append(", bill_rate = ").append(billRate);
                    }

                    update.append(", tc_rate = ").append(rate);
                    update.append(", start_time = ").append(getStartTimeInMilitaryTime(serviceLineID, ic));
                    update.append(", end_time = ").append(getEndTimeInMilitaryTime(serviceLineID, ic));
                    update.append(", break_time_minutes = ").append(getBreakTimeMinutes(serviceLineID, ic));
                    update.append(", date_modified = ").append(conn.toSQLString(now));
                    update.append(", modified_by = ").append(userID);
                    update.append(" WHERE service_line_id = ").append(serviceLineID);

                    Diagnostics.debug("Update = " + update);
                    updateStatements.add(update.toString());
                }
                else {
                    break;
                }

            }// end of for loop


            if (valid) {
                for (Iterator iter = updateStatements.iterator(); iter.hasNext();) {
                    String update = (String) iter.next();
                    conn.updateEx(update);
                }
            }
        }
        return valid;

    }

    int getStartTimeInMilitaryTime(String serviceLineId, InvocationContext ic) {
        String startHours = ic.getParameter(serviceLineId + "_" + "start_time_hour");
        String startMinutes = ic.getParameter(serviceLineId + "_" + "start_time_minutes");
        String startAMPM = ic.getParameter(serviceLineId + "_" + "start_time_AMPM");

        return TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(startHours), Integer.valueOf(startMinutes), startAMPM);
    }

    int getEndTimeInMilitaryTime(String serviceLineId, InvocationContext ic) {
        String endHours = ic.getParameter(serviceLineId + "_" + "end_time_hour");
        String endMinutes = ic.getParameter(serviceLineId + "_" + "end_time_minutes");
        String endAMPM = ic.getParameter(serviceLineId + "_" + "end_time_AMPM");
        return TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(endHours), Integer.valueOf(endMinutes), endAMPM);
    }

    int getBreakTimeMinutes(String serviceLineId, InvocationContext ic) {
        String lunchDinnerHours = ic.getParameter(serviceLineId + "_" + "lunch_dinner_hours");
        String lunchDinnerMinutes = ic.getParameter(serviceLineId + "_" + "lunch_dinner_minutes");

        int breakTimeMinutes = (Integer.valueOf(lunchDinnerHours) * 60) + Integer.valueOf(lunchDinnerMinutes);
        return breakTimeMinutes;
    }

    int getStartTimeInMilitaryTime(InvocationContext ic) {
        String startHours = ic.getParameter("start_time_hour");
        String startMinutes = ic.getParameter("start_time_minutes");
        String startAMPM = ic.getParameter("start_time_AMPM");

        return TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(startHours), Integer.valueOf(startMinutes), startAMPM);
    }

    int getEndTimeInMilitaryTime(InvocationContext ic) {
        String endHours = ic.getParameter("end_time_hour");
        String endMinutes = ic.getParameter("end_time_minutes");
        String endAMPM = ic.getParameter("end_time_AMPM");
        return TimeUtils.getTimeAsMilitaryTime(Integer.valueOf(endHours), Integer.valueOf(endMinutes), endAMPM);
    }

    int getBreakTimeMinutes(InvocationContext ic) {
        String lunchDinnerHours = ic.getParameter("lunch_dinner_hours");
        String lunchDinnerMinutes = ic.getParameter("lunch_dinner_minutes");

        int breakTimeMinutes = (Integer.valueOf(lunchDinnerHours) * 60) + Integer.valueOf(lunchDinnerMinutes);
        return breakTimeMinutes;
    }

    private String getNumberOfHours(InvocationContext ic) {

        try {
            String lunchDinnerHours = ic.getParameter("lunch_dinner_hours");
            String lunchDinnerMinutes = ic.getParameter("lunch_dinner_minutes");

            String startHours = ic.getParameter("start_time_hour");
            String startMinutes = ic.getParameter("start_time_minutes");
            String startAMPM = ic.getParameter("start_time_AMPM");
            float start = (Float.valueOf(startHours) * 60) + Float.valueOf(startMinutes);
            if ("PM".equals(startAMPM)) {
                start += 720;
            }

            String endHours = ic.getParameter("end_time_hour");
            String endMinutes = ic.getParameter("end_time_minutes");
            String endAMPM = ic.getParameter("end_time_AMPM");
            float end = (Float.valueOf(endHours) * 60) + Float.valueOf(endMinutes);
            if ("PM".equals(endAMPM)) {
                end += 720;
            }

            float breakTime = (Float.valueOf(lunchDinnerHours) * 60) + Float.valueOf(lunchDinnerMinutes);
            double netHours = ((end - start) - breakTime) / 60.0;
            return String.valueOf(netHours);
        }
        catch (Exception e) {
            Diagnostics.error(e.getMessage());
        }
        return null;
    }
}
