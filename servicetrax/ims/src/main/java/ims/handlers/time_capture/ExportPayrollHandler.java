package ims.handlers.time_capture;

import ims.helpers.IMSUtil;
import ims.helpers.MapUtil;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;


/**
 * @version $Header: ExportPayrollHandler.java, 7, 3/6/2006 3:46:54 PM, Blake Von Haden$
 */
public class ExportPayrollHandler extends BaseHandler
{
	public void setUpHandler(){}


	public void destroy(){}


	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		boolean result = false;
		ConnectionWrapper conn = null;
		try
		{
			Diagnostics.debug2("ExportPayrollHandler.handleEnvironment()");

			ic.setHTMLTemplateName(ic.getParameter("template_name"));

			String resourceName = ic.getParameter("resourceName");
			conn = (ConnectionWrapper)ic.getResource(resourceName);

			result = insertPayrollLines(conn, ic);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Problem in ExportPayrollHandler");
		}
		finally
		{
			if (conn != null)
				conn.release();
		}
		return result;
	}

	public boolean insertPayrollLines(ConnectionWrapper conn, InvocationContext ic) throws Exception
	{
		Diagnostics.trace("ExportPayrollHandler.insertPayrollLines()");
		boolean result = true;
		String submitType = ic.getParameter("submit_type");
		String batchId = ic.getParameter("ext_batch_id");
		String orgId = (String)(ic.getSessionDatum("org_id"));

		//first test if we are exporting
		if (submitType != null && submitType.equalsIgnoreCase("re_export"))
		{
			return export(ic, batchId, orgId, conn);
		}

		//not exporting so make sure we have not already used the ext_batch_id
		QueryResults rs = conn.resultsQueryEx("SELECT ext_batch_id FROM payroll_batches WHERE ext_batch_id = " + conn.toSQLString(batchId));
		if( rs.next() )
		{
			ic.setTransientDatum("error_msg","You have selected a Batch ID ("+batchId+") that already exists, please select another...");
			result = false;
		}
		else
		{
			String beginDate = ic.getParameter("begin_date");
			String endDate = ic.getParameter("end_date");
			String userId = (String)(ic.getSessionDatum("user_id"));
			StringBuffer insertBatchLinesString = new StringBuffer();
			StringBuffer insertBatchString = new StringBuffer();
			StringBuffer whereString = new StringBuffer();
	
			whereString.append(" WHERE service_line_date between " + conn.toSQLString(beginDate) + " AND " + conn.toSQLString(endDate) );
			whereString.append(" AND organization_id = "+conn.toSQLString(orgId));
			whereString.append(" AND payroll_exported_flag = 'N'");
			whereString.append(" AND status_id > 1");
	
			Map payroll_batch_statuses = MapUtil.getTypeMap(conn,"payroll_batch_status_type");
			insertBatchString.append("INSERT INTO payroll_batches (ext_batch_id, organization_id, begin_date, end_date, payroll_batch_status_type_id, date_created, created_by)");
			insertBatchString.append("VALUES ("+conn.toSQLString(batchId)+","+conn.toSQLString(orgId)+","+conn.toSQLString(beginDate)+","+conn.toSQLString(endDate)+","+conn.toSQLString((String)payroll_batch_statuses.get("processed"))+",getDate(),"+userId+")");
	
			insertBatchLinesString.append("INSERT INTO payroll_batch_lines (service_line_id, int_batch_id, payroll_qty, payroll_rate, payroll_total, ext_item_id, ext_employee_id, ext_pay_code) ");
			insertBatchLinesString.append("SELECT service_line_id, scope_identity(),payroll_qty,payroll_rate,payroll_total,ext_item_id,ext_employee_id,ext_pay_code FROM payroll_v " + whereString);
	
			try
			{
				conn.setAutoCommit(false);
				conn.updateEx(insertBatchString);
				conn.updateEx(insertBatchLinesString);
				result = export(ic, batchId, orgId, conn);

				conn.commit();
			}
			catch (Exception e)
			{
				result = false;
				conn.rollback();
				ErrorHandler.handleException(ic, e, "Problem in ExportPayrollHandler");
			}
			finally
			{
				conn.setAutoCommit(true);
			}
		}
		IMSUtil.closeQueryResultSet(rs);
		return result;
	}

	public boolean export(InvocationContext ic, String batchId, String orgId, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("ExportPayrollHandler.export()");
    	HttpServletResponse resp = ic.getHttpServletResponse();
        PrintWriter out = new PrintWriter(resp.getOutputStream());
        resp.setContentType("text/comma-separated-values ");  // does not exists, so browser will ask to download the file
        resp.setHeader("Pragma", "no-cache");

		boolean result = true;
		StringBuffer whereString = new StringBuffer();
		StringBuffer selectString = new StringBuffer();

		whereString.append("WHERE ext_batch_id = " + conn.toSQLString(batchId) + " and organization_id = "+orgId);

		selectString.append("SELECT int_batch_id, ext_batch_id, sum(payroll_qty) hours, convert(char(10),begin_date,101) begin_date, convert(char(10),end_date,101) end_date, ext_employee_id, rtrim(ext_pay_code) ext_pay_code, rtrim(ext_item_id) ext_item_id"
								+ " FROM payroll_batches_v "
								+ whereString
								+ " GROUP BY int_batch_id, ext_batch_id, begin_date, end_date, ext_employee_id, ext_pay_code, ext_item_id");
		String int_batch_id = null;

        out.print("BATCH ID\t");
        out.print("HOURS\t");
        out.print("BEGIN DATE\t");
        out.print("END DATE\t");
        out.print("EMPLOYEE ID\t");
        out.print("PAY CODE\t");
        out.println("ITEM NUMBER");

		QueryResults rs = conn.resultsQueryEx(selectString);
		while (rs.next())
		{
			int_batch_id = rs.getString("int_batch_id");
            out.print(rs.getString("ext_batch_id")+"\t");
            out.print(rs.getString("hours")+"\t");
            out.print(rs.getString("begin_date")+"\t");
            out.print(rs.getString("end_date")+"\t");
            out.print(rs.getString("ext_employee_id")+"\t");
            out.print(rs.getString("ext_pay_code")+"\t");
            out.println(rs.getString("ext_item_id"));
		}
		rs.close();

		out.flush();
		out.close();

		//update the batch to indicate a new create date since re-exported
		String updateString = new String("UPDATE payroll_batches SET date_created = getDate() WHERE int_batch_id = " + conn.toSQLString(int_batch_id));
		conn.updateEx(updateString);

		return result;
	}
}