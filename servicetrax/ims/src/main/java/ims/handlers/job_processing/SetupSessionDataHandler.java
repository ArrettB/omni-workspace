package ims.handlers.job_processing;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * 
 * @version $Id: SetupSessionDataHandler.java, 7, 1/24/2006 4:47:12 PM, Blake Von Haden$
 */
public class SetupSessionDataHandler extends BaseHandler {
	
	public static final String SELECT_NEW_CONTACTS
		= "SELECT a_m_contact_id,"
		+ "       a_m_sales_contact_id,"
		+ "       job_location_contact_id,"
		+ "       customer_contact_id,"
		+ "       customer_contact2_id,"
		+ "       customer_contact3_id,"
		+ "       customer_contact4_id, "
		+ "       job_location_id "
		+ "  FROM requests "
		+ " WHERE request_id = ?";
		
	
	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.trace("SetupSessionDataHandler.handleEnvironment()");
		boolean result = true;
		ConnectionWrapper conn = null;
		boolean close_connection = false;

		try
		{
			conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

			if (conn == null)
			{
				conn = (ConnectionWrapper) ic.getResource();
				close_connection = true;
			}

			result = setSessionData(ic, conn);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Problem in SetupSessionDataHandler");
			result = false;
		}
		finally
		{
			if (conn != null && close_connection)
				conn.release();
		}
		return result;
	}

	private boolean setSessionData(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("SetupSessionDataHandler.setSessionData()");
		String job_id = ic.getParameter("job_id");
		String service_id = ic.getParameter("service_id");
		boolean isNew = false;
		String requestId = null;
		boolean result = true;

		String query 
			= "SELECT customer_id, customer_name, ext_customer_id, end_user_id, end_user_name, ext_dealer_id,"
			+ "       job_status_type_code, a_m_sales_contact_id, is_new "
			+ "  FROM jobs_v WHERE job_id = " + conn.toSQLString(job_id);
		Diagnostics.debug2("job query = " + query);
		QueryResults rs = null;
		try
		{
			rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
				ic.setSessionDatum("job_id", job_id);
				ic.setSessionDatum("customer_id", rs.getString("customer_id"));
				ic.setSessionDatum("customer_name", rs.getString("customer_name"));
				ic.setSessionDatum("end_user_id", rs.getString("end_user_id"));
				ic.setSessionDatum("end_user_name", rs.getString("end_user_name"));
				ic.setSessionDatum("ext_customer_id", rs.getString("ext_customer_id"));
				ic.setSessionDatum("ext_dealer_id", rs.getString("ext_dealer_id"));
				ic.setSessionDatum("job_status_type_code", rs.getString("job_status_type_code"));
				ic.setSessionDatum("a_m_sales_contact_id", rs.getString("a_m_sales_contact_id"));
				
				if (rs.getString("job_status_type_code") != null && rs.getString("job_status_type_code").equalsIgnoreCase("closed")) {
					ic.setSessionDatum("readonly", "true");
				} else {
					ic.removeSessionDatum("readonly");
				}
					
				isNew = "Y".equalsIgnoreCase(rs.getString("is_new")) ? true : false;
				ic.setSessionDatum("is_new", rs.getString("is_new").toUpperCase());
			}
			else
			{// clear job info from session
				ic.removeSessionDatum("job_id");
				ic.removeSessionDatum("customer_id");
				ic.removeSessionDatum("customer_name");
				ic.removeSessionDatum("end_user_id");
				ic.removeSessionDatum("end_user_name");
				ic.removeSessionDatum("ext_customer_id");
				ic.removeSessionDatum("ext_dealer_id");
				ic.removeSessionDatum("job_status_type_code");
				ic.removeSessionDatum("a_m_sales_contact_id");
				ic.removeSessionDatum("readonly");
				ic.removeSessionDatum("is_new");
				result = false;
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}

		query = "SELECT serv_status_type_code, request_id FROM services_v WHERE service_id = " + conn.toSQLString(service_id);
		Diagnostics.debug2("service query = " + query);
		try
		{
			rs = conn.resultsQueryEx(query);
			if (rs.next())
			{
				ic.setSessionDatum("service_id", service_id);
				ic.setSessionDatum("serv_status_type_code", rs.getString("serv_status_type_code"));
				requestId = rs.getString("request_id");
			}
			else
			{// clear service info from session
				ic.removeSessionDatum("service_id");
				ic.removeSessionDatum("serv_status_type_code");
				result = false;
			}
		}
		finally
		{
			if (rs != null)
				rs.close();
		}
		
//		if (result && isNew) {
//			result = setNewContacts(ic, conn, requestId);
//		}

		return result;
	}
	
	private boolean setNewContacts(InvocationContext ic, ConnectionWrapper conn, String requestId) throws Exception {
		Diagnostics.trace("SetupSessionDataHandler.setNewContacts()");
		boolean result = true;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			stmt = conn.prepareStatement(SELECT_NEW_CONTACTS);
			stmt.setString(1, requestId);
			rs = stmt.executeQuery();
			
			if (rs.next()) {
				ic.setTransientDatum("a_m_contact_id", rs.getString("a_m_contact_id"));
				ic.setTransientDatum("a_m_sales_contact_id", rs.getString("a_m_sales_contact_id"));
				ic.setTransientDatum("job_location_contact_id", rs.getString("job_location_contact_id"));
				ic.setTransientDatum("customer_contact_id", rs.getString("customer_contact_id"));
				ic.setTransientDatum("customer_contact2_id", rs.getString("customer_contact2_id"));
				ic.setTransientDatum("customer_contact3_id", rs.getString("customer_contact3_id"));
				ic.setTransientDatum("customer_contact4_id", rs.getString("customer_contact4_id"));
				ic.setTransientDatum("job_location_id", rs.getString("job_location_id"));
			}
		}catch (Exception e) {
			Diagnostics.error("Error in SetupSessionDataHandler.setNewContacts():" + e);
			result = false;
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
		}
		
		return result;
	}
	
	
}
