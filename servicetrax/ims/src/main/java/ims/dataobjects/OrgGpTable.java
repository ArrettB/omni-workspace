package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class OrgGpTable extends AbstractDatabaseObject
{

	private int orgTableID;
	private int tableID;
	private int orgID;
	private String viewName;

	public OrgGpTable()
	{
		super();
	}


	public static OrgGpTable fetch(String orgTableID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(orgTableID), ic, null);
	}

	public static OrgGpTable fetch(String orgTableID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(orgTableID), ic, resourceName);
	}

	public static OrgGpTable fetch(int orgTableID, InvocationContext ic)
	{
		 return fetch(orgTableID, ic, null);
	}

	public static OrgGpTable fetch(int orgTableID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("OrgGpTable.fetch()");

		OrgGpTable result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT org_table_id ");
			query.append(", table_id ");
			query.append(", org_id ");
			query.append(", view_name ");
			query.append("FROM org_gp_tables ");
			query.append("WHERE (org_table_id = ").append(orgTableID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new OrgGpTable();
				result.setOrgTableID(rs.getInt(1));
				result.setTableID(rs.getInt(2));
				result.setOrgID(rs.getInt(3));
				result.setViewName(rs.getString(4));
			}
			else
			{
				Diagnostics.error("Error in OrgGpTable.fetch(), Could not find OrgGpTable; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in OrgGpTable.fetch()");
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
		Diagnostics.trace("OrgGpTable.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE org_gp_tables ");
			update.append("SET table_id = ").append(this.getTableID());
			update.append(", org_id = ").append(this.getOrgID());
			update.append(", view_name = ").append(conn.toSQLString(StringUtil.truncate(this.getViewName(), 50)));
			update.append("WHERE (org_table_id = ").append(this.getOrgTableID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in OrgGpTable.internalUpdate()");
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
		Diagnostics.trace("OrgGpTable.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO org_gp_tables (");
				insert.append("table_id");
				insert.append(", org_id");
				insert.append(", view_name");
				insert.append(") VALUES (");
				insert.append(this.getTableID());
				insert.append(", ").append(this.getOrgID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getViewName(), 50)));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO org_gp_tables (");
				insert.append("org_table_id");
				insert.append(", table_id");
				insert.append(", org_id");
				insert.append(", view_name");
				insert.append(") VALUES (");
				insert.append(this.getOrgTableID());
				insert.append(", ").append(this.getTableID());
				insert.append(", ").append(this.getOrgID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getViewName(), 50)));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				orgTableID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in OrgGpTable.internalInsert()");
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
		Diagnostics.trace("OrgGpTable.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM org_gp_tables ");
			delete.append("WHERE (org_table_id = ").append(this.getOrgTableID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in OrgGpTable.internalDelete()");
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
		if (this.getOrgTableID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("OrgGpTable:\n");
		result.append("  org_table_id = ").append(this.getOrgTableID()).append("\n");
		result.append("  table_id = ").append(this.getTableID()).append("\n");
		result.append("  org_id = ").append(this.getOrgID()).append("\n");
		result.append("  view_name = ").append(this.getViewName()).append("\n");
		return result.toString();
	}


	public int getOrgTableID()
	{
		return orgTableID;
	}

	public int getTableID()
	{
		return tableID;
	}

	public int getOrgID()
	{
		return orgID;
	}

	public String getViewName()
	{
		return viewName;
	}

	public void setOrgTableID(int orgTableIDIn)
	{
		orgTableID = orgTableIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTableID(int tableIDIn)
	{
		tableID = tableIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOrgID(int orgIDIn)
	{
		orgID = orgIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setViewName(String viewNameIn)
	{
		viewName = viewNameIn;
		handleAction(MODIFY_ACTION);
	}
}
