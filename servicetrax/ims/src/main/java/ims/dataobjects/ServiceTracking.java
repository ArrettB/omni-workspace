package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class ServiceTracking extends AbstractDatabaseObject
{

	private int serviceTrackingID;
	private int serviceID;
	private int trackingTypeID;
	private int notificationTypeID;
	private int toContactID;
	private int fromUserID;
	private String notes;
	private int newStatusID;
	private int oldStatusID;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public ServiceTracking()
	{
		super();
	}


	public static ServiceTracking fetch(String serviceTrackingID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(serviceTrackingID), ic, null);
	}

	public static ServiceTracking fetch(String serviceTrackingID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(serviceTrackingID), ic, resourceName);
	}

	public static ServiceTracking fetch(int serviceTrackingID, InvocationContext ic)
	{
		 return fetch(serviceTrackingID, ic, null);
	}

	public static ServiceTracking fetch(int serviceTrackingID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("ServiceTracking.fetch()");

		ServiceTracking result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT service_tracking_id ");
			query.append(", service_id ");
			query.append(", tracking_type_id ");
			query.append(", notification_type_id ");
			query.append(", to_contact_id ");
			query.append(", from_user_id ");
			query.append(", notes ");
			query.append(", new_status_id ");
			query.append(", old_status_id ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM service_tracking ");
			query.append("WHERE (service_tracking_id = ").append(serviceTrackingID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new ServiceTracking();
				result.setServiceTrackingID(rs.getInt(1));
				result.setServiceID(rs.getInt(2));
				result.setTrackingTypeID(rs.getInt(3));
				result.setNotificationTypeID(rs.getInt(4));
				result.setToContactID(rs.getInt(5));
				result.setFromUserID(rs.getInt(6));
				result.setNotes(rs.getString(7));
				result.setNewStatusID(rs.getInt(8));
				result.setOldStatusID(rs.getInt(9));
				result.setDateCreated(rs.getDate(10));
				result.setCreatedBy(rs.getInt(11));
				result.setDateModified(rs.getDate(12));
				result.setModifiedBy(rs.getInt(13));
			}
			else
			{
				Diagnostics.error("Error in ServiceTracking.fetch(), Could not find ServiceTracking; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceTracking.fetch()");
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
		Diagnostics.trace("ServiceTracking.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE service_tracking ");
			update.append("SET service_id = ").append(this.getServiceID());
			update.append(", tracking_type_id = ").append(this.getTrackingTypeID());
			update.append(", notification_type_id = ").append(this.getNotificationTypeID());
			update.append(", to_contact_id = ").append(this.getToContactID());
			update.append(", from_user_id = ").append(this.getFromUserID());
			update.append(", notes = ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 240)));
			update.append(", new_status_id = ").append(this.getNewStatusID());
			update.append(", old_status_id = ").append(this.getOldStatusID());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (service_tracking_id = ").append(this.getServiceTrackingID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceTracking.internalUpdate()");
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
		Diagnostics.trace("ServiceTracking.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO service_tracking (");
				insert.append("service_id");
				insert.append(", tracking_type_id");
				insert.append(", notification_type_id");
				insert.append(", to_contact_id");
				insert.append(", from_user_id");
				insert.append(", notes");
				insert.append(", new_status_id");
				insert.append(", old_status_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceID());
				insert.append(", ").append(this.getTrackingTypeID());
				insert.append(", ").append(this.getNotificationTypeID());
				insert.append(", ").append(this.getToContactID());
				insert.append(", ").append(this.getFromUserID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 240)));
				insert.append(", ").append(this.getNewStatusID());
				insert.append(", ").append(this.getOldStatusID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO service_tracking (");
				insert.append("service_tracking_id");
				insert.append(", service_id");
				insert.append(", tracking_type_id");
				insert.append(", notification_type_id");
				insert.append(", to_contact_id");
				insert.append(", from_user_id");
				insert.append(", notes");
				insert.append(", new_status_id");
				insert.append(", old_status_id");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getServiceTrackingID());
				insert.append(", ").append(this.getServiceID());
				insert.append(", ").append(this.getTrackingTypeID());
				insert.append(", ").append(this.getNotificationTypeID());
				insert.append(", ").append(this.getToContactID());
				insert.append(", ").append(this.getFromUserID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 240)));
				insert.append(", ").append(this.getNewStatusID());
				insert.append(", ").append(this.getOldStatusID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				serviceTrackingID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceTracking.internalInsert()");
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
		Diagnostics.trace("ServiceTracking.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM service_tracking ");
			delete.append("WHERE (service_tracking_id = ").append(this.getServiceTrackingID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in ServiceTracking.internalDelete()");
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
		if (this.getServiceTrackingID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("ServiceTracking:\n");
		result.append("  service_tracking_id = ").append(this.getServiceTrackingID()).append("\n");
		result.append("  service_id = ").append(this.getServiceID()).append("\n");
		result.append("  tracking_type_id = ").append(this.getTrackingTypeID()).append("\n");
		result.append("  notification_type_id = ").append(this.getNotificationTypeID()).append("\n");
		result.append("  to_contact_id = ").append(this.getToContactID()).append("\n");
		result.append("  from_user_id = ").append(this.getFromUserID()).append("\n");
		result.append("  notes = ").append(this.getNotes()).append("\n");
		result.append("  new_status_id = ").append(this.getNewStatusID()).append("\n");
		result.append("  old_status_id = ").append(this.getOldStatusID()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getServiceTrackingID()
	{
		return serviceTrackingID;
	}

	public int getServiceID()
	{
		return serviceID;
	}

	public int getTrackingTypeID()
	{
		return trackingTypeID;
	}

	public int getNotificationTypeID()
	{
		return notificationTypeID;
	}

	public int getToContactID()
	{
		return toContactID;
	}

	public int getFromUserID()
	{
		return fromUserID;
	}

	public String getNotes()
	{
		return notes;
	}

	public int getNewStatusID()
	{
		return newStatusID;
	}

	public int getOldStatusID()
	{
		return oldStatusID;
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

	public void setServiceTrackingID(int serviceTrackingIDIn)
	{
		serviceTrackingID = serviceTrackingIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setServiceID(int serviceIDIn)
	{
		serviceID = serviceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setTrackingTypeID(int trackingTypeIDIn)
	{
		trackingTypeID = trackingTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setNotificationTypeID(int notificationTypeIDIn)
	{
		notificationTypeID = notificationTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setToContactID(int toContactIDIn)
	{
		toContactID = toContactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setFromUserID(int fromUserIDIn)
	{
		fromUserID = fromUserIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setNotes(String notesIn)
	{
		notes = notesIn;
		handleAction(MODIFY_ACTION);
	}

	public void setNewStatusID(int newStatusIDIn)
	{
		newStatusID = newStatusIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setOldStatusID(int oldStatusIDIn)
	{
		oldStatusID = oldStatusIDIn;
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
