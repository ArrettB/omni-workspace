package ims.handlers.po;

import ims.handlers.query.RecordListQueryHandler;
import ims.helpers.MapUtil;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;


/**
 * @version $Id: POStatusHandler.java 1 2008-04-16 dzhao $
 */
public class POStatusHandler extends BaseHandler {
	
	public static final String RECEIVE_PO
		= "UPDATE purchase_orders "
		+ "   SET po_status_id = ?," 
		+ "       date_received = getdate(), "
		+ "       modified_by = ?,"
		+ "       date_modified = getdate() "
		+ " WHERE po_id = ?";
	
	public static final String CANCEL_PO
		= "UPDATE purchase_orders "
		+ "   SET po_status_id = ?," 
		+ "       date_canceled = getdate(), "
		+ "       modified_by = ?,"
		+ "       date_modified = getdate() "
		+ " WHERE po_id = ?";
	
	// Note the total and quantity are going in correctly.
	// They look reversed, but that is by design.
	// This is because a PO assumes that the rate is always $1.00 BY DEFINITION
	// and the qty thus is the total.
	public static final String INSERT_SERVICE_LINE
		= "INSERT INTO service_lines (organization_id, status_id, resource_id, item_id, service_line_date, created_by, date_created,"
		+ "                           tc_job_id, tc_job_no, tc_service_id, tc_service_no, tc_qty, tc_rate,"
		+ "                           bill_job_id, bill_job_no, bill_service_id, bill_service_no, bill_qty, bill_rate) "
		+ " SELECT c.organization_id, sls.status_id, re.resource_id, po.item_id, po.date_received, ?, getdate(),"
		+ "        j.job_id, j.job_no, s.service_id, s.service_no, po.po_total, 1,"
		+ "        j.job_id, j.job_no, s.service_id, s.service_no, po.po_total, 1 "
		+ "   FROM purchase_orders po INNER JOIN "
		+ "        requests r ON po.request_id=r.request_id INNER JOIN "
		+ "        jobs j ON r.project_id=j.project_id INNER JOIN "
		+ "        customers c ON j.customer_id=c.customer_id INNER JOIN "
		+ "        services s ON r.request_id=s.request_id LEFT OUTER JOIN "
		+ "        resources re ON po.ext_vendor_id = re.ext_vendor_id,"
		+ "        service_line_statuses sls"
		+ "  WHERE sls.code='Submitted' "
		+ "    AND po.po_id = ?";
	
	public static final String SELECT_PO
		= "SELECT po_id,"
		+ "       CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '-' + CONVERT(VARCHAR, po.po_no) project_request_po_no,"
		+ "       CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '.' + CONVERT(VARCHAR, r.version_no) project_request_no,"
		+ "       po.ext_po_id,"
		+ "       r.is_sent,"
	    + "       po.po_total " 
	    + "  FROM purchase_orders po INNER JOIN "
	    + "       requests r ON po.request_id = r.request_id INNER JOIN "
	    + "       projects p ON r.project_id = p.project_id "
	    + " WHERE ";
	

	public void setUpHandler() {
		Diagnostics.debug2("POStatusHandler.setUpHandler()");
	}

	public boolean handleEnvironment(InvocationContext ic) {
		boolean result = true;
		Diagnostics.debug2("POStatusHandler.handleEnvironment()");
		ConnectionWrapper conn = null;
		ConnectionWrapper gpConn = null;
		int idx = 0;
	
		Set<String>poIds = null;
		Set<String>updatedPoIds = null;
		Set poData = null;	

		try	{
			conn = (ConnectionWrapper)ic.getResource();
			
			String gpOrg = (String)ic.getRequiredSessionDatum("org_resource");
			gpConn = (ConnectionWrapper)ic.getResource(gpOrg);
			
			String[] archiveCheckBoxes = StringUtil.stringToArray(ic.getParameter("selectedIds"), ',');
			String toStatusCode = ic.getParameter("submit_status");
			
			String userId = (String) ic.getRequiredSessionDatum("user_id");

			String recordId;
			String poMessage = null;
			String poErrorMessage = "";
			if (archiveCheckBoxes !=  null)	{
				poIds = new HashSet<String>();
				updatedPoIds =  new HashSet<String>();
				for (int i = 0; i < archiveCheckBoxes.length; i++) {	
					idx = archiveCheckBoxes[i].indexOf(",");
					recordId = archiveCheckBoxes[i].substring(idx+1);
					poIds.add(recordId);
				}

				poData = getPOData(conn, ic, poIds);
				String doAction = null;
				
				for (Iterator iter = poData.iterator(); iter.hasNext();) {
					POReceiveData po = (POReceiveData) iter.next();
					String pojectRequestPoNo = po.getProjectRequestPONo();
					
					if (!"Y".equalsIgnoreCase(po.getIsRequestSent())) {
						poErrorMessage += "Cannot " + doAction + " PO (" + pojectRequestPoNo + "). Service Request (" 
									   + po.getProjectRequestNo() + ") must be sent first." + RecordListQueryHandler.NEW_LINE;
						continue;
					}
					
					String poId = po.getPoId();
					String extPOId = po.getExtPOId();
					Double poTOtal = po.getPoTotal();
					
					
					if (result && "received".equalsIgnoreCase(toStatusCode)) {
						poMessage = receivePOInGreatPlains(ic, gpConn, gpOrg, extPOId, poTOtal.doubleValue());	
						doAction = "receive"; 
					} else if (result && "canceled".equalsIgnoreCase(toStatusCode)) {
						poMessage = cancelPOInGreatPlains(ic, gpConn, gpOrg, extPOId);	
						doAction = "cancel";
					}	
					
					if (StringUtil.hasAValue(poMessage)) {
						poErrorMessage += "Failed to " + doAction + " PO (" + pojectRequestPoNo + ")." + poMessage + RecordListQueryHandler.NEW_LINE;
					} else {
						updatedPoIds.add(poId);
					}
				}
				
				if (result) {
					result = updatePOStatus(conn, ic, toStatusCode, userId, updatedPoIds);
				}
				
				if (result && "received".equalsIgnoreCase(toStatusCode)) {
					result = insertServiceLines(conn, ic, userId, updatedPoIds);
				}		
				
				if (StringUtil.hasAValue(poErrorMessage)) {
					ic.setTransientDatum(POPreHandler.PO_ERROR_MESSAGE, poErrorMessage);
				} 
			}
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in POStatusHandler");
			return false;
		} finally {
			if (gpConn != null) gpConn.release();
			if (conn != null) conn.release();
		}
		return result;
	}
	
	public static String cancelPOInGreatPlains(InvocationContext ic, ConnectionWrapper gpConn, String gpOrg,  String extPOId) throws SQLException {
		String result = null;
		CallableStatement stmt = null;
		int iErrorState = 0;
		
		try {
			stmt = gpConn.prepareCall("{call ott_spPOPUpdatePO(?, ?, ?, ?)}");
			stmt.setString(1, extPOId);
			stmt.setInt(2, 1);
			stmt.registerOutParameter(3, Types.INTEGER);
			stmt.registerOutParameter(4, Types.CHAR);
			Diagnostics.error("POPreHandler.setPOStatus() Calling ott_spPOPUpdatePO "
					+ " with '" + extPOId
					+ "', 1'" 
					+ "' for resource " + gpOrg);
			stmt.execute();

			iErrorState = stmt.getInt(3);

			if (iErrorState != 0) {
				String sErrString = stmt.getString(4);
				result = "Error code: " + iErrorState + ". " + sErrString;
			} 
			Diagnostics.error("POStatusHandler.cancelPOInGreatPlains() " + result);
			
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in POStatusHandler.cancelPOInGreatPlains");
			result = e.getLocalizedMessage();
		} finally {
			if (stmt != null) stmt.close();
		}

		return result;
	}
	
	public static String receivePOInGreatPlains(InvocationContext ic, ConnectionWrapper gpConn, String gpOrg, String extPOId, double poTotal) throws SQLException {
		String result = null;
		CallableStatement stmt = null;
		int iErrorState = 0;
		
		try {
			stmt = gpConn.prepareCall("{call ott_spPOPCompletePOReceipt(?, ?, ?, ?)}");
			stmt.setString(1, extPOId);
			stmt.setDouble(2, poTotal);
			stmt.registerOutParameter(3, Types.INTEGER);
			stmt.registerOutParameter(4, Types.CHAR);
			Diagnostics.error("POPreHandler.setPOStatus() Calling ott_spPOPUpdatePO "
					+ " with exPOId='" + extPOId
					+ "', poTotal='" +  poTotal
					+ "' for resource " + gpOrg);
			stmt.execute();

			iErrorState = stmt.getInt(3);

			if (iErrorState != 0) {
				String sErrString = stmt.getString(4);
				result = "Error code: " + iErrorState + ". " + sErrString;
			} 
			Diagnostics.error("POStatusHandler.receivePOInGreatPlains() " + result);
			
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in POStatusHandler.receivePOInGreatPlains");
			result = e.getLocalizedMessage();
		} finally {
			if (stmt != null) stmt.close();
		}

		return result;
	}
	
	private boolean updatePOStatus(ConnectionWrapper conn, InvocationContext ic, String toStatusCode, String userId, Set poIds) throws SQLException {
		boolean result = true;
		PreparedStatement stmt = null;
		
		try {
			
			if ("received".equalsIgnoreCase(toStatusCode)) {
				stmt = conn.prepareStatement(RECEIVE_PO);
			} else {
				stmt = conn.prepareStatement(CANCEL_PO);
			}
			
			Map request_types = MapUtil.getTypeMap(conn, "po_status_type");
			String toStatusId = (String) request_types.get(toStatusCode);
			
			stmt.setInt(1, Integer.parseInt(toStatusId));
			stmt.setInt(2, Integer.parseInt(userId));
			
			for (Iterator iter = poIds.iterator(); iter.hasNext();) {
				String poId = (String) iter.next();
				stmt.setInt(3, Integer.parseInt(poId));
				stmt.addBatch();
			}
			
			stmt.executeBatch();
			
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in POStatusHandler.updatePOStatus");
			result = false;
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return result;
	}
	
	private boolean insertServiceLines(ConnectionWrapper conn, InvocationContext ic, String userId, Set poIds) throws SQLException {
		boolean result = true;
		PreparedStatement stmt = null;
		
		try {
			stmt = conn.prepareStatement(INSERT_SERVICE_LINE);
			
			stmt.setInt(1, Integer.parseInt(userId));
			
			for (Iterator iter = poIds.iterator(); iter.hasNext();) {
				String poId = (String) iter.next();
				stmt.setInt(2, Integer.parseInt(poId));
				stmt.addBatch();
			}
			
			stmt.executeBatch();
			
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in POStatusHandler.insertServiceLines");
			result = false;
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return result;
	}
	
	private Set getPOData(ConnectionWrapper conn, InvocationContext ic, Set poIds) throws SQLException {
		Set<POReceiveData>result = new HashSet<POReceiveData>();
		Statement stmt = null;
		ResultSet rs = null;
		POReceiveData poData = null;
		
		try {
			InClause selectedClause = new InClause();
			for (Iterator iter = poIds.iterator(); iter.hasNext(); ) {
				String poId = (String) iter.next();
				selectedClause.add(poId);
			}
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery(SELECT_PO + selectedClause.getInClause("po_id"));
			
			while (rs.next()) {
				poData = new POReceiveData(rs.getString("po_id"), 
						                   rs.getString("project_request_po_no"), 
						                   rs.getString("project_request_no"), 
						                   rs.getString("ext_po_id"), 
						                   rs.getString("is_sent"), 
						                   rs.getDouble("po_total"));
				result.add(poData);
			}
			
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in POStatusHandler.getPOData");
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return result;
	}
	
	public void destroy() {
		Diagnostics.debug2("POStatusHandler.destroy()");
	}

}