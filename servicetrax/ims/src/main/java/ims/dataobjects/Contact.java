package ims.dataobjects;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class Contact extends AbstractDatabaseObject implements Serializable
{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4736838798939258451L;
	private int contactID;
	private int contactTypeID;
	private int contStatusTypeID;
	private String contactName;
	private String phoneWork;
	private String phoneCell;
	private String phoneHome;
	private String email;
	private String notes;
	private Date dateCreated;
	private int createdBy;
	private Date dateModified;
	private int modifiedBy;

	public Contact()
	{
		super();
	}


	public static Contact fetch(String contactID, ConnectionWrapper conn)
	{
		Diagnostics.trace("Contact.fetch()");

		Contact result = null;
		QueryResults rs = null;
		try
		{
			StringBuffer query = new StringBuffer();
			query.append("SELECT contact_id ");
			query.append(", contact_type_id ");
			query.append(", cont_status_type_id ");
			query.append(", contact_name ");
			query.append(", phone_work ");
			query.append(", phone_cell ");
			query.append(", phone_home ");
			query.append(", email ");
			query.append(", notes ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM contacts ");
			query.append("WHERE (contact_id = ").append(contactID).append(") ");

			rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
				result = new Contact();
				result.setContactID(rs.getInt(1));
				result.setContactTypeID(rs.getInt(2));
				result.setContStatusTypeID(rs.getInt(3));
				result.setContactName(rs.getString(4));
				result.setPhoneWork(rs.getString(5));
				result.setPhoneCell(rs.getString(6));
				result.setPhoneHome(rs.getString(7));
				result.setEmail(rs.getString(8));
				result.setNotes(rs.getString(9));
				result.setDateCreated(rs.getDate(10));
				result.setCreatedBy(rs.getInt(11));
				result.setDateModified(rs.getDate(12));
				result.setModifiedBy(rs.getInt(13));
			}
			else
			{
				Diagnostics.error("Error in Contact.fetch(), Could not find Contact; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			Diagnostics.error("Error in Contact.fetch()", e);
		}
		finally
		{
			if (rs != null)
			{
				try
				{
					rs.close();
				}
				catch (SQLException ignore){}
			}
		}

		 if (result != null) result.handleAction(FETCH_ACTION);
		return result;
	}

	protected void internalUpdate(InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("Contact.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE contacts ");
			update.append("SET contact_type_id = ").append(this.getContactTypeID());
			update.append(", cont_status_type_id = ").append(this.getContStatusTypeID());
			update.append(", contact_name = ").append(conn.toSQLString(StringUtil.truncate(this.getContactName(), 100)));
			update.append(", phone_work = ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneWork(), 50)));
			update.append(", phone_cell = ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneCell(), 50)));
			update.append(", phone_home = ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneHome(), 50)));
			update.append(", email = ").append(conn.toSQLString(StringUtil.truncate(this.getEmail(), 100)));
			update.append(", notes = ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 500)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (contact_id = ").append(this.getContactID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Contact.internalUpdate()");
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
		Diagnostics.trace("Contact.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO contacts (");
				insert.append("contact_type_id");
				insert.append(", cont_status_type_id");
				insert.append(", contact_name");
				insert.append(", phone_work");
				insert.append(", phone_cell");
				insert.append(", phone_home");
				insert.append(", email");
				insert.append(", notes");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getContactTypeID());
				insert.append(", ").append(this.getContStatusTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getContactName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneWork(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneCell(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneHome(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEmail(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 500)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO contacts (");
				insert.append("contact_id");
				insert.append(", contact_type_id");
				insert.append(", cont_status_type_id");
				insert.append(", contact_name");
				insert.append(", phone_work");
				insert.append(", phone_cell");
				insert.append(", phone_home");
				insert.append(", email");
				insert.append(", notes");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getContactID());
				insert.append(", ").append(this.getContactTypeID());
				insert.append(", ").append(this.getContStatusTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getContactName(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneWork(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneCell(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPhoneHome(), 50)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getEmail(), 100)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getNotes(), 500)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				contactID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Contact.internalInsert()");
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
		Diagnostics.trace("Contact.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM contacts ");
			delete.append("WHERE (contact_id = ").append(this.getContactID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in Contact.internalDelete()");
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
		if (this.getContactID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("Contact:\n");
		result.append("  contact_id = ").append(this.getContactID()).append("\n");
		result.append("  contact_type_id = ").append(this.getContactTypeID()).append("\n");
		result.append("  cont_status_type_id = ").append(this.getContStatusTypeID()).append("\n");
		result.append("  contact_name = ").append(this.getContactName()).append("\n");
		result.append("  phone_work = ").append(this.getPhoneWork()).append("\n");
		result.append("  phone_cell = ").append(this.getPhoneCell()).append("\n");
		result.append("  phone_home = ").append(this.getPhoneHome()).append("\n");
		result.append("  email = ").append(this.getEmail()).append("\n");
		result.append("  notes = ").append(this.getNotes()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getContactID()
	{
		return contactID;
	}

	public int getContactTypeID()
	{
		return contactTypeID;
	}

	public int getContStatusTypeID()
	{
		return contStatusTypeID;
	}

	public String getContactName()
	{
		return contactName;
	}

	public String getPhoneWork()
	{
		return phoneWork;
	}

	public String getPhoneCell()
	{
		return phoneCell;
	}

	public String getPhoneHome()
	{
		return phoneHome;
	}

	public String getEmail()
	{
		return email;
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

	public void setContactID(int contactIDIn)
	{
		contactID = contactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setContactTypeID(int contactTypeIDIn)
	{
		contactTypeID = contactTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setContStatusTypeID(int contStatusTypeIDIn)
	{
		contStatusTypeID = contStatusTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setContactName(String contactNameIn)
	{
		contactName = contactNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPhoneWork(String phoneWorkIn)
	{
		phoneWork = phoneWorkIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPhoneCell(String phoneCellIn)
	{
		phoneCell = phoneCellIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPhoneHome(String phoneHomeIn)
	{
		phoneHome = phoneHomeIn;
		handleAction(MODIFY_ACTION);
	}

	public void setEmail(String emailIn)
	{
		email = emailIn;
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
