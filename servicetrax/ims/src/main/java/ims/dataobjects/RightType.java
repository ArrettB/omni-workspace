package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class RightType extends AbstractDatabaseObject
{

	private int rightTypeID;
	private String code;
	private String name;
	private String description;
	private int createdBy;
	private Date dateCreated;
	private int modifiedBy;
	private Date dateModified;

	public RightType()
	{
		super();
	}


	public static RightType fetch(String rightTypeID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(rightTypeID), ic, null);
	}

	public static RightType fetch(String rightTypeID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(rightTypeID), ic, resourceName);
	}

	public static RightType fetch(int rightTypeID, InvocationContext ic)
	{
		 return fetch(rightTypeID, ic, null);
	}

	public static RightType fetch(int rightTypeID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("RightType.fetch()");

		RightType result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT right_type_id ");
			query.append(", code ");
			query.append(", name ");
			query.append(", description ");
			query.append(", created_by ");
			query.append(", date_created ");
			query.append(", modified_by ");
			query.append(", date_modified ");
			query.append("FROM right_types ");
			query.append("WHERE (right_type_id = ").append(rightTypeID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new RightType();
				result.setRightTypeID(rs.getInt(1));
				result.setCode(rs.getString(2));
				result.setName(rs.getString(3));
				result.setDescription(rs.getString(4));
				result.setCreatedBy(rs.getInt(5));
				result.setDateCreated(rs.getDate(6));
				result.setModifiedBy(rs.getInt(7));
				result.setDateModified(rs.getDate(8));
			}
			else
			{
				Diagnostics.error("Error in RightType.fetch(), Could not find RightType; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RightType.fetch()");
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
		Diagnostics.trace("RightType.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE right_types ");
			update.append("SET code = ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 50)));
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
			update.append(", description = ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 2000)));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append("WHERE (right_type_id = ").append(this.getRightTypeID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RightType.internalUpdate()");
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
		Diagnostics.trace("RightType.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO right_types (");
				insert.append("code");
				insert.append(", name");
				insert.append(", description");
				insert.append(", created_by");
				insert.append(", date_created");
				insert.append(", modified_by");
				insert.append(", date_modified");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getCode(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 2000)));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO right_types (");
				insert.append("right_type_id");
				insert.append(", code");
				insert.append(", name");
				insert.append(", description");
				insert.append(", created_by");
				insert.append(", date_created");
				insert.append(", modified_by");
				insert.append(", date_modified");
				insert.append(") VALUES (");
				insert.append(this.getRightTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 2000)));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				rightTypeID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RightType.internalInsert()");
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
		Diagnostics.trace("RightType.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM right_types ");
			delete.append("WHERE (right_type_id = ").append(this.getRightTypeID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in RightType.internalDelete()");
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
		if (this.getRightTypeID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("RightType:\n");
		result.append("  right_type_id = ").append(this.getRightTypeID()).append("\n");
		result.append("  code = ").append(this.getCode()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  description = ").append(this.getDescription()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		return result.toString();
	}


	public int getRightTypeID()
	{
		return rightTypeID;
	}

	public String getCode()
	{
		return code;
	}

	public String getName()
	{
		return name;
	}

	public String getDescription()
	{
		return description;
	}

	public int getCreatedBy()
	{
		return createdBy;
	}

	public Date getDateCreated()
	{
		return dateCreated;
	}

	public int getModifiedBy()
	{
		return modifiedBy;
	}

	public Date getDateModified()
	{
		return dateModified;
	}

	public void setRightTypeID(int rightTypeIDIn)
	{
		rightTypeID = rightTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCode(String codeIn)
	{
		code = codeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setName(String nameIn)
	{
		name = nameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDescription(String descriptionIn)
	{
		description = descriptionIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCreatedBy(int createdByIn)
	{
		createdBy = createdByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateCreated(Date dateCreatedIn)
	{
		dateCreated = dateCreatedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setModifiedBy(int modifiedByIn)
	{
		modifiedBy = modifiedByIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateModified(Date dateModifiedIn)
	{
		dateModified = dateModifiedIn;
		handleAction(MODIFY_ACTION);
	}
}
