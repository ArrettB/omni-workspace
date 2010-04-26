package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class ServiceInvoice extends AbstractDatabaseObject
{

	private int serviceID;
	private int invoiceID;

	public ServiceInvoice()
	{
		super();
	}


	public static ServiceInvoice fetch(String serviceID, String invoiceID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(serviceID), Integer.parseInt(invoiceID), ic, null);
	}

	public static ServiceInvoice fetch(String serviceID, String invoiceID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(serviceID), Integer.parseInt(invoiceID), ic, resourceName);
	}

	public static ServiceInvoice fetch(int serviceID, int invoiceID, InvocationContext ic)
	{
		 return fetch(serviceID, invoiceID, ic, null);
	}

	public static ServiceInvoice fetch(int serviceID, int invoiceID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ServiceInvoice.fetch()");

		ServiceInvoice result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT service_id ");
			query.append(", invoice_id ");
			query.append("FROM service_invoices ");
			query.append("WHERE (service_id = ").append(serviceID).append(" AND invoice_id = ").append(invoiceID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ServiceInvoice();
				result.setServiceID(rs.getInt(1));
				result.setInvoiceID(rs.getInt(2));
			}
			else
			{
				Diagnostics.error("Error in ServiceInvoice.fetch(), Could not find ServiceInvoice; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceInvoice.fetch()");
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
		Diagnostics.trace("ServiceInvoice.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE service_invoices ");
			update.append("WHERE (service_id = ").append(this.getServiceID()).append(" AND invoice_id = ").append(this.getInvoiceID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceInvoice.internalUpdate()");
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
		Diagnostics.trace("ServiceInvoice.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO service_invoices (");
				insert.append(") VALUES (");
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO service_invoices (");
				insert.append("service_id");
				insert.append(", invoice_id");
				insert.append(") VALUES (");
				insert.append(this.getServiceID());
				insert.append(", ").append(this.getInvoiceID());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceInvoice.internalInsert()");
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
		Diagnostics.trace("ServiceInvoice.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM service_invoices ");
			delete.append("WHERE (service_id = ").append(this.getServiceID()).append(" AND invoice_id = ").append(this.getInvoiceID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceInvoice.internalDelete()");
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
		if (this.getServiceID() <= 0)
		{
			skipPrimaryKey = true;
		}
		else if (this.getInvoiceID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ServiceInvoice:\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  invoice_id = ").append(this.getInvoiceID()).append("\n");
		return result.toString();
	}


	public int getServiceID()
	{
		return serviceID;
	}

	public int getInvoiceID()
	{
		return invoiceID;
	}

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setInvoiceID(int invoiceIDIn)
	{
		invoiceID = invoiceIDIn;
		handleAction(MODIFY_ACTION);
	}
}
