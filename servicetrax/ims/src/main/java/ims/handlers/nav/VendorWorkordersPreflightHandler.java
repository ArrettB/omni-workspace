/*
 * Created on Mar 11, 2004 To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */

package ims.handlers.nav;

import ims.dataobjects.Function;
import ims.dataobjects.User;

import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase To change the template for this generated type comment go to Window - Preferences - Java - Code Generation - Code
 *         and Comments
 * @version $Header: VendorWorkordersPreflightHandler.java, 4, 1/19/2006 3:59:44 PM, Blake Von Haden$
 */
public class VendorWorkordersPreflightHandler extends BaseHandler {
	
	public static final String SELECT
		= "SELECT rv.project_id,"
		+ "       rv.request_id,"
		+ "       rv.request_vendor_id,"
		+ "       rv.vendor_contact_id,"
		+ "       rv.vendor_contact_name,"
		+ "       rv.workorder_no,"
		+ "       rv.customer_name,"
		+ "       rv.request_status_type_name,"
		+ "       rv.customer_po_no,"
		+ "       ISNULL(CONVERT(VARCHAR(12), rv.emailed_date, 101),'No Address') emailed_date,"
		+ "       rv.priority,"
		+ "       rv.est_start_date_varchar,"
		+ "       rv.est_end_date_varchar,"
		+ "       rv.sch_start_date," 
		+ "       rv.sch_start_time,"
		+ "       rv.sch_end_date,"
		+ "       rv.act_start_date,"
		+ "       rv.act_start_time,"
		+ "       rv.act_end_date,"
		+ "       rv.estimated_cost,"
		+ "       rv.total_cost,"
		+ "       rv.invoice_date,"
		+ "       rv.invoice_numbers,"
		+ "       rv.visit_count,"
		+ "       rv.complete_flag,"
		+ "       rv.invoiced_flag,"
		+ "       rv.vendor_notes,"
		+ "       rv.date_created"
		+ "  FROM request_vendors_v2 rv ";

	public void setUpHandler() throws Exception
	{
	}

	public String getApprovedStatusSeq(InvocationContext ic)
	{
		String result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			result = conn.queryEx("SELECT sequence_no FROM lookups_v WHERE lookup_code = 'approved' AND type_code = 'workorder_status_type'");
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception in getApprovedStatusSeq", e);
		}
		finally
		{
			if (conn != null)
				conn.release();
		}
		return result;

	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug("VendorWorkordersPreflightHandler.handleEnvironment()");

		User currentUser = (User) ic.getSessionDatum("user");
		String userContactIDParam = StringUtil.toPStmtInt(String.valueOf(currentUser.contactID));
		String userIDParam = StringUtil.toPStmtInt(String.valueOf(currentUser.userID));
		String filterCustomerID = ic.getParameter("filter_customer_id");
		String filterCustomerIDParam = StringUtil.toPStmtInt(filterCustomerID);
		Map rights = currentUser.getRights();
		Function multiVendorFunction = (Function) rights.get("enet/multi_vendor");
		boolean multiVendors = false;
		if (multiVendorFunction != null)
			multiVendors = multiVendorFunction.view;

		String statusSeqNo = ic.getParameter("status_seq_no");
		if (statusSeqNo == null || statusSeqNo.length() == 0)
			statusSeqNo = getApprovedStatusSeq(ic);

		String status = ic.getParameter("status");
		if (status == null || status.length() == 0)
			status = "closed";

		StringBuffer query = new StringBuffer(SELECT);

		if (multiVendors)
		{
			query.append(", user_vendors uv");
			query.append(" WHERE (rv.customer_id = uv.customer_id");
			query.append("   AND uv.user_id = " + userIDParam);
			if (filterCustomerID != null && filterCustomerID.length() > 0) {
				query.append(" AND uv.customer_id = " + filterCustomerIDParam);
			}
			query.append(")");

		}
		else
		{
			query.append(" WHERE (rv.vendor_contact_id = " + userContactIDParam);
			// query.append(" OR rv.furniture1_contact_id = " + userContactID);
			// query.append(" OR rv.furniture2_contact_id = " + userContactID);
			query.append(" )");

		}
		query.append(" AND rv.status_seq_no >= " + StringUtil.toPStmtInt(statusSeqNo));
		query.append(" AND rv.request_status_type_code != " + StringUtil.toPStmtString(status));
		query.append(" ORDER BY rv.workorder_no");

		ic.setTransientDatum("vendor_query", query.toString());

		return true;

	}

	public void destroy()
	{
	}

}