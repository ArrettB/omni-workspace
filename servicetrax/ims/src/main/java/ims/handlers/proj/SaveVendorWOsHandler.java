/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2003, Dynamic Information Systems, LLC
 * SaveVendorWOsHandler.java, 7, 3/6/2006 3:46:56 PM, Blake Von Haden$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */
package ims.handlers.proj;

import ims.helpers.IMSUtil;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.Hashtable;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase
 * 
 * @version $Id: SaveVendorWOsHandler.java 1249 2008-05-22 14:41:47Z dzhao $
 */
public class SaveVendorWOsHandler extends BaseHandler
{
	public static final String UPDATE_REQUEST_VENDORS
	 	= "UPDATE request_vendors "
	 	+ "  SET sch_start_date = ?,"
		+ "      sch_end_date = ?,"
		+ "      sch_start_time = ?,"
		+ "      act_start_date = ?,"
		+ "      act_end_Date = ?,"
		+ "      act_start_time = ?,"
		+ "      estimated_cost = ?,"
		+ "      total_cost = ?,"
		+ "      invoice_date = ?,"
		+ "      invoice_numbers = ?,"
		+ "      visit_count = ?,"
		+ "      complete_flag = ?,"
		+ "      invoiced_flag = ?,"
		+ "      vendor_notes = ?,"
		+ " WHERE request_vendor_id = ?";

	public void setUpHandler() throws Exception {}

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#handleEnvironment(dynamic.intraframe.engine.InvocationContext)
	 */
	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.trace("SaveVendorWOsHandler.handleEnvironment()");
		boolean result = true;
		boolean prePostHandler = false;
		ConnectionWrapper conn = null;
		String button = null;
		try
		{
			button = ic.getRequiredParameter("button");
			conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
			if (conn == null)
			{
				conn = (ConnectionWrapper) ic.getResource();
				prePostHandler = false;
			}
			else
			{
				prePostHandler = true;
			}

			if (button.equalsIgnoreCase("save"))
			{
				result = handleSave(ic, conn);
				if (result)
					result = handleDelete(ic, conn);
			}
		}
		catch (Exception e)
		{
			SmartFormHandler.handleException(ic, e, conn, button);
			result = false;
		}
		finally
		{
			if (!prePostHandler && conn != null)
				conn.release();
		}

		return result;
	}

	/**
	 * @param ic
	 * @param conn
	 * @return
	 */
	private boolean handleSave(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("SaveVendorWOsHandler.handleSave()");
		boolean result = true;
		Hashtable<String,String> requestVendorIds = new Hashtable<String,String>();

		// test if this is smartform version
		/*
		 * String test = ic.getParameter(smartform_flag); if( StringUtil.hasAValue(smartform_flag) &&
		 * smartform_flag.equalsIgnoreCase("true") ) {
		 */
		int counter = 1;
		String index = "";
		if (StringUtil.hasAValue(ic.getParameter("request_vendor_id_1")))
			index = "_" + counter;
		String requestVendorID = null;
		while ((requestVendorID = ic.getParameter("request_vendor_id" + index)) != null)
		{
			String changed = ic.getParameter(requestVendorID + "_changed");
			
			if (StringUtil.hasAValue(changed) && "Y".equals(changed)) {	
				String sch_start_date = ic.getParameter("sch_start_date" + index);
				StdDate schStartDate = getDate(ic, "sch_start_date" + index);
				String sch_end_date = ic.getParameter("sch_end_date" + index);
				StdDate schEndDate = getDate(ic, "sch_end_date" + index);
				String sch_start_time = ic.getParameter("sch_start_time" + index);
				StdDate schStartTime = getTime(ic, "sch_start_time" + index, schStartDate);
	
				String act_start_date = ic.getParameter("act_start_date" + index);
				StdDate actStartDate = getDate(ic, "act_start_date" + index);
				String act_end_date = ic.getParameter("act_end_date" + index);
				StdDate actEndDate = getDate(ic, "act_end_date" + index);
				String act_start_time = ic.getParameter("act_start_time" + index);
				StdDate actStartTime = getTime(ic, "act_start_time" + index, actStartDate);
	
				String estimated_cost = ic.getParameter("estimated_cost" + index);
				double estimatedCost = getMoney(ic, "estimated_cost" + index);
				String total_cost = ic.getParameter("total_cost" + index);
				double totalCost = getMoney(ic, "total_cost" + index);
	
				String invoice_date = ic.getParameter("invoice_date" + index);
				StdDate invoiceDate = getDate(ic, "invoice_date" + index);
				String invoiceNumbers = ic.getParameter("invoice_numbers" + index);
				String visitCount = ic.getParameter("visit_count" + index);
				String completeFlag = ic.getParameter("complete_flag" + index);
				String invoicedFlag = ic.getParameter("invoiced_flag" + index);
				String vendorNotes = ic.getParameter("vendor_notes" + index);
	
				// CHECK MANDATORY FIELDS FIRST
				if (completeFlag.equalsIgnoreCase("Y"))
				{
					if (actStartDate == null)
					{
						result = false;
						ic.setTransientDatum("err@act_start_date" + index, "Mandatory");
					}
					if (actEndDate == null)
					{
						result = false;
						ic.setTransientDatum("err@act_end_date" + index, "Mandatory");
					}
				}
				if (invoicedFlag.equalsIgnoreCase("Y"))
				{
					if (totalCost <= 0)
					{
						result = false;
						ic.setTransientDatum("err@total_cost" + index, "Mandatory");
					}
					if (invoiceDate == null)
					{
						result = false;
						ic.setTransientDatum("err@invoice_date" + index, "Mandatory");
					}
				}
				if (!StringUtil.hasAValue(visitCount))
				{// visit_count
					result = false;
					ic.setTransientDatum("err@visit_count" + index, "Mandatory");
				}
	
				// NOT MANDATORY BUT HAVE FORMATING REQUIREMENTS
	
				if (StringUtil.hasAValue(sch_start_date) && schStartDate == null)
				{// sch_start_date
					result = false;
					ic.setTransientDatum("err@sch_start_date" + index, "Invalid");
				}
				if (StringUtil.hasAValue(sch_end_date) && schEndDate == null)
				{// sch_end_date
					result = false;
					ic.setTransientDatum("err@sch_end_date" + index, "Invalid");
				}
				if (StringUtil.hasAValue(sch_start_time) && schStartTime == null)
				{// sch_start_time
					result = false;
					ic.setTransientDatum("err@sch_start_time" + index, "Invalid");
				}
				if (StringUtil.hasAValue(invoice_date) && invoiceDate == null)
				{// invoice_date
					result = false;
					ic.setTransientDatum("err@invoice_date" + index, "Invalid");
				}
				if (StringUtil.hasAValue(estimated_cost) && estimatedCost < 0)
				{// estimated_cost
					result = false;
					ic.setTransientDatum("err@estimated_cost" + index, "Invalid");
				}
	
				if (StringUtil.hasAValue(act_start_date) && actStartDate == null)
				{// act_start_date
					result = false;
					ic.setTransientDatum("err@act_start_date" + index, "Invalid");
				}
				if (StringUtil.hasAValue(act_end_date) && actEndDate == null)
				{// act_end_date
					result = false;
					ic.setTransientDatum("err@act_end_date" + index, "Invalid");
				}
				if (StringUtil.hasAValue(act_start_time) && actStartTime == null)
				{// act_start_time
					result = false;
					ic.setTransientDatum("err@act_start_time" + index, "Invalid");
				}
				if (StringUtil.hasAValue(total_cost))
				{// total_cost
					try
					{
						Integer.parseInt(visitCount);
					}
					catch (NumberFormatException e)
					{
						result = false;
						ic.setTransientDatum("err@total_cost" + index, "Not A Number");
					}
				}
				if (StringUtil.hasAValue(visitCount))
				{// visit_count
					try
					{
						Integer.parseInt(visitCount);
					}
					catch (NumberFormatException e)
					{
						result = false;
						ic.setTransientDatum("err@visit_count" + index, "Not A Number");
					}
				}
	
				if (result)
				{
					ic.setParameter("vendor_saved", "true");
	
					// determine if user updated sch dates, if so email customer
					StringBuffer query = new StringBuffer();
					query
							.append("SELECT rv.request_vendor_id, rv.request_id, rv.vendor_contact_name, rv.sch_start_date, r.request_type_code, r.request_status_type_code FROM request_vendors_v rv, requests_v r WHERE rv.request_id = r.request_id AND rv.request_vendor_id = "
									+ conn.toSQLString(requestVendorID));
					QueryResults rs = conn.resultsQueryEx(query);
					StdDate old_sch_start_date = new StdDate("01/01/1951");
					if (rs.next())
					{// grabbing old sch_start_date to indicate so we can email when it gets updated
						if (rs.getDate("sch_start_date") != null)
							old_sch_start_date = new StdDate(rs.getDate("sch_start_date"));
	
						if (schStartDate != null && !schStartDate.equals(old_sch_start_date))
						{// user must have updated schStartDate prepare data to email customer
							ic.setTransientDatum("record_id" + index, rs.getString("request_id"));
							ic.setTransientDatum("record_type_code" + index, rs.getString("request_type_code"));
							ic.setTransientDatum("request_vendor_id" + index, requestVendorID);
							ic.setTransientDatum("vendor_contact_name" + index, rs.getString("vendor_contact_name"));
							ic.setTransientDatum("sch_start_date" + index, schStartDate.toString());
							ic.setTransientDatum("old_sch_start_date" + index, old_sch_start_date.toString());
							// <><><>POST HANDLER DOES THE EMALING BECAUSE SMARTFORM NEEDS TO COMPLETE FIRST
						}
					}
					requestVendorIds.put(requestVendorID, ""); // used in the posthandler as transient
					IMSUtil.closeQueryResultSet(rs);
	
					if (StringUtil.hasAValue(index))
					{// coming from smartsheet concept so update
						StringBuffer update = new StringBuffer();
						update.append("UPDATE request_vendors");
						update.append(" SET sch_start_date = ").append(conn.toSQLString(schStartDate));
						update.append(", sch_end_date = ").append(conn.toSQLString(schEndDate));
						update.append(", sch_start_time = ").append(conn.toSQLString(schStartTime));
						update.append(", act_start_date = ").append(conn.toSQLString(actStartDate));
						update.append(", act_end_Date = ").append(conn.toSQLString(actEndDate));
						update.append(", act_start_time = ").append(conn.toSQLString(actStartTime));
						update.append(", estimated_cost = ").append(estimatedCost);
						update.append(", total_cost = ").append(totalCost);
						update.append(", invoice_date = ").append(conn.toSQLString(invoiceDate));
						update.append(", invoice_numbers = ").append(conn.toSQLString(invoiceNumbers));
						update.append(", visit_count = ").append(conn.toSQLString(visitCount));
						update.append(", complete_flag = ").append(conn.toSQLString(completeFlag));
						update.append(", invoiced_flag = ").append(conn.toSQLString(invoicedFlag));
						update.append(", vendor_notes = ").append(conn.toSQLString(vendorNotes));
						update.append(" WHERE request_vendor_id = " + requestVendorID);
	
						conn.updateExactlyEx(update, 1);
					}
	
					// used in the post handler
					ic.setTransientDatum("request_vendor_ids", requestVendorIds);
				}
				else
				{
					ic.setTransientDatum("use_transient" + index, "true");
					copyToTransient(ic, "act_start_date" + index);
					copyToTransient(ic, "act_end_date" + index);
					copyToTransient(ic, "total_cost" + index);
					copyToTransient(ic, "visit_count" + index);
					copyToTransient(ic, "invoice_flag" + index);
					copyToTransient(ic, "complete_flag" + index);
					copyToTransient(ic, "invoiced_flag" + index);
				}
			
			}

			counter++;
			index = "_" + counter;
		}
		Diagnostics.error("result='" + result + "'");
		return result;
	}

	/**
	 * @param ic
	 * @param conn
	 * @return
	 */
	private boolean handleDelete(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("SaveVendorWOsHandler.handleDelete()");
		boolean result = true;

		StringBuffer query = new StringBuffer();
		query.append("DELETE FROM request_vendors WHERE ");
		InClause delete_in_clause = new InClause();
		boolean found_vendor = false;

		String[] request_vendor_ids = ic.getParameterValues("delete_request_vendor_id");
		if (request_vendor_ids != null)
		{
			for (int i = 0; i < request_vendor_ids.length; i++)
			{
				delete_in_clause.add(request_vendor_ids[i]);
				found_vendor = true;
			}
		}

		if (found_vendor)
		{
			query.append(delete_in_clause.getInClause("request_vendor_id"));
			conn.updateEx(query);
		}

		return result;
	}

	private StdDate getDate(InvocationContext ic, String dateParamName)
	{
		StdDate result = null;
		String temp = ic.getParameter(dateParamName);
		if (StringUtil.hasAValue(temp))
		{
			try
			{
				result = new StdDate(temp);
			}
			catch (ParseException e)
			{
				Diagnostics.warning("Could not parse date: " + dateParamName + temp, e);
			}
		}
		return result;

	}

	private StdDate getTime(InvocationContext ic, String timeParamName, StdDate baseDate)
	{
		StdDate result = null;
		String temp = ic.getParameter(timeParamName);
		if (StringUtil.hasAValue(temp))
		{
			try
			{
				if (baseDate != null && temp != null && temp.length() <= 8)
				{
					temp = baseDate.toString() + " " + temp;
					result = new StdDate(temp);
				}
				else
					result = new StdDate(temp);
			}
			catch (ParseException e)
			{
				Diagnostics.warning("Could not parse time: " + timeParamName + ", " + temp, e);
			}
		}
		return result;
	}

	private double getMoney(InvocationContext ic, String dateParamName)
	{
		double result = -1;
		String temp = ic.getParameter(dateParamName);
		if (StringUtil.hasAValue(temp))
		{
			try
			{
				NumberFormat format = DecimalFormat.getCurrencyInstance();
				if (!temp.substring(0, 1).equals("$"))
					temp = "$" + temp;
				result = format.parse(temp).doubleValue();
			}
			catch (ParseException e)
			{
				Diagnostics.warning("Could not parse money: " + dateParamName + ", " + temp, e);
			}
		}
		return result;

	}

	private void copyToTransient(InvocationContext ic, String paramName)
	{
		ic.setTransientDatum(paramName, ic.getParameter(paramName));
	}

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#destroy()
	 */
	public void destroy()
	{
	}

}
