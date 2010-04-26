package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class ResourceItem extends AbstractDatabaseObject
{

	private int resourceItemID;
	private int itemID;
	private int resourceID;
	private String defaultItemFlag;
	private double maxAmount;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ResourceItem()
	{
		super();
	}


	public static ResourceItem fetch(String resourceItemID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(resourceItemID), ic, null);
	}

	public static ResourceItem fetch(String resourceItemID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(resourceItemID), ic, resourceName);
	}

	public static ResourceItem fetch(int resourceItemID, InvocationContext ic)
	{
		 return fetch(resourceItemID, ic, null);
	}

	public static ResourceItem fetch(int resourceItemID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ResourceItem.fetch()");

		ResourceItem result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT resource_item_id ");
			query.append(", item_id ");
			query.append(", resource_id ");
			query.append(", default_item_flag ");
			query.append(", max_amount ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM resource_items ");
			query.append("WHERE (resource_item_id = ").append(resourceItemID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ResourceItem();
				result.setResourceItemID(rs.getInt(1));
				result.setItemID(rs.getInt(2));
				result.setResourceID(rs.getInt(3));
				result.setDefaultItemFlag(rs.getString(4));
				result.setMaxAmount(rs.getDouble(5));
				result.setDateCreated(rs.getDate(6));
				result.setCreatedBy(rs.getInt(7));
				result.setDateModified(rs.getDate(8));
				result.setModifiedBy(rs.getInt(9));
			}
			else
			{
				Diagnostics.error("Error in ResourceItem.fetch(), Could not find ResourceItem; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceItem.fetch()");
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
		Diagnostics.trace("ResourceItem.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE resource_items ");
			update.append("SET item_id = ").append(this.getItemID());
			update.append(", resource_id = ").append(this.getResourceID());
			update.append(", default_item_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultItemFlag(), 1)));
			if( maxAmount != 0 )
				update.append(", max_amount = ").append(this.getMaxAmount());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (resource_item_id = ").append(this.getResourceItemID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceItem.internalUpdate()");
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
		Diagnostics.trace("ResourceItem.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO resource_items (");
				insert.append("item_id");
				insert.append(", resource_id");
				insert.append(", default_item_flag");
				insert.append(", max_amount");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getItemID());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultItemFlag(), 1)));
				if( maxAmount != 0 )
					insert.append(", ").append(this.getMaxAmount());
				else
					insert.append(", null");
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO resource_items (");
				insert.append("resource_item_id");
				insert.append(", item_id");
				insert.append(", resource_id");
				insert.append(", default_item_flag");
				insert.append(", max_amount");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getResourceItemID());
				insert.append(", ").append(this.getItemID());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDefaultItemFlag(), 1)));
				if( maxAmount != 0 )
					insert.append(", ").append(this.getMaxAmount());
				else
					insert.append(", null");
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
Diagnostics.error("insert query='"+insert+"'");
			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				resourceItemID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceItem.internalInsert()");
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
		Diagnostics.trace("ResourceItem.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM resource_items ");
			delete.append("WHERE (resource_item_id = ").append(this.getResourceItemID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceItem.internalDelete()");
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
		if (this.getResourceItemID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ResourceItem:\n");
		result.append("  resource_item_id = ").append(this.getResourceItemID()).append("\n");
		result.append("  item_id = ").append(this.getItemID()).append("\n");
		result.append("  resource_id = ").append(this.getResourceID()).append("\n");
		result.append("  default_item_flag = ").append(this.getDefaultItemFlag()).append("\n");
		result.append("  max_amount = ").append(this.getMaxAmount()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getResourceItemID()
	{
		return resourceItemID;
	}

	public int getItemID()
	{
		return itemID;
	}

	public int getResourceID()
	{
		return resourceID;
	}

	public String getDefaultItemFlag()
	{
		return defaultItemFlag;
	}

	public double getMaxAmount()
	{
		return maxAmount;
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

	public void setResourceItemID(int resourceItemIDIn)
	{
		resourceItemID = resourceItemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setItemID(int itemIDIn)
	{
		itemID = itemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceID(int resourceIDIn)
	{
		resourceID = resourceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDefaultItemFlag(String defaultItemFlagIn)
	{
		defaultItemFlag = defaultItemFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setMaxAmount(double maxAmountIn)
	{
		maxAmount = maxAmountIn;
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
