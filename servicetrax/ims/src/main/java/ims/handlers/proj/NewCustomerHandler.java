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
import dynamic.util.string.StringUtil;

/**
 * @author dzhao
 * @version $Id: NewCustomerHandler.java, 1, 8/3/2007, David Zhao $
 */
public class NewCustomerHandler extends BaseHandler {
	public static final String INSERT_CUSTOMER
	 	= "INSERT INTO customers (organization_id,"
	 	+ "                       customer_name,"
	 	+ "                       customer_type_id,"
	 	+ "                       street1,"
	 	+ "                       street2,"
	 	+ "                       city,"
	 	+ "                       county,"
	 	+ "                       state,"
	 	+ "                       zip,"
	 	+ "                       country,"
	 	+ "                       active_flag,"
	 	+ "                       date_created,"
	 	+ "                       created_by,"
	 	+ "                       ext_dealer_id) "
	 	+ " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y', getdate(), ?, ?)";

	public static final String INSERT_END_USER
	 	= "INSERT INTO customers (organization_id,"
	 	+ "                       customer_name,"
	 	+ "                       customer_type_id,"
	 	+ "                       active_flag,"
	 	+ "                       date_created,"
	 	+ "                       created_by,"
	 	+ "                       end_user_parent_id,"
	 	+ "                       ext_dealer_id) "
	 	+ " SELECT ?, ?, ?, 'Y', getdate(), ?, ?,"
	 	+ "        CASE l.code WHEN 'dealer' THEN ISNULL(c.ext_customer_id, c.ext_dealer_id) "
	 	+ "                    ELSE c.ext_dealer_id END "
	 	+ "   FROM customers c INNER JOIN lookups l ON c.customer_type_id=l.lookup_id "
	 	+ "                    INNER JOIN lookup_types lt ON l.lookup_type_id = lt.lookup_type_id "
	 	+ "  WHERE lt.code='customer_type' AND c.customer_id = ?";

	public static final String UPDATE_CUSTOMER
	 	= "UPDATE customers "
	 	+ "   SET customer_name = ?,"
	 	+ "       customer_type_id = ?,"
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
	 	+ " WHERE customer_id = ?";

	public static final String UPDATE_END_USER
	 	= "UPDATE customers "
	 	+ "   SET customer_name = ?,"
	 	+ "       customer_type_id = ?,"
	 	+ "       active_flag = ?,"
	 	+ "       date_modified = getdate(),"
	 	+ "       modified_by = ? "
	 	+ " WHERE customer_id = ?";

	public static final String SELECT_CUSTOMER_TYPE
		= "SELECT l.code "
		+ "  FROM lookups l INNER JOIN "
		+ "       lookup_types lt ON l.lookup_type_id = lt.lookup_type_id "
		+ " WHERE lt.code = 'customer_type' AND l.lookup_id = ?";



    public void setUpHandler(){}
	public void destroy(){}


	public boolean handleEnvironment(InvocationContext ic) throws Exception {
		Diagnostics.trace("NewCustomerHandler.handleEnvironment()");

		ConnectionWrapper conn = null;
		boolean result = true;

		try	{
			ic.removeSessionDatum("current_customer_id");
			ic.removeSessionDatum("current_end_user_id");
			conn = (ConnectionWrapper) ic.getResource();

			String userId = (String) ic.getSessionDatum("user_id");
			String organizationId = (String) ic.getSessionDatum("org_id");
			String extDealerId = (String) ic.getSessionDatum("ext_dealer_id");
			String extDirectDealerId = (String) ic.getSessionDatum("ext_direct_dealer_id");

			if (StringUtil.hasAValue(extDirectDealerId)) {
				extDealerId = extDirectDealerId;
			}

			String customerType = ic.getParameter("customer_type");
			String endUserParentId = ic.getParameter("end_user_parent_id");

			String customerName = ic.getParameter("customer_name");
			String customerTypeId = ic.getParameter("customer_type_id");
			String street1 = ic.getParameter("street1");
			String street2 = ic.getParameter("street2");
			String city = ic.getParameter("city");
			String county = ic.getParameter("county");
			String state = ic.getParameter("state");
			String zip = ic.getParameter("zip");
			String country = ic.getParameter("country");
			String active = ic.getParameter("active_flag") == null ? "N" : "Y";
			String currentId = ic.getParameter("current_id");
			String button = ic.getParameter("button");

			try
			{
				if (street1.equals("")) street1 = null;
				if (street2.equals("")) street2 = null;
				if (city.equals("")) city = null;
				if (county.equals("")) county = null;
				if (state.equals("XXX")) state = null;
				if (zip.equals("")) zip = null;
				if (country.equals("")) country = null;
			}
			catch(NullPointerException e)
			{

			}


			String dealerTypeId = (String) ic.getAppGlobalDatum("customerType:dealer");
			String endUserTypeId = (String) ic.getAppGlobalDatum("customerType:end_user");

			if (!StringUtil.hasAValue(endUserParentId)) {
				endUserParentId = null;
			}

			if ("new".equalsIgnoreCase(button)) {
				if ("end_user".equals(customerType)) {
					saveEndUser(conn, userId, organizationId, endUserParentId, customerName, endUserTypeId);
					ic.setSessionDatum("current_end_user_id", getIdentity(conn));
				} else {
					saveCustomer(conn, userId, organizationId, extDealerId, customerName, customerTypeId, street1, street2, city, county, state, zip, country);
					String newCustomerId = getIdentity(conn);

					if (!dealerTypeId.equalsIgnoreCase(customerTypeId)) {
						saveEndUser(conn, userId, organizationId, newCustomerId, customerName, endUserTypeId);
						ic.setSessionDatum("current_end_user_id", getIdentity(conn));
					}
					ic.setSessionDatum("current_customer_id", newCustomerId);
				}
			} else if ("view".equalsIgnoreCase(button)) {
				if ("end_user".equals(customerType)) {
					updateEndUser(conn, customerName, customerTypeId, active, userId, currentId);
				} else {
					updateCustomer(conn, customerName, customerTypeId, street1, street2, city, county, state, zip, country, active, userId, currentId);
				}
			}

		} catch (Exception e) {
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in NewCustomerHandler");
		} finally {
			if (conn != null) conn.release();
		}

		return result;
	}
	private void saveCustomer(ConnectionWrapper conn, String userId, String organizationId, String extDealerId, String customerName, String customerTypeId, String street1, String street2, String city, String county, String state, String zip, String country) throws SQLException {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(INSERT_CUSTOMER);

			stmt.setString(1, organizationId);
			stmt.setString(2, customerName);
			stmt.setString(3, customerTypeId);
			stmt.setString(4, street1);
			stmt.setString(5, street2);
			stmt.setString(6, city);
			stmt.setString(7, county);
			stmt.setString(8, state);
			stmt.setString(9, zip);
			stmt.setString(10, country);
			stmt.setString(11, userId);
			stmt.setString(12, extDealerId);

			stmt.executeUpdate();
		} finally {
			if (stmt != null) stmt.close();
		}
	}

	private void saveEndUser(ConnectionWrapper conn, String userId, String organizationId, String endUserParentId, String customerName, String customerTypeId) throws SQLException {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(INSERT_END_USER);

			stmt.setString(1, organizationId);
			stmt.setString(2, customerName);
			stmt.setString(3, customerTypeId);
			stmt.setString(4, userId);
			stmt.setString(5, endUserParentId);
			stmt.setString(6, endUserParentId);

			stmt.executeUpdate();
		} finally {
			if (stmt != null) stmt.close();
		}
	}

	private void updateCustomer(ConnectionWrapper conn, String customerName, String customerTypeId, String street1, String street2, String city, String county, String state, String zip, String country, String active, String userId, String customerId) throws SQLException {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(UPDATE_CUSTOMER);

			stmt.setString(1, customerName);
			stmt.setString(2, customerTypeId);
			stmt.setString(3, street1);
			stmt.setString(4, street2);
			stmt.setString(5, city);
			stmt.setString(6, county);
			stmt.setString(7, state);
			stmt.setString(8, zip);
			stmt.setString(9, country);
			stmt.setString(10, active);
			stmt.setString(11, userId);
			stmt.setString(12, customerId);

			stmt.executeUpdate();
		} finally {
			if (stmt != null) stmt.close();
		}
	}

	private void updateEndUser(ConnectionWrapper conn, String customerName, String customerTypeId, String active, String userId, String customerId) throws SQLException {
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(UPDATE_END_USER);

			stmt.setString(1, customerName);
			stmt.setString(2, customerTypeId);
			stmt.setString(3, active);
			stmt.setString(4, userId);
			stmt.setString(5, customerId);

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
