package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class ScheduledResource extends AbstractDatabaseObject
{

	private int schedResID;
	private int serviceID;
	private int supResourceID;
	private int resourceItemID;
	private Date scheduleDate;
	private int estHours;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ScheduledResource()
	{
		super();
	}


	public static ScheduledResource fetch(String schedResID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(schedResID), ic, null);
	}

	public static ScheduledResource fetch(String schedResID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(schedResID), ic, resourceName);
	}

	public static ScheduledResource fetch(int schedResID, InvocationContext ic)
	{
		 return fetch(schedResID, ic, null);
	}

	public static ScheduledResource fetch(int schedResID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ScheduledResource.fetch()");

		ScheduledResource result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT sched_res_id ");
			query.append(", service_id ");
			query.append(", sup_resource_id ");
			query.append(", resource_item_id ");
			query.append(", schedule_date ");
			query.append(", est_hours ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM scheduled_resources ");
			query.append("WHERE (sched_res_id = ").append(schedResID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ScheduledResource();
				result.setSchedResID(rs.getInt(1));
				result.setServiceID(rs.getInt(2));
				result.setSupResourceID(rs.getInt(3));
				result.setResourceItemID(rs.getInt(4));
				result.setScheduleDate(rs.getDate(5));
				result.setEstHours(rs.getInt(6));
				result.setDateCreated(rs.getDate(7));
				result.setCreatedBy(rs.getInt(8));
				result.setDateModified(rs.getDate(9));
				result.setModifiedBy(rs.getInt(10));
			}
			else
			{
				Diagnostics.error("Error in ScheduledResource.fetch(), Could not find ScheduledResource; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ScheduledResource.fetch()");
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
		Diagnostics.trace("ScheduledResource.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE scheduled_resources ");
			update.append("SET service_id = ").append(this.getServiceID());
			update.append(", sup_resource_id = ").append(this.getSupResourceID());
			update.append(", resource_item_id = ").append(this.getResourceItemID());
			update.append(", schedule_date = ").append(conn.toSQLString(this.getScheduleDate()));
			update.append(", est_hours = ").append(this.getEstHours());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (sched_res_id = ").append(this.getSchedResID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ScheduledResource.internalUpdate()");
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
		Diagnostics.trace("ScheduledResource.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO scheduled_resources (");
				insert.append("service_id");
				insert.append(", sup_resource_id");
				insert.append(", resource_item_id");
				insert.append(", schedule_date");
				insert.append(", est_hours");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceID());
				insert.append(", ").append(this.getSupResourceID());
				insert.append(", ").append(this.getResourceItemID());
				insert.append(", ").append(conn.toSQLString(this.getScheduleDate()));
				insert.append(", ").append(this.getEstHours());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO scheduled_resources (");
				insert.append("sched_res_id");
				insert.append(", service_id");
				insert.append(", sup_resource_id");
				insert.append(", resource_item_id");
				insert.append(", schedule_date");
				insert.append(", est_hours");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getSchedResID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getSupResourceID());
				insert.append(", ").append(this.getResourceItemID());
				insert.append(", ").append(conn.toSQLString(this.getScheduleDate()));
				insert.append(", ").append(this.getEstHours());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				schedResID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ScheduledResource.internalInsert()");
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
		Diagnostics.trace("ScheduledResource.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM scheduled_resources ");
			delete.append("WHERE (sched_res_id = ").append(this.getSchedResID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ScheduledResource.internalDelete()");
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
		if (this.getSchedResID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ScheduledResource:\n");
		result.append("  sched_res_id = ").append(this.getSchedResID()).append("\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  sup_resource_id = ").append(this.getSupResourceID()).append("\n");
		result.append("  resource_item_id = ").append(this.getResourceItemID()).append("\n");
		result.append("  schedule_date = ").append(this.getScheduleDate()).append("\n");
		result.append("  est_hours = ").append(this.getEstHours()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getSchedResID()
	{
		return schedResID;
	}

	public int getServiceID()
	{
		return serviceID;
	}

	public int getSupResourceID()
	{
		return supResourceID;
	}

	public int getResourceItemID()
	{
		return resourceItemID;
	}

	public Date getScheduleDate()
	{
		return scheduleDate;
	}

	public int getEstHours()
	{
		return estHours;
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

	public void setSchedResID(int schedResIDIn)
	{
		schedResID = schedResIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setSupResourceID(int supResourceIDIn)
	{
		supResourceID = supResourceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setResourceItemID(int resourceItemIDIn)
	{
		resourceItemID = resourceItemIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setScheduleDate(Date scheduleDateIn)
	{
		scheduleDate = scheduleDateIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEstHours(int estHoursIn)
	{
		estHours = estHoursIn;
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
