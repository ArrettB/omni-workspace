package ims.handlers.time_capture;

import ims.helpers.IMSUtil;
import ims.helpers.MapUtil;

import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;


/**
 * @version $Header: ExportExpensesHandler.java, 7, 3/6/2006 3:46:54 PM, Blake Von Haden$
 */
public class ExportExpensesHandler extends BaseHandler
{
	public void setUpHandler(){}
	public void destroy(){}


	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		boolean result = false;
		ConnectionWrapper conn = null;
		try
		{
			Diagnostics.trace("ExportExpensesHandler.handleEnvironment()");

			ic.setHTMLTemplateName(ic.getParameter("template_name"));
			String resourceName = ic.getParameter("resourceName");
			conn = (ConnectionWrapper)ic.getResource(resourceName);

			result = insertExpensesLines(conn, ic);
		}
		catch (Exception e)
		{
			Diagnostics.trace("error:"+e);	
			ErrorHandler.handleException(ic, e, "Problem in ExportExpensesHandler");
		}
		finally
		{
			if (conn != null)
				conn.release();
		}
		return result;
	}

	public boolean insertExpensesLines(ConnectionWrapper conn, InvocationContext ic) throws Exception
	{
		Diagnostics.trace("ExportExpensesHandler.insertExpensesLines()");
		boolean result = true;
		String submitType = ic.getParameter("submit_type");
		String batchId = ic.getParameter("ext_batch_id");
		String orgId = (String)(ic.getSessionDatum("org_id"));

		//first see if we are re-exporting
		if (submitType != null && submitType.equalsIgnoreCase("re_export"))
		{
			return export(ic, batchId, orgId, conn);
		}

		//otherwise test ext_batch_id
		QueryResults rs = conn.resultsQueryEx("SELECT ext_batch_id FROM expenses_batches WHERE ext_batch_id = " + conn.toSQLString(batchId));
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
	
			whereString.append(" WHERE service_line_date between ").append(conn.toSQLString(beginDate)).append(" AND ").append(conn.toSQLString(endDate) );
			whereString.append(" AND organization_id = ").append(conn.toSQLString(orgId));
			whereString.append(" AND expenses_exported_flag = 'N'");
			whereString.append(" AND status_id > 1");
			whereString.append(" AND (expense_export_code IS NOT NULL and expense_export_code <> '')");
	
			Map expenses_batch_statuses = MapUtil.getTypeMap(conn,"expenses_batch_status_type");
			insertBatchString.append("INSERT INTO expenses_batches (ext_batch_id, organization_id, begin_date, end_date, expenses_batch_status_type_id, date_created, created_by)");
			insertBatchString.append("VALUES (").append(conn.toSQLString(batchId)).append(",").append(conn.toSQLString(orgId)).append(",").append(conn.toSQLString(beginDate)).append(","+conn.toSQLString(endDate)).append(",").append(conn.toSQLString((String)expenses_batch_statuses.get("processed"))).append(",getDate(),").append(userId).append(")");
	
			insertBatchLinesString.append("INSERT INTO expenses_batch_lines (service_line_id, int_batch_id, expense_qty, expense_rate, expense_total, ext_item_id, ext_employee_id, expense_export_code) ");
			insertBatchLinesString.append("SELECT service_line_id, scope_identity(),expense_qty,expense_rate,expense_total,ext_item_id,ext_employee_id, expense_export_code FROM expenses_export_v ").append(whereString);
	
			int rows;
			try
			{
				conn.setAutoCommit(false);
				rows = conn.updateEx(insertBatchString);
				rows += conn.updateEx(insertBatchLinesString);
				result = export(ic, batchId, orgId, conn);
				conn.commit();
			}
			catch (Exception e)
			{
				result = false;
				conn.rollback();
				ErrorHandler.handleException(ic, e, "Problem in ExportExpensesHandler");
			}
			finally
			{
				if (conn != null)
				{
					conn.setAutoCommit(true);
				}
			}
		}
		IMSUtil.closeQueryResultSet(rs);
		return result;
	}

	public boolean export(InvocationContext ic, String batchId, String orgId, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("ExportExpensesHandler.export("+batchId+")");
    	HttpServletResponse resp = ic.getHttpServletResponse();
        PrintWriter out = new PrintWriter(resp.getOutputStream());
        resp.setContentType("text/comma-separated-values ");  // does not exists, so browser will ask to download the file
   	    resp.setHeader("Pragma", "no-cache");

		boolean result = true;
		StringBuffer whereString = new StringBuffer();
		StringBuffer selectString = new StringBuffer();

		whereString.append("WHERE ext_batch_id = " + conn.toSQLString(batchId) + " and organization_id = "+orgId);

		selectString.append("SELECT int_batch_id, ext_batch_id, sum(isNull(expense_total,0)) sum_expense_total, convert(char(10),begin_date,101) begin_date, convert(char(10),end_date,101) end_date, rtrim(ext_employee_id) ext_employee_id, employee_name, rtrim(expense_export_code) expense_export_code"
								+ " FROM expenses_batches_v "
								+ whereString
								+ " GROUP BY int_batch_id, ext_batch_id, begin_date, end_date, ext_employee_id, employee_name, expense_export_code"
								+ " ORDER BY employee_name");
		String int_batch_id = null;

        out.print("Co Code,");
        out.print("Batch ID,");
        out.print("File #,");
        out.print("Adjust DED Code,");
        out.println("Adjust DED Amount");
		BigDecimal total = null;
		BigDecimal zero = new BigDecimal("0").setScale(2,BigDecimal.ROUND_HALF_DOWN);
		int not_exported_count = 0;
		int total_count = 0;

		QueryResults rs = conn.resultsQueryEx(selectString);
		while (rs.next())
		{
			total_count++;
			int_batch_id = rs.getString("int_batch_id");
			total = new BigDecimal(rs.getDouble("sum_expense_total")).setScale(2,BigDecimal.ROUND_HALF_DOWN);
			if( total.compareTo(zero) > 0)
			{//have a value so export it
	            out.print("MKY,");
	            out.print(rs.getString("ext_batch_id")+",");
	            out.print(rs.getString("ext_employee_id")+",");
	            out.print(rs.getString("expense_export_code")+",");
				out.println(total.negate().toString() );
			}
			else
				not_exported_count++;
		}
		rs.close();
/*
Diagnostics.error("not_exported_count="+not_exported_count+", total_count="+total_count);
		if( not_exported_count > 0)
			ic.setTransientDatum("error_msg","There were ("+not_exported_count+") of ("+total_count+") line(s) with total dollars = $0.00 that were not exported.");
		if( not_exported_count != total_count )
		{
		}	
*/
		out.flush();
		out.close();

		//update the batch to indicate a new create date since re-exported
		String updateString = new String("UPDATE expenses_batches SET date_created = getDate() WHERE int_batch_id = " + conn.toSQLString(int_batch_id));
		conn.updateEx(updateString);

		return result;
	}
}