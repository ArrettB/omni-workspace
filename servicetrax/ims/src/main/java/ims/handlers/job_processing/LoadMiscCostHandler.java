/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: C:\work\ims\src\ims\handlers\job_processing\LoadMiscCostHandler.java, 10, 3/15/2006 3:28:35 PM, Blake Von Haden$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */
package ims.handlers.job_processing;

import ims.helpers.IMSUtil;

import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;


/**
 * Load the job costs from Great Plains.
 * This will be miscellaneous costs including materials and subcontractors.
 *
 * @version $Id: C:\work\ims\src\ims\handlers\job_processing\LoadMiscCostHandler.java, 10, 3/15/2006 3:28:35 PM, Blake Von Haden$
 */
public class LoadMiscCostHandler extends BaseHandler
{
	
	private class JobInfo
	{
		private String jobId;
		private String jobTypeId;
		private String jobStatusTypeCode;

		public JobInfo(String jobId, String jobTypeId, String jobStatusTypeCode)
		{
			this.jobId = jobId;
			this.jobTypeId = jobTypeId;
			this.jobStatusTypeCode = jobStatusTypeCode;
		}

		public String getJobId()
		{
			return jobId;
		}

		public String getJobTypeId()
		{
			return jobTypeId;
		}

		public String getJobStatusTypeCode()
		{
			return jobStatusTypeCode;
		}

	}

	public void setUpHandler() throws Exception {}
	public void destroy() {}

	/* (non-Javadoc)
	 * @see dynamic.intraframe.handlers.BaseHandler#handleEnvironment(dynamic.intraframe.engine.InvocationContext)
	 */
	public boolean handleEnvironment(InvocationContext ic)
		throws Exception
	{
		boolean result = true;
		ConnectionWrapper gp_conn = null;
		ConnectionWrapper conn = null;

		try
		{
			String org_resource = (String) ic.getSessionDatum("org_resource");

			if (!StringUtil.hasAValue(org_resource))
			{
				//failed to determine which great plains database to grab item data from.
				SmartFormHandler.addSmartFormError(ic,
				    "Missing org_resource, cannot connect to Great Plains.\n"
				    + "Exception in LoadMiscCostHandler, could not get org_resource from session data.\n"
				    + "Variable org_resource is used to connect to the appropriate Great Plains database.");
				Diagnostics.error(
				    "LoadMiscCostHandler.handleEnvironment() Unable to find org_resource, cannot connect to Great Plains to load items.");
				result = false;
			}
			else
			{
				String organizationId = (String) ic.getSessionDatum("org_id");
				String userId = (String) ic.getRequiredSessionDatum("user_id");

				gp_conn = (ConnectionWrapper) ic.getResource(org_resource);
				conn = (ConnectionWrapper) ic.getResource();

				int count = loadMisc(organizationId, userId, ic, conn, gp_conn);
				ic.setTransientDatum("load_count", "" + count);
			}
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}

			if (gp_conn != null)
			{
				gp_conn.release();
			}
		}

		return result;
	}

	private int loadMisc(String organizationId, String userId, InvocationContext ic, ConnectionWrapper conn,
	    ConnectionWrapper gp_conn) throws SQLException
	{
		int count = 0;
		String query = "SELECT CAST(doctype AS varchar) + '-' + vchrnmbr unique_id, pordnmbr, shipmthd, prchamnt FROM pm10000";
		QueryResults rs = null;

		try
		{
			rs = gp_conn.resultsQueryEx(query);

			while (rs.next())
			{
				String uniqueId = rs.getString("unique_id").trim();
				String jobReq = rs.getString("pordnmbr");
				String itemName = rs.getString("shipmthd");
				double amount = rs.getDouble("prchamnt");

				if (StringUtil.hasAValue(jobReq) && StringUtil.hasAValue(itemName) && itemNew(uniqueId, organizationId, conn))
				{
					jobReq = jobReq.trim();
					String[] values = jobReq.split("-");
					String jobNo = null;
					String reqNo = null;

					if (values.length > 0)
						jobNo = values[0].trim();

					if (values.length > 1)
						reqNo = values[1].trim();

					itemName = itemName.trim();

					// get job id
					JobInfo jobInfo = getJobId(jobNo, organizationId, ic, conn);
					String jobId = null;
					String jobTypeId = null;
					boolean good = true;
					Object[] itemValues = null;
					if (jobInfo != null)
					{
						if (!"closed".equals(jobInfo.getJobStatusTypeCode()))
						{
							jobId = jobInfo.getJobId();
							jobTypeId = jobInfo.getJobTypeId();
							// get item id
							itemValues = getItemId(itemName, organizationId, jobReq, jobTypeId, ic, conn);
						}
						else
						{
							SmartFormHandler.addSmartFormError(ic, "A payable for Job '" + jobNo + "' with requisition '" + reqNo + "' was not loaded because the job is closed.");
							good &= false;
						}
					}
					else
					{
						good &= false;
					}

					String itemId = null;
					double marginAmount = amount;
					if (itemValues != null)
					{
						itemId = (String) itemValues[0];
						marginAmount += ((amount * ((Double) itemValues[1]).doubleValue()) / 100.0);
					}
					else
					{
						good &= false;
					}

					// get request (service) id
					String serviceId = null;
					if (jobInfo != null && jobId != null)
						serviceId = getServiceId(reqNo, jobId, jobNo, ic, conn);

					String resourceId = null;
					if (StringUtil.hasAValue(serviceId))
					{
						resourceId =  getPayableResourceId("Payable", organizationId, jobReq, ic, conn);
					}
					else
					{
						good &= false;
					}

					if (!StringUtil.hasAValue(resourceId))
					{
						good &= false;
					}

					if (good)
					{
						save(uniqueId, jobId, serviceId, resourceId, itemId, amount, marginAmount, userId, conn);
						count++;
					}
				}
			}
		}
		finally
		{
			rs.close();
		}

		return count;
	}

	/**
	 * @param uniqueId
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private boolean itemNew(String uniqueId, String organizationId, ConnectionWrapper conn)
		throws SQLException
	{
		String query = "SELECT service_line_id"
			+ " FROM service_lines"
			+ " WHERE ext_id = " + conn.toSQLString(uniqueId)
			+ " AND organization_id = " + organizationId;
		String itemId = conn.queryEx(query);

		return itemId == null;
	}

	/**
	 * Get the payable resource ID.
	 *
	 * @param organizationId
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private String getPayableResourceId(String resourceName, String organizationId, String jobReq, InvocationContext ic, ConnectionWrapper conn)
		throws SQLException
	{
		String query = "SELECT resource_id"
			+ " FROM resources"
			+ " WHERE name = " + conn.toSQLString(resourceName)
			+ " AND organization_id = " + organizationId;
		String resourceId = conn.queryEx(query);

		if (!StringUtil.hasAValue(resourceId))
			SmartFormHandler.addSmartFormError(ic,
					"For Job '" + jobReq + "' the resource '" + resourceName + "' could not be matched in the ServiceTrax system.");

		return resourceId;
	}

	/**
	 * @param reqNo
	 * @param jobId
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private String getServiceId(String reqNo, String jobId, String jobNo, InvocationContext ic, ConnectionWrapper conn)
		throws SQLException
	{
		String query = "SELECT s.service_id, l.lookup_code"
			+ " FROM services s INNER JOIN service_status_types_v l"
			+ " ON s.serv_status_type_id = l.lookup_id"
			+ " WHERE s.service_no = " + conn.toSQLString(reqNo)
			+ " AND s.job_id = " + jobId;
		String serviceId = null;
		
		QueryResults rs = null;
		try
		{
			rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
				serviceId = rs.getString("service_id");
				String lookupCode = rs.getString("lookup_code");
				if ("closed".equals(lookupCode))
				{
					SmartFormHandler.addSmartFormError(ic, "The payable was not loaded for Job '" + jobNo + "', requisition '" + reqNo + "' because the requisition is closed.");
					serviceId = null;
				}
			}
			else
			{
				SmartFormHandler.addSmartFormError(ic, "For Job '" + jobNo + "' the requisition '" + reqNo + "' could not be matched in the ServiceTrax system.");
			}
		}
		finally
		{
			IMSUtil.closeQueryResultSet(rs);
		}

		return serviceId;
	}

	/**
	 * @param itemName
	 * @param jobReq 
	 * @param jobTypeId 
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private Object[] getItemId(String itemName, String organizationId, String jobReq, String jobTypeId, InvocationContext ic, ConnectionWrapper conn)
		throws SQLException
	{
		String query = "SELECT item_id, percent_margin, job_type_id"
			+ " FROM items"
			+ " WHERE name = " + conn.toSQLString(itemName)
			+ " AND organization_id = " + organizationId;
		Object[] values = null;
		QueryResults rs = null;

		try
		{
			rs = conn.resultsQueryEx(query);

			if (rs.next())
			{
				values = new Object[] { rs.getString("item_id"), new Double(rs.getDouble("percent_margin")) };
				String itemJobTypeId = rs.getString("job_type_id");
				if (itemJobTypeId != null && !itemJobTypeId.equals(jobTypeId))
				{
					SmartFormHandler.addSmartFormError(ic, "For Job '" + jobReq + "' the item '" + itemName + "' has the wrong suffix.");
				}
			}
		}
		finally
		{
			IMSUtil.closeQueryResultSet(rs);
		}

		if (values == null)
			SmartFormHandler.addSmartFormError(ic, "For Job '" + jobReq + "' the item '" + itemName + "' could not be matched in the ServiceTrax system.");

		return values;
	}

	/**
	 * @param jobNo
	 * @param conn
	 * @return 0 - jobId, 1 - jobTypeId
	 * @throws SQLException
	 */
	private JobInfo getJobId(String jobNo, String organizationId, InvocationContext ic, ConnectionWrapper conn)
		throws SQLException
	{
		String query = "SELECT job_id, job_type_id, job_status_type_code"
			+ " FROM jobs_v"
			+ " WHERE job_no = " + conn.toSQLString(jobNo)
			+ " AND organization_id = " + conn.toSQLString(organizationId);
		JobInfo jobInfo = null;
		QueryResults rs = null;
		
		try
		{
			rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
				jobInfo = new JobInfo(rs.getString("job_id"), rs.getString("job_type_id"), rs.getString("job_status_type_code"));
			}
		}
		finally
		{
			IMSUtil.closeQueryResultSet(rs);
		}

		if (jobInfo == null)
			SmartFormHandler.addSmartFormError(ic, "The job number '" + jobNo + "' could not be matched in the ServiceTrax system.");

		return jobInfo;
	}

	/**
	 * Create a new expense entry in the Service Trax service_lines table.
	 *
	 * @param jobId
	 * @param serviceId
	 * @param resourceId
	 * @param itemId
	 * @param itemId2
	 * @param amount
	 * @param marginAmount
	 * @param userId
	 * @param columnPosition
	 * @param conn
	 * @throws SQLException
	 */
	private void save(String uniqueId, String jobId, String serviceId, String resourceId, String itemId, double amount,
	    double marginAmount, String userId, ConnectionWrapper conn)
		throws SQLException
	{
		String query = "INSERT INTO service_lines"
			+ "(ext_id, service_line_date, status_id, tc_job_id, tc_service_id, resource_id, item_id"
			+ ", item_type_code, tc_qty, tc_rate, bill_rate, entered_date, entered_by"
			+ ", entry_method, date_created, created_by)"
			+ "VALUES"
			+ "(" + conn.toSQLString(uniqueId)
			+ ", cast(convert(char(10), getDate(), 101) as datetime)" // service_line_date
			+ ", 3" // status_id
			+ ", " + conn.toSQLString(jobId)
			+ ", " + conn.toSQLString(serviceId)
			+ ", " + conn.toSQLString(resourceId)
			+ ", " + conn.toSQLString(itemId)
			+ ", 'expense'"	// item_type_code
			+ ", 1" // tc_qty
			+ ", " + amount
			+ ", " + marginAmount
			+ ", getDate()" // entered_date
			+ ", " + conn.toSQLString(userId)
			+ ", 'GREAT PLAINS'"
			+ ", getDate()" + ", "
			+ conn.toSQLString(userId) + ")";

		conn.updateEx(query);
	}

}
