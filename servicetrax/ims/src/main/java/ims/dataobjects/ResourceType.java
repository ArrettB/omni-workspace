package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class ResourceType extends AbstractDatabaseObject
{

	private int resourceTypeID;
	private String code;
	private String name;
	private int defTimeUomTypeID;
	private String estimateHoursFlag;
	private String uniqueFlag;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ResourceType()
	{
		super();
	}


	public static ResourceType fetch(String resourceTypeID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(resourceTypeID), ic, null);
	}

	public static ResourceType fetch(String resourceTypeID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(resourceTypeID), ic, resourceName);
	}

	public static ResourceType fetch(int resourceTypeID, InvocationContext ic)
	{
		 return fetch(resourceTypeID, ic, null);
	}

	public static ResourceType fetch(int resourceTypeID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ResourceType.fetch()");

		ResourceType result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT resource_type_id ");
			query.append(", code ");
			query.append(", name ");
			query.append(", def_time_uom_type_id ");
			query.append(", estimate_hours_flag ");
			query.append(", unique_flag ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM resource_types ");
			query.append("WHERE (resource_type_id = ").append(resourceTypeID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ResourceType();
				result.setResourceTypeID(rs.getInt(1));
				result.setCode(rs.getString(2));
				result.setName(rs.getString(3));
				result.setDefTimeUomTypeID(rs.getInt(4));
				result.setEstimateHoursFlag(rs.getString(5));
				result.setUniqueFlag(rs.getString(6));
				result.setDateCreated(rs.getDate(7));
				result.setCreatedBy(rs.getInt(8));
				result.setDateModified(rs.getDate(9));
				result.setModifiedBy(rs.getInt(10));
			}
			else
			{
				Diagnostics.error("Error in ResourceType.fetch(), Could not find ResourceType; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceType.fetch()");
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
		Diagnostics.trace("ResourceType.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE resource_types ");
			update.append("SET code = ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 20)));
			update.append(", name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
			update.append(", def_time_uom_type_id = ").append(this.getDefTimeUomTypeID());
			update.append(", estimate_hours_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getEstimateHoursFlag(), 50)));
			update.append(", unique_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getUniqueFlag(), 1)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (resource_type_id = ").append(this.getResourceTypeID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceType.internalUpdate()");
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
		Diagnostics.trace("ResourceType.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO resource_types (");
				insert.append("code");
				insert.append(", name");
				insert.append(", def_time_uom_type_id");
				insert.append(", estimate_hours_flag");
				insert.append(", unique_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getCode(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(", ").append(this.getDefTimeUomTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEstimateHoursFlag(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUniqueFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO resource_types (");
				insert.append("resource_type_id");
				insert.append(", code");
				insert.append(", name");
				insert.append(", def_time_uom_type_id");
				insert.append(", estimate_hours_flag");
				insert.append(", unique_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getResourceTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getCode(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 50)));
				insert.append(", ").append(this.getDefTimeUomTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEstimateHoursFlag(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getUniqueFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				resourceTypeID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceType.internalInsert()");
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
		Diagnostics.trace("ResourceType.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM resource_types ");
			delete.append("WHERE (resource_type_id = ").append(this.getResourceTypeID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceType.internalDelete()");
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
		if (this.getResourceTypeID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ResourceType:\n");
		result.append("  resource_type_id = ").append(this.getResourceTypeID()).append("\n");
		result.append("  code = ").append(this.getCode()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  def_time_uom_type_id = ").append(this.getDefTimeUomTypeID()).append("\n");
		result.append("  estimate_hours_flag = ").append(this.getEstimateHoursFlag()).append("\n");
		result.append("  unique_flag = ").append(this.getUniqueFlag()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getResourceTypeID()
	{
		return resourceTypeID;
	}

	public String getCode()
	{
		return code;
	}

	public String getName()
	{
		return name;
	}

	public int getDefTimeUomTypeID()
	{
		return defTimeUomTypeID;
	}

	public String getEstimateHoursFlag()
	{
		return estimateHoursFlag;
	}

	public String getUniqueFlag()
	{
		return uniqueFlag;
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

	public void setResourceTypeID(int resourceTypeIDIn)
	{
		resourceTypeID = resourceTypeIDIn;
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

	public void setDefTimeUomTypeID(int defTimeUomTypeIDIn)
	{
		defTimeUomTypeID = defTimeUomTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEstimateHoursFlag(String estimateHoursFlagIn)
	{
		estimateHoursFlag = estimateHoursFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUniqueFlag(String uniqueFlagIn)
	{
		uniqueFlag = uniqueFlagIn;
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
