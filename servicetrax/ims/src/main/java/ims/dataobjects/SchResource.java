package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class SchResource extends AbstractDatabaseObject
{

	private int schResourceID;
	private int jobID;
	private int serviceID;
	private int resourceID;
	private int primaryResourceFlag;
	private Date scheduleDate;
	private int estHours;
	private String notes;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public SchResource()
	{
		super();
	}


	public static SchResource fetch(String schResourceID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(schResourceID), ic, null);
	}

	public static SchResource fetch(String schResourceID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(schResourceID), ic, resourceName);
	}

	public static SchResource fetch(int schResourceID, InvocationContext ic)
	{
		 return fetch(schResourceID, ic, null);
	}

	public static SchResource fetch(int schResourceID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("SchResource.fetch()");

		SchResource result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT sch_resource_id ");
			query.append(", job_id ");
			query.append(", service_id ");
			query.append(", resource_id ");
			query.append(", primary_resource_flag ");
			query.append(", schedule_date ");
			query.append(", est_hours ");
			query.append(", notes ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM sch_resources ");
			query.append("WHERE (sch_resource_id = ").append(schResourceID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new SchResource();
				result.setSchResourceID(rs.getInt(1));
				result.setJobID(rs.getInt(2));
				result.setServiceID(rs.getInt(3));
				result.setResourceID(rs.getInt(4));
				result.setPrimaryResourceFlag(rs.getInt(5));
				result.setScheduleDate(rs.getDate(6));
				result.setEstHours(rs.getInt(7));
				result.setNotes(rs.getString(8));
				result.setDateCreated(rs.getDate(9));
				result.setCreatedBy(rs.getInt(10));
				result.setDateModified(rs.getDate(11));
				result.setModifiedBy(rs.getInt(12));
			}
			else
			{
				Diagnostics.error("Error in SchResource.fetch(), Could not find SchResource; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in SchResource.fetch()");
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
		Diagnostics.trace("SchResource.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE sch_resources ");
			update.append("SET job_id = ").append(this.getJobID());
			update.append(", service_id = ").append(this.getServiceID());
			update.append(", resource_id = ").append(this.getResourceID());
			update.append(", primary_resource_flag = ").append(this.getPrimaryResourceFlag());
			update.append(", schedule_date = ").append(conn.toSQLString(this.getScheduleDate()));
			update.append(", est_hours = ").append(this.getEstHours());
			update.append(", notes = ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 200)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (sch_resource_id = ").append(this.getSchResourceID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in SchResource.internalUpdate()");
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
		Diagnostics.trace("SchResource.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO sch_resources (");
				insert.append("job_id");
				insert.append(", service_id");
				insert.append(", resource_id");
				insert.append(", primary_resource_flag");
				insert.append(", schedule_date");
				insert.append(", est_hours");
				insert.append(", notes");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getJobID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(this.getPrimaryResourceFlag());
				insert.append(", ").append(conn.toSQLString(this.getScheduleDate()));
				insert.append(", ").append(this.getEstHours());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 200)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO sch_resources (");
				insert.append("sch_resource_id");
				insert.append(", job_id");
				insert.append(", service_id");
				insert.append(", resource_id");
				insert.append(", primary_resource_flag");
				insert.append(", schedule_date");
				insert.append(", est_hours");
				insert.append(", notes");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getSchResourceID());
				insert.append(", ").append(this.getJobID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getResourceID());
				insert.append(", ").append(this.getPrimaryResourceFlag());
				insert.append(", ").append(conn.toSQLString(this.getScheduleDate()));
				insert.append(", ").append(this.getEstHours());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 200)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				schResourceID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in SchResource.internalInsert()");
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
		Diagnostics.trace("SchResource.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM sch_resources ");
			delete.append("WHERE (sch_resource_id = ").append(this.getSchResourceID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in SchResource.internalDelete()");
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
		if (this.getSchResourceID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("SchResource:\n");
		result.append("  sch_resource_id = ").append(this.getSchResourceID()).append("\n");
		result.append("  job_id = ").append(this.getJobID()).append("\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  resource_id = ").append(this.getResourceID()).append("\n");
		result.append("  primary_resource_flag = ").append(this.getPrimaryResourceFlag()).append("\n");
		result.append("  schedule_date = ").append(this.getScheduleDate()).append("\n");
		result.append("  est_hours = ").append(this.getEstHours()).append("\n");
		result.append("  notes = ").append(this.getNotes()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getSchResourceID()
	{
		return schResourceID;
	}

	public int getJobID()
	{
		return jobID;
	}

	public int getServiceID()
	{
		return serviceID;
	}

	public int getResourceID()
	{
		return resourceID;
	}

	public int getPrimaryResourceFlag()
	{
		return primaryResourceFlag;
	}

	public Date getScheduleDate()
	{
		return scheduleDate;
	}

	public int getEstHours()
	{
		return estHours;
	}

	public String getNotes()
	{
		return notes;
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

	public void setSchResourceID(int schResourceIDIn)
	{
		schResourceID = schResourceIDIn;
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

	public void setResourceID(int resourceIDIn)
	{
		resourceID = resourceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPrimaryResourceFlag(int primaryResourceFlagIn)
	{
		primaryResourceFlag = primaryResourceFlagIn;
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

	public void setNotes(String notesIn)
	{
		notes = notesIn;
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
