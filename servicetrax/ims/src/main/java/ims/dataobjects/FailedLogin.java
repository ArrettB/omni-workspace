package ims.dataobjects;

import java.util.Date;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.dbtk.meta.AbstractDatabaseObject;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class FailedLogin extends AbstractDatabaseObject
{

	private int failedLoginID;
	private Date dateCreated;
	private String login;
	private String password;
	private String ipAddress;
	private int userID;

	public FailedLogin()
	{
		super();
	}


	public static FailedLogin fetch(String failedLoginID, InvocationContext ic)
	{
		 return fetch(Integer.parseInt(failedLoginID), ic, null);
	}

	public static FailedLogin fetch(String failedLoginID, InvocationContext ic, String resourceName)
	{
		 return fetch(Integer.parseInt(failedLoginID), ic, resourceName);
	}

	public static FailedLogin fetch(int failedLoginID, InvocationContext ic)
	{
		 return fetch(failedLoginID, ic, null);
	}

	public static FailedLogin fetch(int failedLoginID, InvocationContext ic, String resourceName)
	{
		Diagnostics.trace("FailedLogin.fetch()");

		FailedLogin result = null;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT failed_login_id ");
			query.append(", date_created ");
			query.append(", login ");
			query.append(", password ");
			query.append(", ip_address ");
			query.append(", user_id ");
			query.append("FROM failed_logins ");
			query.append("WHERE (failed_login_id = ").append(failedLoginID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
			result = new FailedLogin();
				result.setFailedLoginID(rs.getInt(1));
				result.setDateCreated(rs.getDate(2));
				result.setLogin(rs.getString(3));
				result.setPassword(rs.getString(4));
				result.setIpAddress(rs.getString(5));
				result.setUserID(rs.getInt(6));
			}
			else
			{
				Diagnostics.error("Error in FailedLogin.fetch(), Could not find FailedLogin; Select was:" + query);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FailedLogin.fetch()");
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
		Diagnostics.trace("FailedLogin.internalUpdate()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer update = new StringBuffer();
			update.append("UPDATE failed_logins ");
			update.append("SET date_created = ").append(conn.toSQLString(this.getDateCreated()));
			update.append(", login = ").append(conn.toSQLString(StringUtil.truncate(this.getLogin(), 200)));
			update.append(", password = ").append(conn.toSQLString(StringUtil.truncate(this.getPassword(), 200)));
			update.append(", ip_address = ").append(conn.toSQLString(StringUtil.truncate(this.getIpAddress(), 200)));
			update.append(", user_id = ").append(this.getUserID());
			update.append("WHERE (failed_login_id = ").append(this.getFailedLoginID()).append(")");

			conn.updateExactlyEx(update, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FailedLogin.internalUpdate()");
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
		Diagnostics.trace("FailedLogin.internalInsert()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer insert = new StringBuffer();
			boolean skipPrimary = skipPrimaryKey();
			if (skipPrimary)
			{
				insert.append("INSERT INTO failed_logins (");
				insert.append("date_created");
				insert.append(", login");
				insert.append(", password");
				insert.append(", ip_address");
				insert.append(", user_id");
				insert.append(") VALUES (");
				insert.append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLogin(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPassword(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getIpAddress(), 200)));
				insert.append(", ").append(this.getUserID());
				insert.append(")");
			}
			else
			{
				insert.append("INSERT INTO failed_logins (");
				insert.append("failed_login_id");
				insert.append(", date_created");
				insert.append(", login");
				insert.append(", password");
				insert.append(", ip_address");
				insert.append(", user_id");
				insert.append(") VALUES (");
				insert.append(this.getFailedLoginID());
				insert.append(", ").append(conn.toSQLString(this.getDateCreated()));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getLogin(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getPassword(), 200)));
				insert.append(", ").append(conn.toSQLString(StringUtil.truncate(this.getIpAddress(), 200)));
				insert.append(", ").append(this.getUserID());
				insert.append(")");
			}

			conn.updateExactlyEx(insert, 1);
			if (skipPrimary)
			{
				failedLoginID = Integer.parseInt(conn.queryEx("select @@identity"));
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FailedLogin.internalInsert()");
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
		Diagnostics.trace("FailedLogin.internalDelete()");

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource(resourceName);
			StringBuffer delete = new StringBuffer();
			delete.append("DELETE FROM failed_logins ");
			delete.append("WHERE (failed_login_id = ").append(this.getFailedLoginID()).append(")");

			conn.updateExactlyEx(delete, 1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in FailedLogin.internalDelete()");
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
		if (this.getFailedLoginID() <= 0)
		{
			skipPrimaryKey = true;
		}
		return skipPrimaryKey;
	}


	public String toString()
	{
		StringBuffer result = new StringBuffer();
		result.append("FailedLogin:\n");
		result.append("  failed_login_id = ").append(this.getFailedLoginID()).append("\n");
		result.append("  date_created = ").append(this.getDateCreated()).append("\n");
		result.append("  login = ").append(this.getLogin()).append("\n");
		result.append("  password = ").append(this.getPassword()).append("\n");
		result.append("  ip_address = ").append(this.getIpAddress()).append("\n");
		result.append("  user_id = ").append(this.getUserID()).append("\n");
		return result.toString();
	}


	public int getFailedLoginID()
	{
		return failedLoginID;
	}

	public Date getDateCreated()
	{
		return dateCreated;
	}

	public String getLogin()
	{
		return login;
	}

	public String getPassword()
	{
		return password;
	}

	public String getIpAddress()
	{
		return ipAddress;
	}

	public int getUserID()
	{
		return userID;
	}

	public void setFailedLoginID(int failedLoginIDIn)
	{
		failedLoginID = failedLoginIDIn;
		handleAction(MODIFY_ACTION);
	}

	public void setDateCreated(Date dateCreatedIn)
	{
		dateCreated = dateCreatedIn;
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

	public void setIpAddress(String ipAddressIn)
	{
		ipAddress = ipAddressIn;
		handleAction(MODIFY_ACTION);
	}

	public void setUserID(int userIDIn)
	{
		userID = userIDIn;
		handleAction(MODIFY_ACTION);
	}
}
