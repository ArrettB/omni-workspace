package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class XrefResource extends AbstractDatabaseObject
{

	private int xrefResID;
	private int resourceID;
	private int repID;
	private int palmUserID;

	public XrefResource()
	{
		super();
	}


	public static XrefResource fetch(String xrefResID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(xrefResID), ic, null);
	}

	public static XrefResource fetch(String xrefResID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(xrefResID), ic, resourceName);
	}

	public static XrefResource fetch(int xrefResID, InvocationContext ic)
	{
		 return fetch(xrefResID, ic, null);
	}

	public static XrefResource fetch(int xrefResID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("XrefResource.fetch()");

		XrefResource result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT xref_res_id ");
			query.append(", resource_id ");
			query.append(", rep_id ");
			query.append(", palm_user_id ");
			query.append("FROM xref_resources ");
			query.append("WHERE (xref_res_id = ").append(xrefResID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new XrefResource();
				result.setXrefResID(rs.getInt(1));
				result.setResourceID(rs.getInt(2));
				result.setRepID(rs.getInt(3));
				result.setPalmUserID(rs.getInt(4));
			}
			else
			{
				Diagnostics.error("Error in XrefResource.fetch(), Could not find XrefResource; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefResource.fetch()");
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
		Diagnostics.trace("XrefResource.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE xref_resources ");
			update.append("SET resource_id = ").append(this.getResourceID());
			update.append(", rep_id = ").append(this.getRepID());
			update.append(", palm_user_id = ").append(this.getPalmUserID());
			update.append("WHERE (xref_res_id = ").append(this.getXrefResID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefResource.internalUpdate()");
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
		Diagnostics.trace("XrefResource.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO xref_resources (");
				insert.append("resource_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getResourceID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO xref_resources (");
				insert.append("xref_res_id");
				insert.append(", resource_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getXrefResID());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				xrefResID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefResource.internalInsert()");
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
		Diagnostics.trace("XrefResource.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM xref_resources ");
			delete.append("WHERE (xref_res_id = ").append(this.getXrefResID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefResource.internalDelete()");
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
		if (this.getXrefResID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("XrefResource:\n");
		result.append("  xref_res_id = ").append(this.getXrefResID()).append("\n");
		result.append("  resource_id = ").append(this.getResourceID()).append("\n");
		result.append("  rep_id = ").append(this.getRepID()).append("\n");
		result.append("  palm_user_id = ").append(this.getPalmUserID()).append("\n");
		return result.toString();
	}


	public int getXrefResID()
	{
		return xrefResID;
	}

	public int getResourceID()
	{
		return resourceID;
	}

	public int getRepID()
	{
		return repID;
	}

	public int getPalmUserID()
	{
		return palmUserID;
	}

	public void setXrefResID(int xrefResIDIn)
	{
		xrefResID = xrefResIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceID(int resourceIDIn)
	{
		resourceID = resourceIDIn;
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
