/*
 *                 Apex IT
 *
 * This software can only be used with the expressed written
 * consent of Apex IT. All rights reserved.
 *
 * Copyright 2007, Apex IT
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */

package ims.handlers.po;

import ims.helpers.MapUtil;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.HashMap;
import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @version $Id: POPreHandler.java, 1, 4/10/2008, David Zhao $
 */
public class POPreHandler extends BaseHandler {

	public static final String EXT_PO_ID = "extPOId"; 
	public static final String PO_MESSAGE = "poMessage"; 
	public static final String PO_ERROR_MESSAGE = "poErrorMessage"; 
	
	public static final String SELECT_VENDOR_NAME
		= "SELECT RTRIM(vendname) vendor_name "
		+ "  FROM pm00200 "
		+ " WHERE vendorid = ?";
	
	public static final String SELECT_EXT_ITEM_ID
		= "SELECT ext_item_id "
		+ "  FROM items "
		+ " WHERE item_id = ?";
	
//	public static final String SELECT_JOB_NO
//		= "SELECT j.job_no "
//		+ "  FROM services s INNER JOIN "
//		+ "       jobs j ON s.job_id = j.job_id "
//		+ " WHERE s.request_id = ?"; 
	
	public static final String SELECT_JOB_INFO
		= "SELECT p.project_no,"
		+ "       u.ext_employee_id "
		+ "  FROM projects p INNER JOIN "
		+ "       requests r ON p.project_id = r.project_id LEFT OUTER JOIN "
		+ "       jobs j ON p.project_id = j.project_id LEFT OUTER JOIN "
		+ "       users u ON j.billing_user_id = u.user_id "
		+ " WHERE r.request_id = ?"; 
	

	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic) throws Exception {
		Diagnostics.trace("POPreHandler.HandleEnvironment()");
		boolean result = true;
		
		ConnectionWrapper gpConn = null;
		
		try {

			String gpOrg = (String)ic.getRequiredSessionDatum("org_resource");
			gpConn = (ConnectionWrapper)ic.getResource(gpOrg);
			
			String extVendorId = ic.getParameter("ext_vendor_id");
			String vendorName = getVendorName(ic, gpConn, extVendorId);
			ic.setParameter("vendor_name", vendorName);
			
			ic.removeSessionDatum(PO_ERROR_MESSAGE);
			
			ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
			
			String button = ic.getParameter("po_button");
//			String mode = ic.getRequiredParameter("mode");
//			String requestId = (String) ic.getSessionDatum("request_id");
			
//			String poId = ic.getParameter("po_id");
			
			if (StringUtil.hasAValue(button)) {
				result = setPOStatus(ic, conn, gpConn, gpOrg);
	
			}
		} catch (Exception e) {
			result = false;
			Diagnostics.error("Exception in POPreHandler.handleEnvironment()", e);
		} finally {
			if (gpConn != null) gpConn.release();
		}

		Diagnostics.trace("POPreHandler result ='" + result + "'");
		return result;
	}

	private boolean setPOStatus(InvocationContext ic, ConnectionWrapper conn, ConnectionWrapper gpConn, String gpOrg) throws Exception {
		Diagnostics.trace("POPreHandler.setPOStatus()");
		boolean result = true;

		try {
			Map statusMap = MapUtil.getTypeMap(conn, "po_status_type");
			String poId = ic.getParameter("po_id");
			String statusId = ic.getParameter("po_status_id");
			String action = ic.getParameter("po_button");
			String extPOId = ic.getParameter("ext_po_id");
			String projectRequestPONo = ic.getParameter("project_request_po_no");
			String poMessage = null;

			if ("cancel".equalsIgnoreCase(action) && StringUtil.hasAValue(poId)) {
				
				if (((String) statusMap.get("new")).equals(statusId) || ((String) statusMap.get("released")).equals(statusId)) {
					if (((String) statusMap.get("released")).equals(statusId)) {
						poMessage = POStatusHandler.cancelPOInGreatPlains(ic, gpConn, gpOrg, extPOId);
					}
					
					if (StringUtil.hasAValue(poMessage)) {
						ic.setSessionDatum(PO_ERROR_MESSAGE, "Failed to cancel PO (" + projectRequestPONo + "). " + poMessage);
					} else {
						ic.setParameter("po_status_id", (String) statusMap.get("canceled"));
						ic.setParameter("po_status_code", "canceled"); 
						ic.setParameter("date_canceled", conn.now());
						ic.removeSessionDatum(PO_ERROR_MESSAGE);
					}
				}
			} else if ("save".equalsIgnoreCase(action)) {
//				ic.setParameter("request_status_id", (String) statusMap.get("new"));
//				ic.setParameter("request_status_code", "new"); 
			} else if ("send".equalsIgnoreCase(action)) {
//				boolean isRequestSent = "y".equalsIgnoreCase((String) ic.getSessionDatum("request_is_sent")) ? true : false;
//				if (isRequestSent && ((String) statusMap.get("new")).equals(statusId)) {
				if (((String) statusMap.get("new")).equals(statusId)) {
					
					Map releaseResult = releasePOToGreatPlains(ic, conn, gpConn, gpOrg, (String) statusMap.get("released"));
					extPOId = (String) releaseResult.get(EXT_PO_ID);
					
					if(StringUtil.hasAValue(extPOId)) {
						ic.setParameter("ext_po_id", extPOId);
						ic.setParameter("po_status_id", (String) statusMap.get("released"));
						ic.setParameter("po_status_code", "released"); 
						ic.setParameter("date_released", conn.now());
					} else {
						Diagnostics.error("Failed to release PO (" + projectRequestPONo + "): " + (String) releaseResult.get(PO_MESSAGE));
					}
				}
			} else {
				Diagnostics.error("POPreHandler.setPOStatus() Unknown action '" + action + "'");
			}
		} catch (Exception e) {
			result = false;
			Diagnostics.error("Exception in POPreHandler.setPOStatus()", e);
		}finally {

		}

		return result;
	}

	private Map releasePOToGreatPlains(InvocationContext ic, ConnectionWrapper conn, ConnectionWrapper gpConn, String gpOrg, String statusId) throws SQLException {
		Map<String,String> result = new HashMap<String,String>();
		CallableStatement stmt = null;
		int iErrorState = 0;
		String extPOId = null;
		
		try {
			String projectRequestPONo = ic.getParameter("project_request_po_no");
			String extVendorId = ic.getParameter("ext_vendor_id");
			String extVendorAddressId = ic.getParameter("ext_vendor_address_id");
			String extItemId = getExtItemId(ic, conn, ic.getParameter("item_id"));
			double poTotal = Double.parseDouble(ic.getParameter("po_total"));
			String description = ic.getParameter("description");
			String requestId = ic.getParameter("request_id");
			Map jobInfoMap = getProjectNo(ic, conn, requestId);
			String commentText = null;
			
			if (description.length() > 500) {
				commentText = description.substring(0,500);
			} else {
				commentText = description;
			}
			
			if (!StringUtil.hasAValue((String) jobInfoMap.get("jobNo"))) {
				result.put(PO_MESSAGE, "Fail to release po(" + projectRequestPONo + "): job_no is NULL.");
				return result;
			}
			
			stmt = gpConn.prepareCall("{call ott_spPOPCreatePO(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			stmt.setString(1, extPOId);
			stmt.registerOutParameter(1, Types.CHAR);
			stmt.setString(2,(String) jobInfoMap.get("jobNo"));
			stmt.setString(3, extVendorId);
			stmt.setString(4, extVendorAddressId);
			stmt.setString(5, extItemId);
			stmt.setDouble(6, poTotal);
			stmt.setString(7,(String) jobInfoMap.get("buyerId"));
			stmt.setString(8, description);
			stmt.setString(9, commentText);
			stmt.registerOutParameter(10, Types.INTEGER);
			stmt.registerOutParameter(11, Types.CHAR);
			Diagnostics.error("POPreHandler.setPOStatus() Calling ott_spPOPCreatePO "
					+ " with '" + extPOId
					+ "','" + (String) jobInfoMap.get("jobNo")
					+ "','" + extVendorId
					+ "','" + extVendorAddressId
					+ "','" + extItemId
					+ "','" + poTotal					
					+ "','" + (String) jobInfoMap.get("buyerId")
					+ "','" + description					
					+ "','" + commentText
					+ "' for resource " + gpOrg);
			stmt.execute();

			iErrorState = stmt.getInt(10);
			String msg = "good";
			String extPoId = null;
			if (iErrorState != 0) {
				String sErrString = stmt.getString(11);
				msg = "Failed to release PO (" + projectRequestPONo + "): Error code: " + iErrorState + ". " + sErrString;
				ic.setSessionDatum(PO_ERROR_MESSAGE, msg);
			} else {
				extPoId = stmt.getString(1);
				ic.removeSessionDatum(PO_ERROR_MESSAGE);
			}
			Diagnostics.error("POPreHandler.releasePO() " + msg);
			result.put(EXT_PO_ID, extPoId);
			result.put(PO_MESSAGE, msg);
			
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in POPreHandler.releasePO");
		} finally {
			if (stmt != null) stmt.close();
		}

		return result;
	}
	
	private String getVendorName(InvocationContext ic, ConnectionWrapper conn, String extVendorId) throws SQLException {
		String result = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.prepareStatement(SELECT_VENDOR_NAME);
			stmt.setString(1, extVendorId);
			rs = stmt.executeQuery();
			if (rs.next()) {
				result = rs.getString("vendor_name");
			}
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in POPreHandler.getVendorName");
		} finally {
			if (stmt != null) stmt.close();
			if (rs != null) rs.close();
		}

		return result;

	}
	
	private String getExtItemId(InvocationContext ic, ConnectionWrapper conn, String itemId) throws SQLException {
		String result = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.prepareStatement(SELECT_EXT_ITEM_ID);
			stmt.setInt(1, Integer.parseInt(itemId));
			rs = stmt.executeQuery();
			if (rs.next()) {
				result = rs.getString("ext_item_id");
			}
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in POPreHandler.getExtItemId");
		} finally {
			if (stmt != null) stmt.close();
			if (rs != null) rs.close();
		}

		return result;

	}
	
//	private String getJobNo(InvocationContext ic, ConnectionWrapper conn, String requestId) throws SQLException {
//		String result = null;
//		PreparedStatement stmt = null;
//		ResultSet rs = null;
//
//		try {
//			stmt = conn.prepareStatement(SELECT_JOB_NO);
//			stmt.setInt(1, Integer.parseInt(requestId));
//			rs = stmt.executeQuery();
//			if (rs.next()) {
//				result = rs.getString("job_no");
//			}
//		} catch (Exception e) {
//			ErrorHandler.handleException(ic, e, "Problem in POPreHandler.getJobNo");
//		} finally {
//			if (stmt != null) stmt.close();
//			if (rs != null) rs.close();
//		}
//
//		return result;
//
//	}
	
	private Map getProjectNo(InvocationContext ic, ConnectionWrapper conn, String requestId) throws SQLException {
		Map<String, String> result = new HashMap<String, String>();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.prepareStatement(SELECT_JOB_INFO);
			stmt.setInt(1, Integer.parseInt(requestId));
			rs = stmt.executeQuery();
			if (rs.next()) {
				result.put("jobNo", rs.getString("project_no"));
				result.put("buyerId", rs.getString("project_no"));
			}
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in POPreHandler.getProjectNo");
		} finally {
			if (stmt != null) stmt.close();
			if (rs != null) rs.close();
		}

		return result;

	}

}