package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class XrefTime extends AbstractDatabaseObject
{

	private int xrefTimeID;
	private int timeID;
	private int repID;
	private int palmUserID;

	public XrefTime()
	{
		super();
	}


	public static XrefTime fetch(String xrefTimeID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(xrefTimeID), ic, null);
	}

	public static XrefTime fetch(String xrefTimeID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(xrefTimeID), ic, resourceName);
	}

	public static XrefTime fetch(int xrefTimeID, InvocationContext ic)
	{
		 return fetch(xrefTimeID, ic, null);
	}

	public static XrefTime fetch(int xrefTimeID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("XrefTime.fetch()");

		XrefTime result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT xref_time_id ");
			query.append(", time_id ");
			query.append(", rep_id ");
			query.append(", palm_user_id ");
			query.append("FROM xref_time ");
			query.append("WHERE (xref_time_id = ").append(xrefTimeID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new XrefTime();
				result.setXrefTimeID(rs.getInt(1));
				result.setTimeID(rs.getInt(2));
				result.setRepID(rs.getInt(3));
				result.setPalmUserID(rs.getInt(4));
			}
			else
			{
				Diagnostics.error("Error in XrefTime.fetch(), Could not find XrefTime; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefTime.fetch()");
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
		Diagnostics.trace("XrefTime.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE xref_time ");
			update.append("SET time_id = ").append(this.getTimeID());
			update.append(", rep_id = ").append(this.getRepID());
			update.append(", palm_user_id = ").append(this.getPalmUserID());
			update.append("WHERE (xref_time_id = ").append(this.getXrefTimeID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefTime.internalUpdate()");
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
		Diagnostics.trace("XrefTime.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO xref_time (");
				insert.append("time_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getTimeID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO xref_time (");
				insert.append("xref_time_id");
				insert.append(", time_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getXrefTimeID());
				insert.append(", ").append(this.getTimeID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				xrefTimeID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefTime.internalInsert()");
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
		Diagnostics.trace("XrefTime.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM xref_time ");
			delete.append("WHERE (xref_time_id = ").append(this.getXrefTimeID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefTime.internalDelete()");
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
		if (this.getXrefTimeID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("XrefTime:\n");
		result.append("  xref_time_id = ").append(this.getXrefTimeID()).append("\n");
		result.append("  time_id = ").append(this.getTimeID()).append("\n");
		result.append("  rep_id = ").append(this.getRepID()).append("\n");
		result.append("  palm_user_id = ").append(this.getPalmUserID()).append("\n");
		return result.toString();
	}


	public int getXrefTimeID()
	{
		return xrefTimeID;
	}

	public int getTimeID()
	{
		return timeID;
	}

	public int getRepID()
	{
		return repID;
	}

	public int getPalmUserID()
	{
		return palmUserID;
	}

	public void setXrefTimeID(int xrefTimeIDIn)
	{
		xrefTimeID = xrefTimeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTimeID(int timeIDIn)
	{
		timeID = timeIDIn;
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
