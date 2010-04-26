/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005,2006, Dynamic Information Systems, LLC
 * $Header: PocketEntryHandler.java, 3, 1/27/2006 1:58:10 PM, Blake Von Haden$
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
 */package ims.handlers.pocket;

import ims.listeners.IMSApplicationContextListener;

import java.sql.SQLException;
import java.text.ParseException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;

/**
 * 
 * @version $Header: PocketEntryHandler.java, 3, 1/27/2006 1:58:10 PM, Blake Von Haden$
 */
public class PocketEntryHandler extends BaseHandler
{

	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public static String getStatusID(InvocationContext ic, String statusCode) throws SQLException {
		return (String) ic.getAppGlobalDatum(IMSApplicationContextListener.SERVICE_LINE_STATUS_MAP + ":" + statusCode.toLowerCase());
	}

	public static String getPayCodeForItem(String itemID, InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		String orgID = (String) ic.getRequiredSessionDatum("org_id");
		String viewName = conn.queryEx("SELECT pda_item_paycodes_table FROM organizations WHERE organization_id = " + orgID);
		String payCode = conn.queryEx("SELECT pay_code FROM " + viewName + " WHERE item_id = " + itemID);
		return payCode;
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("PocketEntryHandler.handleEnvironment()");
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			String button = ic.getRequiredParameter("button");
			if (button.equalsIgnoreCase("Add"))
				addLines(ic, conn);
			else if (button.equalsIgnoreCase("Delete"))
				deleteLine(ic, conn);
			else if (button.equalsIgnoreCase("Update"))
				updateLine(ic, conn);
			else
				Diagnostics.error("Unrecognized button in PocketEntryHandler, button = " + button);
			SmartFormHandler.copyParametersToTransient(ic);
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e, "Exception in PocketEntryHandler");
		}
		finally
		{
			if (conn != null)
				conn.release();
			ic.setHTMLTemplateName("pocket/hours_entry.html");
		}
		return result;
	}

	private void updateLine(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		String serviceLineID = ic.getParameter("service_line_id");
		String resourceIDs[] = ic.getParameterValues("resource_id");
		String itemID = ic.getParameter("item_id");
		String numHours = ic.getParameter("tc_qty");
		String hoursDate = ic.getParameter("service_line_date");
		String userID = ic.getSessionDatum("user_id").toString();
		StdDate now = new StdDate();
		StdDate hoursDateParsed = null;
		boolean valid = true;
		if (resourceIDs == null || resourceIDs.length != 1)
		{
			valid = false;
			ic.setTransientDatum("err@resource_id", "You must choose one employee when updating a line.");
		}
		if (itemID == null || itemID.length() == 0)
		{
			valid = false;
			ic.setTransientDatum("err@item_id", "You must choose a item.");
		}
		if (numHours == null || numHours.length() == 0)
		{
			valid = false;
			ic.setTransientDatum("err@num_hours", "You must enter the amount of hours.");
		}
		else
		{
			try
			{
				Double.parseDouble(numHours);
			}
			catch (NumberFormatException e)
			{
				valid = false;
				ic.setTransientDatum("err@num_hours",
						"The number of hours you entered could not be understood.  Please enter again.");
			}
		}
		if (hoursDate == null || hoursDate.length() == 0)
		{
			valid = false;
			ic.setTransientDatum("err@hours_date", "You must enter the date.");
		}
		else
		{
			try
			{
				hoursDateParsed = new StdDate(hoursDate);
			}
			catch (ParseException e)
			{
				valid = false;
				ic.setTransientDatum("err@hours_date", "The date you entered could not be understood.  Please enter again.");
			}
		}
		if (valid)
		{
			String payCode = getPayCodeForItem(itemID, ic, conn);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE service_lines SET");
			update.append(" resource_id = ").append(resourceIDs[0]);
			update.append(", item_id = ").append(itemID);
			update.append(", tc_qty = ").append(numHours);
			update.append(", ext_pay_code = ").append(payCode);
			update.append(", service_line_date = ").append(conn.toSQLString(hoursDateParsed));
			update.append(", date_modified = ").append(conn.toSQLString(now));
			update.append(", modified_by = ").append(userID);
			update.append(" WHERE service_line_id = " + serviceLineID);
			conn.updateEx(update);
		}
	}

	private void deleteLine(InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		String serviceLineID = ic.getParameter("service_line_id");
		String delete = "DELETE FROM service_lines WHERE service_line_id = " + serviceLineID;
		int deleted = conn.updateEx(delete);
		Diagnostics.debug("Deleted " + deleted + " service_lines ");
		ic.removeParameter("service_line_id");
	}

	private void addLines(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.debug2("PocketEntryHandler.addLines()");
		boolean valid = true;
		String jobID = ic.getParameter("job_id").toString();
		String userID = ic.getSessionDatum("user_id").toString();
		String serviceID = ic.getParameter("tc_service_id");
		String itemID = ic.getParameter("item_id");
		String hoursDate = ic.getParameter("service_line_date");
		String numHours = ic.getParameter("tc_qty");
		String resourceIDs[] = ic.getParameterValues("resource_id");
		StdDate now = new StdDate();
		StdDate hoursDateParsed = null;
		String tempStatusID = getStatusID(ic, "Temp");
		if (resourceIDs == null || resourceIDs.length == 0)
		{
			valid = false;
			ic.setTransientDatum("err@resource_id", "You must choose at least one employee.");
		}
		if (serviceID == null || serviceID.length() == 0)
		{
			valid = false;
			ic.setTransientDatum("err@service_id", "You must choose a requisition.");
		}
		if (itemID == null || itemID.length() == 0)
		{
			valid = false;
			ic.setTransientDatum("err@item_id", "You must choose a item.");
		}
		if (hoursDate == null || hoursDate.length() == 0)
		{
			valid = false;
			ic.setTransientDatum("err@hours_date", "You must enter the date.");
		}
		else
		{
			try
			{
				hoursDateParsed = new StdDate(hoursDate);
			}
			catch (ParseException e)
			{
				valid = false;
				ic.setTransientDatum("err@hours_date", "The date you entered could not be understood.  Please enter again.");
			}
		}
		if (numHours == null || numHours.length() == 0)
		{
			valid = false;
			ic.setTransientDatum("err@num_hours", "You must enter the amount of hours.");
		}
		else
		{
			try
			{
				Double.parseDouble(numHours);
			}
			catch (NumberFormatException e)
			{
				valid = false;
				ic.setTransientDatum("err@num_hours",
						"The number of hours you entered could not be understood.  Please enter again.");
			}
		}
		if (valid)
		{
			String payCode = getPayCodeForItem(itemID, ic, conn);
			for (int i = 0; i < resourceIDs.length; i++)
			{
				int rate = 0;
				StringBuffer insert = new StringBuffer();
				insert.append("INSERT INTO service_lines (");
				insert.append(" service_line_date");
				insert.append(", tc_job_id");
				insert.append(", tc_service_id");
				insert.append(", status_id");
				insert.append(", item_id");
				insert.append(", resource_id");
				insert.append(", tc_rate");
				insert.append(", tc_qty");
				insert.append(", ext_pay_code");
				insert.append(", entered_date");
				insert.append(", entered_by");
				insert.append(", entry_method");
				insert.append(", billable_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(") VALUES (");
				insert.append("  ").append(conn.toSQLString(hoursDateParsed));
				insert.append(", ").append(jobID);
				insert.append(", ").append(serviceID);
				insert.append(", ").append(tempStatusID);
				insert.append(", ").append(itemID);
				insert.append(", ").append(resourceIDs[i]);
				insert.append(", ").append(rate);
				insert.append(", ").append(numHours);
				insert.append(", ").append(conn.toSQLString(payCode));
				insert.append(", ").append(conn.toSQLString(now));
				insert.append(", ").append(userID);
				insert.append(", ").append(conn.toSQLString("PDA"));
				insert.append(", ").append(conn.toSQLString("Y"));
				insert.append(", ").append(conn.toSQLString(now));
				insert.append(", ").append(userID);
				insert.append(")");
				Diagnostics.debug("insert = " + insert);
				conn.updateExactlyEx(insert, 1);
			}

		}
	}

}