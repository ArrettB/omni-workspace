/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: C:\work\ims\src\ims\handlers\job_processing\CostReport.java, 13, 3/31/2006 2:08:52 PM, Blake Von Haden$
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

import ims.helpers.IMSUtil;

import java.sql.SQLException;
import java.text.DecimalFormat;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.util.CellReference;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;


/**
 * Generate the Cost report. The bulk of the data comes from service lines.
 * @version $Id: C:\work\ims\src\ims\handlers\job_processing\CostReport.java, 13, 3/31/2006 2:08:52 PM, Blake Von Haden$
 */
public class CostReport extends XLSBaseReport
{
	private final static String ACCOUNT_NUM = "ACCOUNT_NUM";
	

	/**
	 * The report starts here.  Gather the data.
	 * @param organizationId
	 *
	 * @param job_id
	 * @param conn
	 * @throws SQLException
	 */
	public void generate(String jobId, String organizationId, String customerName, ConnectionWrapper conn)
		throws SQLException
	{
		header(getOrganizationName(organizationId, conn), "Cost Spreadsheet");
		
		String query = "SELECT job_name FROM jobs WHERE job_id = " + conn.toSQLString(jobId);
		footer("Customer: " + customerName, "Job Name: " + conn.queryEx(query));
		
		nextRow();
		addBoldStringCell("Job");

		query = "SELECT job_no FROM jobs WHERE job_id = " + conn.toSQLString(jobId);
		addStringCellRightJustify(conn.queryEx(query));

		nextRow();
		addBoldStringCell("Total Bids");
		addCurrencyCell(getTotalBidsPerJob(jobId, conn));

		nextRow();
		addBoldStringCell("Invoiced to Date");
		double invoicedToDate = getInvoicedToDate(jobId, conn);
		addCurrencyCell(invoicedToDate);

		nextRow();
		addBoldStringCell("Total costs");
		HSSFCell totalCostCell = addCurrencyCell(0);

		nextRow();
		addBoldStringCell("Invoiced Gross Profit");
		HSSFCell grossProfitCell = addStringCellRightJustify("");

		nextRow();
		addBoldStringCell("Running Revenue");
		double runningRevenue = getRunningRevenue(jobId, conn);
		addCurrencyCell(runningRevenue);

		nextRow();
		addBoldStringCell("Running Gross Profit");
		HSSFCell runningProfitCell = addStringCellRightJustify("");

		// row between summary and details sections
		nextRow();
		setColumnWidth((short) 0, (short) 20);

		query = "SELECT service_id, service_no FROM services WHERE job_id = " + conn.toSQLString(jobId);

		double totalCosts = 0;
		QueryResults rs = null;

		try
		{
			rs = conn.resultsQueryEx(query);

			while (rs.next())
			{
				String serviceId = rs.getString("service_id");
				String serviceNo = rs.getString("service_no");

				nextRow();
				requisitionTitle(serviceNo);
				RequestTotals hours = generateHours(jobId, serviceId, serviceNo, conn);

				RequestTotals expenses = generateExpenses(jobId, serviceId, serviceNo, conn);
				
				totalCosts += hours.getTotal() + expenses.getTotal();
				
				displayReqTotal(serviceNo, hours, expenses);
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}

		totalCostCell.setCellValue(totalCosts);

		DecimalFormat format = new DecimalFormat("#0");
		double profitPercent = 0;
		if (invoicedToDate != 0)
		{
			// show the invoiced gross profit
			profitPercent = ((invoicedToDate - totalCosts) / invoicedToDate) * 100.0;
			grossProfitCell.setCellValue(format.format(profitPercent) + "%");
			
		}
		if (runningRevenue != 0)
		{
			// show the running gross profit
			profitPercent = ((runningRevenue - totalCosts) / runningRevenue) * 100.0;
			runningProfitCell.setCellValue(format.format(profitPercent) + "%");
		}

		setPrintArea();
	}

	/**
	 * Get the running revenue for the job.
	 * This is the sum of the Unbilled Ops, Billable total and the Posted, Billable total.
	 * It basically accounts for stuff not sent to Great Plains yet.
	 * 
	 * @param jobId
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private double getRunningRevenue(String jobId, ConnectionWrapper conn) throws SQLException
	{
		double result = 0;
		String query = "SELECT SUM(bill_total) bill_total"
			+  " FROM billing_v"
			+ " WHERE billable_flag = 'Y'"
			+   " AND ("
			+         "(status_id = 4 AND invoice_id IS NULL)"
			+        " OR "
			+        " (((status_id = 4 AND invoice_id IS NOT NULL) OR status_id = 5)"
			+         " AND (posted_flag = 'Y' OR  billed_flag = 'Y'))"
			+         ")"
			+   " AND bill_job_id =" + conn.toSQLString(jobId);
		QueryResults rs = null;

		try
		{
			rs = conn.resultsQueryEx(query);

			if (rs.next())
			{
				result = rs.getDouble("bill_total");
			}
		}
		finally
		{
			IMSUtil.closeQueryResultSet(rs);
		}

		return result;
	}

	/**
	 * @param organizationId
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private String getOrganizationName(String organizationId, ConnectionWrapper conn) throws SQLException
	{
		String query = "SELECT name FROM organizations WHERE organization_id = " + conn.toSQLString(organizationId);
		return conn.queryEx(query);
	}

	/**
	 * Get the value of the total bids for this job.
	 * 
	 * @param jobId
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private double getTotalBidsPerJob(String jobId, ConnectionWrapper conn) throws SQLException
	{
		double result = 0;
		String query = "SELECT SUM(quotes.quote_total) quote_total"
			+ " FROM services INNER JOIN quotes ON services.quote_id = quotes.quote_id"
			+ " WHERE services.job_id = " + conn.toSQLString(jobId);
		QueryResults rs = null;
		try
		{
			rs = conn.resultsQueryEx(query);

			if (rs.next())
			{
				result = rs.getDouble("quote_total");
			}
		}
		finally
		{
			IMSUtil.closeQueryResultSet(rs);
		}

		return result;
	}

	/**
	 * Get the total for invoices for this job.
	 * 
	 * @param jobId
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private double getInvoicedToDate(String jobId, ConnectionWrapper conn)
		throws SQLException
	{
		double result = 0;
		String query = "SELECT sum(iv.bill_total + iv.custom_line_total) total_tot"
			+ " FROM invoice_pre_total_v iv"
			+ " WHERE iv.job_id = " + conn.toSQLString(jobId);
		QueryResults rs = null;

		try
		{
			rs = conn.resultsQueryEx(query);

			if (rs.next())
			{
				result = rs.getDouble("total_tot");
			}
		}
		finally
		{
			IMSUtil.closeQueryResultSet(rs);
		}

		return result;
	}

	/**
	 * @param serviceNo
	 */
	private void requisitionTitle(String serviceNo)
	{
		nextRow();
		addBoldStringCell("Requisition #" + serviceNo);
	}

	/**
	 * Get the hours for regular and subcontractor items.
	 * 
	 * @param jobId
	 * @param serviceId
	 * @param serviceNo
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private RequestTotals generateHours(String jobId, String serviceId, String serviceNo, ConnectionWrapper conn)
		throws SQLException
	{
		String query =
			"SELECT  v.item_name, sum(v.tc_qty * v.cost_per_uom) total, sum(v.tc_qty) labor_hours, v.cost_per_uom std_rate, v.column_position"
			+ " FROM job_costing_v v"
			+ " WHERE v.bill_job_id = " + conn.toSQLString(jobId)
			+ " AND v.bill_service_id = " + conn.toSQLString(serviceId)
			+ " AND v.item_type_code = 'hours'"
			+ " GROUP BY v.bill_service_id, v.item_id, v.item_name, v.cost_per_uom, v.column_position";
		QueryResults rs = null;

		double total = 0;
		int row = 0;
		try
		{
			hoursTitle();
			rs = conn.resultsQueryEx(query);

			breakTotals(ACCOUNT_NUM);

			int count = 0;

			while (rs.next())
			{
				count++;
				total += processHoursRow(rs);
			}

			row = displayTotals("Hours", count);
		}
		finally
		{
			if (rs != null)
				rs.close();
		}

		return new RequestTotals(total, row);
	}

	/**
	 * Retrieve expense service lines - basically just material costs.
	 * 
	 * @param jobId
	 * @param serviceId
	 * @param serviceNo
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private RequestTotals generateExpenses(String jobId, String serviceId, String serviceNo, ConnectionWrapper conn)
		throws SQLException
	{
		String query = "SELECT  v.item_name, (v.tc_qty * v.cost_per_uom) total, v.tc_qty, v.cost_per_uom, v.tc_total gp_total, v.entry_method, v.column_position"
			+ " FROM job_costing_v v"
			+ " WHERE v.bill_job_id = " + conn.toSQLString(jobId)
			+ " AND v.bill_service_id = " + conn.toSQLString(serviceId)
			+ " AND v.item_type_code = 'expense'"
			+ " ORDER BY v.item_name";
		QueryResults rs = null;

		double total = 0;
		int row = 0;

		try
		{
			expensesTitle();
			rs = conn.resultsQueryEx(query);

			breakTotals(ACCOUNT_NUM);

			int count = 0;

			while (rs.next())
			{
				count++;
				total += processExpensesRow(rs);
			}

			row = displayTotals("Expenses", count);
		}
		finally
		{
			if (rs != null)
				rs.close();
		}

		return new RequestTotals(total, row);
	}

	/**
	 * Assign the column titles and set the column widths.
	 *
	 */
	private void hoursTitle()
	{
		HSSFRow row = nextRow();
		row.setHeightInPoints(30);
		addStringCell("");
		addBoldStringCell("HOURS");
		row = nextRow();
		addStringCell("");
		addTitleCell("Desc", (short) 20);
		addTitleCell("Total", (short) 15);
		addTitleCell("Quantity", (short) 15);
		addTitleCell("Std Rate", (short) 12);
		addTitleCell("Subs", (short) 12);
		addTitleCell("Materials", (short) 12);
	}

	/**
	 * Assign the column titles and set the column widths.
	 *
	 */
	private void expensesTitle()
	{
		HSSFRow row = nextRow();
		row.setHeightInPoints(30);
		addStringCell("");
		addBoldStringCell("EXPENSES");
		row = nextRow();
		addStringCell("");
		addTitleCell("Desc", (short) 20);
		addTitleCell("Total", (short) 15);
		addTitleCell("Quantity", (short) 15);
		addTitleCell("Std Rate", (short) 12);
		addTitleCell("Subs", (short) 12);
		addTitleCell("Materials", (short) 12);
	}

	/**
	 * Add an hours row to the report.
	 *
	 * @param rs
	 * @throws SQLException
	 */
	private double processHoursRow(QueryResults rs) throws SQLException
	{
		double amount = 0;

		// data row
		nextRow();

		addStringCell("");
		addStringCell(rs.getString("item_name"));

		String columnPosition = rs.getString("column_position");
		amount = rs.getDouble("total");
		addCurrencyCell(amount);	// total
		addNumberCell(rs.getDouble("labor_hours"));	// quantity
		addCurrencyCell(rs.getDouble("std_rate"));

		if ("subcontractor".equals(columnPosition))
		{
			addCurrencyCell(amount);
		}

		return amount;
	}

	/**
	 * Add an expense row to the report.
	 *
	 * @param rs
	 * @throws SQLException
	 */
	private double processExpensesRow(QueryResults rs)
		throws SQLException
	{
		// data row
		nextRow();
		String columnPosition = rs.getString("column_position");

		addStringCell("");
		addStringCell(rs.getString("item_name"));
		double amount = 0;
		
		String entryMethod = rs.getString("entry_method");
		if ("GREAT PLAINS".equals(entryMethod))
		{
			amount = rs.getDouble("gp_total");
			addCurrencyCell(amount);
			addStringCell("");
			if ("subcontractor".equals(columnPosition))
			{
				addStringCell("");
				addCurrencyCell(amount);
			}
			else if ("material".equals(columnPosition))
			{
				addStringCell("");
				addStringCell("");
				addCurrencyCell(amount);
			}
			else
			{
				addCurrencyCell(amount);				
			}
		}
		else
		{
			amount = rs.getDouble("total");
			addCurrencyCell(amount);
			addNumberCell(rs.getDouble("tc_qty"));

			addCurrencyCell(rs.getDouble("cost_per_uom"));				
			if ("subcontractor".equals(columnPosition))
			{
				addCurrencyCell(amount);
			}
			else if ("material".equals(columnPosition))
			{
				addStringCell("");
				addCurrencyCell(amount);
			}
		}

		return amount;
	}

	/**
	 * Display the totals at the breaks by Account Num.
	 *
	 * @param title
	 * @param count
	 * @return 
	 */
	private int displayTotals(String title, int count)
	{
		// account num total
		HSSFRow row = nextRow();
		addStringCell("");
		addBoldStringCell("Total " + title);

		if (count > 0)
		{
			addSubTotalCell(ACCOUNT_NUM);
			addNumberSubTotalCell(ACCOUNT_NUM);
			addStringSubtotalCell("");
			addSubTotalCell(ACCOUNT_NUM);
			addSubTotalCell(ACCOUNT_NUM);
		}
		return row.getRowNum();
	}
	
	/**
	 * Display the requisition summary total.
	 *
	 * @param req
	 * @param total
	 */
	private void displayReqTotal(String serviceNo, RequestTotals hours, RequestTotals expenses)
	{
		nextRow();
		nextRow();
		addStringCell("");
		addBoldStringCell("Total Per Req #" + serviceNo);
		HSSFCell totalCell = addCurrencyCell(0);

		CellReference cellRefHours = new CellReference(hours.getRow(), 2);
		CellReference cellRefExpense = new CellReference(expenses.getRow(), 2);

		totalCell.setCellFormula(cellRefHours.toString() + "+" + cellRefExpense.toString());
	}

	public class RequestTotals
	{
		double total;
		int row;
		public RequestTotals(double total, int row)
		{
			this.total = total;
			this.row = row;
		}
		public int getRow()
		{
			return row;
		}
		public double getTotal()
		{
			return total;
		}
	}
	
}
