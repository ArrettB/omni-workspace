package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class GreatPlainsTable extends AbstractDatabaseObject
{

	private int tableID;
	private String tableName;
	private String gpPhysicalName;
	private String gpDisplayName;

	public GreatPlainsTable()
	{
		super();
	}


	public static GreatPlainsTable fetch(String tableID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(tableID), ic, null);
	}

	public static GreatPlainsTable fetch(String tableID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(tableID), ic, resourceName);
	}

	public static GreatPlainsTable fetch(int tableID, InvocationContext ic)
	{
		 return fetch(tableID, ic, null);
	}

	public static GreatPlainsTable fetch(int tableID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("GreatPlainsTable.fetch()");

		GreatPlainsTable result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT table_id ");
			query.append(", table_name ");
			query.append(", gp_physical_name ");
			query.append(", gp_display_name ");
			query.append("FROM great_plains_tables ");
			query.append("WHERE (table_id = ").append(tableID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new GreatPlainsTable();
				result.setTableID(rs.getInt(1));
				result.setTableName(rs.getString(2));
				result.setGpPhysicalName(rs.getString(3));
				result.setGpDisplayName(rs.getString(4));
			}
			else
			{
				Diagnostics.error("Error in GreatPlainsTable.fetch(), Could not find GreatPlainsTable; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in GreatPlainsTable.fetch()");
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
		Diagnostics.trace("GreatPlainsTable.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE great_plains_tables ");
			update.append("SET table_name = ").append(conn.toSQLString(StringUtil.truncate(this.getTableName(), 50)));
			update.append(", gp_physical_name = ").append(conn.toSQLString(StringUtil.truncate(this.getGpPhysicalName(), 50)));
			update.append(", gp_display_name = ").append(conn.toSQLString(StringUtil.truncate(this.getGpDisplayName(), 50)));
			update.append("WHERE (table_id = ").append(this.getTableID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in GreatPlainsTable.internalUpdate()");
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
		Diagnostics.trace("GreatPlainsTable.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO great_plains_tables (");
				insert.append("table_name");
				insert.append(", gp_physical_name");
				insert.append(", gp_display_name");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getTableName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getGpPhysicalName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getGpDisplayName(), 50)));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO great_plains_tables (");
				insert.append("table_id");
				insert.append(", table_name");
				insert.append(", gp_physical_name");
				insert.append(", gp_display_name");
				insert.append(") VALUES (");
				insert.append(this.getTableID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTableName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getGpPhysicalName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getGpDisplayName(), 50)));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				tableID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in GreatPlainsTable.internalInsert()");
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
		Diagnostics.trace("GreatPlainsTable.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM great_plains_tables ");
			delete.append("WHERE (table_id = ").append(this.getTableID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in GreatPlainsTable.internalDelete()");
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
		if (this.getTableID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("GreatPlainsTable:\n");
		result.append("  table_id = ").append(this.getTableID()).append("\n");
		result.append("  table_name = ").append(this.getTableName()).append("\n");
		result.append("  gp_physical_name = ").append(this.getGpPhysicalName()).append("\n");
		result.append("  gp_display_name = ").append(this.getGpDisplayName()).append("\n");
		return result.toString();
	}


	public int getTableID()
	{
		return tableID;
	}

	public String getTableName()
	{
		return tableName;
	}

	public String getGpPhysicalName()
	{
		return gpPhysicalName;
	}

	public String getGpDisplayName()
	{
		return gpDisplayName;
	}

	public void setTableID(int tableIDIn)
	{
		tableID = tableIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTableName(String tableNameIn)
	{
		tableName = tableNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setGpPhysicalName(String gpPhysicalNameIn)
	{
		gpPhysicalName = gpPhysicalNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setGpDisplayName(String gpDisplayNameIn)
	{
		gpDisplayName = gpDisplayNameIn;
		handleAction(MODIFY_ACTION);
	}
}
