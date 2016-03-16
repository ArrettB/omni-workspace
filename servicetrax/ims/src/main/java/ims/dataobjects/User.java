package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 
 * @version $Header: User.java, 30, 9/19/2006 11:22:16 AM, Greg Case$
 */
public class User extends AbstractDatabaseObject implements Serializable
{

	// TODO - create the array of password salts and the hashing method
	//String[] passwordSalts = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

    // TODO - get the salt based on the userID
//	public String getSalt( ) {
//		int modUserId = userID % 10;
//
//		return passwordSalts[modUserId];
//	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 4580411370265837975L;
	public int userID;
	public String extEmployeeID;
	public int contactID;
	public int userTypeID;
	public String pin;
	public String firstName;
	public Date lastLogin;
	public String lastName;
	public String login;
	public String password;
	public String activeFlag;
	public Date dateCreated;
	public int createdBy;
	public Date dateModified;
	public int modifiedBy;
	public String userTypeCode;
	public String userTypeName;
	public String extDealerID;
	public String vendorContactID;

	//custom member objects
	private List<String> roleIDs;
	private Map rights;


	public User()
	{
		super();
	}

	public void fetchRoles(ConnectionWrapper conn) throws SQLException
	{
		roleIDs = new ArrayList<String>();
		String query = "SELECT role_id id FROM user_roles WHERE user_id = " + conn.toSQLString(""+userID);
		QueryResults rs = conn.resultsQueryEx(query);
		while (rs.next())
			roleIDs.add(rs.getString("id"));
		rs.close();
	}

	public void fetchType(ConnectionWrapper conn) throws SQLException
	{
		String query = "SELECT user_type_code, user_type_name, ext_dealer_id, vendor_contact_id FROM users_v WHERE user_id = " + conn.toSQLString(""+userID);
		QueryResults rs = conn.resultsQueryEx(query);
		if (rs.next())
		{
			userTypeCode = rs.getString("user_type_code");
			userTypeName = rs.getString("user_type_name");
			extDealerID = rs.getString("ext_dealer_id");
			vendorContactID = rs.getString("vendor_contact_id");
		}
		rs.close();
	}

	public void fetchRights(ConnectionWrapper conn) throws SQLException
	{
		rights = Function.fetchByUser(conn, ""+userID);
	}

	public static User fetch(String userID, ConnectionWrapper conn)
	{
		Diagnostics.trace("User.fetch()");

		User result = null;
		QueryResults rs = null;
		try
		{
			StringBuffer query = new StringBuffer();
			query.append("SELECT user_id ");
			query.append(", ext_employee_id ");
			query.append(", contact_id ");
			query.append(", user_type_id ");
			query.append(", pin ");
			query.append(", first_name ");
			query.append(", last_login ");
			query.append(", last_name ");
			query.append(", login ");
			query.append(", password ");
			query.append(", active_flag ");
			query.append(", date_created ");
			query.append(", created_by ");
			query.append(", date_modified ");
			query.append(", modified_by ");
			query.append("FROM users ");
			query.append("WHERE user_id = ?");

			rs = conn.select(query, userID);
			if (rs.next())
			{
				result = new User();
				result.setUserID(rs.getInt(1));
				result.setExtEmployeeID(rs.getString(2));
				result.setContactID(rs.getInt(3));
				result.setUserTypeID(rs.getInt(4));
				result.setPin(rs.getString(5));
				result.setFirstName(rs.getString(6));
				result.setLastLogin(rs.getDate(7));
				result.setLastName(rs.getString(8));
				result.setLogin(rs.getString(9));
				result.setPassword(null); //don't set the password for security password
				result.setActiveFlag(rs.getString(11));
				result.setDateCreated(rs.getDate(12));
				result.setCreatedBy(rs.getInt(13));
				result.setDateModified(rs.getDate(14));
				result.setModifiedBy(rs.getInt(15));
				result.fetchType(conn);
			}
			else
			{
				Diagnostics.error("Error in User.fetch(), Could not find User; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			Diagnostics.error("Error in User.fetch()", e);
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
		Diagnostics.trace("User.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE users ");
			update.append("SET ext_employee_id = ").append(this.getExtEmployeeID());
			update.append(", contact_id = ").append(this.getContactID());
			update.append(", user_type_id = ").append(this.getUserTypeID());
			update.append(", pin = ").append(conn.toSQLString(StringUtil.truncate(this.getPin(), 200)));
			update.append(", first_name = ").append(conn.toSQLString(StringUtil.truncate(this.getFirstName(), 200)));
			update.append(", last_login = ").append(conn.toSQLString(this.getLastLogin()));
			update.append(", last_name = ").append(conn.toSQLString(StringUtil.truncate(this.getLastName(), 200)));
			update.append(", login = ").append(conn.toSQLString(StringUtil.truncate(this.getLogin(), 200)));
			update.append(", password = ").append(conn.toSQLString(StringUtil.truncate(this.getPassword(), 20)));
			update.append(", active_flag = ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 240)));
			update.append(", date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", created_by = ").append(this.getCreatedBy());
			update.append(", date_modified = ").append(conn.toSQLString(this.getDateModified()));
			update.append(", modified_by = ").append(this.getModifiedBy());
			update.append("WHERE (user_id = ").append(this.getUserID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in User.internalUpdate()");
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
		Diagnostics.trace("User.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO users (");
				insert.append("  ext_employee_id");
				insert.append(", contact_id");
				insert.append(", user_type_id");
				insert.append(", pin");
				insert.append(", first_name");
				insert.append(", last_login");
				insert.append(", last_name");
				insert.append(", login");
				insert.append(", password");
				insert.append(", active_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getExtEmployeeID());
				insert.append(", ").append(this.getContactID());
				insert.append(", ").append(this.getUserTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPin(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getFirstName(), 200)));
				insert.append(", ").append(conn.toSQLString(this.getLastLogin()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLastName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLogin(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPassword(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 240)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO users (");
				insert.append("user_id");
				insert.append(", ext_employee_id");
				insert.append(", contact_id");
				insert.append(", user_type_id");
				insert.append(", pin");
				insert.append(", first_name");
				insert.append(", last_login");
				insert.append(", last_name");
				insert.append(", login");
				insert.append(", password");
				insert.append(", active_flag");
				insert.append(", date_created");
				insert.append(", created_by");
				insert.append(", date_modified");
				insert.append(", modified_by");
				insert.append(") VALUES (");
				insert.append(this.getUserID());
				insert.append(", ").append(this.getExtEmployeeID());
				insert.append(", ").append(this.getContactID());
				insert.append(", ").append(this.getUserTypeID());
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPin(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getFirstName(), 200)));
				insert.append(", ").append(conn.toSQLString(this.getLastLogin()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLastName(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLogin(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPassword(), 20)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getActiveFlag(), 240)));
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(this.getCreatedBy());
				insert.append(", ").append(conn.toSQLString(this.getDateModified()));
				insert.append(", ").append(this.getModifiedBy());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				userID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in User.internalInsert()");
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
		Diagnostics.trace("User.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM users ");
			delete.append("WHERE (user_id = ").append(this.getUserID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in User.internalDelete()");
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
		if (this.getUserID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}

	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("User:\n");
		result.append("  user_id = ").append(this.getUserID()).append("\n");
		result.append("  ext_employee_id = ").append(this.getExtEmployeeID()).append("\n");
		result.append("  contact_id = ").append(this.getContactID()).append("\n");
		result.append("  user_type_id = ").append(this.getUserTypeID()).append("\n");
		result.append("  pin = ").append(this.getPin()).append("\n");
		result.append("  first_name = ").append(this.getFirstName()).append("\n");
		result.append("  last_login = ").append(this.getLastLogin()).append("\n");
		result.append("  last_name = ").append(this.getLastName()).append("\n");
		result.append("  login = ").append(this.getLogin()).append("\n");
		result.append("  password = ").append(this.getPassword()).append("\n");
		result.append("  active_flag = ").append(this.getActiveFlag()).append("\n");
		result.append("  userTypeCode = ").append(this.userTypeCode).append("\n");
		result.append("  userTypeName = ").append(this.userTypeName).append("\n");
		result.append("  extDealerID = ").append(this.extDealerID).append("\n");
		result.append("  vendorContactID = ").append(this.vendorContactID).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  created_by = ").append(this.getCreatedBy()).append("\n");
		result.append("  date_modified = ").append(this.getDateModified()).append("\n");
		result.append("  modified_by = ").append(this.getModifiedBy()).append("\n");
		return result.toString();
	}


	public int getUserID()
	{
		return userID;
	}

	public String getExtEmployeeID()
	{
		return extEmployeeID;
	}

	public int getContactID()
	{
		return contactID;
	}

	public int getUserTypeID()
	{
		return userTypeID;
	}

	public String getPin()
	{
		return pin;
	}

	public String getFirstName()
	{
		return firstName;
	}

	public Date getLastLogin()
	{
		return lastLogin;
	}

	public String getLastName()
	{
		return lastName;
	}

	public String getLogin()
	{
		return login;
	}

	public String getPassword()
	{
		return password;
	}

	public String getActiveFlag()
	{
		return activeFlag;
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

	public void setUserID(int userIDIn)
	{
		userID = userIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setExtEmployeeID(String extEmployeeIDIn)
	{
		extEmployeeID = extEmployeeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setContactID(int contactIDIn)
	{
		contactID = contactIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUserTypeID(int userTypeIDIn)
	{
		userTypeID = userTypeIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPin(String pinIn)
	{
		pin = pinIn;
		handleAction(MODIFY_ACTION);
	}

	public void setFirstName(String firstNameIn)
	{
		firstName = firstNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLastLogin(Date lastLoginIn)
	{
		lastLogin = lastLoginIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLastName(String lastNameIn)
	{
		lastName = lastNameIn;
		handleAction(MODIFY_ACTION);
	}

	public void setLogin(String loginIn)
	{
		login = loginIn;
		handleAction(MODIFY_ACTION);
	}

	public void setPassword(String passwordIn)
	{
		password = passwordIn;
		handleAction(MODIFY_ACTION);
	}

	public void setActiveFlag(String activeFlagIn)
	{
		activeFlag = activeFlagIn;
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
	/**
	 * @return Returns the rights.
	 */
	public Map getRights()
	{
		return rights;
	}
	/**
	 * @return Returns the roleIDs.
	 */
	public List getRoleIDs()
	{
		return roleIDs;
	}
}
