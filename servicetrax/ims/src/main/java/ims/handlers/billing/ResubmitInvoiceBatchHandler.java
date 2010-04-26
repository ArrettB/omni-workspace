package ims.handlers.billing;

import ims.dataobjects.Invoice;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * @version $Id: ResubmitInvoiceBatchHandler.java 1665 2009-08-12 15:49:40Z bvonhaden $
 */
public class ResubmitInvoiceBatchHandler extends BaseHandler {
	
	public static final String SELECT
		= "SELECT invoice_id "
		+ "  FROM invoices i INNER JOIN "
		+ "       invoice_batch_statuses ibs ON i.batch_status_id = ibs.status_id "
	    + " WHERE ibs.code <> 'PROCESSED' "
	    + "   AND i.ext_batch_id = ? "
	    + "   AND i.organization_id = ? ";
	
	public void setUpHandler(){}

	public boolean resubmit(InvocationContext ic) throws Exception
	{
		String resourceName = ic.getParameter("resourceName");
		String batchId = ic.getParameter("ext_batch_id");
		boolean result = true;
		ConnectionWrapper conn = (ConnectionWrapper) ic.getResource(resourceName);

		try
		{
			conn.setAutoCommit(false);
			
			List<String> invoiceIds = getInvoiceIds(conn, ic, batchId, (String) ic.getSessionDatum("org_id"));

			String userId = (String)(ic.getSessionDatum("user_id"));
			Invoice.buildInvoice(conn, ic, invoiceIds, batchId, userId);

			conn.commit();
			result = true;
		}
		catch (Exception e)
		{
			conn.rollback();
			ErrorHandler.handleException(ic, e, "Problem in ResubmitInvoiceBatchHandler");
			result = false;
		}

		finally
		{
			if (conn != null)
			{
				conn.setAutoCommit(true);
				conn.release();
			}
		}
		return result;

	}

	public static void copyParametersToTransient(InvocationContext ic)
	{
		Diagnostics.trace("SmartFormHandler.copyParametersToTransient()");
		Enumeration<String> keys = ic.getParameterKeys();
		while (keys.hasMoreElements())
		{
			String key = keys.nextElement();
			String value = ic.getParameter(key);
			ic.setTransientDatum(key, value);
		}
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		try
		{
			Diagnostics.debug2("ResubmitInvoiceBatchHandler.handleEnvironment()");

			if (!resubmit(ic))
				return false;

			ic.setHTMLTemplateName(ic.getParameter("template_name"));
			copyParametersToTransient(ic);

			return true;
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Problem in ResubmitInvoiceBatchHandler");
			return false;
		}

	}
	
	private List<String> getInvoiceIds(ConnectionWrapper conn, InvocationContext ic, String batchId, String organizationId)
			throws Exception
	{
		List<String> result = new ArrayList<String>();
		QueryResults rs = null;
		try
		{
			rs = conn.select(SELECT, new String[] { batchId, organizationId });
			while (rs.next())
			{
				result.add(rs.getString("invoice_id"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exeception in ResubmitInvoiceBatchHandler.getInvoiceIds()");
		}
		finally
		{
			if (rs != null)
			{
				rs.close();
			}
		}

		return result;
	}

	// DESTROY
	public void destroy(){}

}