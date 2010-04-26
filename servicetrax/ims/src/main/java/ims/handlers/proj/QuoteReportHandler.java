package ims.handlers.proj;

import java.io.FileNotFoundException;
import java.sql.Date;
import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * Generate a old report.
 * 
 * The old reports are custom per organization.
 * 
 *
 * @version $Header: QuoteReportHandler.java, 14, 12/9/2005 11:30:59 AM, Blake Von Haden$
 */
public class QuoteReportHandler extends BaseHandler
{	
    public void setUpHandler(){}
	public void destroy(){}


	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{
			Diagnostics.trace("QuoteReportHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();

			String quoteID = ic.getRequiredParameter("quote_id");
			StringBuffer query = new StringBuffer();
			query.append("SELECT q.project_quote_no, q.date_quoted, q.description, q.quote_type_name, q.quote_total, q.taxable_flag, q.taxable_amount, q.warehouse_fee_flag, q.extra_conditions, q.ext_direct_dealer_id,");
			query.append(" q.quoted_by_user_name, q.quoted_by_phone, q.ext_dealer_id, q.customer_name, q.job_name, q.request_id, q.sales_rep_contact_name, q.duration_name, q.duration_qty");
			query.append(" FROM quotes_v q");
			query.append(" WHERE quote_id = ").append(quoteID);

			QueryResults rs = null;
			try
			{
				rs = conn.resultsQueryEx(query);
				if( rs.next() )
				{
					String requestID = rs.getString("request_id");
	
					ic.setTransientDatum("quote_id", quoteID);
					ic.setTransientDatum("project_quote_no", rs.getString("project_quote_no"));
					Date date_quoted = rs.getDate("date_quoted");
					String formatted = ic.format(date_quoted,"MMMM d, yyyy");
					ic.setTransientDatum("date_quoted", formatted);
					
					ic.setTransientDatum("description", rs.getString("description"));
					ic.setTransientDatum("quote_type_name", rs.getString("quote_type_name"));
					Double quote_total = new Double( rs.getDouble("quote_total") );
					ic.setTransientDatum("quote_total", ic.format(quote_total,"money") );
					Double taxable_amount = new Double( rs.getDouble("taxable_amount") );
					if( taxable_amount.doubleValue() > 0.01 ) 
						ic.setTransientDatum("taxable_amount", ic.format(taxable_amount,"money") );
					
					ic.setTransientDatum("warehouse_fee_flag", rs.getString("warehouse_fee_flag"));
					
					ic.setTransientDatum("job_name", rs.getString("job_name"));
					ic.setTransientDatum("quoted_by_name", rs.getString("quoted_by_user_name"));
					ic.setTransientDatum("quoted_by_phone", rs.getString("quoted_by_phone"));
					String ext_direct_dealer_id = rs.getString("ext_direct_dealer_id");
					String ext_dealer_id = rs.getString("ext_dealer_id");
					ic.setTransientDatum("ext_dealer_id", ext_dealer_id);
					String customer_name = rs.getString("customer_name");
					ic.setTransientDatum("customer_name", customer_name);
					ic.setTransientDatum("job_name", rs.getString("job_name"));
					ic.setTransientDatum("sales_rep_contact_name", rs.getString("sales_rep_contact_name"));
					ic.setTransientDatum("duration_name", rs.getString("duration_name"));
					ic.setTransientDatum("duration_qty", rs.getString("duration_qty"));
					ic.setTransientDatum("extra_conditions", rs.getString("extra_conditions"));
	
					setAddress(ic, conn, requestID, ext_direct_dealer_id, ext_dealer_id, customer_name);
				}
			}
			finally
			{
				if (rs != null)
					rs.close();
			}

			// dispatch the correct template
			String orgCode = (String) ic.getSessionDatum("org_code");
			String templatePath = "enet/rep/" + orgCode.toLowerCase().trim() + "_quote.html";
			try
			{
				ic.getTemplate(templatePath);
				// use custom if the template was found
				ic.setHTMLTemplateName(templatePath);
			}
			catch (FileNotFoundException e)
			{
				// use default
				ic.setHTMLTemplateName("enet/rep/q_report.html");
			}

		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in QuoteReportHandler");
		}
		finally
		{
			if (conn != null) conn.release();
		}

		return result;
	}
	
	private void setAddress(InvocationContext ic, ConnectionWrapper conn, String requestID, String ext_direct_dealer_id, String ext_dealer_id, String customer_name) throws Exception, SQLException
	{
		ConnectionWrapper gp_conn = null;
		QueryResults rs = null;
		try
		{
			StringBuffer addressQuery = new StringBuffer();
			ConnectionWrapper address_conn = null;
			if( ext_dealer_id != null && ext_dealer_id.equalsIgnoreCase( ext_direct_dealer_id ) )
			{//dealer is the direct dealer for this org (A&M), use customer address (job location's address) instead of dealers
				addressQuery.append("SELECT "+conn.toSQLString(customer_name)+" customer_name, jl.street1, jl.street2, jl.street3, jl.city, jl.state, jl.zip ");
				addressQuery.append(" FROM job_locations jl, requests r");
				addressQuery.append(" WHERE r.job_location_id = jl.job_location_id");
				addressQuery.append(" AND r.request_id = ").append(requestID);
				address_conn = conn;					
			}
			else
			{//dealer is not direct, so send quote to dealer, get dealer'a address from great plains
				gp_conn = (ConnectionWrapper)ic.getResource( (String)ic.getSessionDatum("org_resource") );
				if( gp_conn == null )
					throw new Exception("Failed to create Great Plains Database Connection, please see your administrator.");
				addressQuery.append("SELECT custname customer_name, address1 street1, address2 street2, address3 street3, city, state, zip ");
				addressQuery.append(" FROM RM00101 WHERE custnmbr="+conn.toSQLString(ext_dealer_id));
				address_conn = gp_conn;
			}
			Diagnostics.debug2("address query = "+addressQuery );
			rs = address_conn.resultsQueryEx(addressQuery);
			if (rs.next())
			{
				StringBuffer address = new StringBuffer();
				String jobLocationName = rs.getString("customer_name");
				String street1 = rs.getString("street1");
				String street2 = rs.getString("street2");
				String street3 = rs.getString("street3");
				String city = rs.getString("city");
				String state = rs.getString("state");
				String zip = rs.getString("zip");
	
				if ( StringUtil.hasAValue(jobLocationName) )
				{
					address.append(jobLocationName).append("<br>");
				}
				if ( StringUtil.hasAValue(street1) )
				{
					address.append(street1).append("<br>");
				}
				if ( StringUtil.hasAValue(street2) )
				{
					address.append(street2).append("<br>");
				}
				if ( StringUtil.hasAValue(street3) )
				{
					address.append(street3).append("<br>");
				}
				if ( StringUtil.hasAValue(city) )
				{
					address.append(city);
				}
				if ( StringUtil.hasAValue(state) )
				{
					address.append(", ").append(state);
				}
				if ( StringUtil.hasAValue(zip) )
				{
					address.append(" ").append(zip);
				}
	
				ic.setTransientDatum("address", address.toString());
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
			if (gp_conn != null)
				gp_conn.release();
		}
	}
}
