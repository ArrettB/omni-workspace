package ims.handlers.proj;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author dzhao
 * @version $Id: NewContactHandler.java, 1, 7/18/2007, David Zhao $
 */
public class NewContactHandler extends BaseHandler {
	
	public static final String INSERT_NEW_CUSTOMER_CONTACT
		= "INSERT INTO contacts (contact_name," 
	 	+ "  	 	             organization_id,"
	 	+ "                      ext_dealer_id,"
	 	+ "                      customer_id,"
	 	+ "                      contact_type_id,"
	 	+ "                      cont_status_type_id,"
	 	+ "                      phone_work,"
	 	+ "                      phone_cell,"
	 	+ "                      phone_home,"
	 	+ "                      email,"
	 	+ "                      date_created,"
	 	+ "                      created_by) "
	 	+ " SELECT ?, ?, ?, ?, ?, l.lookup_id, ?, ?, ?, ?, getdate(), ? " 
	 	+ "   FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id "
	 	+ "  WHERE l.code='active' AND lt.code='contact_status_type'";
	
	public static final String INSERT_NEW_JOB_LOCATION_CONTACT
	 	= "INSERT INTO contacts (contact_name," 
	 	+ "  	 	             organization_id,"
	 	+ "                      ext_dealer_id,"
	 	+ "                      contact_type_id,"
	 	+ "                      cont_status_type_id,"
	 	+ "                      phone_work,"
	 	+ "                      phone_cell,"
	 	+ "                      phone_home,"
	 	+ "                      email,"
	 	+ "                      date_created,"
	 	+ "                      created_by) "
	 	+ " SELECT ?, ?, ?, ?, l.lookup_id, ?, ?, ?, ?, getdate(), ? " 
	 	+ "   FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id "
	 	+ "  WHERE l.code='active' AND lt.code='contact_status_type'";
	
	public static final String SELECT_IDENTITY = "SELECT @@IDENTITY current_id";
	
	public static final String INSERT_JOB_LOCATION_CONTACT
	 	= "INSERT INTO job_location_contacts (job_location_id," 
	 	+ "  	 	                          contact_id,"
	 	+ "                                   created_by,"
	 	+ "                                   date_created) "
	 	+ " VALUES (?, ?, ?, getdate())"; 
	
	public static final String DELETE_JOB_LOCATION_CONTACT
	 	= "DELETE FROM job_location_contacts WHERE job_location_id = ? AND contact_id = ?"; 	
	
	public static final String INSERT_CONTACT_GROUP
		= "INSERT INTO contact_groups (contact_id,"
		+ "                            contact_type_id," 
	 	+ "                            created_by,"
	 	+ "                            date_created) "
	 	+ " SELECT ?, ?, ?, getdate()";
	
	public static final String UPDATE_CONTACT
		= "UPDATE contacts "
		+ "   SET contact_name = ?,"
		+ "       phone_work = ?,"
		+ "       phone_cell = ?,"
		+ "       phone_home = ?,"
		+ "       email = ?,"
	 	+ "       date_modified = getdate(),"
	 	+ "       modified_by = ? "
		+ " WHERE contact_id = ?";
	
	public static final String DEACTIVATE_CONTACT
		= "UPDATE contacts "
		+ "   SET contact_name = ?,"
		+ "       phone_work = ?,"
		+ "       phone_cell = ?,"
		+ "       phone_home = ?,"
		+ "       email = ?,"
	 	+ "       date_modified = getdate(),"
	 	+ "       modified_by = ?,"
	 	+ "       cont_status_type_id = (SELECT lookup_id"
	 	+ "                                FROM lookups l INNER JOIN " 
	 	+ "                                     lookup_types lt ON l.lookup_type_id=lt.lookup_type_id " 
	 	+ "                               WHERE lt.code='contact_status_type' AND l.code='inactive') " 
		+ " WHERE contact_id = ?";

	
    public void setUpHandler(){}
	public void destroy(){}


	public boolean handleEnvironment(InvocationContext ic) throws Exception {
		
		Diagnostics.trace("NewContactHandler.handleEnvironment()");
		
		ConnectionWrapper conn = null;
		boolean result = true;
		
		try	{
			ic.removeSessionDatum("current_contact_id");
			
			conn = (ConnectionWrapper) ic.getResource();

			String userId = (String) ic.getSessionDatum("user_id");
			String organizationId = (String) ic.getSessionDatum("org_id");
			String extDealerId = (String) ic.getSessionDatum("ext_dealer_id");
			String customerId = (String) ic.getParameter("customer_id");
			String jobLocationId = (String) ic.getParameter("contact_job_location_id");
			String paramType = ic.getParameter("param_type");
			
			String contactId = ic.getParameter("current_id");
			String contactName = ic.getParameter("contact_name");
			String contactTypeId = ic.getParameter("contact_type_id");
			String workPhone= ic.getParameter("phone_work");
			String cellPhone= ic.getParameter("phone_cell");
			String homePhone= ic.getParameter("phone_home");
			String email = ic.getParameter("email");
			String button = ic.getParameter("button");
			
			String active = ic.getParameter("cont_status_type_id");
			
			if (!StringUtil.hasAValue(workPhone)) {
				workPhone = null;
			}
			
			if (!StringUtil.hasAValue(cellPhone)) {
				cellPhone = null;
			}
			
			if (!StringUtil.hasAValue(homePhone)) {
				homePhone = null;
			}
			
			if (!StringUtil.hasAValue(email)) {
				email = null;
			}
			
			if ("new".equalsIgnoreCase(button)) {
				if ("customer".equals(paramType)) {
					saveNewCustomerContact(conn, userId, organizationId, extDealerId, customerId, contactName, contactTypeId, workPhone, cellPhone, homePhone, email);
					String newContactId =  getIdentity(conn);
					ic.setSessionDatum("current_contact_id", newContactId);
					saveCustomerContactGroup(conn, userId, newContactId, contactTypeId);
				} else {
					saveNewJobLocationContact(conn, userId, organizationId, extDealerId, contactName, contactTypeId, workPhone, cellPhone, homePhone, email);
					String newContactId =  getIdentity(conn);
					saveJobLocationContact(conn, jobLocationId, newContactId, userId);
					ic.setSessionDatum("current_contact_id", newContactId);
				}
			} else if ("view".equalsIgnoreCase(button)){
				if ("customer".equals(paramType)) {
					updateCustomerContact(conn, contactName, workPhone, cellPhone, homePhone, email, userId, contactId, active);
				} else {
					updateJobLocationContact(conn, contactName, workPhone, cellPhone, homePhone, email, userId, contactId);
					if (active == null) {
						deleteJobLocationContact(conn, jobLocationId, contactId);
					}
				}
				

			}
		} catch (Exception e) {
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in NewContactHandler");
		} finally {
			if (conn != null) conn.release();
		}

		return result;
	}
	
	private void saveNewCustomerContact(ConnectionWrapper conn, String userId, String organizationId, String extDealerId, String customerId, String contactName, String contactTypeId, String workPhone, String cellPhone, String homePhone, String email) throws SQLException {

		PreparedStatement stmt = null;
			
		try {				
			stmt = conn.prepareStatement(INSERT_NEW_CUSTOMER_CONTACT);
		
			stmt.setString(1, contactName);
			stmt.setString(2, organizationId);
			stmt.setString(3, extDealerId);
			stmt.setString(4, customerId);
			stmt.setString(5, contactTypeId);
			stmt.setString(6, workPhone);
			stmt.setString(7, cellPhone);
			stmt.setString(8, homePhone);
			stmt.setString(9, email);
			stmt.setString(10, userId);
			
			stmt.executeUpdate();			
		} catch (Exception e) {
			Diagnostics.error("Exception saving new customer contact: " + e);	
		} finally {
			if (stmt != null) stmt.close();
		}
	}
	
	private void saveCustomerContactGroup(ConnectionWrapper conn, String userId, String contactId, String contactTypeId) throws SQLException {

		PreparedStatement stmt = null;
			
		try {		
			stmt = conn.prepareStatement(INSERT_CONTACT_GROUP);
			
			stmt.setString(1, contactId);
			stmt.setString(2, contactTypeId);
			stmt.setString(3, userId);
			
			stmt.executeUpdate();			
		}catch (Exception e) {
			Diagnostics.error("Exception saving new customer contact group: " + e);				
		} finally {
			if (stmt != null) stmt.close();
		}
	}
	
	private void saveNewJobLocationContact(ConnectionWrapper conn, String userId, String organizationId, String extDealerId, String contactName, String contactTypeId, String workPhone, String cellPhone, String homePhone, String email) throws SQLException {
		
		PreparedStatement stmt = null;
		
		try {
				stmt = conn.prepareStatement(INSERT_NEW_JOB_LOCATION_CONTACT);
				
				stmt.setString(1, contactName);
				stmt.setString(2, organizationId);
				stmt.setString(3, extDealerId);
				stmt.setString(4, contactTypeId);
				stmt.setString(5, workPhone);
				stmt.setString(6, cellPhone);
				stmt.setString(7, homePhone);
				stmt.setString(8, email);
				stmt.setString(9, userId);
				
				stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception saving new job location contact: " + e);				
		} finally {
			if (stmt != null) stmt.close();
		}
	}
	
	private void saveJobLocationContact(ConnectionWrapper conn, String jobLocationId, String contactId, String userId) throws SQLException {
		
		PreparedStatement stmt = null;
		
		try {
				stmt = conn.prepareStatement(INSERT_JOB_LOCATION_CONTACT);
				
				stmt.setString(1, jobLocationId);
				stmt.setString(2, contactId);
				stmt.setString(3, userId);
				
				stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception saving new job location contact: " + e);				
		} finally {
			if (stmt != null) stmt.close();
		}
	}
	
	private void deleteJobLocationContact(ConnectionWrapper conn, String jobLocationId, String contactId) throws SQLException {
		
		PreparedStatement stmt = null;
		
		try {
				stmt = conn.prepareStatement(DELETE_JOB_LOCATION_CONTACT);
				
				stmt.setString(1, jobLocationId);
				stmt.setString(2, contactId);
				
				stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception saving new job location contact: " + e);				
		} finally {
			if (stmt != null) stmt.close();
		}
	}
	
	private void updateCustomerContact(ConnectionWrapper conn, String contactName, String workPhone, String cellPhone, String homePhone, String email,  String userId, String contactId, String active) throws SQLException {
		
		PreparedStatement stmt = null;
		
		try {
				if (active == null) {
					stmt = conn.prepareStatement(DEACTIVATE_CONTACT);
				} else {
					stmt = conn.prepareStatement(UPDATE_CONTACT);
				}
				
				stmt.setString(1, contactName);
				stmt.setString(2, workPhone);
				stmt.setString(3, cellPhone);
				stmt.setString(4, homePhone);
				stmt.setString(5, email);
				stmt.setString(6, userId);
				stmt.setString(7, contactId);
				
				stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception updating contact (" + contactId + "): " + e);						
		} finally {
			if (stmt != null) stmt.close();
		}	
	}
	
	private void updateJobLocationContact(ConnectionWrapper conn, String contactName, String workPhone, String cellPhone, String homePhone, String email,  String userId, String contactId) throws SQLException {
		
		PreparedStatement stmt = null;
		
		try {
				stmt = conn.prepareStatement(UPDATE_CONTACT);
				
				stmt.setString(1, contactName);
				stmt.setString(2, workPhone);
				stmt.setString(3, cellPhone);
				stmt.setString(4, homePhone);
				stmt.setString(5, email);
				stmt.setString(6, userId);
				stmt.setString(7, contactId);
				
				stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("Exception updating contact (" + contactId + "): " + e);						
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
			rs = stmt.executeQuery(SELECT_IDENTITY);
			
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
