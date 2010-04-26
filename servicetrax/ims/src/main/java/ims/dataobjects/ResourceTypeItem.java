package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class ResourceTypeItem extends AbstractDatabaseObject
{

	private int resTypeItemID;
	private int resourceTypeID;
	private int itemID;
	private String defaultItemFlag;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ResourceTypeItem()
	{
		super();
	}


	public static ResourceTypeItem fetch(String resTypeItemID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(resTypeItemID), ic, null);
	}

	public static ResourceTypeItem fetch(String resTypeItemID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(resTypeItemID), ic, resourceName);
	}

	public static ResourceTypeItem fetch(int resTypeItemID, InvocationContext ic)
	{
		 return fetch(resTypeItemID, ic, null);
	}

	public static ResourceTypeItem fetch(int resTypeItemID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ResourceTypeItem.fetch()");

		ResourceTypeItem result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT res_type_item_id ");
			query.append(", resource_type_id ");
			query.append(", item_id ");
			query.append(", default_item_flag ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM resource_type_items ");
			query.append("WHERE (res_type_item_id = ").append(resTypeItemID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ResourceTypeItem();
				result.setResTypeItemID(rs.getInt(1));
				result.setResourceTypeID(rs.getInt(2));
				result.setItemID(rs.getInt(3));
				result.setDefaultItemFlag(rs.getString(4));
				result.setDateCreated(rs.getDate(5));
				result.setCreatedBy(rs.getInt(6));
				result.setDateModified(rs.getDate(7));
				result.setModifiedBy(rs.getInt(8));
			}
			else
			{
				Diagnostics.error("Error in ResourceTypeItem.fetch(), Could not find ResourceTypeItem; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceTypeItem.fetch()");
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
		Diagnostics.trace("ResourceTypeItem.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE resource_type_items ");
			update.append("SET resource_type_id = ").append(this.getResourceTypeID());
			update.append(", item_id = ").append(this.getItemID());
			update.append(", default_item_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultItemFlag(), 1)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (res_type_item_id = ").append(this.getResTypeItemID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceTypeItem.internalUpdate()");
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
		Diagnostics.trace("ResourceTypeItem.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO resource_type_items (");
				insert.append("resource_type_id");
				insert.append(", item_id");
				insert.append(", default_item_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getResourceTypeID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultItemFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO resource_type_items (");
				insert.append("res_type_item_id");
				insert.append(", resource_type_id");
				insert.append(", item_id");
				insert.append(", default_item_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getResTypeItemID());
				insert.append(", ").append(this.getResourceTypeID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultItemFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				resTypeItemID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceTypeItem.internalInsert()");
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
		Diagnostics.trace("ResourceTypeItem.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM resource_type_items ");
			delete.append("WHERE (res_type_item_id = ").append(this.getResTypeItemID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceTypeItem.internalDelete()");
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
		if (this.getResTypeItemID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ResourceTypeItem:\n");
		result.append("  res_type_item_id = ").append(this.getResTypeItemID()).append("\n");
		result.append("  resource_type_id = ").append(this.getResourceTypeID()).append("\n");
		result.append("  item_id = ").append(this.getItemID()).append("\n");
		result.append("  default_item_flag = ").append(this.getDefaultItemFlag()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getResTypeItemID()
	{
		return resTypeItemID;
	}

	public int getResourceTypeID()
	{
		return resourceTypeID;
	}

	public int getItemID()
	{
		return itemID;
	}

	public String getDefaultItemFlag()
	{
		return defaultItemFlag;
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

	public void setResTypeItemID(int resTypeItemIDIn)
	{
		resTypeItemID = resTypeItemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceTypeID(int resourceTypeIDIn)
	{
		resourceTypeID = resourceTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setItemID(int itemIDIn)
	{
		itemID = itemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDefaultItemFlag(String defaultItemFlagIn)
	{
		defaultItemFlag = defaultItemFlagIn;
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
