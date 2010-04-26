package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class ResourceEstimate extends AbstractDatabaseObject
{

	private int resourceEstID;
	private int jobID;
	private int serviceID;
	private int resourceTypeID;
	private int jobItemRateID;
	private int unitQty;
	private int timeUomTypeID;
	private int timeQty;
	private Date startDate;
	private int totalHours;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ResourceEstimate()
	{
		super();
	}


	public static ResourceEstimate fetch(String resourceEstID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(resourceEstID), ic, null);
	}

	public static ResourceEstimate fetch(String resourceEstID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(resourceEstID), ic, resourceName);
	}

	public static ResourceEstimate fetch(int resourceEstID, InvocationContext ic)
	{
		 return fetch(resourceEstID, ic, null);
	}

	public static ResourceEstimate fetch(int resourceEstID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ResourceEstimate.fetch()");

		ResourceEstimate result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT resource_est_id ");
			query.append(", job_id ");
			query.append(", service_id ");
			query.append(", resource_type_id ");
			query.append(", job_item_rate_id ");
			query.append(", unit_qty ");
			query.append(", time_uom_type_id ");
			query.append(", time_qty ");
			query.append(", start_date ");
			query.append(", total_hours ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM resource_estimates ");
			query.append("WHERE (resource_est_id = ").append(resourceEstID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ResourceEstimate();
				result.setResourceEstID(rs.getInt(1));
				result.setJobID(rs.getInt(2));
				result.setServiceID(rs.getInt(3));
				result.setResourceTypeID(rs.getInt(4));
				result.setJobItemRateID(rs.getInt(5));
				result.setUnitQty(rs.getInt(6));
				result.setTimeUomTypeID(rs.getInt(7));
				result.setTimeQty(rs.getInt(8));
				result.setStartDate(rs.getDate(9));
				result.setTotalHours(rs.getInt(10));
				result.setDateCreated(rs.getDate(11));
				result.setCreatedBy(rs.getInt(12));
				result.setDateModified(rs.getDate(13));
				result.setModifiedBy(rs.getInt(14));
			}
			else
			{
				Diagnostics.error("Error in ResourceEstimate.fetch(), Could not find ResourceEstimate; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceEstimate.fetch()");
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
		Diagnostics.trace("ResourceEstimate.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE resource_estimates ");
			update.append("SET job_id = ").append(this.getJobID());
			update.append(", service_id = ").append(this.getServiceID());
			update.append(", resource_type_id = ").append(this.getResourceTypeID());
			update.append(", job_item_rate_id = ").append(this.getJobItemRateID());
			update.append(", unit_qty = ").append(this.getUnitQty());
			update.append(", time_uom_type_id = ").append(this.getTimeUomTypeID());
			update.append(", time_qty = ").append(this.getTimeQty());
			update.append(", start_date = ").append(conn.toSQLString(this.getStartDate()));
			update.append(", total_hours = ").append(this.getTotalHours());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (resource_est_id = ").append(this.getResourceEstID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceEstimate.internalUpdate()");
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
		Diagnostics.trace("ResourceEstimate.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO resource_estimates (");
				insert.append("job_id");
				insert.append(", service_id");
				insert.append(", resource_type_id");
				insert.append(", job_item_rate_id");
				insert.append(", unit_qty");
				insert.append(", time_uom_type_id");
				insert.append(", time_qty");
				insert.append(", start_date");
				insert.append(", total_hours");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getJobID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getResourceTypeID());
				insert.append(", ").append(this.getJobItemRateID());
				insert.append(", ").append(this.getUnitQty());
				insert.append(", ").append(this.getTimeUomTypeID());
				insert.append(", ").append(this.getTimeQty());
				insert.append(", ").append(conn.toSQLString(this.getStartDate()));
				insert.append(", ").append(this.getTotalHours());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO resource_estimates (");
				insert.append("resource_est_id");
				insert.append(", job_id");
				insert.append(", service_id");
				insert.append(", resource_type_id");
				insert.append(", job_item_rate_id");
				insert.append(", unit_qty");
				insert.append(", time_uom_type_id");
				insert.append(", time_qty");
				insert.append(", start_date");
				insert.append(", total_hours");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getResourceEstID());
				insert.append(", ").append(this.getJobID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getResourceTypeID());
				insert.append(", ").append(this.getJobItemRateID());
				insert.append(", ").append(this.getUnitQty());
				insert.append(", ").append(this.getTimeUomTypeID());
				insert.append(", ").append(this.getTimeQty());
				insert.append(", ").append(conn.toSQLString(this.getStartDate()));
				insert.append(", ").append(this.getTotalHours());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				resourceEstID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceEstimate.internalInsert()");
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
		Diagnostics.trace("ResourceEstimate.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM resource_estimates ");
			delete.append("WHERE (resource_est_id = ").append(this.getResourceEstID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ResourceEstimate.internalDelete()");
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
		if (this.getResourceEstID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ResourceEstimate:\n");
		result.append("  resource_est_id = ").append(this.getResourceEstID()).append("\n");
		result.append("  job_id = ").append(this.getJobID()).append("\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  resource_type_id = ").append(this.getResourceTypeID()).append("\n");
		result.append("  job_item_rate_id = ").append(this.getJobItemRateID()).append("\n");
		result.append("  unit_qty = ").append(this.getUnitQty()).append("\n");
		result.append("  time_uom_type_id = ").append(this.getTimeUomTypeID()).append("\n");
		result.append("  time_qty = ").append(this.getTimeQty()).append("\n");
		result.append("  start_date = ").append(this.getStartDate()).append("\n");
		result.append("  total_hours = ").append(this.getTotalHours()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getResourceEstID()
	{
		return resourceEstID;
	}

	public int getJobID()
	{
		return jobID;
	}

	public int getServiceID()
	{
		return serviceID;
	}

	public int getResourceTypeID()
	{
		return resourceTypeID;
	}

	public int getJobItemRateID()
	{
		return jobItemRateID;
	}

	public int getUnitQty()
	{
		return unitQty;
	}

	public int getTimeUomTypeID()
	{
		return timeUomTypeID;
	}

	public int getTimeQty()
	{
		return timeQty;
	}

	public Date getStartDate()
	{
		return startDate;
	}

	public int getTotalHours()
	{
		return totalHours;
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

	public void setResourceEstID(int resourceEstIDIn)
	{
		resourceEstID = resourceEstIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobID(int jobIDIn)
	{
		jobID = jobIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceTypeID(int resourceTypeIDIn)
	{
		resourceTypeID = resourceTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setJobItemRateID(int jobItemRateIDIn)
	{
		jobItemRateID = jobItemRateIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUnitQty(int unitQtyIn)
	{
		unitQty = unitQtyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTimeUomTypeID(int timeUomTypeIDIn)
	{
		timeUomTypeID = timeUomTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTimeQty(int timeQtyIn)
	{
		timeQty = timeQtyIn;
		handleAction(MODIFY_ACTION);
	}

	public void setStartDate(Date startDateIn)
	{
		startDate = startDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTotalHours(int totalHoursIn)
	{
		totalHours = totalHoursIn;
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
