package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class InvoiceTracking extends AbstractDatabaseObject
{

	private int invoiceTrackingID;
	private int invoiceID;
	private int invoiceTrackingTypeID;
	private int alertTypeID;
	private int toContactID;
	private int fromUserID;
	private String notes;
	private int newStatusID;
	private int oldStatusID;
	private int createdBy;
	private Date dateCreated;
	private int modifiedBy;
	private Date dateModified;

	public InvoiceTracking()
	{
		super();
	}


	public static InvoiceTracking fetch(String invoiceTrackingID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(invoiceTrackingID), ic, null);
	}

	public static InvoiceTracking fetch(String invoiceTrackingID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(invoiceTrackingID), ic, resourceName);
	}

	public static InvoiceTracking fetch(int invoiceTrackingID, InvocationContext ic)
	{
		 return fetch(invoiceTrackingID, ic, null);
	}

	public static InvoiceTracking fetch(int invoiceTrackingID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("InvoiceTracking.fetch()");

		InvoiceTracking result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT invoice_tracking_id ");
			query.append(", invoice_id ");
			query.append(", invoice_tracking_type_id ");
			query.append(", alert_type_id ");
			query.append(", to_contact_id ");
			query.append(", from_user_id ");
			query.append(", notes ");
			query.append(", new_status_id ");
			query.append(", old_status_id ");
			query.append(", created_by ");
			query.append(", date_created ");
			query.append(", modified_by ");
			query.append(", date_modified ");
			query.append("FROM invoice_tracking ");
			query.append("WHERE (invoice_tracking_id = ").append(invoiceTrackingID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new InvoiceTracking();
				result.setInvoiceTrackingID(rs.getInt(1));
				result.setInvoiceID(rs.getInt(2));
				result.setInvoiceTrackingTypeID(rs.getInt(3));
				result.setAlertTypeID(rs.getInt(4));
				result.setToContactID(rs.getInt(5));
				result.setFromUserID(rs.getInt(6));
				result.setNotes(rs.getString(7));
				result.setNewStatusID(rs.getInt(8));
				result.setOldStatusID(rs.getInt(9));
				result.setCreatedBy(rs.getInt(10));
				result.setDateCreated(rs.getDate(11));
				result.setModifiedBy(rs.getInt(12));
				result.setDateModified(rs.getDate(13));
			}
			else
			{
				Diagnostics.error("Error in InvoiceTracking.fetch(), Could not find InvoiceTracking; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceTracking.fetch()");
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
		Diagnostics.trace("InvoiceTracking.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE invoice_tracking ");
			update.append("SET invoice_id = ").append(this.getInvoiceID());
			update.append(", invoice_tracking_type_id = ").append(this.getInvoiceTrackingTypeID());
			update.append(", alert_type_id = ").append(this.getAlertTypeID());
			update.append(", to_contact_id = ").append(this.getToContactID());
			update.append(", from_user_id = ").append(this.getFromUserID());
			update.append(", notes = ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 240)));
			update.append(", new_status_id = ").append(this.getNewStatusID());
			update.append(", old_status_id = ").append(this.getOldStatusID());
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append("WHERE (invoice_tracking_id = ").append(this.getInvoiceTrackingID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceTracking.internalUpdate()");
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
		Diagnostics.trace("InvoiceTracking.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO invoice_tracking (");
				insert.append("invoice_id");
				insert.append(", invoice_tracking_type_id");
				insert.append(", alert_type_id");
				insert.append(", to_contact_id");
				insert.append(", from_user_id");
				insert.append(", notes");
				insert.append(", new_status_id");
				insert.append(", old_status_id");
				insert.append(", created_by");
				insert.append(", date_created");
				insert.append(", modified_by");
				insert.append(", date_modified");
				insert.append(") VALUES (");
				insert.append(this.getInvoiceID());
				insert.append(", ").append(this.getInvoiceTrackingTypeID());
				insert.append(", ").append(this.getAlertTypeID());
				insert.append(", ").append(this.getToContactID());
				insert.append(", ").append(this.getFromUserID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 240)));
				insert.append(", ").append(this.getNewStatusID());
				insert.append(", ").append(this.getOldStatusID());
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO invoice_tracking (");
				insert.append("invoice_tracking_id");
				insert.append(", invoice_id");
				insert.append(", invoice_tracking_type_id");
				insert.append(", alert_type_id");
				insert.append(", to_contact_id");
				insert.append(", from_user_id");
				insert.append(", notes");
				insert.append(", new_status_id");
				insert.append(", old_status_id");
				insert.append(", created_by");
				insert.append(", date_created");
				insert.append(", modified_by");
				insert.append(", date_modified");
				insert.append(") VALUES (");
				insert.append(this.getInvoiceTrackingID());
				insert.append(", ").append(this.getInvoiceID());
				insert.append(", ").append(this.getInvoiceTrackingTypeID());
				insert.append(", ").append(this.getAlertTypeID());
				insert.append(", ").append(this.getToContactID());
				insert.append(", ").append(this.getFromUserID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 240)));
				insert.append(", ").append(this.getNewStatusID());
				insert.append(", ").append(this.getOldStatusID());
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				invoiceTrackingID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceTracking.internalInsert()");
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
		Diagnostics.trace("InvoiceTracking.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM invoice_tracking ");
			delete.append("WHERE (invoice_tracking_id = ").append(this.getInvoiceTrackingID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in InvoiceTracking.internalDelete()");
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
		if (this.getInvoiceTrackingID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("InvoiceTracking:\n");
		result.append("  invoice_tracking_id = ").append(this.getInvoiceTrackingID()).append("\n");
		result.append("  invoice_id = ").append(this.getInvoiceID()).append("\n");
		result.append("  invoice_tracking_type_id = ").append(this.getInvoiceTrackingTypeID()).append("\n");
		result.append("  alert_type_id = ").append(this.getAlertTypeID()).append("\n");
		result.append("  to_contact_id = ").append(this.getToContactID()).append("\n");
		result.append("  from_user_id = ").append(this.getFromUserID()).append("\n");
		result.append("  notes = ").append(this.getNotes()).append("\n");
		result.append("  new_status_id = ").append(this.getNewStatusID()).append("\n");
		result.append("  old_status_id = ").append(this.getOldStatusID()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		return result.toString();
	}


	public int getInvoiceTrackingID()
	{
		return invoiceTrackingID;
	}

	public int getInvoiceID()
	{
		return invoiceID;
	}

	public int getInvoiceTrackingTypeID()
	{
		return invoiceTrackingTypeID;
	}

	public int getAlertTypeID()
	{
		return alertTypeID;
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

	public void setInvoiceTrackingID(int invoiceTrackingIDIn)
	{
		invoiceTrackingID = invoiceTrackingIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setInvoiceID(int invoiceIDIn)
	{
		invoiceID = invoiceIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setInvoiceTrackingTypeID(int invoiceTrackingTypeIDIn)
	{
		invoiceTrackingTypeID = invoiceTrackingTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setAlertTypeID(int alertTypeIDIn)
	{
		alertTypeID = alertTypeIDIn;
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
