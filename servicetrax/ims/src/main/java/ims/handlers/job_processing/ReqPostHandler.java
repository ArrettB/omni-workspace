/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001,2003,2006, Dynamic Information Systems, LLC
 * $Header: ReqPostHandler.java, 10, 1/27/2006 1:58:10 PM, Blake Von Haden$
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
package ims.handlers.job_processing;

import ims.helpers.MapUtil;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Id: ReqPostHandler.java, 1098, 3/6/2008 9:28:04 AM, David Zhao$
 */
public class ReqPostHandler extends BaseHandler {
	
	private static Map requestTypeMap;
	
	public static final String UPDATE_REQUEST
		= "UPDATE requests "
		+ "   SET est_start_date = s.est_start_date,"
		+ "       est_start_time = s.est_start_time,"
		+ "       est_end_date = s.est_end_date,"	
		+ "       cust_col_1 = s.cust_col_1,"
		+ "       cust_col_2 = s.cust_col_2,"
		+ "       cust_col_3 = s.cust_col_3,"
		+ "       cust_col_4 = s.cust_col_4,"
		+ "       cust_col_5 = s.cust_col_5,"
		+ "       cust_col_6 = s.cust_col_6,"
		+ "       cust_col_7 = s.cust_col_7,"
		+ "       cust_col_8 = s.cust_col_8,"
		+ "       cust_col_9 = s.cust_col_9,"
		+ "       cust_col_10 = s.cust_col_10,"
		+ "       description = s.description,"
		+ "       customer_contact_id = s.customer_contact_id,"
		+ "       delivery_type_id = s.delivery_type_id,"
		+ "       job_location_id = s.job_location_id,"	
		+ "       pri_furn_line_type_id = s.pri_furn_line_type_id,"
		+ "       pri_furn_type_id = s.pri_furn_type_id,"
		+ "       priority_type_id = s.priority_type_id,"
		+ "       schedule_type_id = s.schedule_type_id,"
		+ "       sec_furn_line_type_id = s.sec_furn_line_type_id,"
		+ "       sec_furn_type_id = s.sec_furn_type_id,"	
		+ "       taxable_flag = s.taxable_flag,"
		+ "       warehouse_loc = s.warehouse_loc,"
		+ "       wood_product_type_id = s.wood_product_type_id,"
		+ "       date_modified = getdate() "	
		+ "  FROM requests r INNER JOIN services s ON r.request_id = s.request_id "
		+ " WHERE request_type_id <> ? "
		+ "   AND s.service_id = ?";
	
	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("ReqPostHandler.handleEnvironment()");
		boolean result = true;

		// set data for acknowledgement popup window: note ack_email_info was set by PDSEmailHandler
		String button = ic.getParameter("button");
		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

		if (StringUtil.hasAValue(button))
		{//

			if (button.equals(SmartFormComponent.Save))
			{// validate that end_date is after start_date

				// manage custom columns only if short view
				String service_type_name = ic.getParameter("service_type_name");
				if (StringUtil.hasAValue(service_type_name) && service_type_name.equalsIgnoreCase("Short View"))
					handleCustomColsRecord(ic, conn);

				String serviceId = ic.getParameter("service_id");
				String est_start_date = ic.getParameter("est_start_date");
				String est_end_date = ic.getParameter("est_end_date");
				if (StringUtil.hasAValue(est_start_date) && StringUtil.hasAValue(est_end_date))
				{
					StdDate start_date = new StdDate(est_start_date);
					StdDate end_date = new StdDate(est_end_date);
					if (start_date.after(end_date))
					{// user defined error, start_date > end_date not allowed.
						result = false;
						SmartFormHandler.addSmartFormError(ic,
								"Start Date is after End Date, please ensure Start Date is before End Date.");
						ic.setTransientDatum("err@est_start_date", "false");
						ic.setTransientDatum("err@est_end_date", "false");
					}
				}

				//David's update SR code begins: 
//				String isNew = (String) ic.getSessionDatum("is_new");
				if (requestTypeMap == null) {
					requestTypeMap = MapUtil.getTypeMap(conn, "request_type");
				}

				int count = updateRequest(conn, serviceId);
				Diagnostics.debug3("Updated " + count + " request records to based on service change.'");
				
				//David's update SR code ends
				
//				// sneak in update to SERVICE REQUESTS est dates, and rare custom columns if we change them on the req.
				StringBuffer query = new StringBuffer();

				// sneak in update to WORKORDERS custom columns if we change them on the req.
				query = new StringBuffer();
				query.append("UPDATE requests SET ");
				query.append(" cust_col_1=s.cust_col_1, cust_col_2=s.cust_col_2, cust_col_3=s.cust_col_3, cust_col_4=s.cust_col_4, cust_col_5=s.cust_col_5,");
				query.append(" cust_col_6=s.cust_col_6, cust_col_7=s.cust_col_7, cust_col_8=s.cust_col_8, cust_col_9=s.cust_col_9, cust_col_10=s.cust_col_10");
				query.append(" FROM services s, extranet_req_v e ");
				query.append(" WHERE requests.request_id = e.request_id AND e.request_type_code = 'workorder'");
				query.append("  AND e.service_id = s.service_id AND e.service_id = ").append(StringUtil.toSQLString(serviceId));
				conn.updateEx(query);

				// sneak in update of scheduling info to associated workorders
				conn.updateEx("UPDATE request_vendors SET sch_start_date = s.est_start_date, sch_start_time=s.est_start_time, sch_end_date=s.est_end_date FROM sch_request_vendors_v s WHERE request_vendors.request_vendor_id = s.request_vendor_id AND service_id ="
								+ StringUtil.toSQLString(serviceId));

			}

			String new_status = ic.getParameter("new_status");
			// handle case of closing or opening requisition
			if (result && StringUtil.hasAValue(new_status))
				result = ic.dispatchHandler("ims.handlers.job_processing.StatusHandler");
		}

		if (result)
			ic.setParameter("successful_save", "true");

		return result;
	}

	private boolean handleCustomColsRecord(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("ReqPostHandler.handleCustomColsRecord()");
		boolean result = true;
		String user_id = (String) ic.getSessionDatum("user_id");
		String customer_id = (String) ic.getSessionDatum("customer_id");
		String service_id = ic.getParameter("service_id");

		// test if custom columns exist
		StringBuffer query = null;
		String count = conn.queryEx("SELECT count(*) FROM custom_cols WHERE service_id = " + conn.toSQLString(service_id));
		if (count.equals("0"))
		{// insert
			query = new StringBuffer();
			query.append("INSERT INTO custom_cols (service_id, custom_cust_col_id, col_title, col_sequence, active_flag, is_mandatory, is_droplist, created_by, date_created)");
			query.append(" SELECT ").append(conn.toSQLString(service_id)).append(", custom_cust_col_id, column_desc, col_sequence, active_flag, is_mandatory, is_droplist, ").append(user_id).append(", getDate()");
			query.append(" FROM custom_cust_columns");
			query.append(" WHERE customer_id = ").append(conn.toSQLString(customer_id)).append(" ORDER BY col_sequence");
			conn.updateEx(query);
		}

		// update value of custom_cols
		String c_value = null;
		String c_name = null;
		StringBuffer update_string = new StringBuffer();
		for (int i = 1; i < 11; i++)
		{
			// put droplist id or non droplist text into custom_cols
			c_name = "cust_col_" + i;
			c_value = ic.getParameter("x" + c_name); // use the x to separate custom_col table value from request table value
			query = new StringBuffer();
			query.append("UPDATE custom_cols SET col_value = ").append(conn.toSQLString(c_value)).append(", modified_by = ").append(user_id).append(", date_modified = getDate()");
			query.append(" WHERE service_id = ").append(conn.toSQLString(service_id)).append(" AND col_sequence = ").append(i);
			conn.updateEx(query);

			// want only text in the request table for smart table display purposes
			if (StringUtil.hasAValue(ic.getParameter("x" + c_name + "_text")))
				c_value = ic.getParameter("x" + c_name + "_text");
			update_string.append(c_name).append(" = ").append(conn.toSQLString(c_value)).append(", ");
		}

		if (StringUtil.hasAValue(update_string.toString()))
		{// update request to have only text values
			query = new StringBuffer();
			query.append("UPDATE services SET ").append(update_string).append(" modified_by = ").append(user_id).append(", date_modified = getDate()");
			query.append(" WHERE service_id = ").append(conn.toSQLString(service_id));
			conn.updateEx(query);
		}

		return result;
	}
	
	private int updateRequest(ConnectionWrapper conn, String serviceId) throws SQLException {
		int updated = 0;
		PreparedStatement stmt = null;

		try {
			stmt = conn.prepareStatement(UPDATE_REQUEST);
			stmt.setString(1, (String) requestTypeMap.get("workorder"));
			stmt.setString(2, serviceId);
			updated = stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception in ReqPostHandler.updateRequest: " + e);
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return updated;
	}

}
