package ims.dataobjects;

import java.sql.SQLException;
import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Item extends AbstractDatabaseObject
{

	private int itemID;
	private int organizationID;
	private String name;
	private String description;
	private String extItemID;
	private int itemTypeID;
	private int itemStatusTypeID;
	private String billableFlag;
	private String expenseExportCode;
	private int jobTypeID;
	private Double costPerUOM;
	private Double percentMargin;
	private String columnPosition;
	private boolean allowExpenseEntry;
	private Integer itemCategoryTypeID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public Item()
	{
		super();
	}


	public static Item fetch(String itemID, ConnectionWrapper conn)
	{
		Diagnostics.trace("Item.fetch()");

		Item result = null;
		QueryResults rs = null;
		try
		{
			StringBuffer query = new StringBuffer();
			query.append("SELECT item_id ");
			query.append(", organization_id ");
			query.append(", name ");
			query.append(", description ");
			query.append(", ext_item_id ");
			query.append(", item_type_id ");
			query.append(", item_status_type_id ");
			query.append(", billable_flag ");
			query.append(", expense_export_code ");
			query.append(", job_type_id ");
			query.append(", cost_per_uom ");
			query.append(", percent_margin ");
			query.append(", column_position ");
			query.append(", allow_expense_entry ");
			query.append(", item_category_type_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM items ");
			query.append("WHERE (item_id = ").append(itemID).append(") ");

			rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
				result = new Item();
				result.setItemID(rs.getInt("item_id"));
				result.setOrganizationID(rs.getInt("organization_id"));
				result.setName(rs.getString("name"));
				result.setDescription(rs.getString("description"));
				result.setExtItemID(rs.getString("ext_item_id"));
				result.setItemTypeID(rs.getInt("item_type_id"));
				result.setItemStatusTypeID(rs.getInt("item_status_type_id"));
				result.setBillableFlag(rs.getString("billable_flag"));
				result.setExpenseExportCode(rs.getString("expense_export_code"));
				result.setJobTypeID(rs.getInt("job_type_id"));
				result.setCostPerUOM(getDouble("cost_per_uom", rs));
				result.setPercentMargin(getDouble("percent_margin", rs));
				result.setColumnPosition(rs.getString("column_position"));
				result.setAllowExpenseEntry(StringUtil.toBoolean(rs.getString("allow_expense_entry")));
				result.setItemCategoryTypeID(getInteger("item_category_type_id", rs));
				result.setDateCreated(rs.getDate("date_created"));
				result.setCreatedBy(rs.getInt("created_by"));
				result.setDateModified(rs.getDate("date_modified"));
				result.setModifiedBy(rs.getInt("modified_by"));
			}
			else
			{
				Diagnostics.error("Error in Item.fetch(), Could not find Item; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception in Item.fetch()", e);
		}
		finally
		{
			if (rs != null)
				try
				{
					rs.close();
				}
				catch (SQLException ignore) {}
		}

		 if (result != null) result.handleAction(FETCH_ACTION);
		return result;
	}
	
	static Integer getInteger(String columnName, QueryResults rs) throws SQLException
	{
		Integer result = null;
		int value = rs.getInt(columnName);
		
		if (value == 0)
		{
			if (!rs.wasNull())
				result = new Integer(0);
		}
		else
		{
			result = new Integer(value);
		}
		
		return result;
	}

	static Double getDouble(String columnName, QueryResults rs) throws SQLException
	{
		Double result = null;
		double value = rs.getDouble(columnName);
		
		if (value == 0)
		{
			if (!rs.wasNull())
				result = new Double(0);
		}
		else
		{
			result = new Double(value);
		}
		
		return result;
	}

	protected void internalUpdate(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Item.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			internalUpdate(conn);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Item.internalUpdate()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalUpdate(ConnectionWrapper conn) throws SQLException
	{
		StringBuffer update = new StringBuffer();
		update.append("UPDATE items ");
		update.append("SET name = ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
		update.append(", organization_id = ").append(this.getOrganizationID());
		update.append(", description = ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 100)));
		update.append(", ext_item_id = ").append(conn.toSQLString(StringUtil.truncate(this.getExtItemID(), 30)));
		update.append(", item_type_id = ").append(this.getItemTypeID());
		update.append(", item_status_type_id = ").append(this.getItemStatusTypeID());
		update.append(", billable_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getBillableFlag(), 1)));
		update.append(", expense_export_code = ").append(conn.toSQLString(StringUtil.truncate(this.getExpenseExportCode(), 10)));
		update.append(", job_type_id = ").append(this.getJobTypeID());
		update.append(", cost_per_uom = ").append(getCostPerUOM());
		update.append(", percent_margin = ").append(getPercentMargin());
		update.append(", column_position = ").append(conn.toSQLString(this.getColumnPosition()));
		update.append(", allow_expense_entry = ").append(conn.toSQLString(getAllowExpenseEntry()));
		update.append(", item_category_type_id = ").append(getItemCategoryTypeID());
		update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
		update.append(", created_by = ").append(this.getCreatedBy());
		update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
		update.append(", modified_by = ").append(this.getModifiedBy());
		update.append("WHERE (item_id = ").append(this.getItemID()).append(")");

		conn.updateExactlyEx(update, 1);
	}


	protected void internalInsert(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Item.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			internalInsert(conn);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Item.internalInsert()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalInsert(ConnectionWrapper conn) throws SQLException
	{
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO items (");
				insert.append("name");
				insert.append(", organization_id");
				insert.append(", description");
				insert.append(", ext_item_id");
				insert.append(", item_type_id");
				insert.append(", item_status_type_id");
				insert.append(", billable_flag");
				insert.append(", expense_export_code");
				insert.append(", job_type_id");
				insert.append(", cost_per_uom");
				insert.append(", percent_margin");
				insert.append(", column_position");
				insert.append(", allow_expense_entry");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
				insert.append(", ").append(this.getOrganizationID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtItemID(), 30)));
				insert.append(", ").append(this.getItemTypeID());
				insert.append(", ").append(this.getItemStatusTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBillableFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExpenseExportCode(), 10)));
				insert.append(", ").append(this.getJobTypeID());
				insert.append(", ").append(getCostPerUOM());
				insert.append(", ").append(getPercentMargin());
				insert.append(", ").append(conn.toSQLString(this.getColumnPosition()));
				insert.append(", ").append(conn.toSQLString(getAllowExpenseEntry()));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO items (");
				insert.append("item_id");
				insert.append(", name");
				insert.append(", organization_id");
				insert.append(", description");
				insert.append(", ext_item_id");
				insert.append(", item_type_id");
				insert.append(", item_status_type_id");
				insert.append(", billable_flag");
				insert.append(", expense_export_code");
				insert.append(", job_type_id");
				insert.append(", cost_per_uom");
				insert.append(", percent_margin");
				insert.append(", column_position");
				insert.append(", allow_expense_entry");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getItemID());
				insert.append(", ").append(this.getOrganizationID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getDescription(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExtItemID(), 30)));
				insert.append(", ").append(this.getItemTypeID());
				insert.append(", ").append(this.getItemStatusTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getBillableFlag(), 1)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getExpenseExportCode(), 10)));
				insert.append(", ").append(this.getJobTypeID());
				insert.append(", ").append(getCostPerUOM());
				insert.append(", ").append(getPercentMargin());
				insert.append(", ").append(conn.toSQLString(this.getColumnPosition()));
				insert.append(", ").append(conn.toSQLString(getAllowExpenseEntry()));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				itemID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
	}

	protected void internalDelete(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Item.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			internalDelete(conn);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Item.internalDelete()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	protected void internalDelete(ConnectionWrapper conn) throws SQLException
	{
		StringBuffer delete = new StringBuffer();
		delete.append("DELETE FROM items ");
		delete.append("WHERE (item_id = ").append(this.getItemID()).append(")");

		conn.updateExactlyEx(delete, 1);
	}

	private boolean skipPrimaryKey()
	{
		boolean skipPrimaryKey = false;
		if (this.getItemID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}

	public void commit(ConnectionWrapper conn) throws SQLException
	{
		Diagnostics.trace("AbstractDatabaseObject.commit()");
		int status = this.getInternalStatus();
		switch (status)
		{
			case NEW_STATUS:
				this.internalInsert(conn);
				this.handleAction(COMMIT_ACTION);
				break;

			case DIRTY_STATUS:
				this.internalUpdate(conn);
				this.handleAction(COMMIT_ACTION);
				break;

			case DELETED_STATUS:
				this.internalDelete(conn);
				this.handleAction(COMMIT_ACTION);
				break;

			case CLEAN_STATUS:
			case INVALID_STATUS:
				//nothing to do
				break;

			default:
				Diagnostics.error("Error in AbstractDatabaseObject.commit(), internalStatus for object is " + status + ", object = "  + this);
		}
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Item:\n");
		result.append("  item_id = ").append(this.getItemID()).append("\n");
		result.append("  organization_id = ").append(this.getOrganizationID()).append("\n");
		result.append("  name = ").append(this.getName()).append("\n");
		result.append("  description = ").append(this.getDescription()).append("\n");
		result.append("  ext_item_id = ").append(this.getExtItemID()).append("\n");
		result.append("  item_type_id = ").append(this.getItemTypeID()).append("\n");
		result.append("  item_status_type_id = ").append(this.getItemStatusTypeID()).append("\n");
		result.append("  billable_flag = ").append(this.getBillableFlag()).append("\n");
		result.append("  expense_export_code = ").append(this.getExpenseExportCode()).append("\n");
		result.append("  job_type_id = ").append(this.getJobTypeID()).append("\n");
		result.append("  cost_per_uom = ").append(getCostPerUOM()).append("\n");
		result.append("  percent_margin = ").append(getPercentMargin()).append("\n");
		result.append("  column_position = ").append(this.getColumnPosition()).append("\n");
		result.append("  allow_expense_entry = ").append(getAllowExpenseEntry()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getItemID()
	{
		return itemID;
	}

	public int getOrganizationID()
	{
		return organizationID;
	}

	public String getName()
	{
		return name;
	}

	public String getDescription()
	{
		return description;
	}

	public String getExtItemID()
	{
		return extItemID;
	}

	public int getItemTypeID()
	{
		return itemTypeID;
	}

	public int getItemStatusTypeID()
	{
		return itemStatusTypeID;
	}

	public String getBillableFlag()
	{
		return billableFlag;
	}

	public String getExpenseExportCode()
	{
		return expenseExportCode;
	}
	
	public int getJobTypeID()
	{
		return jobTypeID;
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

	public void setItemID(int itemIDIn)
	{
		itemID = itemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOrganizationID(int orgIDIn)
	{
		organizationID = orgIDIn;
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

	public void setExtItemID(String extItemIDIn)
	{
		extItemID = extItemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setItemTypeID(int itemTypeIDIn)
	{
		itemTypeID = itemTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setItemStatusTypeID(int itemStatusTypeIDIn)
	{
		itemStatusTypeID = itemStatusTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setBillableFlag(String billableFlagIn)
	{
		billableFlag = billableFlagIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExpenseExportCode(String expenseExportCodeIn)
	{
		expenseExportCode = expenseExportCodeIn;
		handleAction(MODIFY_ACTION);
	}
	
	public void setJobTypeID(int jobTypeID)
	{
		this.jobTypeID = jobTypeID;
		handleAction(MODIFY_ACTION);
	}

	public void setDateCreated(Date dateCreatedIn)
	{
		dateCreated = dateCreatedIn;
		handleAction(MODIFY_ACTION);
	}

	public void setCreatedBy(String createdBy)
	{
		setCreatedBy(Integer.parseInt(createdBy));
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

	public void setModifiedBy(String modifiedBy)
	{
		setModifiedBy(Integer.parseInt(modifiedBy));
	}
	
	public void setModifiedBy(int modifiedByIn)
	{
		modifiedBy = modifiedByIn;
		handleAction(MODIFY_ACTION);
	}
	public String getColumnPosition()
	{
		return columnPosition;
	}
	public void setColumnPosition(String columnPosition)
	{
		this.columnPosition = columnPosition;
		handleAction(MODIFY_ACTION);
	}

	public Double getCostPerUOM()
	{
		return costPerUOM;
	}

	public void setCostPerUOM(Double costPerUOM)
	{
		this.costPerUOM = costPerUOM;
		handleAction(MODIFY_ACTION);
	}

	public Double getPercentMargin()
	{
		return percentMargin;
	}

	public void setPercentMargin(Double percentMargin)
	{
		this.percentMargin = percentMargin;
		handleAction(MODIFY_ACTION);
	}

	public boolean isAllowExpenseEntry()
	{
		return allowExpenseEntry;
	}

	public String getAllowExpenseEntry()
	{
		return isAllowExpenseEntry() ? "Y" : "N";
	}
	
	public void setAllowExpenseEntry(String allowExpenseEntry)
	{
		setAllowExpenseEntry(StringUtil.toBoolean(allowExpenseEntry));
	}

	public void setAllowExpenseEntry(boolean allowExpenseEntry)
	{
		this.allowExpenseEntry = allowExpenseEntry;
		handleAction(MODIFY_ACTION);
	}

	public Integer getItemCategoryTypeID()
	{
		return itemCategoryTypeID;
	}

	public void setItemCategoryTypeID(Integer itemCategoryTypeID)
	{
		this.itemCategoryTypeID = itemCategoryTypeID;
		handleAction(MODIFY_ACTION);
	}
}
