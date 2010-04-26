package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class ServInvLine extends AbstractDatabaseObject
{

	private int serviceLineID;
	private int invoiceLineID;

	public ServInvLine()
	{
		super();
	}


	public static ServInvLine fetch(String serviceLineID, String invoiceLineID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(serviceLineID), Integer.parseInt(invoiceLineID), ic, null);
	}

	public static ServInvLine fetch(String serviceLineID, String invoiceLineID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(serviceLineID), Integer.parseInt(invoiceLineID), ic, resourceName);
	}

	public static ServInvLine fetch(int serviceLineID, int invoiceLineID, InvocationContext ic)
	{
		 return fetch(serviceLineID, invoiceLineID, ic, null);
	}

	public static ServInvLine fetch(int serviceLineID, int invoiceLineID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ServInvLine.fetch()");

		ServInvLine result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT service_line_id ");
			query.append(", invoice_line_id ");
			query.append("FROM serv_inv_lines ");
			query.append("WHERE (service_line_id = ").append(serviceLineID).append(" AND invoice_line_id = ").append(invoiceLineID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ServInvLine();
				result.setServiceLineID(rs.getInt(1));
				result.setInvoiceLineID(rs.getInt(2));
			}
			else
			{
				Diagnostics.error("Error in ServInvLine.fetch(), Could not find ServInvLine; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServInvLine.fetch()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}

		 if (result != null) result.handleAction(FETCH_ACTION);
		return result;
	}

	protected void internalUpdate(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ServInvLine.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE serv_inv_lines ");
			update.append("WHERE (service_line_id = ").append(this.getServiceLineID()).append(" AND invoice_line_id = ").append(this.getInvoiceLineID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServInvLine.internalUpdate()");
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
		Diagnostics.trace("ServInvLine.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO serv_inv_lines (");
				insert.append(") VALUES (");
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO serv_inv_lines (");
				insert.append("service_line_id");
				insert.append(", invoice_line_id");
				insert.append(") VALUES (");
				insert.append(this.getServiceLineID());
				insert.append(", ").append(this.getInvoiceLineID());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServInvLine.internalInsert()");
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
		Diagnostics.trace("ServInvLine.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM serv_inv_lines ");
			delete.append("WHERE (service_line_id = ").append(this.getServiceLineID()).append(" AND invoice_line_id = ").append(this.getInvoiceLineID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServInvLine.internalDelete()");
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
		if (this.getServiceLineID() <= 0)
		{
			skipPrimaryKey = true;
		}
		else if (this.getInvoiceLineID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ServInvLine:\n");
		result.append("  service_line_id = ").append(this.getServiceLineID()).append("\n");
		result.append("  invoice_line_id = ").append(this.getInvoiceLineID()).append("\n");
		return result.toString();
	}


	public int getServiceLineID()
	{
		return serviceLineID;
	}

	public int getInvoiceLineID()
	{
		return invoiceLineID;
	}

	public void setServiceLineID(int serviceLineIDIn)
	{
		serviceLineID = serviceLineIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setInvoiceLineID(int invoiceLineIDIn)
	{
		invoiceLineID = invoiceLineIDIn;
		handleAction(MODIFY_ACTION);
	}
}
