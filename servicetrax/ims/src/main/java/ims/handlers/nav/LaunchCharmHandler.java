package ims.handlers.nav;

import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;

/**
 * This handler is responsible for placing authentication information in the database, and then redirecting the user's browser the Charm-base site
 * @author gcase
 *
 */
public class LaunchCharmHandler extends BaseHandler
{
	public void setUpHandler()
	{
	}

	public void destroy()
	{
		Diagnostics.debug2("LaunchCharmHandler.destroy()");
	}



  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("LaunchCharmHandler.handleEnvironment()");
		boolean result = true;

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			String authKey = Long.toString(Math.abs(new Random(System.currentTimeMillis()).nextLong()));
			StdDate now = new StdDate();
			now = now.addHours(1);

			StringBuffer insert = new StringBuffer();
			insert.append("INSERT INTO authentication_keys (auth, user_id, organization_id, expire_date) VALUES (");
			insert.append(conn.toSQLString(authKey));
			insert.append(", " + conn.toSQLString(ic.getSessionDatum("user_id").toString()));
			insert.append(", " + conn.toSQLString(ic.getSessionDatum("org_id").toString()));
			insert.append(", " + conn.toSQLString(now));
			insert.append(")");

			conn.updateExactlyEx(insert, 1);

			HttpServletRequest request = ic.getHttpServletRequest();
			String host = request.getServerName(); //www.mydomain.com
			int port = request.getServerPort(); //8008, etc.
			String redirect;
			if (port == 443)
			{
				redirect = "https://" + host;
			}
			else if (port == 80)
			{
				redirect = "http://" + host;
			}
			else
			{
				redirect = "http://" + host + ":" + port;
			}

			String context = ic.getAppGlobalDatum("charmContext").toString();
			if (!context.startsWith("/"))
				context = "/" + context;
			redirect += context + "/";

			String address = ic.getParameter("address");
			redirect += address;
			if (address.contains("?"))
			{
				redirect += "&auth=" + authKey;
			}
			else
			{
				redirect += "?auth=" + authKey;
			}

			Diagnostics.debug("Redirecting to " + redirect);
			ic.sendRedirect(redirect);

		}
		finally
		{
			if (conn != null)
				conn.release();
		}

		return result;
	}

}
