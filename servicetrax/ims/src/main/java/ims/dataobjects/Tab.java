package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Tab extends AbstractDatabaseObject
{

	private int tabID;
	private int templateID;
	private String name;
	private int sequence;
	private String typeCode;
	private String defaultTab;
	private String tableID;
	private int parentTabID;
	private int tabLevel;

	public Tab()
	{
		super();
	}


	public static Tab fetch(String tabID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(tabID), ic, null);
	}

	public static Tab fetch(String tabID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(tabID), ic, resourceName);
	}

	public static Tab fetch(int tabID, InvocationContext ic)
	{
		 return fetch(tabID, ic, null);
	}

	public static Tab fetch(int tabID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Tab.fetch()");

		Tab result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT tab_id ");
			query.append(", template_id ");
			query.append(", name ");
			query.append(", sequence ");
			query.append(", type_code ");
			query.append(", default_tab ");
			query.append(", table_id ");
			query.append(", parent_tab_id ");
			query.append(", tab_level ");
			query.append("FROM tabs ");
			query.append("WHERE (tab_id = ").append(tabID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Tab();
				result.setTabID(rs.getInt(1));
				result.setTemplateID(rs.getInt(2));
				result.setName(rs.getString(3));
				result.setSequence(rs.getInt(4));
				result.setTypeCode(rs.getString(5));
				result.setDefaultTab(rs.getString(6));
				result.setTableID(rs.getString(7));
				result.setParentTabID(rs.getInt(8));
				result.setTabLevel(rs.getInt(9));
			}
			else
			{
				Diagnostics.error("Error in Tab.fetch(), Could not find Tab; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Tab.fetch()");
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
		Diagnostics.trace("Tab.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE tabs ");
			update.append("SET template_id = ").append(this.getTemplateID());
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
			update.append(", sequence = ").append(this.getSequence());
			update.append(", type_code = ").append(conn.toSQLString(StringUtil.truncate(this.getTypeCode(), 30)));
			update.append(", default_tab = ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultTab(), 1)));
			update.append(", table_id = ").append(conn.toSQLString(StringUtil.truncate(this.getTableID(), 50)));
			update.append(", parent_tab_id = ").append(this.getParentTabID());
			update.append(", tab_level = ").append(this.getTabLevel());
			update.append("WHERE (tab_id = ").append(this.getTabID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Tab.internalUpdate()");
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
		Diagnostics.trace("Tab.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO tabs (");
				insert.append("template_id");
				insert.append(", name");
				insert.append(", sequence");
				insert.append(", type_code");
				insert.append(", default_tab");
				insert.append(", table_id");
				insert.append(", parent_tab_id");
				insert.append(", tab_level");
				insert.append(") VALUES (");
				insert.append(this.getTemplateID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(", ").append(this.getSequence());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTypeCode(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultTab(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTableID(), 50)));
				insert.append(", ").append(this.getParentTabID());
				insert.append(", ").append(this.getTabLevel());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO tabs (");
				insert.append("tab_id");
				insert.append(", template_id");
				insert.append(", name");
				insert.append(", sequence");
				insert.append(", type_code");
				insert.append(", default_tab");
				insert.append(", table_id");
				insert.append(", parent_tab_id");
				insert.append(", tab_level");
				insert.append(") VALUES (");
				insert.append(this.getTabID());
				insert.append(", ").append(this.getTemplateID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(", ").append(this.getSequence());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTypeCode(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultTab(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTableID(), 50)));
				insert.append(", ").append(this.getParentTabID());
				insert.append(", ").append(this.getTabLevel());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				tabID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Tab.internalInsert()");
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
		Diagnostics.trace("Tab.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM tabs ");
			delete.append("WHERE (tab_id = ").append(this.getTabID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Tab.internalDelete()");
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
		if (this.getTabID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Tab:\n");
		result.append("  tab_id = ").append(this.getTabID()).append("\n");
		result.append("  template_id = ").append(this.getTemplateID()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  sequence = ").append(this.getSequence()).append("\n");
		result.append("  type_code = ").append(this.getTypeCode()).append("\n");
		result.append("  default_tab = ").append(this.getDefaultTab()).append("\n");
		result.append("  table_id = ").append(this.getTableID()).append("\n");
		result.append("  parent_tab_id = ").append(this.getParentTabID()).append("\n");
		result.append("  tab_level = ").append(this.getTabLevel()).append("\n");
		return result.toString();
	}


	public int getTabID()
	{
		return tabID;
	}

	public int getTemplateID()
	{
		return templateID;
	}

	public String getName()
	{
		return name;
	}

	public int getSequence()
	{
		return sequence;
	}

	public String getTypeCode()
	{
		return typeCode;
	}

	public String getDefaultTab()
	{
		return defaultTab;
	}

	public String getTableID()
	{
		return tableID;
	}

	public int getParentTabID()
	{
		return parentTabID;
	}

	public int getTabLevel()
	{
		return tabLevel;
	}

	public void setTabID(int tabIDIn)
	{
		tabID = tabIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTemplateID(int templateIDIn)
	{
		templateID = templateIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setName(String nameIn)
	{
		name = nameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSequence(int sequenceIn)
	{
		sequence = sequenceIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTypeCode(String typeCodeIn)
	{
		typeCode = typeCodeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDefaultTab(String defaultTabIn)
	{
		defaultTab = defaultTabIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTableID(String tableIDIn)
	{
		tableID = tableIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setParentTabID(int parentTabIDIn)
	{
		parentTabID = parentTabIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTabLevel(int tabLevelIn)
	{
		tabLevel = tabLevelIn;
		handleAction(MODIFY_ACTION);
	}
}
