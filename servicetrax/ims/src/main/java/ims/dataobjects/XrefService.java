package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class XrefService extends AbstractDatabaseObject
{

	private int xrefServiceID;
	private int serviceID;
	private int repID;
	private int palmUserID;

	public XrefService()
	{
		super();
	}


	public static XrefService fetch(String xrefServiceID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(xrefServiceID), ic, null);
	}

	public static XrefService fetch(String xrefServiceID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(xrefServiceID), ic, resourceName);
	}

	public static XrefService fetch(int xrefServiceID, InvocationContext ic)
	{
		 return fetch(xrefServiceID, ic, null);
	}

	public static XrefService fetch(int xrefServiceID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("XrefService.fetch()");

		XrefService result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT xref_service_id ");
			query.append(", service_id ");
			query.append(", rep_id ");
			query.append(", palm_user_id ");
			query.append("FROM xref_services ");
			query.append("WHERE (xref_service_id = ").append(xrefServiceID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new XrefService();
				result.setXrefServiceID(rs.getInt(1));
				result.setServiceID(rs.getInt(2));
				result.setRepID(rs.getInt(3));
				result.setPalmUserID(rs.getInt(4));
			}
			else
			{
				Diagnostics.error("Error in XrefService.fetch(), Could not find XrefService; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefService.fetch()");
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
		Diagnostics.trace("XrefService.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE xref_services ");
			update.append("SET service_id = ").append(this.getServiceID());
			update.append(", rep_id = ").append(this.getRepID());
			update.append(", palm_user_id = ").append(this.getPalmUserID());
			update.append("WHERE (xref_service_id = ").append(this.getXrefServiceID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefService.internalUpdate()");
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
		Diagnostics.trace("XrefService.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO xref_services (");
				insert.append("service_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getServiceID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO xref_services (");
				insert.append("xref_service_id");
				insert.append(", service_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getXrefServiceID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				xrefServiceID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefService.internalInsert()");
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
		Diagnostics.trace("XrefService.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM xref_services ");
			delete.append("WHERE (xref_service_id = ").append(this.getXrefServiceID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefService.internalDelete()");
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
		if (this.getXrefServiceID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("XrefService:\n");
		result.append("  xref_service_id = ").append(this.getXrefServiceID()).append("\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  rep_id = ").append(this.getRepID()).append("\n");
		result.append("  palm_user_id = ").append(this.getPalmUserID()).append("\n");
		return result.toString();
	}


	public int getXrefServiceID()
	{
		return xrefServiceID;
	}

	public int getServiceID()
	{
		return serviceID;
	}

	public int getRepID()
	{
		return repID;
	}

	public int getPalmUserID()
	{
		return palmUserID;
	}

	public void setXrefServiceID(int xrefServiceIDIn)
	{
		xrefServiceID = xrefServiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setRepID(int repIDIn)
	{
		repID = repIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPalmUserID(int palmUserIDIn)
	{
		palmUserID = palmUserIDIn;
		handleAction(MODIFY_ACTION);
	}
}
