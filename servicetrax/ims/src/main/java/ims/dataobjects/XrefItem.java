package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class XrefItem extends AbstractDatabaseObject
{

	private int xrefItemID;
	private int itemID;
	private int repID;
	private int palmUserID;

	public XrefItem()
	{
		super();
	}


	public static XrefItem fetch(String xrefItemID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(xrefItemID), ic, null);
	}

	public static XrefItem fetch(String xrefItemID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(xrefItemID), ic, resourceName);
	}

	public static XrefItem fetch(int xrefItemID, InvocationContext ic)
	{
		 return fetch(xrefItemID, ic, null);
	}

	public static XrefItem fetch(int xrefItemID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("XrefItem.fetch()");

		XrefItem result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT xref_item_id ");
			query.append(", item_id ");
			query.append(", rep_id ");
			query.append(", palm_user_id ");
			query.append("FROM xref_items ");
			query.append("WHERE (xref_item_id = ").append(xrefItemID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new XrefItem();
				result.setXrefItemID(rs.getInt(1));
				result.setItemID(rs.getInt(2));
				result.setRepID(rs.getInt(3));
				result.setPalmUserID(rs.getInt(4));
			}
			else
			{
				Diagnostics.error("Error in XrefItem.fetch(), Could not find XrefItem; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefItem.fetch()");
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
		Diagnostics.trace("XrefItem.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE xref_items ");
			update.append("SET item_id = ").append(this.getItemID());
			update.append(", rep_id = ").append(this.getRepID());
			update.append(", palm_user_id = ").append(this.getPalmUserID());
			update.append("WHERE (xref_item_id = ").append(this.getXrefItemID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefItem.internalUpdate()");
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
		Diagnostics.trace("XrefItem.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO xref_items (");
				insert.append("item_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getItemID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO xref_items (");
				insert.append("xref_item_id");
				insert.append(", item_id");
				insert.append(", rep_id");
				insert.append(", palm_user_id");
				insert.append(") VALUES (");
				insert.append(this.getXrefItemID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(this.getRepID());
				insert.append(", ").append(this.getPalmUserID());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				xrefItemID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefItem.internalInsert()");
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
		Diagnostics.trace("XrefItem.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM xref_items ");
			delete.append("WHERE (xref_item_id = ").append(this.getXrefItemID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in XrefItem.internalDelete()");
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
		if (this.getXrefItemID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("XrefItem:\n");
		result.append("  xref_item_id = ").append(this.getXrefItemID()).append("\n");
		result.append("  item_id = ").append(this.getItemID()).append("\n");
		result.append("  rep_id = ").append(this.getRepID()).append("\n");
		result.append("  palm_user_id = ").append(this.getPalmUserID()).append("\n");
		return result.toString();
	}


	public int getXrefItemID()
	{
		return xrefItemID;
	}

	public int getItemID()
	{
		return itemID;
	}

	public int getRepID()
	{
		return repID;
	}

	public int getPalmUserID()
	{
		return palmUserID;
	}

	public void setXrefItemID(int xrefItemIDIn)
	{
		xrefItemID = xrefItemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setItemID(int itemIDIn)
	{
		itemID = itemIDIn;
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
