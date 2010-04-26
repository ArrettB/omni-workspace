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

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.util.CellReference;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.util.date.StdDate;
import dynamic.util.resources.ResourceManager;
import dynamic.util.xml.XMLUtils;


/**
 * Generate the Cost report. The bulk of the data comes from service lines.
 *
 * @version $Id: C:\work\ims\src\ims\handlers\job_processing\CostReport.java, 1098, 3/6/2008 9:28:04 AM, David Zhao$
 */
public class MacroCostReport extends XLSBaseReport
{
	private final static String ACCOUNT_NUM = "ACCOUNT_NUM";
	
	
	private Date startDate;
	private Date endDate;
	private String organizationId;
	
	private final static int LONG_LENGTH = 20;
	private final static int SHORT_LENGTH = 12;
	
	public MacroCostReport(String organizationId, Date startDate, Date endDate)
	{
		super();
		this.organizationId = organizationId;
		this.startDate = startDate;
		this.endDate = endDate;
	}
	
	private void jobTitle()
	{
		addTitleCell("Job No",  LONG_LENGTH);
		addTitleCell("Job Name",  LONG_LENGTH);
		addTitleCell("Total Bids",  SHORT_LENGTH);
		addTitleCell("Invoiced to Date",  SHORT_LENGTH);
		addTitleCell("Total Costs",  SHORT_LENGTH);
		addTitleCell("Invoiced Gross Profit",  SHORT_LENGTH);
		addTitleCell("Running Revenue",  SHORT_LENGTH);
		addTitleCell("Running Gross Profit",  SHORT_LENGTH);
		
	}
	
	public void run(ConnectionWrapper conn) throws SQLException
	{

		header(getOrganizationName(organizationId, conn), "Cost Spreadsheet");
				
		String jobQuery = "SELECT DISTINCT jobs.job_id, jobs.job_no, jobs.job_name, ISNULL(SUM(quotes.quote_total),0) AS [total_bids]" +
				" FROM jobs " + 
				" INNER JOIN services ON jobs.job_id = services.job_id" +
				" INNER JOIN customers ON jobs.customer_id = customers.customer_id" +
				" INNER JOIN service_lines ON services.service_id = service_lines.bill_service_id" +
				" LEFT OUTER JOIN quotes ON services.quote_id = quotes.quote_id" +
				" WHERE service_lines.service_line_date BETWEEN "+ conn.toSQLString(startDate) + " AND " + conn.toSQLString(endDate) + 
				" AND customers.organization_id = " + organizationId + 
			    " GROUP BY jobs.job_id, jobs.job_no, jobs.job_name" + 
				" ORDER BY jobs.job_no";
		
		QueryResults rs = null;
		
		try
		{
			int count = 0;
			rs = conn.resultsQueryEx(jobQuery);

			while (rs.next() && count++ < 50)
			{
				String jobId = rs.getString("job_id");
				String jobNo = rs.getString("job_no");
				String jobName = rs.getString("job_name");
				double totalBids = rs.getDouble("total_bids");

				double invoicedToDate = getInvoicedToDate(jobId, conn);
				double totalCost = 0;
				double runningRevenue = getRunningRevenue(jobId, conn);
				
				nextRow();
				jobTitle();
				nextRow();

				addStringCell(jobNo);
				addStringCell(jobName);
				addCurrencyCell(totalBids);
				
				addCurrencyCell(invoicedToDate);
				CellReference invoicedToDateRef = currentCellReference();
				
				HSSFCell totalCostCell = addCurrencyCell(0);
				CellReference totalCostCellRef = currentCellReference();

				HSSFCell invoicedGrossProfitCell = addPercentCell(0);
				invoicedGrossProfitCell.setCellFormula("(" + invoicedToDateRef + " - " + totalCostCellRef + " ) / " + invoicedToDateRef);
	
				addCurrencyCell(runningRevenue);
				CellReference runningRevenueCellRef = currentCellReference();

				HSSFCell runningGrossProfitCell = addPercentCell(0);
				runningGrossProfitCell.setCellFormula("(" + runningRevenueCellRef + " - " + totalCostCellRef + " ) / " + runningRevenueCellRef);

				nextRow();
				
		//		requisitionTitle(serviceNo);
				RequestTotals hours = generateHours(jobId,conn);

				RequestTotals expenses = generateExpenses(jobId, conn);
				
				totalCost = hours.getTotal() + expenses.getTotal();
				totalCostCell.setCellValue(totalCost);
				
				displayJobTotal(jobNo, hours, expenses);

				nextRow();
				nextRow();
				
				
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}
		
		
	}
	
	
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
	//	addCurrencyCell(getTotalBidsPerJob(jobId, conn));

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
		setColumnWidth(0,  20);

		query = "SELECT service_id, service_no FROM services WHERE job_id = " + conn.toSQLString(jobId);

		double totalCosts = 0;
		QueryResults rs = null;

		try
		{
			rs = conn.resultsQueryEx(query);

			while (rs.next())
			{
//				String serviceId = rs.getString("service_id");
				String serviceNo = rs.getString("service_no");

				nextRow();
				requisitionTitle(serviceNo);
		//		RequestTotals hours = generateHours(jobId, serviceId, serviceNo, conn);

	//			RequestTotals expenses = generateExpenses(jobId, serviceId, serviceNo, conn);
				
			//	totalCosts += hours.getTotal() + expenses.getTotal();
				
		//		displayReqTotal(serviceNo, hours, expenses);
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
		String query = "SELECT SUM(iv.bill_total + iv.custom_line_total) total_tot"
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
	private RequestTotals generateHours(String jobId, ConnectionWrapper conn)
		throws SQLException
	{
		String query =
			"SELECT v.item_name, SUM(v.tc_qty * v.cost_per_uom) total, SUM(v.tc_qty) labor_hours, v.cost_per_uom std_rate, v.column_position"
			+ " FROM job_costing_v v"
			+ " WHERE v.bill_job_id = " + conn.toSQLString(jobId)
			+ " AND v.item_type_code = 'hours'"
			+ " GROUP BY v.item_id, v.item_name, v.cost_per_uom, v.column_position"
			+ " ORDER BY v.item_name";
		
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
	private RequestTotals generateExpenses(String jobId, ConnectionWrapper conn)
		throws SQLException
	{
		String query = "SELECT v.item_name, SUM(v.tc_qty * v.cost_per_uom) total, SUM(v.tc_qty) tc_qty, v.cost_per_uom, SUM(v.tc_total) gp_total, v.entry_method, v.column_position"
			+ " FROM job_costing_v v"
			+ " WHERE v.bill_job_id = " + conn.toSQLString(jobId)
			+ " AND v.item_type_code = 'expense'" 
			+ " GROUP BY v.item_name, v.cost_per_uom, v.entry_method, v.column_position"
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
		addTitleCell("Desc",  20);
		addTitleCell("Quantity",  15);
		addTitleCell("Std Rate",  12);
		addTitleCell("Total",  15);
		addTitleCell("Subs",  12);
		addTitleCell("Materials",  12);
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
		addTitleCell("Desc",  20);
		addTitleCell("Quantity",  15);
		addTitleCell("Std Rate",  12);
		addTitleCell("Total",  15);
		addTitleCell("Subs",  12);
		addTitleCell("Materials",  12);
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
		addNumberCell(rs.getDouble("labor_hours"));	// quantity
		addCurrencyCell(rs.getDouble("std_rate"));
		addCurrencyCell(amount);	// total

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
			addNumberCell(rs.getDouble("tc_qty"));
			addCurrencyCell(rs.getDouble("cost_per_uom"));				
			addCurrencyCell(amount);
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
			addNumberSubTotalCell(ACCOUNT_NUM);
			addStringSubtotalCell("");
			addSubTotalCell(ACCOUNT_NUM);
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
//	private void displayReqTotal(String serviceNo, RequestTotals hours, RequestTotals expenses)
//	{
//		nextRow();
//		nextRow();
//		addStringCell("");
//		addBoldStringCell("Total Per Req #" + serviceNo);
//		HSSFCell totalCell = addCurrencyCell(0);
//
//		CellReference cellRefHours = new CellReference(hours.getRow(), 2);
//		CellReference cellRefExpense = new CellReference(expenses.getRow(), 2);
//
//		totalCell.setCellFormula(cellRefHours.toString() + "+" + cellRefExpense.toString());
//	}

	private void displayJobTotal(String jobNo, RequestTotals hours, RequestTotals expenses)
	{
		nextRow();
		nextRow();
		addStringCell("");
		addBoldStringCell("Total for Job No " + jobNo);
		addStringSubtotalCell("");
		addStringSubtotalCell("");
		HSSFCell totalCell = addSubtotalCell(0);

		CellReference cellRefHours = new CellReference(hours.getRow(), 4);
		CellReference cellRefExpense = new CellReference(expenses.getRow(), 4);

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

	public static void main(String[] args)
	{
		String xmlFile = "C:\\work\\ims\\www\\WEB-INF\\ims-dev.xml";
		String dest = "C:\\work\\export.xls";

		ConnectionWrapper conn = null;
		OutputStream out = null;
		try
		{
			Document doc = XMLUtils.parse(xmlFile);

			Element resourceManagerElement = XMLUtils.getSingleElement(doc, "resourceManager");
			String resourceManagerClass = resourceManagerElement.getAttribute("class");
			ResourceManager RM = (ResourceManager) Class.forName(resourceManagerClass).newInstance();
			RM.initialize(resourceManagerElement, null);

			if (!new File(dest).canWrite())
			{
				System.out.println("Can't write to " + dest);
			}
			
			conn = (ConnectionWrapper) RM.getResource();
	
			MacroCostReport report = new MacroCostReport("2", new StdDate("10/01/2005"), new StdDate("10/31/2005"));
			report.run(conn);
			
			out = new FileOutputStream(dest);
	 
			
			report.write(out);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if (conn != null)
				conn.release();
	
			if (out != null)
				try
				{
					out.close();
				}
				catch (IOException ignored)
				{
				}
		}

	}

	
}
