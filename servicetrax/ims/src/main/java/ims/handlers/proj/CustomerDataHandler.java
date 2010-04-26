package ims.handlers.proj;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;

public class CustomerDataHandler extends BaseHandler
{

	public void setUpHandler() throws Exception
	{

	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception {

		String customer_id = ic.getParameter("customer_id");
		String customer_type = null;

		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper)ic.getResource();

			StringBuffer query = new StringBuffer();
			query.append("select lu.code from customers cst left join lookups lu on cst.customer_type_id = lu.lookup_id where customer_id=" + customer_id);
			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
				customer_type = rs.getString("code");
			}

		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in CustomerPostHandler");
		}
		finally
		{
			// Close the connection to the database.
			try
			{
				if (conn != null)
				{
					conn.release();
				}
			}
			catch (Exception e){}
		}


		ic.getHttpServletResponse().getOutputStream().print("customer_type=" + customer_type + ",");

		return false;
	}

	public void destroy()
	{

	}

}
