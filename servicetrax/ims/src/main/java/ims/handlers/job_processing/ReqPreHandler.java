package ims.handlers.job_processing;

import ims.helpers.IMSUtil;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Id: ReqPreHandler.java, 1098, 3/6/2008 8:28:04 AM, David Zhao$
 */
public class ReqPreHandler extends BaseHandler
{
	public void setUpHandler(){}
	public void destroy(){}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("ReqPreHandler.handleEnvironment()");
		boolean result = true;

		String button = ic.getParameter("button");
		String mode = ic.getParameter(SmartFormComponent.MODE);
		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

		if (StringUtil.hasAValue(button) && button.equals(SmartFormComponent.Save) && StringUtil.hasAValue(mode)
				&& mode.equals(SmartFormComponent.Insert))
		{// we are inserting so determine the service_no

			// determine service_no
			String job_id = ic.getParameter("job_id");
			String service_no = null;

			String query ="SELECT (max_request_no+1) max_request_no, (max_service_no+1) max_service_no FROM max_req_no_v WHERE job_id="
							+ conn.toSQLString(job_id);
			Diagnostics.debug3("Create new Service, retrieve next service_no query= " + query.toString());
			QueryResults rs = null;
			try
			{
				rs = conn.resultsQueryEx(query);
	
				if (rs.next()) // should always return a number
				{
					if (rs.getInt("max_service_no") > rs.getInt("max_request_no"))
						service_no = rs.getString("max_service_no");
					else
						service_no = rs.getString("max_request_no");
					ic.setParameter("service_no", service_no);
					Diagnostics.debug2("Determined new service_no to be = '" + service_no + "'");
				}
				else
				{
					Diagnostics.error("Failed to determine next service_no.");
				}
			}
			finally
			{
				IMSUtil.closeQueryResultSet(rs);
			}
			
		}

		Diagnostics.debug2("ReqPreHandler.handleEnvironment() result = " + result);

		return result;
	}

}
