package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class TemplateLocation extends AbstractDatabaseObject
{

	private int templateLocationID;
	private String location;
	private String target;
	private int level1Tab;
	private int level1Template;
	private int level2Tab;
	private int level2Template;
	private int level3Tab;
	private int level3Template;

	public TemplateLocation()
	{
		super();
	}


	public static TemplateLocation fetch(String templateLocationID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(templateLocationID), ic, null);
	}

	public static TemplateLocation fetch(String templateLocationID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(templateLocationID), ic, resourceName);
	}

	public static TemplateLocation fetch(int templateLocationID, InvocationContext ic)
	{
		 return fetch(templateLocationID, ic, null);
	}

	public static TemplateLocation fetch(int templateLocationID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("TemplateLocation.fetch()");

		TemplateLocation result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT template_location_id ");
			query.append(", location ");
			query.append(", target ");
			query.append(", level_1_tab ");
			query.append(", level_1_template ");
			query.append(", level_2_tab ");
			query.append(", level_2_template ");
			query.append(", level_3_tab ");
			query.append(", level_3_template ");
			query.append("FROM template_locations ");
			query.append("WHERE (template_location_id = ").append(templateLocationID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new TemplateLocation();
				result.setTemplateLocationID(rs.getInt(1));
				result.setLocation(rs.getString(2));
				result.setTarget(rs.getString(3));
				result.setLevel1Tab(rs.getInt(4));
				result.setLevel1Template(rs.getInt(5));
				result.setLevel2Tab(rs.getInt(6));
				result.setLevel2Template(rs.getInt(7));
				result.setLevel3Tab(rs.getInt(8));
				result.setLevel3Template(rs.getInt(9));
			}
			else
			{
				Diagnostics.error("Error in TemplateLocation.fetch(), Could not find TemplateLocation; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in TemplateLocation.fetch()");
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
		Diagnostics.trace("TemplateLocation.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE template_locations ");
			update.append("SET location = ").append(conn.toSQLString(StringUtil.truncate(this.getLocation(), 50)));
			update.append(", target = ").append(conn.toSQLString(StringUtil.truncate(this.getTarget(), 50)));
			update.append(", level_1_tab = ").append(this.getLevel1Tab());
			update.append(", level_1_template = ").append(this.getLevel1Template());
			update.append(", level_2_tab = ").append(this.getLevel2Tab());
			update.append(", level_2_template = ").append(this.getLevel2Template());
			update.append(", level_3_tab = ").append(this.getLevel3Tab());
			update.append(", level_3_template = ").append(this.getLevel3Template());
			update.append("WHERE (template_location_id = ").append(this.getTemplateLocationID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in TemplateLocation.internalUpdate()");
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
		Diagnostics.trace("TemplateLocation.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO template_locations (");
				insert.append("location");
				insert.append(", target");
				insert.append(", level_1_tab");
				insert.append(", level_1_template");
				insert.append(", level_2_tab");
				insert.append(", level_2_template");
				insert.append(", level_3_tab");
				insert.append(", level_3_template");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getLocation(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTarget(), 50)));
				insert.append(", ").append(this.getLevel1Tab());
				insert.append(", ").append(this.getLevel1Template());
				insert.append(", ").append(this.getLevel2Tab());
				insert.append(", ").append(this.getLevel2Template());
				insert.append(", ").append(this.getLevel3Tab());
				insert.append(", ").append(this.getLevel3Template());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO template_locations (");
				insert.append("template_location_id");
				insert.append(", location");
				insert.append(", target");
				insert.append(", level_1_tab");
				insert.append(", level_1_template");
				insert.append(", level_2_tab");
				insert.append(", level_2_template");
				insert.append(", level_3_tab");
				insert.append(", level_3_template");
				insert.append(") VALUES (");
				insert.append(this.getTemplateLocationID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLocation(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTarget(), 50)));
				insert.append(", ").append(this.getLevel1Tab());
				insert.append(", ").append(this.getLevel1Template());
				insert.append(", ").append(this.getLevel2Tab());
				insert.append(", ").append(this.getLevel2Template());
				insert.append(", ").append(this.getLevel3Tab());
				insert.append(", ").append(this.getLevel3Template());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				templateLocationID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in TemplateLocation.internalInsert()");
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
		Diagnostics.trace("TemplateLocation.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM template_locations ");
			delete.append("WHERE (template_location_id = ").append(this.getTemplateLocationID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in TemplateLocation.internalDelete()");
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
		if (this.getTemplateLocationID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("TemplateLocation:\n");
		result.append("  template_location_id = ").append(this.getTemplateLocationID()).append("\n");
		result.append("  location = ").append(this.getLocation()).append("\n");
		result.append("  target = ").append(this.getTarget()).append("\n");
		result.append("  level_1_tab = ").append(this.getLevel1Tab()).append("\n");
		result.append("  level_1_template = ").append(this.getLevel1Template()).append("\n");
		result.append("  level_2_tab = ").append(this.getLevel2Tab()).append("\n");
		result.append("  level_2_template = ").append(this.getLevel2Template()).append("\n");
		result.append("  level_3_tab = ").append(this.getLevel3Tab()).append("\n");
		result.append("  level_3_template = ").append(this.getLevel3Template()).append("\n");
		return result.toString();
	}


	public int getTemplateLocationID()
	{
		return templateLocationID;
	}

	public String getLocation()
	{
		return location;
	}

	public String getTarget()
	{
		return target;
	}

	public int getLevel1Tab()
	{
		return level1Tab;
	}

	public int getLevel1Template()
	{
		return level1Template;
	}

	public int getLevel2Tab()
	{
		return level2Tab;
	}

	public int getLevel2Template()
	{
		return level2Template;
	}

	public int getLevel3Tab()
	{
		return level3Tab;
	}

	public int getLevel3Template()
	{
		return level3Template;
	}

	public void setTemplateLocationID(int templateLocationIDIn)
	{
		templateLocationID = templateLocationIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLocation(String locationIn)
	{
		location = locationIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTarget(String targetIn)
	{
		target = targetIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLevel1Tab(int level1TabIn)
	{
		level1Tab = level1TabIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLevel1Template(int level1TemplateIn)
	{
		level1Template = level1TemplateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLevel2Tab(int level2TabIn)
	{
		level2Tab = level2TabIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLevel2Template(int level2TemplateIn)
	{
		level2Template = level2TemplateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLevel3Tab(int level3TabIn)
	{
		level3Tab = level3TabIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLevel3Template(int level3TemplateIn)
	{
		level3Template = level3TemplateIn;
		handleAction(MODIFY_ACTION);
	}
}
