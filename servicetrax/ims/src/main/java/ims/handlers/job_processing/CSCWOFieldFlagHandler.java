package ims.handlers.job_processing;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;

/**
 * From the intranet Job Header edit page, they want to change the value of
 * the resources.CSC_WO_FIELD_FLAG for the project related to the job.
 * 
 * The resources.CSC_WO_FIELD_FLAG is used to determine if the project number will
 * be displayed in the project number dropdown list when creating a CSC work order.
 * 
 * @version $Id: CSCWOFieldFlagHandler.java, 1, 1/27/2006 1:07:36 PM, Blake Von Haden$
 */
public class CSCWOFieldFlagHandler extends BaseHandler
{

	public void setUpHandler(){}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		boolean result = true;
		
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			Object projectId = ic.getRowDatum("job/job_edit", "project_id");
			String query = "SELECT TOP 1 csc_wo_field_flag FROM requests WHERE project_id = " + projectId;
			String flag = conn.queryEx(query);
			ic.setTransientDatum("csc_wo_field_flag", flag);
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}

		return result;
	}

	public void destroy(){}

}
