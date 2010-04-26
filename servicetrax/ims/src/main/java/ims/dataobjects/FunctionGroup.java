package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class FunctionGroup extends AbstractDatabaseObject
{

	private int functionGroupID;
	private String name;
	private String code;

	public FunctionGroup()
	{
		super();
	}


	public static FunctionGroup fetch(String functionGroupID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(functionGroupID), ic, null);
	}

	public static FunctionGroup fetch(String functionGroupID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(functionGroupID), ic, resourceName);
	}

	public static FunctionGroup fetch(int functionGroupID, InvocationContext ic)
	{
		 return fetch(functionGroupID, ic, null);
	}

	public static FunctionGroup fetch(int functionGroupID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("FunctionGroup.fetch()");

		FunctionGroup result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT function_group_id ");
			query.append(", name ");
			query.append(", code ");
			query.append("FROM function_groups ");
			query.append("WHERE (function_group_id = ").append(functionGroupID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new FunctionGroup();
				result.setFunctionGroupID(rs.getInt(1));
				result.setName(rs.getString(2));
				result.setCode(rs.getString(3));
			}
			else
			{
				Diagnostics.error("Error in FunctionGroup.fetch(), Could not find FunctionGroup; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FunctionGroup.fetch()");
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
		Diagnostics.trace("FunctionGroup.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE function_groups ");
			update.append("SET name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
			update.append(", code = ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 50)));
			update.append("WHERE (function_group_id = ").append(this.getFunctionGroupID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FunctionGroup.internalUpdate()");
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
		Diagnostics.trace("FunctionGroup.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO function_groups (");
				insert.append("name");
				insert.append(", code");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 50)));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO function_groups (");
				insert.append("function_group_id");
				insert.append(", name");
				insert.append(", code");
				insert.append(") VALUES (");
				insert.append(this.getFunctionGroupID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 50)));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				functionGroupID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FunctionGroup.internalInsert()");
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
		Diagnostics.trace("FunctionGroup.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM function_groups ");
			delete.append("WHERE (function_group_id = ").append(this.getFunctionGroupID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FunctionGroup.internalDelete()");
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
		if (this.getFunctionGroupID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("FunctionGroup:\n");
		result.append("  function_group_id = ").append(this.getFunctionGroupID()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  code = ").append(this.getCode()).append("\n");
		return result.toString();
	}


	public int getFunctionGroupID()
	{
		return functionGroupID;
	}

	public String getName()
	{
		return name;
	}

	public String getCode()
	{
		return code;
	}

	public void setFunctionGroupID(int functionGroupIDIn)
	{
		functionGroupID = functionGroupIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setName(String nameIn)
	{
		name = nameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCode(String codeIn)
	{
		code = codeIn;
		handleAction(MODIFY_ACTION);
	}
}
