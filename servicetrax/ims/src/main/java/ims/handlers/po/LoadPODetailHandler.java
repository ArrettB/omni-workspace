/*
 *               Apex IT
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2000-2008, Apex IT
 * $Id: LoadPODetailHandler.java, , 4/6/2008, David Zhao$
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
package ims.handlers.po;

import ims.helpers.MapUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @version $Id: LoadPODetailHandler.java 1 2008-04-6 dzhao $
 */
public class LoadPODetailHandler extends BaseHandler {
	
	public static final String SELECT_REQUEST
		= "SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '-' + CONVERT(VARCHAR, ISNULL((SELECT MAX(po_no) FROM purchase_orders WHERE request_id = r.request_id), 0) + 1) project_request_po_no,"
		+ "       ISNULL((SELECT MAX(po_no) FROM purchase_orders WHERE request_id = r.request_id), 0) + 1 po_no,"
		+ "       p.job_name,"
		+ "       p.project_type_id,"
		+ "       r.description "
        + "  FROM projects p INNER JOIN "
        + "       requests r ON p.project_id = r.project_id "
        + " WHERE r.request_id = ? ";
	
	public static final String SELECT_PO
		= "SELECT CONVERT(VARCHAR, p.project_no) + '-' + CONVERT(VARCHAR, r.request_no) + '-' + CONVERT(VARCHAR, po.po_no) project_request_po_no,"
		+ "       po.po_no,"
		+ "       p.job_name,"
		+ "       p.project_type_id,"
		+ "       l.code po_status_code "
	    + "  FROM purchase_orders po INNER JOIN "
	    + "       lookups l ON po.po_status_id = l.lookup_id INNER JOIN "
	    + "       requests r ON po.request_id = r.request_id INNER JOIN "
	    + "       projects p ON r.project_id = p.project_id "
	    + " WHERE po.po_id = ?";

	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("LoadPODetailHandler.handleEnvironment()");
		boolean result = true;
		String jobName = null;
		String poId = null;
		
		ConnectionWrapper conn = null;
//		ConnectionWrapper gp_conn = null;

		try	{
			conn = (ConnectionWrapper) ic.getResource();
//			String gp_org = (String)ic.getRequiredSessionDatum("org_resource");
//			gp_conn = (ConnectionWrapper)ic.getResource(gp_org);
			
			jobName = (String) ic.getSessionDatum("job_name");
			String requestId = (String) ic.getSessionDatum("request_id");
			poId = ic.getParameter("po_id");
			
			Map valueMap = null;
			
			if (StringUtil.hasAValue(poId)) {
				valueMap = getValuesByPO(ic, conn, Integer.parseInt(poId));
				String poStatusCode = (String) valueMap.get("po_status_code");
				
				if (!"new".equalsIgnoreCase(poStatusCode)) {
					ic.setSessionDatum("po_readonly", "true");
				} else {
					ic.setSessionDatum("po_readonly", "false");
				}
			} else {		
				if (StringUtil.hasAValue(requestId)) {
					valueMap =  getValuesByRequst(ic, conn, Integer.parseInt(requestId));
					
					ic.setTransientDatum("description", (String) valueMap.get("description"));
					
					Map request_types = MapUtil.getTypeMap(conn, "po_status_type");
					ic.setTransientDatum("po_status_id", (String) request_types.get("new"));
				}
				ic.setSessionDatum("po_readonly", "false");			
			}
			
			if (!StringUtil.hasAValue(jobName)) {
				jobName = (String) valueMap.get("job_name");
			}
			
			ic.setTransientDatum("project_request_po_no", (String) valueMap.get("project_request_po_no"));
			ic.setTransientDatum("po_no", (String) valueMap.get("po_no"));
			ic.setTransientDatum("jobName", jobName);
			ic.setTransientDatum("job_type_id", (String) valueMap.get("job_type_id"));

		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in LoadPODetailHandler");
			result = false;
		} finally {
			if (conn != null) {
				conn.release();
			}
		}

		// set template if available
		String template_name = ic.getParameter("templateName");
		if (StringUtil.hasAValue(template_name))
			ic.setHTMLTemplateName(template_name);

		return result;
	}

	private Map getValuesByRequst(InvocationContext ic, ConnectionWrapper conn, int requestId) throws SQLException {
		Map<String, String> result = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.prepareStatement(SELECT_REQUEST);
			stmt.setInt(1, requestId);
			rs = stmt.executeQuery();
			if (rs.next()) {
				result = new HashMap<String, String>();
				result.put("project_request_po_no", rs.getString("project_request_po_no"));
				result.put("po_no", rs.getString("po_no"));
				result.put("job_name", rs.getString("job_name"));
				result.put("job_type_id", rs.getString("project_type_id"));
				result.put("description", rs.getString("description"));
			}
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in LoadPODetailHandler.getValuesByRequst");
		} finally {
			if (stmt != null) stmt.close();
			if (rs != null) rs.close();
		}

		return result;

	}
	
	private Map getValuesByPO(InvocationContext ic, ConnectionWrapper conn, int poId) throws SQLException {
		Map<String, String> result = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.prepareStatement(SELECT_PO);
			stmt.setInt(1, poId);
			rs = stmt.executeQuery();
			if (rs.next()) {
				result = new HashMap<String, String>();
				result.put("project_request_po_no", rs.getString("project_request_po_no"));
				result.put("po_no", rs.getString("po_no"));
				result.put("job_name", rs.getString("job_name"));
				result.put("job_type_id", rs.getString("project_type_id"));
				result.put("po_status_code", rs.getString("po_status_code"));
			}
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Problem in LoadPODetailHandler.getValuesByPO");
		} finally {
			if (stmt != null) stmt.close();
			if (rs != null) rs.close();
		}

		return result;

	}

}
