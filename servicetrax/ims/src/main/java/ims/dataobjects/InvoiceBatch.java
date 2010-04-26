package ims.dataobjects;

import ims.daemons.IMCommandRunner;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.BaseInvocationContext;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * Great Plains integration.  Call the stored procedure to send the invoices to Great Plains.
 *
 * The eConnect stored procedure may be optionally called if the app global datum
 * runEconnect is set to true or false.
 *
 * @version $Id: InvoiceBatch.java 1671 2009-08-19 22:54:19Z bvonhaden $
 */
public class InvoiceBatch
{
	public static final String UPDATE_INVOICES
	= "UPDATE invoices "
	+ "   SET batch_status_id = (SELECT status_id FROM invoice_batch_statuses WHERE code = 'PROCESSING') "
	+       ", modified_by = ?"
	+       ", date_modified = getDate()"
	+ "  FROM invoices i INNER JOIN "
	+ "       jobs j ON i.job_id = j.job_id INNER JOIN "
	+ "       customers c ON j.customer_id = c.customer_id "
	+ " WHERE c.organization_id = ? "
	+ "   AND i.ext_batch_id = ?"
	+ " AND i.batch_status_id <> (SELECT status_id FROM invoice_batch_statuses WHERE code = 'PROCESSED')";

	public static final String ERROR_INVOICES
	= "UPDATE invoices "
	+ "   SET batch_status_id = (SELECT status_id FROM invoice_batch_statuses WHERE code = 'ERROR') "
	+    ", batch_error_message = ?"
	+ "  FROM invoices i INNER JOIN "
	+ "       jobs j ON i.job_id = j.job_id INNER JOIN "
	+ "       customers c ON j.customer_id = c.customer_id "
	+ " WHERE c.organization_id = ? "
	+ "   AND i.ext_batch_id = ?"
	+ " AND i.batch_status_id = (SELECT status_id FROM invoice_batch_statuses WHERE code = 'PROCESSING')";

	public static boolean sendToGP(String batchId, String modifiedBy, ConnectionWrapper conn, InvocationContext ic) throws Exception
	{
		boolean result = true;
		Diagnostics.debug("InvoiceBatch.sendToGP()");
		IMCommandRunner imcr = (IMCommandRunner) ic.getAppGlobalDatum(IMCommandRunner.IMCOMMAND_RUNNER);
		String orgId = (String) (ic.getSessionDatum("org_id"));
		if (imcr != null)
		{
			try
			{
				conn.commit();
				IMCommand imc = new IMCommand(batchId, "inv", orgId);
				imc.initialize((BaseInvocationContext) ic);
				imcr.enqueueCmd(imc);
			}
			catch (Exception e)
			{
				ErrorHandler.handleException(ic, e, "Problem in sendToGP");
			}
		}
		else
		{
			boolean runEconnect = StringUtil.toBoolean((String)ic.getAppGlobalDatum("runEconnect"));
			if (runEconnect)
			{
				changeStatus(orgId, batchId, modifiedBy, UPDATE_INVOICES, conn);
				conn.commit();
				result = runEconnect(batchId, modifiedBy, conn, ic);
			}
			else
			{
				Diagnostics.debug("InvoiceBatch.sendToGP() eConnect disabled");
				ic.setTransientDatum("integrationManagerMsg", "Transfer to Great Plains is not enabled.");
			}
		}
		return result;
	}


	private static void changeStatus(String orgID, String batchID, String modifiedBy, String statusUpdateQuery, ConnectionWrapper conn) throws SQLException
	{
		try
		{
			Object[] params = new Object[] { modifiedBy, orgID, batchID };
			long count = conn.update(statusUpdateQuery, params);

			Diagnostics.debug("InvoiceBatch.changeStatus() updated:" + count);
		}
		catch (SQLException e)
		{
			Diagnostics.error("Exception in InvoiceBatch.changeStatus(): SQL = " + statusUpdateQuery + " , Organization_id = "
					+ orgID + " and ext_batch_id = " + batchID, e);
		}
	}


	private static boolean runEconnect(String batchId, String modifiedBy, ConnectionWrapper conn, InvocationContext ic) throws Exception
	{
		boolean result = true;
		QueryResults rs = null;
		try
		{
			String orgId = (String) (ic.getSessionDatum("org_id"));
			String query = "SELECT name, resource_name, default_site, invoice_suffix, comment_id"
				+  " FROM organizations"
				+ " WHERE organization_id = ?";
			rs = conn.select(query, orgId);
			if (rs.next())
			{
				int org_id = Integer.parseInt(orgId);
				result = fireProcedure(org_id, batchId, modifiedBy, rs, conn, ic);
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}
		return result;
	}

	private static boolean fireProcedure(int orgId, String batchId, String modifiedBy, QueryResults rs, ConnectionWrapper conn, InvocationContext ic) throws Exception
	{
		int iErrorState = 0;
		String resourceName = rs.getString("resource_name");
		String defaultSite = rs.getString("default_site");
		String invoiceSuffix = rs.getString("invoice_suffix");
		String commentId = rs.getString("comment_id");
		String orgName = rs.getString("name");

		StringBuffer mandatoryMessage = new StringBuffer();
		if (!StringUtil.hasAValue(defaultSite))
		{
			mandatoryMessage.append("Invalid organization setup: " + orgName + " needs GP Default Site set. ");
		}
		if (!StringUtil.hasAValue(invoiceSuffix))
		{
			mandatoryMessage.append("Invalid organization setup: " + orgName + " needs GP Invoice Suffix set. ");
		}
		if (!StringUtil.hasAValue(commentId))
		{
			mandatoryMessage.append("Invalid organization setup: " + orgName + " needs GP Comment ID set. ");
		}

		if (mandatoryMessage.length() == 0)
		{
			ConnectionWrapper gp_conn = null;
			try
			{
				gp_conn = (ConnectionWrapper)ic.getResource(resourceName);
				String query = "{call ott_SendInvoicesToGP(?, ?, ?, ?, ?, ?, ?) }";
				CallableStatement stmt = gp_conn.prepareCall(query);
				stmt.setString(1, batchId);
				stmt.setInt(2, orgId);
				stmt.setString(3, defaultSite);
				stmt.setString(4, invoiceSuffix);
				stmt.setString(5, commentId);
				stmt.registerOutParameter(6, Types.INTEGER);
				stmt.registerOutParameter(7, Types.CHAR);
				Diagnostics.debug("InvoiceBatch.fireProcedure() Calling " + query
						+ " with '" + batchId
						+ "','" + orgId
						+ "','" + defaultSite
						+ "','" + invoiceSuffix
						+ "','" + commentId
						+ "' for resource " + resourceName);
				stmt.execute();

				iErrorState = stmt.getInt(6);
				String msg = "good";
				if (iErrorState != 0)
				{
					String sErrString = stmt.getString(7);
					msg = "Error code: " + iErrorState + ". " + sErrString;
					ic.setTransientDatum("integrationManagerMsg", msg);
				}
				Diagnostics.debug("InvoiceBatch.fireProcedure() " + msg);
			}
			catch (SQLException e)
			{
				iErrorState = e.getErrorCode();
				ic.setTransientDatum("integrationManagerMsg", "Failed to run batch: " + e.getMessage());
				Diagnostics.error("InvoiceBatch.fireProcedure() Failed to run batch: ", e);
				changeStatusError(orgId, batchId, e.getMessage(), modifiedBy, conn);
				conn.commit();
			}
			finally
			{
				if (gp_conn != null)
					gp_conn.release();
			}
		}
		else
		{
			ic.setTransientDatum("integrationManagerMsg", mandatoryMessage);
			Diagnostics.debug("InvoiceBatch.fireProcedure() " + mandatoryMessage);
			iErrorState = -1;
		}
		return iErrorState == 0;
	}


	private static void changeStatusError(int orgId, String batchID, String msg, String modifiedBy, ConnectionWrapper conn) throws SQLException
	{
		try
		{
			Object[] params = new Object[] { msg, Integer.valueOf(orgId), batchID };
			long count = conn.update(ERROR_INVOICES, params);

			Diagnostics.debug("InvoiceBatch.changeStatusError() updated:" + count);
		}
		catch (SQLException e)
		{
			Diagnostics.error("Exception in InvoiceBatch.changeStatus(): Organization_id = "
					+ orgId + " and ext_batch_id = " + batchID, e);
		}
	}


}
