package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class RoleFunction extends AbstractDatabaseObject
{

	private int roleID;
	private int functionID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public RoleFunction()
	{
		super();
	}


	public static RoleFunction fetch(String roleID, String functionID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(roleID), Integer.parseInt(functionID), ic, null);
	}

	public static RoleFunction fetch(String roleID, String functionID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(roleID), Integer.parseInt(functionID), ic, resourceName);
	}

	public static RoleFunction fetch(int roleID, int functionID, InvocationContext ic)
	{
		 return fetch(roleID, functionID, ic, null);
	}

	public static RoleFunction fetch(int roleID, int functionID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("RoleFunction.fetch()");

		RoleFunction result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT role_id ");
			query.append(", function_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM role_functions ");
			query.append("WHERE (role_id = ").append(roleID).append(" AND function_id = ").append(functionID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new RoleFunction();
				result.setRoleID(rs.getInt(1));
				result.setFunctionID(rs.getInt(2));
				result.setDateCreated(rs.getDate(3));
				result.setCreatedBy(rs.getInt(4));
				result.setDateModified(rs.getDate(5));
				result.setModifiedBy(rs.getInt(6));
			}
			else
			{
				Diagnostics.error("Error in RoleFunction.fetch(), Could not find RoleFunction; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RoleFunction.fetch()");
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
		Diagnostics.trace("RoleFunction.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE role_functions ");
			update.append("SET date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (role_id = ").append(this.getRoleID()).append(" AND function_id = ").append(this.getFunctionID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RoleFunction.internalUpdate()");
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
		Diagnostics.trace("RoleFunction.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO role_functions (");
				insert.append("date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO role_functions (");
				insert.append("role_id");
				insert.append(", function_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getRoleID());
				insert.append(", ").append(this.getFunctionID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RoleFunction.internalInsert()");
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
		Diagnostics.trace("RoleFunction.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM role_functions ");
			delete.append("WHERE (role_id = ").append(this.getRoleID()).append(" AND function_id = ").append(this.getFunctionID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RoleFunction.internalDelete()");
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
		if (this.getRoleID() <= 0)
		{
			skipPrimaryKey = true;
		}
		else if (this.getFunctionID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("RoleFunction:\n");
		result.append("  role_id = ").append(this.getRoleID()).append("\n");
		result.append("  function_id = ").append(this.getFunctionID()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getRoleID()
	{
		return roleID;
	}

	public int getFunctionID()
	{
		return functionID;
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

	public void setRoleID(int roleIDIn)
	{
		roleID = roleIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setFunctionID(int functionIDIn)
	{
		functionID = functionIDIn;
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
