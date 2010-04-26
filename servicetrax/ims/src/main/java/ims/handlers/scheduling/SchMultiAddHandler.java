/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: SchMultiAddHandler.java, 4, 3/6/2006 3:46:56 PM, Blake Von Haden$
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
package ims.handlers.scheduling;

import ims.helpers.IMSUtil;
import ims.listeners.IMSApplicationContextListener;

import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * Add multiple resources to a job.
 *
 * @version $Id: SchMultiAddHandler.java 1094 2008-03-05 17:25:36Z dzhao $
 */
public class SchMultiAddHandler extends SchHandler {
	
	public static final String query 
		= "SELECT sch_resources.weekend_sch_resource_id,"
		+ "       sch_resources.job_id,"
		+ "       sch_resources.service_id,"
		+ "       sch_resources.res_status_type_id,"
		+ "       sch_resources.reason_type_id,"
		+ "       sch_resources.send_to_pda_flag,"
		+ "       sch_resources.res_start_time,"
		+ "       sch_resources.date_confirmed,"
		+ "       sch_resources.sch_notes,"
		+ "       resources.name AS resource_name "
		+ "  FROM sch_resources INNER JOIN resources ON sch_resources.resource_id = resources.resource_id "
		+ " WHERE resources.resource_id = ? "
		+ "   AND sch_resources.sch_resource_id = ?";
	
	public static final String queryByResourceId 
		= "SELECT name resource_name,"
		+ "       null res_status_type_id,"
		+ "       null job_id,"
		+ "       null weekend_sch_resource_id," 
		+ "       null reason_type_id,"
		+ "       null job_id,"
		+ "       null service_id,"
		+ "       null sch_notes,"
		+ "       null res_start_time,"
		+ "       null date_confirmed,"
		+ "       null send_to_pda_flag"
		+ "  FROM resources"
		+ " WHERE resource_id = ?";

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		boolean result = true;
		
		Enumeration params = ic.getParameterKeys();
		ConnectionWrapper conn = null;

		try
		{
			conn = (ConnectionWrapper)ic.getResource();
			conn.setAutoCommit(false);
			Map<String, String> savedParams = new HashMap<String, String>();
			
			String startDate = ic.getParameter("res_start_date");
			String endDate = ic.getParameter("res_end_date");
			String jobId = (String)ic.getSessionDatum("job_id");
			
			if (!StringUtil.hasAValue(jobId))
			{
				SmartFormHandler.addSmartFormError(ic, "A job must be selected");
				result = false;
			}
			if (!StringUtil.hasAValue(startDate))
			{
				SmartFormHandler.addSmartFormError(ic, "Missing required start date");
				result = false;
			}
			
			int countSelected = 0;
			while (result && params.hasMoreElements())
			{
				String fieldName = (String)params.nextElement();
				if (StringUtil.hasAValue(fieldName) && fieldName.startsWith("addCheckBox"))
				{
					countSelected++;
					String fieldValue = ic.getParameter(fieldName);
					
					String[] values = fieldValue.split("_");
					
					String resourceId = values[0];
					String schResourceId = "";
					if (values.length > 1)
						schResourceId = values[1];
					Diagnostics.debug(fieldName + "=" + fieldValue);
					addResource(jobId, resourceId, schResourceId, startDate, endDate, conn, ic, savedParams);
				}
			}
			
			if (countSelected == 0)
				SmartFormHandler.addSmartFormError(ic, "No resources were selected");
				
			restoreParameters(savedParams, ic);
			ic.setParameter("reload_frames","true"); //refreshes windows
			conn.commit();
		}
		catch (Exception e)
		{
			conn.rollback();
			Diagnostics.error("Exception in SchMultiAddHandler.handleEnviroment()", e);
			SmartFormHandler.addSmartFormError(ic, e.getMessage());
		}
		finally
		{
			if (conn != null)
			{
				try
				{
					conn.setAutoCommit(true);
				}
				catch (SQLException ignore){}
				conn.release();
			}
		}

		return result;
	}

	/**
	 * This is trying to emulate the functionality in the template sch/sch_res_edit.html
	 * that normally calls the editSchResource() method.
	 * 
	 * @param jobId
	 * @param resourceId
	 * @param schResourceId
	 * @param endDate
	 * @param startDate
	 * @param conn
	 * @param ic
	 * @param savedParams
	 * @param errorMessages
	 */
	private boolean addResource(String jobId, String resourceId, String schResourceId, String startDate, String endDate, ConnectionWrapper conn, InvocationContext ic, Map<String, String> savedParams)
	{
		boolean result = false;
		
		String resourceName = "Unknown";
		try
		{
			// set up the parameters that editSchResource expects.
			setParameter("resource_id", resourceId, ic, savedParams);
			setParameter("sch_resource_id", schResourceId, ic, savedParams);

			QueryResults rs = null;
			try
			{
				if (StringUtil.hasAValue(schResourceId))
					rs = conn.select(query, new String[]{resourceId, schResourceId});
				else
					rs = conn.select(queryByResourceId, resourceId);
				if (rs.next())
				{
					resourceName = rs.getString("resource_name");
					setParameter("resource_name", resourceName, ic, savedParams);	// sch_resources_all_v.resource_name where sch_resources_all_v.res_sch_id =
					
					String availableId = rs.getString("res_status_type_id");
					if (availableId == null)
					{
						availableId = (String) ic.getAppGlobalDatum(IMSApplicationContextListener.RESOURCE_STATUS_TYPE_MAP + ":available");
					}
					setParameter("res_status_type_id", availableId, ic, savedParams);
	
					setParameter("weekend_sch_resource_id", rs.getString("weekend_sch_resource_id"),ic, savedParams);	// sch_resources_all_v.weekend_sch_resource_id where sch_resources_all_v.res_sch_id =
					setParameter("reason_type_id", rs.getString("reason_type_id"), ic, savedParams);	// sch_resources_all_v.reason_type_id where sch_resources_all_v.res_sch_id = 
					setParameter("job_id", rs.getString("job_id"), ic, savedParams);
					setParameter("service_id", rs.getString("service_id"), ic, savedParams);	// sch_resources_all_v.service_id where sch_resources_all_v.res_sch_id =
					setParameter("resource_qty", "1", ic, savedParams);
					String schNotes = rs.getString("sch_notes");
					if (schNotes == null) schNotes = "";
					setParameter("sch_notes", schNotes, ic, savedParams);	// sch_resources_all_v.sch_notes where sch_resources_all_v.res_sch_id =
					if (StringUtil.hasAValue(schResourceId))
						setParameter("res_start_time", startDate, ic, savedParams);	// sch_resources_all_v.res_start_time where sch_resources_all_v.res_sch_id =
					else
						setParameter("res_start_time", (String)ic.getSessionDatum("est_start_time_only"), ic, savedParams);				
					setParameter("date_confirmed", rs.getString("date_confirmed"), ic, savedParams);	// sch_resources_all_v.date_confirmed where sch_resources_all_v.res_sch_id =
	
					if(hasPDA(resourceId, ic, conn))
					{
						String sendToPdaFlag = rs.getString("send_to_pda_flag");
						if (!StringUtil.hasAValue(sendToPdaFlag)) sendToPdaFlag = "N";
						setParameter("send_to_pda_flag", sendToPdaFlag, ic, savedParams);
					}
					
					setParameter("res_start_date", startDate, ic, savedParams);				
					setParameter("res_end_date", endDate, ic, savedParams);
				}
			}
			finally
			{
				IMSUtil.closeQueryResultSet(rs);
			}

			setParameter("weekend_flag", "N", ic, savedParams);
			setParameter("new_job_id", jobId, ic, savedParams);
			setParameter("new_service_id", (String)ic.getSessionDatum("service_id"), ic, savedParams);
			
			String roleCode = (String)ic.getSessionDatum("role_code");
			if ("scheduler".equals(roleCode) && StringUtil.hasAValue(schResourceId))
				setParameter("sch_foreman_flag", "N", ic, savedParams);
			else
				setParameter("foreman_flag", "N", ic, savedParams);

			setParameter("report_to_type_id", "", ic, savedParams);				

			result = editSchResource(ic, conn, "add");
		}
		catch (Exception e)
		{
			Diagnostics.warning("Failed to add resource " + resourceName, e);
			SmartFormHandler.addSmartFormError(ic, "Failed to add resource " + resourceName + " - " + e.getMessage());
		}
		
		return result;
	}
	
	/**
	 * @param resourceId
	 * @param ic
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private boolean hasPDA(String resourceId, InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		String query = "SELECT u.user_id"
		             +  " FROM resources r, user_organizations_v u"
		             + " WHERE r.user_id = u.user_id"
					 +   " AND u.organization_id = ?"
					 +   " AND u.imobile_login is NOT NULL"
					 +   " AND r.resource_id = ?";
		String value = conn.selectFirst(query, new Object[]{ic.getSessionDatum("org_id"), resourceId});
		boolean result = false;
		if (StringUtil.hasAValue(value))
			result = true;
		
		return result;
	}

	/**
	 * Save a parameter so it may be restored.
	 * 
	 * @param ic
	 * @param savedParams
	 */
	public void setParameter(String parameterName, String newValue, InvocationContext ic, Map<String, String> savedParams)
	{
		savedParams.put(parameterName, ic.getParameter(parameterName));
		if (newValue == null) newValue = "";
		ic.setParameter(parameterName, newValue);
	}
	
	/**
	 * Restore the saved parameters.
	 * @param savedParams
	 * @author bvonhaden
	 *
	 * @version $Header: SchMultiAddHandler.java, 4, 3/6/2006 3:46:56 PM, Blake Von Haden$
	 */
	public void restoreParameters(Map<String, String> savedParams, InvocationContext ic)
	{
		Iterator paramNameList = savedParams.keySet().iterator();
		while (paramNameList.hasNext())
		{
			String name = (String)paramNameList.next();
			ic.setParameter(name, (String)savedParams.get(name));
		}
	}
}
