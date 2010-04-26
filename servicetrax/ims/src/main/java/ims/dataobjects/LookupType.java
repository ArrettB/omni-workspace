package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class LookupType extends AbstractDatabaseObject
{

	private int lookupTypeID;
	private String code;
	private String name;
	private String activeFlag;
	private String updatableFlag;
	private int parentTypeID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public LookupType()
	{
		super();
	}


	public static LookupType fetch(String lookupTypeID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(lookupTypeID), ic, null);
	}

	public static LookupType fetch(String lookupTypeID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(lookupTypeID), ic, resourceName);
	}

	public static LookupType fetch(int lookupTypeID, InvocationContext ic)
	{
		 return fetch(lookupTypeID, ic, null);
	}

	public static LookupType fetch(int lookupTypeID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("LookupType.fetch()");

		LookupType result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT lookup_type_id ");
			query.append(", code ");
			query.append(", name ");
			query.append(", active_flag ");
			query.append(", updatable_flag ");
			query.append(", parent_type_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM lookup_types ");
			query.append("WHERE (lookup_type_id = ").append(lookupTypeID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new LookupType();
				result.setLookupTypeID(rs.getInt(1));
				result.setCode(rs.getString(2));
				result.setName(rs.getString(3));
				result.setActiveFlag(rs.getString(4));
				result.setUpdatableFlag(rs.getString(5));
				result.setParentTypeID(rs.getInt(6));
				result.setDateCreated(rs.getDate(7));
				result.setCreatedBy(rs.getInt(8));
				result.setDateModified(rs.getDate(9));
				result.setModifiedBy(rs.getInt(10));
			}
			else
			{
				Diagnostics.error("Error in LookupType.fetch(), Could not find LookupType; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in LookupType.fetch()");
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
		Diagnostics.trace("LookupType.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE lookup_types ");
			update.append("SET code = ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 100)));
			update.append(", active_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
			update.append(", updatable_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
			update.append(", parent_type_id = ").append(this.getParentTypeID());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (lookup_type_id = ").append(this.getLookupTypeID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in LookupType.internalUpdate()");
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
		Diagnostics.trace("LookupType.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO lookup_types (");
				insert.append("code");
				insert.append(", name");
				insert.append(", active_flag");
				insert.append(", updatable_flag");
				insert.append(", parent_type_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
				insert.append(", ").append(this.getParentTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO lookup_types (");
				insert.append("lookup_type_id");
				insert.append(", code");
				insert.append(", name");
				insert.append(", active_flag");
				insert.append(", updatable_flag");
				insert.append(", parent_type_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getLookupTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 30)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUpdatableFlag(), 1)));
				insert.append(", ").append(this.getParentTypeID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				lookupTypeID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in LookupType.internalInsert()");
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
		Diagnostics.trace("LookupType.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM lookup_types ");
			delete.append("WHERE (lookup_type_id = ").append(this.getLookupTypeID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in LookupType.internalDelete()");
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
		if (this.getLookupTypeID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("LookupType:\n");
		result.append("  lookup_type_id = ").append(this.getLookupTypeID()).append("\n");
		result.append("  code = ").append(this.getCode()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  active_flag = ").append(this.getActiveFlag()).append("\n");
		result.append("  updatable_flag = ").append(this.getUpdatableFlag()).append("\n");
		result.append("  parent_type_id = ").append(this.getParentTypeID()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getLookupTypeID()
	{
		return lookupTypeID;
	}

	public String getCode()
	{
		return code;
	}

	public String getName()
	{
		return name;
	}

	public String getActiveFlag()
	{
		return activeFlag;
	}

	public String getUpdatableFlag()
	{
		return updatableFlag;
	}

	public int getParentTypeID()
	{
		return parentTypeID;
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

	public void setLookupTypeID(int lookupTypeIDIn)
	{
		lookupTypeID = lookupTypeIDIn;
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

	public void setActiveFlag(String activeFlagIn)
	{
		activeFlag = activeFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUpdatableFlag(String updatableFlagIn)
	{
		updatableFlag = updatableFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setParentTypeID(int parentTypeIDIn)
	{
		parentTypeID = parentTypeIDIn;
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
