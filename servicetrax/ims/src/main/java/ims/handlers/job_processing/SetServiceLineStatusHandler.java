package ims.handlers.job_processing;

import ims.dataobjects.Invoice;
import ims.helpers.IMSUtil;
import ims.listeners.IMSApplicationContextListener;

import java.sql.ParameterMetaData;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Enumeration;

import org.w3c.dom.Document;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;
import dynamic.util.xml.XMLUtils;


/**
 * @version $Id: SetServiceLineStatusHandler.java, 1098, 3/6/2008 9:28:04 AM, David Zhao$
 */
public class SetServiceLineStatusHandler extends BaseHandler
{

	public void setUpHandler()
	{
		Diagnostics.debug2("SetServiceLineStatusHandler.setUpHandler()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{

		try
		{
			//because of copy parameters, deleting still shows invoice.  Need to not copy parameters
			String button = (String)ic.getParameter(SmartFormComponent.BUTTON);

			if( !(button != null && (button.equals(SmartFormComponent.Delete) || button.equals(SmartFormComponent.New) ) ) )
			{//not deleting invoice so continue

				Diagnostics.debug2("SetServiceLineStatusHandler.handleEnvironment()");
	
				if (!setStatus(ic))
				{
					return false;
				}

				ic.setHTMLTemplateName(ic.getParameter("template_name"));
				copyParametersToTransient(ic);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Problem in SetServiceLineStatusHandler");
			return false;
		}
		return true;
	}

	private String getStatusID(InvocationContext ic, String statusCode) throws Exception {	
		return (String) ic.getAppGlobalDatum(IMSApplicationContextListener.SERVICE_LINE_STATUS_MAP + ":" + statusCode.toLowerCase());
	}



	public boolean setStatus(InvocationContext ic) throws Exception
	{
		String resourceName = ic.getParameter("resourceName");
		String level = ic.getParameter("level");
		String action = ic.getParameter("submit_action");
		String statusId = "";
		String invoiceId = "";
		String billJobId = "";
		String billServiceId = "";
		String checkedBoxes[] = ic.getParameterValues("statusCheckBox");
		String userId = (String)(ic.getSessionDatum("user_id"));
		StringBuffer updateString = new StringBuffer();
		StringBuffer whereString = new StringBuffer(" where 1=1");
		String updateTable = null;
		String finalWhereString = null;
		boolean updated = true;
		boolean buildInvoice = false;
		boolean isInvoice = false;
		boolean result = true;
		boolean success = true;

		String submittedStatusID = getStatusID(ic, "submitted");
		String postedStatusID = getStatusID(ic, "posted");

		if (level.equals("req_item"))
		{
			updateTable = "time_capture_v";
			finalWhereString = " and service_item_status_id = ?";
		}
		else if (level.equals("req"))
		{
			updateTable = "time_capture_v";
			finalWhereString = " and service_status_id = ?";
		}
		else if (level.equals("job_item"))
		{
			updateTable = "time_capture_v";
			finalWhereString = " and job_item_status_id = ?";
		}
		else if (level.equals("line"))
		{
			updateTable = "service_lines";
			finalWhereString = " and service_line_id = ?";
		}
		else if (level.equals("bill_req_item"))
		{
			updateTable = "billing_v";
			finalWhereString = " and service_item_status_id = ?";
		}
		else if (level.equals("bill_req"))
		{
			updateTable = "billing_v";
			finalWhereString = " and bill_service_status_id = ?";
		}
		else if (level.equals("bill_job_item"))
		{
			updateTable = "billing_v";
			finalWhereString = " and job_item_status_id = ?";
		}
		else if (level.equals("invoice"))
		{
			updateTable = "invoices";
			finalWhereString = " and invoice_id = ?";
			isInvoice = true;
		}


		updateString.append("UPDATE " + updateTable + " set modified_by = " + StringUtil.toPStmtInt(userId) + " ,date_modified = getDate() ");

		//when user is not at detail level, need to insure we move stuff off of just the invoice if we are on the invoice.
		String on_invoice = ic.getParameter("on_invoice");
		if( StringUtil.hasAValue(on_invoice) && on_invoice.equalsIgnoreCase("true") )
		{
			isInvoice = true;
			invoiceId = ic.getParameter("invoice_id");
			finalWhereString = " AND invoice_id = "+ StringUtil.toPStmtString(invoiceId) + finalWhereString;
		}
		else if( action != null && !action.startsWith("changeInvoiceStatus") )
		{
			finalWhereString = " AND invoice_id is null " + finalWhereString;
		}				

		//grabs the lines from the right status group in case user selects from multiple statuses.
		String cur_status_id = ic.getParameter("cur_status_id");
		if( StringUtil.hasAValue(cur_status_id) )
		{
			finalWhereString = " AND status_id = "+ StringUtil.toPStmtInt(cur_status_id) + finalWhereString;
		}


		if (action == null)
		{
			action = "";
			//return false;
		}
		else if (action.equalsIgnoreCase("billable"))
		{
			updateString.append(" ,billable_flag = " + StringUtil.toPStmtString("Y"));
		}
		else if (action.equalsIgnoreCase("nonbillable"))
		{
			updateString.append(" ,billable_flag = " + StringUtil.toPStmtString("N"));
		}
		else if (action.equalsIgnoreCase("changeBillServiceId"))
		{
			billJobId = ic.getParameter("bill_job_id");
			billServiceId = ic.getParameter("bill_service_id");
			updateString.append(", bill_job_id = " + StringUtil.toPStmtInt(billJobId) + ", bill_service_id = " + StringUtil.toPStmtInt(billServiceId));
		}
		else if (action.equalsIgnoreCase("updateTaxes"))
		{
			whereString.append(" and service_line_id = -1"); //do not want to update lines here.
		}
		else if(action.startsWith("move_submit_billing"))
		{
			updateString.append(", invoice_id = " + null);
			updateString.append(", status_id = " + StringUtil.toPStmtInt(submittedStatusID));
			updateString.append(", posted_from_invoice_id = null"); //when unposting want this set back to blank
		}
		else if(action.startsWith("move_posted"))
		{
			updateString.append(", invoice_id = " + null);
			updateString.append(", status_id = " + StringUtil.toPStmtInt(postedStatusID));
			updateString.append(", invoice_post_date = getDate()");
			if (updateTable.equals("service_lines")) {
				updateString.append(", posted_by = " + StringUtil.toPStmtInt(userId));
			}
						
			if (StringUtil.hasAValue(on_invoice) && on_invoice.equalsIgnoreCase("true"))
			{
				updateString.append(", posted_from_invoice_id = " + StringUtil.toPStmtString(invoiceId));
			}
		}
		else if(action.startsWith("assignInvoice"))
		{
			isInvoice = true;
			invoiceId = action.substring(13);
			updateString.append(", invoice_id = " + StringUtil.toPStmtInt(invoiceId));
			
			whereString.append(" AND billable_flag = 'Y'");
		}
		else if(action.startsWith("assignPostInvoice"))
		{
			isInvoice = true;
			invoiceId = action.substring("assignPostInvoice".length());
			updateString.append(", posted_from_invoice_id = " + StringUtil.toPStmtInt(invoiceId));
			updateString.append(", status_id = " + StringUtil.toPStmtInt(postedStatusID));
			updateString.append(", invoice_post_date = getDate()");
			
			whereString.append(" AND billable_flag = 'Y'");
		}
		else if(action.startsWith("moveToInvoice"))
		{
			invoiceId = action.substring(13);
			updateString.append(", invoice_id = " + StringUtil.toPStmtInt(invoiceId));
			
			whereString.append(" AND billable_flag = 'Y'");
		}
		else if(action.startsWith("addCustomLine"))
		{
			isInvoice = true;
			invoiceId = ic.getParameter("invoice_id");
		}
		else if(action.startsWith("changeInvoiceStatus"))
		{
			statusId = action.substring(19);
			updateString.append(" ,status_id = " + StringUtil.toPStmtInt(statusId));
			if (statusId.equals("4"))
			{
				buildInvoice = true;
			}
			isInvoice = true;
		}


		updateString.append(whereString);
		Diagnostics.debug2("updateString query = " + updateString );
		int rows[] = null;
		ConnectionWrapper conn = null;
		
		String host = null;
		int port = 0;
		String from = null;
		String subject = "IMS deadlock alert";
		String alertToEmail = null;
		try {
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			conn.setAutoCommit(false);
			manageTaxableLines(ic, conn);
			
			PreparedStatement pstmt = IMSUtil.queryToPreparedStatement(conn, updateString.append(finalWhereString));
			ParameterMetaData md = pstmt.getParameterMetaData();
			int paramCount = md.getParameterCount();
			Document d = ic.getConfigDocument();
			host = XMLUtils.getValue(d, "mail:host").trim();
			port = Integer.valueOf(XMLUtils.getValue(d, "mail:port").trim()).intValue();
			from = host = XMLUtils.getValue(d, "mail:from").trim();
			alertToEmail = (String) ic.getAppGlobalDatum("deadlockAlter");
			
 			for (int i=0; checkedBoxes != null && i<checkedBoxes.length; i++) {
 				Diagnostics.debug(updateString.toString());
 				pstmt.setString(paramCount, checkedBoxes[i]);
 				pstmt.addBatch();
			}
 			
			rows = pstmt.executeBatch();
			pstmt.close();
			
			for (int i = 0; i < rows.length; i++) {
				if (rows[i] == 0) {
					updated = false;
				}
			}
 			
			if (!updated && action.equals("verify")) {
				ic.setTransientDatum("verify_error","raise verify error");
			}

			if( isInvoice )	{
				if( action.startsWith("changeInvoiceStatus") ) {//multiple invoices could be involved
					for (int i=0; checkedBoxes != null && i<checkedBoxes.length; i++) {
						updateInvoicePO(conn, ic, checkedBoxes[i], action);
					}
				} else {
					updateInvoicePO(conn, ic, invoiceId,action);
				}	
			}

			if (buildInvoice) {
				success = Invoice.buildInvoice(conn,ic,checkedBoxes,ic.getParameter("batch_id"), userId);
			}

			if (success) {
				conn.commit();
			} else {
				conn.rollback();
			}

			result = true;
		} catch (SQLException se) {
			if (se.getErrorCode() == 1205) {
				IMSUtil.sendEmail(host, port, alertToEmail, from, subject, se.getMessage() + " Failed SQL Statement = (" +updateString.append(finalWhereString).toString() + ")");
			}
			ErrorHandler.handleException(ic, se, "SQLException in SetServiceLineStatusHandler.setStatus()");
		} catch (Exception e) {
			conn.rollback();
			ErrorHandler.handleException(ic, e, "Exception in SetServiceLineStatusHandler.setStatus()");
			result = false;
		} finally {
			if (conn != null) {
				conn.setAutoCommit(true);
				conn.release();
			}
		}
		return result;

	}	
	
	
	public static boolean updateInvoicePO(ConnectionWrapper conn, InvocationContext ic, String invoice_id, String action) throws Exception
	{
		Diagnostics.trace("SetServiceLineStatusHandler.updateInvoicePO() invoice_id='"+invoice_id+"'");
		boolean result = true;

		if( StringUtil.hasAValue(invoice_id) )
		{
			//first detect if the job type is a sevice account, if so, only select po_no from the pooled req (internal req).
			StringBuffer jobQuery = new StringBuffer();
			jobQuery.append("SELECT i.job_id, j.spreadsheet_billing_flag, i.description FROM jobs j, invoices i WHERE j.job_id=i.job_id AND invoice_id="+conn.toSQLString(invoice_id));
			Diagnostics.debug2("Determine if job is a service account, thereby only pool req PO's = " + jobQuery );
			QueryResults rs = conn.resultsQueryEx(jobQuery);
			boolean isServiceAccount = false;
			String job_id = null;
			String old_desc = null;
			if( rs.next() )
			{
				old_desc = rs.getString("description");
				if( StringUtil.toBoolean(rs.getString("spreadsheet_billing_flag")) )
				{
					isServiceAccount = true;
					job_id = rs.getString("job_id");
				}
			}
			IMSUtil.closeQueryResultSet(rs);

			StringBuffer poQuery = new StringBuffer();
			if( isServiceAccount )
			{//grab only req 1's po_no no matter the invoice.
				poQuery.append("SELECT po_no, null service_description FROM services WHERE service_no='1' AND job_id = " + conn.toSQLString(job_id));
				Diagnostics.debug2("retrieve reqs' po_no query (Service Account=req 1 only) = " + poQuery );
			}
			else
			{//not a service account, grab all req POs for that invoice
				poQuery.append("SELECT DISTINCT po_no, service_description FROM billing_v WHERE invoice_id = " + conn.toSQLString(invoice_id));
				Diagnostics.debug2("retrieve invoice's Req's po_no query (non Service Account)= " + poQuery );
			}
			//get all the po numbers from services
			StringBuffer invoice_po = new StringBuffer();
			rs = conn.resultsQueryEx(poQuery);
			boolean no_po = true;
			String po_no = null;
			StringBuffer new_desc = new StringBuffer();
			StringBuffer multiple_reqs_msg = new StringBuffer("There are lines from multiple requisitions on this invoice.  PLEASE TYPE IN YOUR OWN INVOICE DESCRIPTION!");
			while( rs.next() )
			{
				if( StringUtil.hasAValue( rs.getString("service_description") ) )
				{
					if( StringUtil.hasAValue( new_desc.toString() ) )
						new_desc = multiple_reqs_msg;
					else
						new_desc.append( rs.getString("service_description") );
				}
				po_no = rs.getString(1);
				if( StringUtil.hasAValue(po_no) )
				{
					if( no_po )
					{
						invoice_po.append( po_no );
						no_po = false;
					}
					else
						 invoice_po.append( "," + po_no );
				}
			}
			rs.close();

			//now get po numbers from custom invoice lines
			poQuery = new StringBuffer();
			poQuery.append("SELECT DISTINCT line_po_no FROM invoice_lines_v WHERE invoice_line_type_code='custom' AND invoice_id = " + conn.toSQLString(invoice_id));
			Diagnostics.debug2("retrieve custom lines po_no query = " + poQuery );

			rs = conn.resultsQueryEx(poQuery);
			po_no = null;
			while( rs.next() )
			{
				po_no = rs.getString(1);
				if( StringUtil.hasAValue(po_no) )
				{
					if( no_po )
					{
						invoice_po.append( po_no );
						no_po = false;
					}
					else
						 invoice_po.append( "," + po_no );
				}
			}
			rs.close();
			
			String newDescription = null;
			String invoicePo = null;
			
			if (new_desc.length() > 500) {
				newDescription = new_desc.substring(0, 500);
			} else {
				newDescription = new_desc.toString();
			}
			
			if (invoice_po.length() > 200) {
				invoicePo = invoice_po.substring(0, 200);
			} else {
				invoicePo = invoice_po.toString();
			}

			//now update the invoice
			StringBuffer invoiceQuery = new StringBuffer();
			invoiceQuery.append("UPDATE invoices SET ");
			if( (action.startsWith("assignInvoice") || action.startsWith("move_submit_billing") ) &&
				(!StringUtil.hasAValue(old_desc) || multiple_reqs_msg.toString().equalsIgnoreCase( old_desc ) ) )
			{
				//invoice desc max size is 500, since only on req desc allowed, and req desc is 500, we are okay.
				new_desc = new StringBuffer( new_desc.toString().replace('\r', ' ') ); //carriage returns mess up javascript and also when sending to great plains.
				new_desc = new StringBuffer( new_desc.toString().replace('\n', ' ') ); //new lines mess up javascript and also when sending to great plains.
				invoiceQuery.append("description = " + conn.toSQLString(newDescription) + ", ");
				ic.setTransientDatum("service_description",new_desc); //used to update the invoice_header in the template
			}

			invoiceQuery.append("po_no = " + conn.toSQLString(invoicePo) + " WHERE invoice_id = " +  conn.toSQLString(invoice_id));
			Diagnostics.debug2("updating invoice's po_no query = " + invoiceQuery );
			int rows = conn.updateEx(invoiceQuery);
			if (rows == 0)
			{
				result = false;
				Diagnostics.error("Update to po_no on Invoice='"+invoice_id+"' did not update any rows, this is an error.");
			}
			else
			{
				ic.setTransientDatum("invoice_po", invoice_po.append(" ").toString() );
				Diagnostics.debug2("Set invoice's PO_NO = '"+invoice_po+"'");
			}
		}
		return result;
	}


	private void manageTaxableLines(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		InClause yesLineClause = new InClause();
		InClause noLineClause = new InClause();
		String[] lines = ic.getParameterValues("taxableCheckBox");
		if( lines != null )
		{
			for(int i = 0; i < lines.length; i++)
			{
				if( lines[i].substring(0,1).equalsIgnoreCase("Y") )
					yesLineClause.add(lines[i].substring(1)); //syntax is Y + service_line_id ie Y11202
				else
					noLineClause.add(lines[i].substring(1)); //syntax is N + service_line_id ie N11202
			}
			String invoice_id = ic.getParameter("invoice_id");
			//First update the lines with taxable set to yes
			if (yesLineClause.isValid())
			{
				StringBuffer yes = new StringBuffer();
				yes.append("UPDATE service_lines SET taxable_flag = 'Y', modified_by = "+conn.toSQLString((String)ic.getSessionDatum("user_id")));
				yes.append(" WHERE invoice_id = " + conn.toSQLString(invoice_id));
				yes.append(" AND ").append(yesLineClause.getInClause("service_line_id"));
				conn.updateEx(yes);
			}
			//Second update the lines with taxable set to no
			if (noLineClause.isValid())
			{
				StringBuffer no = new StringBuffer();
				no.append("UPDATE service_lines SET taxable_flag = 'N', modified_by = "+conn.toSQLString((String)ic.getSessionDatum("user_id")));
				no.append(" WHERE invoice_id = " + conn.toSQLString(invoice_id));
				no.append(" AND ").append(noLineClause.getInClause("service_line_id"));
				conn.updateEx(no);
			}
		}
	}

	public static void copyParametersToTransient(InvocationContext ic)
	{
		Diagnostics.trace("SmartFormHandler.copyParametersToTransient()");
		Enumeration keys = ic.getParameterKeys();
		while (keys.hasMoreElements())
		{
			String key = (String)keys.nextElement();
			String value = ic.getParameter(key);
			ic.setTransientDatum(key,value);
		}
	}


	public void destroy(){}

}