package ims.dataobjects;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.Hashtable;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Function extends AbstractDatabaseObject implements Serializable
{

	/**
	 *
	 */
	private static final long serialVersionUID = -7700384500570656206L;
	private int functionID;
	private int functionGroupID;
	private int templateID;
	public String name;
	private String code;
	private int templateLocationID;
	private String crud;
	private String securityCreate;
	private String securityUpdate;
	private String securityDelete;
	private String isNavFunction;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;
	public boolean view = false;
	public boolean insert = false;
	public boolean update = false;
	public boolean delete = false;

	public Function()
	{
		super();
	}

	public Function(ResultSet rs) throws SQLException
	{
		super();
		//if (rs.getString("id") != null) functionID = Integer.parseInt(rs.getString("id"));
		functionID = rs.getInt("function_id");
		code = rs.getString("code");
		name = rs.getString("name");
		createdBy = rs.getInt("created_by");
		modifiedBy = rs.getInt("modified_by");

	//	if (rs.getString("created_by") != null) createdBy = Integer.parseInt(rs.getString("created_by"));
		dateCreated = rs.getTimestamp("date_created");
	//	if (rs.getString("modified_by") != null) modifiedBy = Integer.parseInt(rs.getString("modified_by"));
		dateModified = rs.getTimestamp("date_modified");
	}

	public static Function fetch(String functionID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(functionID), ic, null);
	}

	public static Function fetch(String functionID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(functionID), ic, resourceName);
	}

	public static Function fetch(int functionID, InvocationContext ic)
	{
		 return fetch(functionID, ic, null);
	}

	public static Function fetch(int functionID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Function.fetch()");

		Function result = null;
		ConnectionWrapper conn = null;
		QueryResults rs = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT function_id ");
			query.append(", function_group_id ");
			query.append(", template_id ");
			query.append(", name ");
			query.append(", code ");
			query.append(", crud ");
			query.append(", security_create ");
			query.append(", security_update ");
			query.append(", security_delete ");
			query.append(", is_nav_function ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM functions ");
			query.append("WHERE function_id = ?");

			rs = conn.select(query, functionID);
			if (rs.next())
			{
				result = new Function();
				result.setFunctionID(rs.getInt(1));
				result.setFunctionGroupID(rs.getInt(2));
				result.setTemplateID(rs.getInt(3));
				result.setName(rs.getString(4));
				result.setCode(rs.getString(5));
				result.setTemplateLocationID(rs.getInt(6));
				result.setCrud(rs.getString(7));
				result.setSecurityCreate(rs.getString(8));
				result.setSecurityUpdate(rs.getString(9));
				result.setSecurityDelete(rs.getString(10));
				result.setIsNavFunction(rs.getString(11));
				result.setDateCreated(rs.getDate(12));
				result.setCreatedBy(rs.getInt(13));
				result.setDateModified(rs.getDate(14));
				result.setModifiedBy(rs.getInt(15));
			}
			else
			{
				Diagnostics.error("Error in Function.fetch(), Could not find Function; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Function.fetch()");
		}
		finally
		{
			if (rs != null)
			{
				try
				{
					rs.close();
				}
				catch (SQLException ignore){}
			}
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
		Diagnostics.trace("Function.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE functions ");
			update.append("SET function_group_id = ").append(this.getFunctionGroupID());
			update.append(", template_id = ").append(this.getTemplateID());
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
			update.append(", code = ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
			update.append(", crud = ").append(conn.toSQLString(StringUtil.truncate(this.getCrud(), 20)));
			update.append(", security_create = ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityCreate(), 1)));
			update.append(", security_update = ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityUpdate(), 1)));
			update.append(", security_delete = ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityDelete(), 1)));
			update.append(", is_nav_function = ").append(conn.toSQLString(StringUtil.truncate(this.getIsNavFunction(), 1)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (function_id = ").append(this.getFunctionID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Function.internalUpdate()");
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
		Diagnostics.trace("Function.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO functions (");
				insert.append("function_group_id");
				insert.append(", template_id");
				insert.append(", name");
				insert.append(", code");
				insert.append(", crud");
				insert.append(", security_create");
				insert.append(", security_update");
				insert.append(", security_delete");
				insert.append(", is_nav_function");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getFunctionGroupID());
				insert.append(", ").append(this.getTemplateID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
				insert.append(", ").append(this.getTemplateLocationID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCrud(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityCreate(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityUpdate(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityDelete(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getIsNavFunction(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO functions (");
				insert.append("function_id");
				insert.append(", function_group_id");
				insert.append(", template_id");
				insert.append(", name");
				insert.append(", code");
				insert.append(", crud");
				insert.append(", security_create");
				insert.append(", security_update");
				insert.append(", security_delete");
				insert.append(", is_nav_function");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getFunctionID());
				insert.append(", ").append(this.getFunctionGroupID());
				insert.append(", ").append(this.getTemplateID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
				insert.append(", ").append(this.getTemplateLocationID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCrud(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityCreate(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityUpdate(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getSecurityDelete(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getIsNavFunction(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				functionID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Function.internalInsert()");
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
		Diagnostics.trace("Function.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM functions ");
			delete.append("WHERE (function_id = ").append(this.getFunctionID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Function.internalDelete()");
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
		if (this.getFunctionID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}

	/**
	 * Get all the functions by user, even if they do not have rights.
	 */
	public static Hashtable fetchByUser(ConnectionWrapper conn, String user_id) throws SQLException
	{
		Hashtable functions = new Hashtable();

		String query = "SELECT f.function_id, f.name, f.code, f.description, rt.code as right_type_code, u.user_id, "
			+ " f.created_by, f.date_created, f.date_modified, f.modified_by"
			+ " FROM functions f, role_function_rights rfr, right_types rt, users u, user_roles ur"
			+ " WHERE u.user_id = ?"
			+ " AND u.user_id = ur.user_id"
			+ " AND ur.role_id = rfr.role_id"
			+ " AND rfr.function_id = f.function_id"
			+ " AND rfr.right_type_id = rt.right_type_id"
			+ " ORDER BY f.code";

		QueryResults rs = conn.select(query, user_id);
		while (rs.next())
		{
			Function func = new Function(rs.getResultSet());
			Function existingFunction = (Function)functions.get(func.code);
			if (existingFunction == null)
			{
				functions.put(func.code, func);
			}
			else
			{
				func = existingFunction;
			}
			setCode(rs.getString("right_type_code"), func.code, func);
		}
		rs.close();

		return functions;
	}

	private static void setCode(String code, String function_id, Function func) throws SQLException
	{
		if (code == null) {
			//Null right type
		} else if (code.equalsIgnoreCase("view")) {
			func.view = true;
		} else if (code.equalsIgnoreCase("insert")) {
			func.insert = true;
		} else if (code.equalsIgnoreCase("update")) {
			func.update = true;
		} else if (code.equalsIgnoreCase("delete")) {
			func.delete = true;
		} else {
			throw new SQLException("Function.fetch("+function_id+") Unknown right type " + code);
		}
	}

	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Function:\n");
		result.append("  function_id = ").append(this.getFunctionID()).append("\n");
		result.append("  function_group_id = ").append(this.getFunctionGroupID()).append("\n");
		result.append("  template_id = ").append(this.getTemplateID()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  code = ").append(this.getCode()).append("\n");
		result.append("  crud = ").append(this.getCrud()).append("\n");
		result.append("  security_create = ").append(this.getSecurityCreate()).append("\n");
		result.append("  security_update = ").append(this.getSecurityUpdate()).append("\n");
		result.append("  security_delete = ").append(this.getSecurityDelete()).append("\n");
		result.append("  is_nav_function = ").append(this.getIsNavFunction()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getFunctionID()
	{
		return functionID;
	}

	public int getFunctionGroupID()
	{
		return functionGroupID;
	}

	public int getTemplateID()
	{
		return templateID;
	}

	public String getName()
	{
		return name;
	}

	public String getCode()
	{
		return code;
	}

	public int getTemplateLocationID()
	{
		return templateLocationID;
	}

	public String getCrud()
	{
		return crud;
	}

	public String getSecurityCreate()
	{
		return securityCreate;
	}

	public String getSecurityUpdate()
	{
		return securityUpdate;
	}

	public String getSecurityDelete()
	{
		return securityDelete;
	}

	public String getIsNavFunction()
	{
		return isNavFunction;
	}

	public Date getDateCreated()
	{
		return dateCreated;
	}

	public int getCreatedBy()
	{
		return createdBy;
	}

	public Date getDateModified()
	{
		return dateModified;
	}

	public int getModifiedBy()
	{
		return modifiedBy;
	}

	public void setFunctionID(int functionIDIn)
	{
		functionID = functionIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setFunctionGroupID(int functionGroupIDIn)
	{
		functionGroupID = functionGroupIDIn;
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

	public void setCode(String codeIn)
	{
		code = codeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTemplateLocationID(int templateLocationIDIn)
	{
		templateLocationID = templateLocationIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCrud(String crudIn)
	{
		crud = crudIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSecurityCreate(String securityCreateIn)
	{
		securityCreate = securityCreateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSecurityUpdate(String securityUpdateIn)
	{
		securityUpdate = securityUpdateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSecurityDelete(String securityDeleteIn)
	{
		securityDelete = securityDeleteIn;
		handleAction(MODIFY_ACTION);
	}

	public void setIsNavFunction(String isNavFunctionIn)
	{
		isNavFunction = isNavFunctionIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateCreated(Date dateCreatedIn)
	{
		dateCreated = dateCreatedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCreatedBy(int createdByIn)
	{
		createdBy = createdByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateModified(Date dateModifiedIn)
	{
		dateModified = dateModifiedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setModifiedBy(int modifiedByIn)
	{
		modifiedBy = modifiedByIn;
		handleAction(MODIFY_ACTION);
	}
}
