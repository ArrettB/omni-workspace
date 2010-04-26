package ims.dataobjects;

import ims.daemons.IMCommandRunner;
import ims.helpers.IMSUtil;
import ims.helpers.MapUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Document;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;

/**
 *
 * @version $Id: Invoice.java 1665 2009-08-12 15:49:40Z bvonhaden $
 */
public class Invoice extends AbstractDatabaseObject
{
	private int invoiceID;
	private int invoiceTypeID;
	private String extInvoiceID;
	private int statusID;
	private int jobID;
	private String description;
	private String extBillCustID;
	private Date dateSent;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;
	
	public static final String FETCH_INVOICE = "SELECT * FROM invoices WHERE invoice_id = ?";
	
	public static final String UPDATE_INVOICES
		= "UPDATE invoices " 
		+ "   SET date_sent = getDate()," 
		+       " date_modified = getDate(),"
        + "       ext_batch_id = ?,"
        + "       start_date = ?," 
        + "       end_date = ?," 
        + "       bill_customer_id = ?,"
        + "       ext_bill_cust_id = ?," 
        + "       cost_codes = ?,"
        + "       sales_reps = ?,"
        + "       gp_description = ? " 
        + " WHERE invoice_id = ?";
	
	public static final String UPDATE_REQUEST_VENDOR
		= "UPDATE request_vendors"
		+ "   SET total_cost = ISNULL(total_cost, 0) + ISNULL(i.sum_bill_total, 0),"
		+ "       invoice_date = getDate(),"
		+ "       invoice_numbers = ISNULL(invoice_numbers, '') + CONVERT(VARCHAR, i.invoice_id) "
		+ "  FROM request_invoices_v i "
		+ " WHERE request_vendors.request_id = i.request_id "
		+ "   AND request_vendors.vendor_contact_id = i.vendor_contact_id "
		+ "   AND i.invoice_id = ?";
	
	public static final String DELETE_SYSTEM_INVOICE_LINE
		= "DELETE FROM invoice_lines "
		+ " WHERE invoice_line_type_id = ? "
		+ "   AND invoice_id = ?";

	
	public Invoice()
	{
		super();
	}


	public static Invoice fetch(String invoiceID, InvocationContext ic)  throws SQLException
	{
		 return fetch(Integer.parseInt(invoiceID), ic, null);
	}

	public static Invoice fetch(String invoiceID, InvocationContext ic, String resourceName)  throws SQLException
	{
		 return fetch(Integer.parseInt(invoiceID), ic, resourceName);
	}

	public static Invoice fetch(int invoiceID, InvocationContext ic)  throws SQLException
	{
		 return fetch(invoiceID, ic, null);
	}

	public static Invoice fetch(int invoiceID, InvocationContext ic, String resourceName) throws SQLException
	{
		Diagnostics.trace("Invoice.fetch()");
		Invoice result = null;
		ConnectionWrapper conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			
			stmt = conn.prepareStatement(FETCH_INVOICE);
			stmt.setInt(1, invoiceID);
			rs = stmt.executeQuery();
			
			if (rs.next())
			{
				result = new Invoice();
				result.setInvoiceID(rs.getInt("invoice_id"));
				result.setInvoiceTypeID(rs.getInt("invoice_type_id"));
				result.setExtInvoiceID(rs.getString("ext_invoice_id"));
				result.setStatusID(rs.getInt("status_id"));
				result.setJobID(rs.getInt("job_id"));
				result.setDescription(rs.getString("description"));
				result.setExtBillCustID(rs.getString("ext_bull_cust_id"));
				result.setDateSent(rs.getDate("date_sent"));
				result.setDateCreated(rs.getDate("date_created"));
				result.setCreatedBy(rs.getInt("created_by"));
				result.setDateModified(rs.getDate("date_modified"));
				result.setModifiedBy(rs.getInt("modified_by"));
			}
			else
			{
				Diagnostics.error("Error in Invoice.fetch(), Could not find Invoice; Select was:" + FETCH_INVOICE + " and invoiceId = " + invoiceID);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Invoice.fetch()");
		}
		finally
		{
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null)
			{
				conn.release();
			}
		}

		 if (result != null) result.handleAction(FETCH_ACTION);
		return result;
	}

	public static boolean buildInvoice(ConnectionWrapper conn, InvocationContext ic, List<String> inInvoiceIds, String batchId, String modifiedBy) throws Exception
	{
		String[] outInvoiceIds = new String[inInvoiceIds.size()];
		outInvoiceIds = inInvoiceIds.toArray(outInvoiceIds);
		return buildInvoice(conn, ic, outInvoiceIds, batchId, modifiedBy);
	}

	public static boolean buildInvoice(ConnectionWrapper conn, InvocationContext ic, String[] invoiceIds, String batchId, String modifiedBy) throws Exception
	{
	    Diagnostics.debug("Invoice.buildInvoice()");

		String im = System.getProperty("am.integrationManager");
		if (ic.getAppGlobalDatum(IMCommandRunner.IMCOMMAND_RUNNER) != null && im == null)
		{
		    Diagnostics.error("am.integration property not set - Integration Manager will not run!");
			ic.setTransientDatum("integrationManagerMsg", XMLUtils.getValue(ic.getConfigDocument(), "integrationManager:notSetupMsg").trim());
			return false;
		}

		batchId = batchId.toUpperCase();
		batchId = batchId.replaceAll("[\"\']", "");

		String getGPCustomerID = "SELECT j.customer_id, j.ext_dealer_id, j.ext_customer_id, o.ext_direct_dealer_id FROM jobs_v j, organizations o WHERE j.organization_id = o.organization_id AND job_id = (SELECT job_id FROM invoices WHERE invoice_id = ?)";

		StringBuffer updateInvoiceString = new StringBuffer();
		updateInvoiceString.append("UPDATE invoices SET date_sent = getDate(), ext_batch_id = " + conn.toSQLString(batchId) );

		StringBuffer insertInvoiceLinesString = new StringBuffer();
		insertInvoiceLinesString.append("INSERT INTO invoice_lines ");
		insertInvoiceLinesString.append(" (invoice_id, invoice_line_no, item_id, description, unit_price, qty, taxable_flag, date_created, created_by)");
		insertInvoiceLinesString.append(" VALUES (");

		StringBuffer insertServInvLineString = new StringBuffer();
		insertServInvLineString.append("INSERT INTO serv_inv_lines ");
		insertServInvLineString.append(" (service_line_id, invoice_line_id)");
		insertServInvLineString.append(" SELECT service_line_id, ");

		String selectStringNonTax = "SELECT b.item_id, b.bill_rate, sum(b.bill_qty) sum_bill_qty, sum(b.bill_total) sum_bill_total, b.taxable_flag, i.description item_description"
			+ " FROM billing_v b, items i"
			+ " WHERE b.item_id = i.item_id AND b.status_id > 3 AND (taxable_flag = 'N' OR item_type_code = 'expense')"
			+ " AND b.invoice_id = ?"
			+ " GROUP BY b.item_id, b.invoice_description, i.description, b.bill_rate, b.taxable_flag";

		//roll all taxable hourly lines together into one line
		String selectStringTax = "SELECT b.invoice_id, i.item_id, sum(b.bill_total) bill_rate, 1 sum_bill_qty, sum(b.bill_total) sum_bill_total, b.taxable_flag, i.description item_description"
			+ " FROM billing_v b, items i"
			+ " WHERE i.NAME='Labor-Tax' AND i.organization_id = b.organization_id AND b.status_id > 3 AND b.taxable_flag = 'Y'"
			+ " AND b.item_type_code = 'hours' AND b.invoice_id = ?"
			+ " GROUP BY b.invoice_id, i.item_id, i.description, b.taxable_flag";

     	QueryResults rs = null;
		User user = (User)ic.getSessionDatum("user");
		boolean result = true;
		String invoiceLineTypeId = null;
		Map<String, String> minDateMap = new HashMap<String, String>();
		Map<String, String> maxDateMap = new HashMap<String, String>();
		Map<String, String> billCustomerMap = new HashMap<String, String>();
		Map<String, String> extBillCustomerMap = new HashMap<String, String>();
		Map<String, String> costCodeMap = new HashMap<String, String>();
		Map<String, String> salesRepMap = new HashMap<String, String>();
		Map<String, String> gpDescriptionMap = new HashMap<String, String>();

		try
		{
			Map invoice_line_types = MapUtil.getTypeMap(conn,"invoice_line_type");
			invoiceLineTypeId = (String)invoice_line_types.get("system"); //do not delete custom lines
			
			deleteSystemInvoiceLines(ic, conn, invoiceIds, invoiceLineTypeId);
			
 			for (int i=0; invoiceIds != null && i<invoiceIds.length; i++)
 			{
				//determine what great plains customer id to reference
				String gp_customer_id = null;
				String ims_customer_id = null;
				Diagnostics.debug("invoicing invoice_id = '"+invoiceIds[i]+"'");
				rs = conn.select(getGPCustomerID, invoiceIds[i]);
				if( rs.next() )
				{
					ims_customer_id = rs.getString("customer_id");
					String ext_dealer_id = rs.getString("ext_dealer_id");
					String ext_direct_dealer_id = rs.getString("ext_direct_dealer_id");
					if( ext_dealer_id != null )
						ext_dealer_id = ext_dealer_id.trim();
					if(ext_direct_dealer_id != null && ext_direct_dealer_id.trim().equalsIgnoreCase( ext_dealer_id ) )
						gp_customer_id = rs.getString("ext_customer_id"); //invoice A&M's direct customer
					else
						gp_customer_id = rs.getString("ext_dealer_id"); //invoice dealer
				}
				else
				{
					gp_customer_id = "no customer_id";
					Diagnostics.error("Invoice.buildInvoice() Failed to determine invoice's customer_id for invoice_id = '"+invoiceIds[i]+"'");
				}
				if( gp_customer_id != null )
					gp_customer_id = gp_customer_id.trim(); //trim ext values for insert
				rs.close();

				//determine the min_start_date and max_end_date to add to invoice description when integrating to great plains.
				String datesQuery = "SELECT MIN(est_start_date) min_start_date, MAX(est_end_date) max_end_date"
					+ " FROM services WHERE service_id in (SELECT bill_service_id FROM service_lines WHERE invoice_id = ?)";
				rs = conn.select(datesQuery, invoiceIds[i]);
				String min_start_date = null;
				String max_end_date = null;
				if( rs.next() )
				{
					min_start_date = ic.format(rs.getDate("min_start_date"),"date");
					max_end_date = ic.format(rs.getDate("max_end_date"),"date");
				}
				rs.close();

 				// make sure old lines are deleted
 				//conn.updateEx("DELETE FROM invoice_lines WHERE invoice_line_type_id = " + conn.toSQLString(invoiceLineTypeId) + " AND invoice_id = " + invoiceIds[i], true);

				//add the new non-tax invoice lines
	      		rs = conn.select(selectStringNonTax, invoiceIds[i]);
				int invLineNo = 0;
				while(rs.next()) {
					invLineNo++;
					String valueString = ","+ invLineNo +","+ rs.getString("item_id") +",'";
					String item_description = rs.getString("item_description");

					//carriage returns mess up javascript and also when sending to great plains, new lines coming across as a box character.
					item_description = StringUtil.replaceString(item_description, "\r\n", " ");
					item_description = StringUtil.replaceString(item_description, "\n", " ");

					valueString += item_description+"',"+ rs.getString("bill_rate") +","+ rs.getString("sum_bill_qty") +","+ conn.toSQLString(rs.getString("taxable_flag")) +", getDate(), " + user.getUserID() +")";

					conn.updateEx(insertInvoiceLinesString + invoiceIds[i] + valueString);
			      	String invoiceLineId = conn.selectFirst("SELECT SCOPE_IDENTITY()");
			      	if(StringUtil.hasAValue(invoiceLineId))
		    	  	{
			      		String query = insertServInvLineString + invoiceLineId +" FROM service_lines WHERE item_id = " + rs.getString("item_id") + " and invoice_id = " + invoiceIds[i] + " and status_id = 4" + " and taxable_flag = " + conn.toSQLString(rs.getString("taxable_flag"));
			      		conn.updateEx(query);
			      	}
				}
				rs.close();

				//add the new tax invoice line (always will be one per invoice)
      			rs = conn.select(selectStringTax, invoiceIds[i]);
				invLineNo = 0;
				while(rs.next())
				{
					invLineNo++;
					String valueString = ","+ invLineNo +","+ rs.getString("item_id") +",'";
					String item_description = rs.getString("item_description");

					//carriage returns mess up javascript and also when sending to great plains, new lines coming across as a box character.
					item_description = StringUtil.replaceString(item_description, "\r\n", " ");
					item_description = StringUtil.replaceString(item_description, "\n", " ");

					valueString += item_description+"',"+ rs.getString("bill_rate") +","+ rs.getString("sum_bill_qty") +","+ conn.toSQLString(rs.getString("taxable_flag")) +", getDate(), " + user.getUserID() +")";

					conn.updateEx(insertInvoiceLinesString + invoiceIds[i] + valueString);
			      	String invoiceLineId = conn.selectFirst("SELECT SCOPE_IDENTITY()");
			      	if(StringUtil.hasAValue(invoiceLineId))
			      	{
			      		String query = insertServInvLineString + invoiceLineId +" FROM service_lines WHERE item_id = " + rs.getString("item_id") + " and invoice_id = " + invoiceIds[i] + " and status_id = 4" + " and taxable_flag = " + conn.toSQLString(rs.getString("taxable_flag"));
			      		conn.updateEx(query);
		    	  	}
				}
				rs.close();

				//determine with cost codes for this invoice
				rs = conn.select("SELECT description FROM invoices WHERE invoice_id = ?", invoiceIds[i] );
				String gp_invoice_description = null;
				if( rs.next() )
				{
					gp_invoice_description = rs.getString("description");
					//carriage returns mess up javascript and also when sending to great plains, new lines coming across as a box character.
					gp_invoice_description = StringUtil.replaceString(gp_invoice_description, "\r\n", " ");
					gp_invoice_description = StringUtil.replaceString(gp_invoice_description, "\n", " ");
				}
				rs.close();

				//determine with cost codes for this invoice by service_line connection
		    	rs = conn.select("SELECT sales_rep_name, cost_to_cust, cost_to_vend, cost_to_job, warehouse_fee FROM invoice_cost_codes_line_v WHERE invoice_id = ?", invoiceIds[i] );
				boolean cost_to_cust  = false;
				boolean cost_to_vend  = false;
				boolean cost_to_job   = false;
				boolean warehouse_fee = false;
				boolean found = false;
				StringBuffer sales_rep_names = new StringBuffer();
				while(rs.next())
				{//may have multiple extranet requests
					if( rs.getString("cost_to_cust").equalsIgnoreCase("Y") )
						cost_to_cust = true;
					if( rs.getString("cost_to_vend").equalsIgnoreCase("Y") )
						cost_to_vend = true;
					if( rs.getString("cost_to_job").equalsIgnoreCase("Y") )
						cost_to_job = true;
					if( rs.getString("warehouse_fee").equalsIgnoreCase("Y") )
						warehouse_fee = true;
					if( StringUtil.hasAValue(rs.getString("sales_rep_name") ) )
						sales_rep_names.append(" "+rs.getString("sales_rep_name") );
					found = true;
				}
				rs.close();
				if( !found)
				{//use the job to find all project requests, grab newest request's data.
					rs = conn.resultsQueryEx("SELECT sales_rep_name, cost_to_cust, cost_to_vend, cost_to_job, warehouse_fee FROM invoice_cost_codes_job_v WHERE invoice_id = " + invoiceIds[i] +
							" AND (date_created = (SELECT MAX(date_created) FROM invoice_cost_codes_job_v WHERE invoice_id = " + invoiceIds[i] + "))");
					if( rs.next() )
					{
						if( rs.getString("cost_to_cust").equalsIgnoreCase("Y") )
							cost_to_cust = true;
						if( rs.getString("cost_to_vend").equalsIgnoreCase("Y") )
							cost_to_vend = true;
						if( rs.getString("cost_to_job").equalsIgnoreCase("Y") )
							cost_to_job = true;
						if( rs.getString("warehouse_fee").equalsIgnoreCase("Y") )
							warehouse_fee = true;
						if( StringUtil.hasAValue(rs.getString("sales_rep_name") ) )
							sales_rep_names.append(" "+rs.getString("sales_rep_name") );
					}
					rs.close();
				}

				StringBuffer cost_codes = new StringBuffer();
				if( cost_to_cust )
					cost_codes.append("CTC ");
				if( cost_to_vend )
					cost_codes.append("CTV ");
				if( cost_to_job )
					cost_codes.append("CTJ ");
				if( warehouse_fee )
					cost_codes.append("Warehouse ");
				
				if (StringUtil.hasAValue(invoiceIds[i])) {
					minDateMap.put(invoiceIds[i], min_start_date);
					maxDateMap.put(invoiceIds[i], max_end_date);
					billCustomerMap.put(invoiceIds[i], ims_customer_id);
					extBillCustomerMap.put(invoiceIds[i], gp_customer_id);
					costCodeMap.put(invoiceIds[i], truncateString(cost_codes, 100));
					salesRepMap.put(invoiceIds[i], truncateString(sales_rep_names, 50));
					gpDescriptionMap.put(invoiceIds[i], truncateString(gp_invoice_description, 500));
				}

				//update the invoices with the new information
//				String updateInvString = updateInvoiceString +
//						", start_date=" + conn.toSQLString(min_start_date) +
//						", end_date=" + conn.toSQLString(max_end_date) +
//						", bill_customer_id = " + conn.toSQLString(ims_customer_id) +
//						", ext_bill_cust_id = " + conn.toSQLString(gp_customer_id) +
//						", cost_codes = " + conn.toSQLString(truncateString(cost_codes, 100)) +
//						", sales_reps = " + conn.toSQLString(truncateString(sales_rep_names, 50)) +
//						", gp_description = " + conn.toSQLString(truncateString(gp_invoice_description, 500)) +
//						" WHERE invoice_id = ?";
//				conn.update(updateInvString, invoiceIds[i]);
//				conn.updateEx("UPDATE request_vendors SET total_cost = isnull(total_cost,0) + isnull(i.sum_bill_total,0), invoice_date = getDate(), invoice_numbers = isnull(invoice_numbers,'') + convert(varchar,i.invoice_id) FROM request_invoices_v i WHERE request_vendors.request_id = i.request_id AND request_vendors.vendor_contact_id = i.vendor_contact_id AND i.invoice_id = " + invoiceIds[i]);
			}
 			
 			updateInvoices(conn, invoiceIds, batchId, minDateMap, maxDateMap, billCustomerMap, extBillCustomerMap, costCodeMap, salesRepMap, gpDescriptionMap);
 			
 			updateRequestVendors(conn, invoiceIds);
 			
 			result = InvoiceBatch.sendToGP(batchId, modifiedBy, conn, ic);
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e, "Problem in Invoice.buildInvoice()");
			ic.setTransientDatum("integrationManagerMsg", "Problem in Invoice.buildInvoice()  Please report this problem: " + e.getMessage());
		}
		return result;
	}
	
	private static void deleteSystemInvoiceLines(InvocationContext ic, ConnectionWrapper conn, String[] invoiceIds, String lineTypeId) throws Exception {
		Diagnostics.debug("Invoice.deleteSystemInvoiceLines()");
		PreparedStatement stmt = null;
		String host = null;
		int port = 0;
		String from = null;
		String subject = "IMS deadlock alert";
		String alertToEmail = null;
		try {
			Document d = ic.getConfigDocument();
			host = XMLUtils.getValue(d, "mail:host").trim();
			port = Integer.valueOf(XMLUtils.getValue(d, "mail:port").trim()).intValue();
			from = host = XMLUtils.getValue(d, "mail:from").trim();
			alertToEmail = (String) ic.getAppGlobalDatum("deadlockAlter");
			stmt = conn.prepareStatement(DELETE_SYSTEM_INVOICE_LINE);
			
			for (int i = 0; i < invoiceIds.length; i++) {
				stmt.setString(1, lineTypeId);
				stmt.setString(2, invoiceIds[i]);
				stmt.addBatch();
			}
			
			stmt.executeBatch();
			
		} catch (SQLException  e) {
			if (e.getErrorCode() == 1205) {
				IMSUtil.sendEmail(host, port, alertToEmail, from, subject, e.getMessage() + " Failed SQL Statement = (" + DELETE_SYSTEM_INVOICE_LINE + ")");
			}
			Diagnostics.error("Exception in Invoice.deleteSystemInvoiceLines(): ", e);
		} finally {
			if (stmt != null) {
				stmt.close();
			}
		}
	}
	
	private static void updateInvoices(ConnectionWrapper conn, String[] invoiceIds, String extBatchId, Map<String, String> minDateMap,	
			Map<String, String> maxDateMap,	Map<String, String> billCustomerMap, Map<String, String> extBillCustomerMap,
			Map<String, String> costCodeMap, Map<String, String> salesRepMap, Map<String, String> gpDescriptionMap) throws Exception {
		
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(UPDATE_INVOICES);
			for (int i = 0; invoiceIds != null && i < invoiceIds.length; i++) {
				if (StringUtil.hasAValue(invoiceIds[i])) {
					
					stmt.setString(1, extBatchId);
					stmt.setString(2, minDateMap.get(invoiceIds[i]));
					stmt.setString(3, maxDateMap.get(invoiceIds[i]));
					stmt.setString(4, billCustomerMap.get(invoiceIds[i]));
					stmt.setString(5, extBillCustomerMap.get(invoiceIds[i]));
					stmt.setString(6, costCodeMap.get(invoiceIds[i]));
					stmt.setString(7, salesRepMap.get(invoiceIds[i]));
					stmt.setString(8, gpDescriptionMap.get(invoiceIds[i]));
					stmt.setString(9, invoiceIds[i]);
					
					stmt.addBatch();
				}
			}
			
			stmt.executeBatch();

		} catch (Exception e) {
			Diagnostics.error("Exception when updating request vendors in Invoice.updateInvoices: ", e);
		} finally {
			if (stmt != null) stmt.close();	
		}
		
	}
	
	private static void updateRequestVendors(ConnectionWrapper conn, String[] invoiceIds) throws Exception {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(UPDATE_REQUEST_VENDOR);
			for (int i = 0; invoiceIds != null && i < invoiceIds.length; i++) {
				if (StringUtil.hasAValue(invoiceIds[i])) {
					stmt.setString(1, invoiceIds[i]);
					stmt.addBatch();
				}
			}
			
			stmt.executeBatch();

		} catch (Exception e) {
			Diagnostics.error("Exception when updating request vendors in Invoice.updateRequestVendors: ", e);
		} finally {
			if (stmt != null) stmt.close();	
		}
		
	}

	private static String truncateString(StringBuffer s, int length)
	{
		if (s == null)
			return null;
		else
			return StringUtil.truncate(s.toString(), length);
	}

	private static String truncateString(String s, int length)
	{
		if (s == null)
			return null;
		else
			return StringUtil.truncate(s, length);
	}


	protected void internalUpdate(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Invoice.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE invoices ");
			update.append("SET invoice_type_id = ").append(this.getInvoiceTypeID());
			update.append(", ext_invoice_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtInvoiceID(), 30)));
			update.append(", status_id = ").append(this.getStatusID());
			update.append(", job_id = ").append(this.getJobID());
			update.append(", description = ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 50)));
			update.append(", ext_bill_cust_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtBillCustID(), 15)));
			update.append(", date_sent = ").append(conn.toSQLString(this.getDateSent()));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (invoice_id = ").append(this.getInvoiceID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Invoice.internalUpdate()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalInsert(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Invoice.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO invoices (");
				insert.append("invoice_type_id");
				insert.append(", ext_invoice_id");
				insert.append(", status_id");
				insert.append(", job_id");
				insert.append(", description");
				insert.append(", ext_bill_cust_id");
				insert.append(", date_sent");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getInvoiceTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtInvoiceID(), 30)));
				insert.append(", ").append(this.getStatusID());
				insert.append(", ").append(this.getJobID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtBillCustID(), 15)));
				insert.append(", ").append(conn.toSQLString(this.getDateSent()));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO invoices (");
				insert.append("invoice_id");
				insert.append(", invoice_type_id");
				insert.append(", ext_invoice_id");
				insert.append(", status_id");
				insert.append(", job_id");
				insert.append(", description");
				insert.append(", ext_bill_cust_id");
				insert.append(", date_sent");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getInvoiceID());
				insert.append(", ").append(this.getInvoiceTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtInvoiceID(), 30)));
				insert.append(", ").append(this.getStatusID());
				insert.append(", ").append(this.getJobID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtBillCustID(), 15)));
				insert.append(", ").append(conn.toSQLString(this.getDateSent()));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				invoiceID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Invoice.internalInsert()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalDelete(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Invoice.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM invoices ");
			delete.append("WHERE (invoice_id = ").append(this.getInvoiceID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Invoice.internalDelete()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	private boolean skipPrimaryKey()
	{
		boolean skipPrimaryKey = false;
		if (this.getInvoiceID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Invoice:\n");
		result.append("  invoice_id = ").append(this.getInvoiceID()).append("\n");
		result.append("  invoice_type_id = ").append(this.getInvoiceTypeID()).append("\n");
		result.append("  ext_invoice_id = ").append(this.getExtInvoiceID()).append("\n");
		result.append("  status_id = ").append(this.getStatusID()).append("\n");
		result.append("  job_id = ").append(this.getJobID()).append("\n");
		result.append("  description = ").append(this.getDescription()).append("\n");
		result.append("  ext_bill_cust_id = ").append(this.getExtBillCustID()).append("\n");
		result.append("  date_sent = ").append(this.getDateSent()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getInvoiceID()
	{
		return invoiceID;
	}

	public int getInvoiceTypeID()
	{
		return invoiceTypeID;
	}

	public String getExtInvoiceID()
	{
		return extInvoiceID;
	}

	public int getStatusID()
	{
		return statusID;
	}

	public int getJobID()
	{
		return jobID;
	}

	public String getDescription()
	{
		return description;
	}

	public String getExtBillCustID()
	{
		return extBillCustID;
	}

	public Date getDateSent()
	{
		return dateSent;
	}

	public Date getDateCreated()
	{
		return dateCreated;
	}

	public int getCreatedBy()
	{
		return createdBy;
	}

	public Date getDateModified()
	{
		return dateModified;
	}

	public int getModifiedBy()
	{
		return modifiedBy;
	}

	public void setInvoiceID(int invoiceIDIn)
	{
		invoiceID = invoiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setInvoiceTypeID(int invoiceTypeIDIn)
	{
		invoiceTypeID = invoiceTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtInvoiceID(String extInvoiceIDIn)
	{
		extInvoiceID = extInvoiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setStatusID(int statusIDIn)
	{
		statusID = statusIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobID(int jobIDIn)
	{
		jobID = jobIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDescription(String descriptionIn)
	{
		description = descriptionIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtBillCustID(String extBillCustIDIn)
	{
		extBillCustID = extBillCustIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateSent(Date dateSentIn)
	{
		dateSent = dateSentIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateCreated(Date dateCreatedIn)
	{
		dateCreated = dateCreatedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCreatedBy(int createdByIn)
	{
		createdBy = createdByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateModified(Date dateModifiedIn)
	{
		dateModified = dateModifiedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setModifiedBy(int modifiedByIn)
	{
		modifiedBy = modifiedByIn;
		handleAction(MODIFY_ACTION);
	}
}
