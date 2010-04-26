package ims.handlers.proj;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * @author dzhao
 * @version $Id: NewJobLocationHandler.java, 1, 8/21/2007, David Zhao $
 */
public class NewJobLocationHandler extends BaseHandler {	
	public static final String INSERT
	 	= "INSERT INTO job_locations (customer_id,"
	 	+ "                           job_location_name,"
	 	+ "                           location_type_id,"
	 	+ "                           street1,"
	 	+ "                           street2,"
	 	+ "                           city,"
	 	+ "                           county,"
	 	+ "                           state,"
	 	+ "                           zip,"
	 	+ "                           country,"
	 	+ "                           date_created,"	 	                              
	 	+ "                           created_by) "
	 	+ " SELECT ?, ?, l.lookup_id, ?, ?, ?, ?, ?, ?, ?, getdate(), ? "
	 	+ "   FROM lookups l JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id "
	 	+ "  WHERE lt.code='location_type' AND l.code = 'worksite'";
	
	public static final String UPDATE
	 	= "UPDATE job_locations "
	 	+ "   SET job_location_name = ?,"
	 	+ "       street1 = ?,"
	 	+ "       street2 = ?,"
	 	+ "       city = ?,"
	 	+ "       county = ?,"
	 	+ "       state = ?,"
	 	+ "       zip = ?,"
	 	+ "       country = ?,"
	 	+ "       active_flag = ?,"
	 	+ "       date_modified = getdate(),"	 	                              
	 	+ "       modified_by = ? "
	 	+ " WHERE job_location_id = ?";
	
	
    public void setUpHandler(){}
	public void destroy(){}


	public boolean handleEnvironment(InvocationContext ic) throws Exception {
		
		Diagnostics.trace("NewJobLocationHandler.handleEnvironment()");
		
		ConnectionWrapper conn = null;
		boolean result = true;
		
		try	{
			ic.removeSessionDatum("current_job_location_id");
			conn = (ConnectionWrapper) ic.getResource();

			String userId = (String) ic.getSessionDatum("user_id");
			String endUserId = ic.getParameter("end_user_id");
			String jobLocationName = ic.getParameter("job_location_name");
			String street1 = ic.getParameter("street1");
			String street2 = ic.getParameter("street2");
			String city = ic.getParameter("city");
			String county = ic.getParameter("county");
			String state = ic.getParameter("state");
			String zip = ic.getParameter("zip");
			String country = ic.getParameter("country");
			String active = ic.getParameter("active_flag") == null ? "N" : "Y";
			String jobLocationId = ic.getParameter("current_id");
			String button = ic.getParameter("button");
			
			if ("new".equalsIgnoreCase(button)) {
				save(conn, endUserId, jobLocationName, street1, street2, city, county, state, zip, country, userId);
				ic.setSessionDatum("current_job_location_id", getIdentity(conn));
			} else if ("view".equalsIgnoreCase(button)) {			
				update(conn, jobLocationName, street1, street2, city, county, state, zip, country, active, userId, jobLocationId);
			}
		} catch (Exception e) {
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in NewJobLocationHandler");
		} finally {
			if (conn != null) conn.release();
		}

		return result;
	}
	
	private void save(ConnectionWrapper conn, String endUserId, String jobLocationName, String street1, String street2, String city, String county, String state, String zip, String country, String userId) throws SQLException {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(INSERT);
			
			stmt.setString(1, endUserId);
			stmt.setString(2, jobLocationName);
			stmt.setString(3, street1);
			stmt.setString(4, street2);
			stmt.setString(5, city);
			stmt.setString(6, county);
			stmt.setString(7, state);
			stmt.setString(8, zip);
			stmt.setString(9, country);
			stmt.setString(10, userId);
	
			stmt.executeUpdate();
		} finally {
			if (stmt != null) stmt.close();
		}
	}
	
	private void update(ConnectionWrapper conn, String jobLocationName, String street1, String street2, String city, String county, String state, String zip, String country, String active, String userId, String jobLocationId) throws SQLException {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(UPDATE);

			stmt.setString(1, jobLocationName);
			stmt.setString(2, street1);
			stmt.setString(3, street2);
			stmt.setString(4, city);
			stmt.setString(5, county);
			stmt.setString(6, state);
			stmt.setString(7, zip);
			stmt.setString(8, country);
			stmt.setString(9, active);
			stmt.setString(10, userId);
			stmt.setString(11, jobLocationId);
	
			stmt.executeUpdate();
		} finally {
			if (stmt != null) stmt.close();
		}
	}
	
	private String getIdentity(ConnectionWrapper conn) throws SQLException {
		
		String result = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(NewContactHandler.SELECT_IDENTITY);
			
			if (rs.next()) {
				result = rs.getString("current_id");
			}
		} catch (Exception e) {
			Diagnostics.error("Exception retrieving @@IDENTITY: " + e);
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
		}

		return result;
	}

}
