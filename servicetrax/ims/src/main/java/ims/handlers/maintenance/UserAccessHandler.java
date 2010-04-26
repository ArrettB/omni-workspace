package ims.handlers.maintenance;

import ims.dataobjects.User;

import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: C:\work\ims\src\ims\handlers\maintenance\UserAccessHandler.java, 29, 4/6/2006 4:10:03 PM, Blake Von Haden$
 */
public class UserAccessHandler extends BaseHandler
{

	public void setUpHandler(){}

	public void destroy(){}

	public boolean handleEnvironment(InvocationContext ic)
	{
		boolean bRet = true;
		String action = ic.getParameter("action");

		try
		{
			Diagnostics.debug2("UserAccessHandler.handleEnvironment() = '" + action + "'");

			if (action.equalsIgnoreCase("displayLogin"))
			{
				ic.setTransientDatum(
					"message",
					new String(
						"Please enter your User Name and Password..."
							+ "<script type=\"text/javascript\">"
							+ "   document.loginform.username.focus() "
							+ "</script>"));
				bRet = false; //false will automatically displays login page
				ic.setParameter("redisplayTemplate", "login.html");
			}
			else if (action.equalsIgnoreCase("login"))
			{
				//user attempting to login
				Diagnostics.debug2("Trying to login user...");
				bRet = loginUser(ic);
			}
			else
			{
				//not a recognized action
				Diagnostics.debug2("UserAccessHandler action = '" + action + "' not currently handled.");
				bRet = false;
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in UserAccessHandler");
		}

		if (!bRet)
		{
			String loginTemplate = ic.getParameter("loginTemplate");
			if (!StringUtil.hasAValue(loginTemplate))
				loginTemplate = "login.html";
			ic.setHTMLTemplateName(loginTemplate);
		}
		
		return bRet;
	}

	/**
	 * Attempt to login the user, if successful set session data
	 */
	public boolean loginUser(InvocationContext ic)
	{
		boolean result = false;

		String userName = ic.getParameter("username");
		String password = ic.getParameter("password");

		if (userName.equals(""))
		{
			ic.setTransientDatum(
				"message",
				"Login failed.  You must enter a User Name..."
					+ "<script type=\"text/javascript\">"
					+ "   document.loginform.username.focus() "
					+ "</script>");
		}
		else if (password.equals(""))
		{
			//they typed in a user name
			ic.setTransientDatum(
				"message",
				"Login failed.  You must enter a Password...<BR><BR>"
					+ "Please try again..."
					+ "<script type=\"text/javascript\">"
					+ "   document.loginform.password.focus() "
					+ "</script>");
			ic.setTransientDatum("user_name", userName);
		}
		else
		{
			//they typed in a password, note we do not allow null passwords

			ConnectionWrapper conn = null;
			QueryResults rs = null;
			try
			{
				conn = (ConnectionWrapper) ic.getResource();
				String query = "SELECT u.active_flag, u.user_id, u.full_name from users_vq u"
					+ " WHERE u.login = ?"
					+ " AND u.password = ?";

				rs = conn.select(query, new String[] {userName, password} );
				if (rs.next())
				{
					String activeFlag = rs.getString("active_flag");
					String userID = rs.getString("user_id");
					String fullName = rs.getString("full_name");
					rs.close();
					rs = null;
					//set user id and name as session datum for future
					// reference
					if ("Y".equalsIgnoreCase(activeFlag))
					{
						//now check the organization
						try
						{
							rs = conn.select("SELECT organization_id FROM user_organizations WHERE user_id = ?", userID);
							String org_id = null;
							int count = 0;
							while (rs.next())
							{
								org_id = rs.getString(1);
								count++;
							}
							if (count == 1)
							{
								// auto-pick if only one
								ic.setParameter("org_id", org_id);
							}
						}
						finally
						{
							if (rs != null)
							{
								rs.close();
								rs = null;
							}
						}

						User user = User.fetch(userID, conn);
						//row returned, user is active, org is good, so
						// valid login, set session data, but first clear
						// all session data,
						ic.clearSessionData();
						ic.setSessionDatum("user", user);
						ic.setSessionDatum("user_id", userID);
						ic.setSessionDatum("user_name", fullName);
						Diagnostics.debug2("Login of user: '" + userName + "' was successful.");

						//Update the users last login time
//						StringBuffer update = new StringBuffer();
//						update.append("UPDATE users");
//						update.append(" SET last_login = ").append(conn.now());
//						update.append(" WHERE user_id = ?");
//						conn.update(update, userID);

						result = true;
					}
					else
					{
						//row returned, user found but not active, notify user
						// of failed login.
						ic.setTransientDatum("message",
							"Login failed.  User '"
								+ userName
								+ "' is no longer active."
								+ "<script type=\"text/javascript\">"
								+ "   document.loginform.username.focus() "
								+ "</script>");
					}
				}
				else
				{
					//failed to locate user or password, invalid login

					ic.setTransientDatum("user_name", userName);
					ic.setTransientDatum("message",
						"You typed in an invalid User Name or Password.<BR><BR>"
							+ "Please try again..."
							+ "<script type=\"text/javascript\">"
							+ "   document.loginform.username.focus() "
							+ "</script>");
				}
			}
			catch (Exception e)
			{
				ErrorHandler.handleException(ic, e, "Exception in UserAccessHandler");
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
				if (conn != null)
				{
					conn.release();
				}
			}

		}

		if (result == false)
		{
			Diagnostics.debug2("Login of user: '" + userName + "' failed.");
		}
		return result;
	}

}
