package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class InvoiceStatus extends AbstractDatabaseObject
{

	private int statusID;
	private String code;
	private String name;

	public InvoiceStatus()
	{
		super();
	}


	public static InvoiceStatus fetch(String statusID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(statusID), ic, null);
	}

	public static InvoiceStatus fetch(String statusID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(statusID), ic, resourceName);
	}

	public static InvoiceStatus fetch(int statusID, InvocationContext ic)
	{
		 return fetch(statusID, ic, null);
	}

	public static InvoiceStatus fetch(int statusID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("InvoiceStatus.fetch()");

		InvoiceStatus result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT status_id ");
			query.append(", code ");
			query.append(", name ");
			query.append("FROM invoice_statuses ");
			query.append("WHERE (status_id = ").append(statusID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new InvoiceStatus();
				result.setStatusID(rs.getInt(1));
				result.setCode(rs.getString(2));
				result.setName(rs.getString(3));
			}
			else
			{
				Diagnostics.error("Error in InvoiceStatus.fetch(), Could not find InvoiceStatus; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceStatus.fetch()");
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
		Diagnostics.trace("InvoiceStatus.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE invoice_statuses ");
			update.append("SET code = ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 10)));
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
			update.append("WHERE (status_id = ").append(this.getStatusID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceStatus.internalUpdate()");
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
		Diagnostics.trace("InvoiceStatus.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO invoice_statuses (");
				insert.append("code");
				insert.append(", name");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getCode(), 10)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO invoice_statuses (");
				insert.append("status_id");
				insert.append(", code");
				insert.append(", name");
				insert.append(") VALUES (");
				insert.append(this.getStatusID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 10)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				statusID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceStatus.internalInsert()");
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
		Diagnostics.trace("InvoiceStatus.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM invoice_statuses ");
			delete.append("WHERE (status_id = ").append(this.getStatusID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceStatus.internalDelete()");
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
		if (this.getStatusID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("InvoiceStatus:\n");
		result.append("  status_id = ").append(this.getStatusID()).append("\n");
		result.append("  code = ").append(this.getCode()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		return result.toString();
	}


	public int getStatusID()
	{
		return statusID;
	}

	public String getCode()
	{
		return code;
	}

	public String getName()
	{
		return name;
	}

	public void setStatusID(int statusIDIn)
	{
		statusID = statusIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCode(String codeIn)
	{
		code = codeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setName(String nameIn)
	{
		name = nameIn;
		handleAction(MODIFY_ACTION);
	}
}
