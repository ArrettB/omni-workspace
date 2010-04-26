package ims.handlers.job_processing;

import ims.helpers.MapUtil;

import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * A handler initialize the service_type_code parameter.
 *
 * @version $Id: InitReqHandler.java, 10, 4/1/2004 1:46:31 PM, Greg Case$
 */

public class InitReqHandler extends BaseHandler
{

	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = false;
		try
		{
			Diagnostics.trace("InitReqHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();

			String job_id = (String)ic.getRequiredSessionDatum("job_id");
			String job_type_code = conn.queryEx("SELECT job_type_code FROM jobs_v WHERE job_id="+conn.toSQLString(job_id));
			ic.setParameter("job_type_code", job_type_code);

			String service_id = (String)ic.getSessionDatum("service_id");
			if (service_id != null && service_id.length() > 0)
			{
				String service_type_code = conn.queryEx("SELECT service_type_name, job_type_code FROM services_v WHERE service_id="+conn.toSQLString(service_id));
				ic.setParameter("service_type_name", service_type_code);
			}
			else
			{
				if( !StringUtil.hasAValue( ic.getParameter("service_type_name") ) )
				{
					Map service_types = MapUtil.getTypeMap(conn,"service_type");
					//if service account default to short view
					if (job_type_code.equalsIgnoreCase("service_account"))
					{
						ic.setParameter("service_type_name", "Short View");
						ic.setParameter("service_type_id", (String)service_types.get("short_view") );
					} 
					else //must be project so default to long view
					{
						ic.setParameter("service_type_name", "Long View");
						ic.setParameter("service_type_id", (String)service_types.get("long_view") );
					}
				}
			}
			ic.setTransientDatum("initialVisit","true");
			result = true;
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Error in DocumentHandler.handleEnvironment()");
		}
		finally
		{
			if (conn != null) conn.release();
		}
		return result;
	}
}
