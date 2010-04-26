package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class RoleFunctionRight extends AbstractDatabaseObject
{

	private int roleFunctionRightID;
	private int roleID;
	private int functionID;
	private int rightTypeID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public RoleFunctionRight()
	{
		super();
	}


	public static RoleFunctionRight fetch(String roleFunctionRightID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(roleFunctionRightID), ic, null);
	}

	public static RoleFunctionRight fetch(String roleFunctionRightID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(roleFunctionRightID), ic, resourceName);
	}

	public static RoleFunctionRight fetch(int roleFunctionRightID, InvocationContext ic)
	{
		 return fetch(roleFunctionRightID, ic, null);
	}

	public static RoleFunctionRight fetch(int roleFunctionRightID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("RoleFunctionRight.fetch()");

		RoleFunctionRight result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT role_function_right_id ");
			query.append(", role_id ");
			query.append(", function_id ");
			query.append(", right_type_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM role_function_rights ");
			query.append("WHERE (role_function_right_id = ").append(roleFunctionRightID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new RoleFunctionRight();
				result.setRoleFunctionRightID(rs.getInt(1));
				result.setRoleID(rs.getInt(2));
				result.setFunctionID(rs.getInt(3));
				result.setRightTypeID(rs.getInt(4));
				result.setDateCreated(rs.getDate(5));
				result.setCreatedBy(rs.getInt(6));
				result.setDateModified(rs.getDate(7));
				result.setModifiedBy(rs.getInt(8));
			}
			else
			{
				Diagnostics.error("Error in RoleFunctionRight.fetch(), Could not find RoleFunctionRight; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RoleFunctionRight.fetch()");
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
		Diagnostics.trace("RoleFunctionRight.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE role_function_rights ");
			update.append("SET role_id = ").append(this.getRoleID());
			update.append(", function_id = ").append(this.getFunctionID());
			update.append(", right_type_id = ").append(this.getRightTypeID());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (role_function_right_id = ").append(this.getRoleFunctionRightID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RoleFunctionRight.internalUpdate()");
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
		Diagnostics.trace("RoleFunctionRight.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO role_function_rights (");
				insert.append("role_id");
				insert.append(", function_id");
				insert.append(", right_type_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getRoleID());
				insert.append(", ").append(this.getFunctionID());
				insert.append(", ").append(this.getRightTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO role_function_rights (");
				insert.append("role_function_right_id");
				insert.append(", role_id");
				insert.append(", function_id");
				insert.append(", right_type_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getRoleFunctionRightID());
				insert.append(", ").append(this.getRoleID());
				insert.append(", ").append(this.getFunctionID());
				insert.append(", ").append(this.getRightTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				roleFunctionRightID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RoleFunctionRight.internalInsert()");
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
		Diagnostics.trace("RoleFunctionRight.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM role_function_rights ");
			delete.append("WHERE (role_function_right_id = ").append(this.getRoleFunctionRightID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RoleFunctionRight.internalDelete()");
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
		if (this.getRoleFunctionRightID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("RoleFunctionRight:\n");
		result.append("  role_function_right_id = ").append(this.getRoleFunctionRightID()).append("\n");
		result.append("  role_id = ").append(this.getRoleID()).append("\n");
		result.append("  function_id = ").append(this.getFunctionID()).append("\n");
		result.append("  right_type_id = ").append(this.getRightTypeID()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getRoleFunctionRightID()
	{
		return roleFunctionRightID;
	}

	public int getRoleID()
	{
		return roleID;
	}

	public int getFunctionID()
	{
		return functionID;
	}

	public int getRightTypeID()
	{
		return rightTypeID;
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

	public void setRoleFunctionRightID(int roleFunctionRightIDIn)
	{
		roleFunctionRightID = roleFunctionRightIDIn;
		handleAction(MODIFY_ACTION);
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

	public void setRightTypeID(int rightTypeIDIn)
	{
		rightTypeID = rightTypeIDIn;
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
