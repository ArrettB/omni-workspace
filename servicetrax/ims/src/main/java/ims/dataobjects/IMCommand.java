package ims.dataobjects;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.BaseInvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.resources.ResourceManager;

/**
 * 
 * @version $Header: IMCommand.java, 7, 1/27/2006 1:58:08 PM, Blake Von Haden$
 */
public class IMCommand
{
	public String batchID;
	public String type;
	public String pathFilename;
	public String integrationName;
	public String orgID;
	public ResourceManager rm;
	public String resourceName;

	public IMCommand(String batchID, String type, String orgID)
	{
		Diagnostics.debug("IMCommand()");
		this.batchID = batchID;
		this.type = type;
		this.orgID = orgID;
	}

	public void initialize(BaseInvocationContext ic)
	{
		Diagnostics.debug("IMCommand.initialize()");
		this.rm = ic.getResourceManager();
		this.resourceName = ic.getParameter("resourceName");
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) rm.getResource(resourceName);
			StringBuffer query = new StringBuffer();
			query.append("SELECT " + type + "_integration_name ");
			query.append("FROM organizations ");
			query.append("WHERE (organization_id = ").append(orgID).append(") ");

			QueryResults rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
				integrationName = rs.getString(1);
			}
			else
			{
				Diagnostics.error("Error in IMCommand.initialize(), Could not find IMCommand; Select was:" + query);
			}
			changeStatus(1);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in IMCommand.initialize()");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}

	public void changeStatus(int status)
	{
		Diagnostics.debug("IMCommand.changeStatus()");
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) rm.getResource(resourceName);
			StringBuffer query = new StringBuffer();

			if (type.equalsIgnoreCase("pr"))
			{
				query.append("UPDATE payroll_batches");
				query.append(" SET status_id = " + status);
				query.append(" WHERE organization_id = " + orgID);
				query.append(" AND ext_batch_id = '" + batchID + "'");
			}
			else if (type.equalsIgnoreCase("inv"))
			{
				query.append("UPDATE invoices");
				query.append(" SET batch_status_id = " + status);
				query.append(" FROM invoices i, jobs_v j ");
				query.append(" WHERE j.organization_id = " + orgID);
				query.append(" AND i.job_id = j.job_id");
				query.append(" AND i.ext_batch_id = '" + batchID + "'");
			}

			Diagnostics.debug2("changeStatus() update query = " + query);
			conn.updateEx(query);

		}
		catch (Exception e)
		{
			Diagnostics.error("Exception in IMCommand.changeStatus()", e);
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
	}
}
