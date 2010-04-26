package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Template extends AbstractDatabaseObject
{

	private int templateID;
	private String templateName;

	public Template()
	{
		super();
	}


	public static Template fetch(String templateID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(templateID), ic, null);
	}

	public static Template fetch(String templateID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(templateID), ic, resourceName);
	}

	public static Template fetch(int templateID, InvocationContext ic)
	{
		 return fetch(templateID, ic, null);
	}

	public static Template fetch(int templateID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Template.fetch()");

		Template result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT template_id ");
			query.append(", template_name ");
			query.append("FROM templates ");
			query.append("WHERE (template_id = ").append(templateID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new Template();
				result.setTemplateID(rs.getInt(1));
				result.setTemplateName(rs.getString(2));
			}
			else
			{
				Diagnostics.error("Error in Template.fetch(), Could not find Template; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Template.fetch()");
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
		Diagnostics.trace("Template.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE templates ");
			update.append("SET template_name = ").append(conn.toSQLString(StringUtil.truncate(this.getTemplateName(), 50)));
			update.append("WHERE (template_id = ").append(this.getTemplateID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Template.internalUpdate()");
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
		Diagnostics.trace("Template.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO templates (");
				insert.append("template_name");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getTemplateName(), 50)));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO templates (");
				insert.append("template_id");
				insert.append(", template_name");
				insert.append(") VALUES (");
				insert.append(this.getTemplateID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getTemplateName(), 50)));
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
			ErrorHandler.handleException(ic, e, "Exception in Template.internalInsert()");
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
		Diagnostics.trace("Template.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM templates ");
			delete.append("WHERE (template_id = ").append(this.getTemplateID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Template.internalDelete()");
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
		result.append("Template:\n");
		result.append("  template_id = ").append(this.getTemplateID()).append("\n");
		result.append("  template_name = ").append(this.getTemplateName()).append("\n");
		return result.toString();
	}


	public int getTemplateID()
	{
		return templateID;
	}

	public String getTemplateName()
	{
		return templateName;
	}

	public void setTemplateID(int templateIDIn)
	{
		templateID = templateIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTemplateName(String templateNameIn)
	{
		templateName = templateNameIn;
		handleAction(MODIFY_ACTION);
	}
}
