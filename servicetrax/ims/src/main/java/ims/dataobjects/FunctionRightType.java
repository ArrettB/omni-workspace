package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class FunctionRightType extends AbstractDatabaseObject
{

	private int functionRightTypeID;
	private int functionID;
	private int rightTypeID;
	private String updatableFlag;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public FunctionRightType()
	{
		super();
	}


	public static FunctionRightType fetch(String functionRightTypeID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(functionRightTypeID), ic, null);
	}

	public static FunctionRightType fetch(String functionRightTypeID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(functionRightTypeID), ic, resourceName);
	}

	public static FunctionRightType fetch(int functionRightTypeID, InvocationContext ic)
	{
		 return fetch(functionRightTypeID, ic, null);
	}

	public static FunctionRightType fetch(int functionRightTypeID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("FunctionRightType.fetch()");

		FunctionRightType result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT function_right_type_id ");
			query.append(", function_id ");
			query.append(", right_type_id ");
			query.append(", updatable_flag ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM function_right_types ");
			query.append("WHERE (function_right_type_id = ").append(functionRightTypeID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new FunctionRightType();
				result.setFunctionRightTypeID(rs.getInt(1));
				result.setFunctionID(rs.getInt(2));
				result.setRightTypeID(rs.getInt(3));
				result.setUpdatableFlag(rs.getString(4));
				result.setDateCreated(rs.getDate(5));
				result.setCreatedBy(rs.getInt(6));
				result.setDateModified(rs.getDate(7));
				result.setModifiedBy(rs.getInt(8));
			}
			else
			{
				Diagnostics.error("Error in FunctionRightType.fetch(), Could not find FunctionRightType; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FunctionRightType.fetch()");
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
		Diagnostics.trace("FunctionRightType.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE function_right_types ");
			update.append("SET function_id = ").append(this.getFunctionID());
			update.append(", right_type_id = ").append(this.getRightTypeID());
			update.append(", updatable_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (function_right_type_id = ").append(this.getFunctionRightTypeID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FunctionRightType.internalUpdate()");
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
		Diagnostics.trace("FunctionRightType.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO function_right_types (");
				insert.append("function_id");
				insert.append(", right_type_id");
				insert.append(", updatable_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getFunctionID());
				insert.append(", ").append(this.getRightTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO function_right_types (");
				insert.append("function_right_type_id");
				insert.append(", function_id");
				insert.append(", right_type_id");
				insert.append(", updatable_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getFunctionRightTypeID());
				insert.append(", ").append(this.getFunctionID());
				insert.append(", ").append(this.getRightTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				functionRightTypeID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FunctionRightType.internalInsert()");
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
		Diagnostics.trace("FunctionRightType.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM function_right_types ");
			delete.append("WHERE (function_right_type_id = ").append(this.getFunctionRightTypeID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FunctionRightType.internalDelete()");
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
		if (this.getFunctionRightTypeID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("FunctionRightType:\n");
		result.append("  function_right_type_id = ").append(this.getFunctionRightTypeID()).append("\n");
		result.append("  function_id = ").append(this.getFunctionID()).append("\n");
		result.append("  right_type_id = ").append(this.getRightTypeID()).append("\n");
		result.append("  updatable_flag = ").append(this.getUpdatableFlag()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getFunctionRightTypeID()
	{
		return functionRightTypeID;
	}

	public int getFunctionID()
	{
		return functionID;
	}

	public int getRightTypeID()
	{
		return rightTypeID;
	}

	public String getUpdatableFlag()
	{
		return updatableFlag;
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

	public void setFunctionRightTypeID(int functionRightTypeIDIn)
	{
		functionRightTypeID = functionRightTypeIDIn;
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

	public void setUpdatableFlag(String updatableFlagIn)
	{
		updatableFlag = updatableFlagIn;
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
