package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class TemplatesD extends AbstractDatabaseObject
{

	private int templateID;
	private int tabID;
	private String name;
	private String path;
	private String targetFrame;

	public TemplatesD()
	{
		super();
	}


	public static TemplatesD fetch(String templateID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(templateID), ic, null);
	}

	public static TemplatesD fetch(String templateID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(templateID), ic, resourceName);
	}

	public static TemplatesD fetch(int templateID, InvocationContext ic)
	{
		 return fetch(templateID, ic, null);
	}

	public static TemplatesD fetch(int templateID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("TemplatesD.fetch()");

		TemplatesD result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT template_id ");
			query.append(", tab_id ");
			query.append(", name ");
			query.append(", path ");
			query.append(", target_frame ");
			query.append("FROM templates_d ");
			query.append("WHERE (template_id = ").append(templateID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new TemplatesD();
				result.setTemplateID(rs.getInt(1));
				result.setTabID(rs.getInt(2));
				result.setName(rs.getString(3));
				result.setPath(rs.getString(4));
				result.setTargetFrame(rs.getString(5));
			}
			else
			{
				Diagnostics.error("Error in TemplatesD.fetch(), Could not find TemplatesD; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in TemplatesD.fetch()");
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
		Diagnostics.trace("TemplatesD.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE templates_d ");
			update.append("SET tab_id = ").append(this.getTabID());
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
			update.append(", path = ").append(conn.toSQLString(StringUtil.truncate(this.getPath(), 50)));
			update.append(", target_frame = ").append(conn.toSQLString(StringUtil.truncate(this.getTargetFrame(), 50)));
			update.append("WHERE (template_id = ").append(this.getTemplateID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in TemplatesD.internalUpdate()");
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
		Diagnostics.trace("TemplatesD.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO templates_d (");
				insert.append("tab_id");
				insert.append(", name");
				insert.append(", path");
				insert.append(", target_frame");
				insert.append(") VALUES (");
				insert.append(this.getTabID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPath(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTargetFrame(), 50)));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO templates_d (");
				insert.append("template_id");
				insert.append(", tab_id");
				insert.append(", name");
				insert.append(", path");
				insert.append(", target_frame");
				insert.append(") VALUES (");
				insert.append(this.getTemplateID());
				insert.append(", ").append(this.getTabID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPath(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTargetFrame(), 50)));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				templateID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in TemplatesD.internalInsert()");
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
		Diagnostics.trace("TemplatesD.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM templates_d ");
			delete.append("WHERE (template_id = ").append(this.getTemplateID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in TemplatesD.internalDelete()");
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
		if (this.getTemplateID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("TemplatesD:\n");
		result.append("  template_id = ").append(this.getTemplateID()).append("\n");
		result.append("  tab_id = ").append(this.getTabID()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  path = ").append(this.getPath()).append("\n");
		result.append("  target_frame = ").append(this.getTargetFrame()).append("\n");
		return result.toString();
	}


	public int getTemplateID()
	{
		return templateID;
	}

	public int getTabID()
	{
		return tabID;
	}

	public String getName()
	{
		return name;
	}

	public String getPath()
	{
		return path;
	}

	public String getTargetFrame()
	{
		return targetFrame;
	}

	public void setTemplateID(int templateIDIn)
	{
		templateID = templateIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTabID(int tabIDIn)
	{
		tabID = tabIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setName(String nameIn)
	{
		name = nameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPath(String pathIn)
	{
		path = pathIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTargetFrame(String targetFrameIn)
	{
		targetFrame = targetFrameIn;
		handleAction(MODIFY_ACTION);
	}
}
