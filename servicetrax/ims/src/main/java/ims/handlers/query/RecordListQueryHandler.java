/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001-2006, Dynamic Information Systems, LLC
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

package ims.handlers.query;

import ims.dataobjects.Function;
import ims.dataobjects.User;
import ims.helpers.IMSUtil;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Id: RecordListQueryHandler.java 1312 2008-08-14 21:20:32Z dzhao $
 */
public class RecordListQueryHandler extends BaseHandler {
	private static final String SERVICE_REQUEST = "service_request";
	private static final String QUOTE = "quote";
	private static final String QUOTE_REQUEST = "quote_request";
	private static final String WORKORDER = "workorder";
	private static final String PROJECT_FOLDER = "project_folder";

	private Map<String, List<String>> recordTypeColumnsMap;

	public static final String NEW_LINE = System.getProperty("line.separator");
	
	public static final String CUSTOMER_ONLY
	 	= " INNER JOIN " + NEW_LINE
	 	+ " user_customers uc ON pv.customer_id = uc.customer_id ";
	
	public static final String CUSTOMER_AND_END_USER
 		= " INNER JOIN " + NEW_LINE
 		+ " user_customers uc ON pv.customer_id = uc.customer_id INNER JOIN " + NEW_LINE
 		+ " user_customer_end_users uceu ON uc.user_customer_id = uceu.user_customer_id ";//AND pv.end_user_id = uceu.customer_id";
// 		+ " user_customer_end_users uceu ON uc.user_customer_id = uceu.user_customer_id AND pv.end_user_id = uceu.customer_id";

	public static final String AND_END_USER
	 	= " AND pv.end_user_id = uceu.customer_id " + NEW_LINE;
	
	public void setUpHandler()
	{
		recordTypeColumnsMap = new HashMap<String, List<String>>();
		
		List<String> columns = new ArrayList<String>();
		columns.add("pv.project_request_version_no");
		columns.add("pv.project_id");
		columns.add("pv.project_no");
		columns.add("pv.request_id");
		columns.add("pv.request_no");
		columns.add("pv.job_name");
		columns.add("pv.customer_name");
		columns.add("pv.end_user_name");
		columns.add("pv.a_m_contact_name");
		columns.add("pv.record_status_name");
		columns.add("pv.record_created");
		columns.add("pv.is_quoted");
		columns.add("pv.has_service_request");
		columns.add("pv.is_new");
		columns.add("'' foo");
		columns.add("'' selected");
		recordTypeColumnsMap.put(QUOTE_REQUEST, Collections.unmodifiableList(columns));
		
		columns = new ArrayList<String>();
		columns.add("pv.project_request_version_no");
		columns.add("pv.project_id");
		columns.add("pv.project_no");
		columns.add("pv.request_id");
		columns.add("pv.request_no");
		columns.add("pv.job_name");
		columns.add("pv.customer_name");
		columns.add("pv.end_user_name");
		columns.add("pv.record_status_name");
		columns.add("pv.dealer_po_no");
		columns.add("pv.description");
		columns.add("pv.est_start_date");	
		columns.add("pv.is_new");
		columns.add("'' foo");
		columns.add("'' selected");
		recordTypeColumnsMap.put(SERVICE_REQUEST, Collections.unmodifiableList(columns));
		
		columns = new ArrayList<String>();
		
		columns.add("pv.project_request_version_no");
		columns.add("pv.project_id");
		columns.add("pv.project_no");
		columns.add("pv.request_id");
		columns.add("pv.request_no");
		columns.add("pv.record_type_name");
		columns.add("pv.record_type_code");
		columns.add("pv.record_status_name");
		columns.add("pv.record_status_code");
		columns.add("pv.customer_name");
		columns.add("pv.job_name");
		columns.add("pv.quote_id");
		columns.add("pv.quote_total");
		columns.add("pv.quoted_by_name");
		columns.add("pv.end_user_name");
		columns.add("pv.is_new");
		columns.add("'' foo");
		columns.add("'' selected");
		recordTypeColumnsMap.put(QUOTE, Collections.unmodifiableList(columns));
		
		columns = new ArrayList<String>();
		columns.add("pv.project_request_no");
		columns.add("pv.project_id");
		columns.add("pv.project_no");
		columns.add("pv.request_id");
		columns.add("pv.request_no");
		columns.add("pv.job_name");
		columns.add("pv.ext_dealer_id");
		columns.add("pv.dealer_name");
		columns.add("pv.customer_name");
		columns.add("pv.end_user_name");
		columns.add("pv.record_type_code");
		columns.add("pv.record_status_name");
		columns.add("pv.dealer_po_no");
		columns.add("pv.customer_po_no");
		columns.add("pv.vendor_count");
		columns.add("pv.vendor_complete_count");
		columns.add("pv.description");
		columns.add("ISNULL(pv.est_start_date, ISNULL(pv.min_act_start_date, pv.min_sch_start_date)) install_date");
		columns.add("pv.record_status_seq_no");
		columns.add("'' foo");
		columns.add("'' selected");
		recordTypeColumnsMap.put(WORKORDER, Collections.unmodifiableList(columns));
		
		columns = new ArrayList<String>();
		columns.add("pv.project_id");
		columns.add("pv.project_no");
		columns.add("pv.customer_id");
		columns.add("pv.customer_name");
		columns.add("pv.end_user_name");
		columns.add("pv.job_name");
		columns.add("pv.project_status_name");
		columns.add("'' foo");
		columns.add("'' selected");
		recordTypeColumnsMap.put(PROJECT_FOLDER, Collections.unmodifiableList(columns));
	}

	public void destroy()
	{
	}

	private String getTableName(String recordTypeCode)
	{
		String tableName = null;
		if (WORKORDER.equalsIgnoreCase(recordTypeCode))
		{
			tableName = "quick_request_vendors_v";
		}
		else if (QUOTE_REQUEST.equalsIgnoreCase(recordTypeCode))
		{
			tableName = "quick_quote_requests_v2";
		}
		else if (QUOTE.equalsIgnoreCase(recordTypeCode))
		{
			tableName = "quick_quotes_v";
		}
		else if (PROJECT_FOLDER.equalsIgnoreCase(recordTypeCode))
		{
			tableName = "quick_project_v";
		}
		else if (SERVICE_REQUEST.equalsIgnoreCase(recordTypeCode))
		{
			tableName = "quick_requests_v2";
		}
		
		return tableName;
	}
	
	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		
		boolean result = true;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			User user = (User)ic.getSessionDatum("user");
			
			String recordTypeCode = ic.getRequiredParameter("record_type_code");
			String tableName = getTableName(recordTypeCode);
			
			if (StringUtil.hasAValue(tableName)) {
				
				boolean restrictByCustomer = false;

				Map userCustomerMap = IMSUtil.getUserCustomer(conn, ic, user.userID);
				Set hasEndUserSet = (Set) userCustomerMap.get(IMSUtil.CUSTOMER_WITH_END_USER);
				Set noEndUserSet = (Set) userCustomerMap.get(IMSUtil.CUSTOMER_WITHOUT_END_USER);
				Set<String> combinedSet = new HashSet<String>(hasEndUserSet);
				for (Iterator iter = noEndUserSet.iterator(); iter.hasNext();) {
					combinedSet.add((String) iter.next());
				}
				
				if (noEndUserSet.size() + hasEndUserSet.size() > 0) {
					restrictByCustomer = true;
				}				

				StringBuffer query = buildMainQuery(conn, ic, recordTypeCode, noEndUserSet, hasEndUserSet);
				
				//add the ORDER BY
				if (PROJECT_FOLDER.equalsIgnoreCase(recordTypeCode)) {
					query.append(" ORDER BY project_no DESC" + NEW_LINE);
				} else if (WORKORDER.equalsIgnoreCase(recordTypeCode)) {
					// I don't think the status is necessary since record no should be unique
					query.append(" ORDER BY project_no DESC, request_no DESC, record_status_seq_no" + NEW_LINE);
				} else {
					query.append(" ORDER BY pv.project_no DESC, pv.request_no" + NEW_LINE);
				}
				
				ic.setTransientDatum("recordListQuery", query.toString());
				
				if (!QUOTE_REQUEST.equals(recordTypeCode) && !SERVICE_REQUEST.equals(recordTypeCode)) {
					
					StringBuffer customerQuery =  new StringBuffer();
					customerQuery.append("SELECT DISTINCT pv.customer_id, pv.customer_name" + NEW_LINE);
					customerQuery.append(" FROM " + tableName + " pv" + NEW_LINE);	
					if (restrictByCustomer) {
						customerQuery.append(CUSTOMER_ONLY + NEW_LINE);
					}
					
					String whereClause = buildWhereClause(ic, conn, restrictByCustomer, combinedSet);
					customerQuery.append(whereClause);
					customerQuery.append(" ORDER BY pv.customer_name" + NEW_LINE);	
					ic.setTransientDatum("customerListQuery", customerQuery.toString());
					
					StringBuffer endUserQuery = buildEndUserQuery(conn, ic, recordTypeCode, noEndUserSet, hasEndUserSet);
					endUserQuery.append(" ORDER BY pv.end_user_name" + NEW_LINE);	
					ic.setTransientDatum("endUserListQuery", endUserQuery.toString());
				
//					StringBuffer dealerQuery =  new StringBuffer();
//					dealerQuery.append("SELECT DISTINCT pv.ext_dealer_id, pv.dealer_name" + NEW_LINE);
//					dealerQuery.append(" FROM " + tableName + " pv" + NEW_LINE);	
//					if (restrictByCustomer) {
//						dealerQuery.append(", user_customers_v ucv" + NEW_LINE);
//					}
//					dealerQuery.append(whereClause);
//					dealerQuery.append(" ORDER BY pv.dealer_name" + NEW_LINE);	
//					ic.setTransientDatum("dealerListQuery", dealerQuery.toString());
				}
			}
		} catch(Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in RecordListQueryHandler.handleEnvironment().");
			result = false;
		} finally {
			if (conn != null)
				conn.release();
		}
		
		return result;
		
	}	
	
	private StringBuffer buildEndUserQuery(ConnectionWrapper conn, InvocationContext ic, String recordTypeCode, Set customerOnly, Set both) throws Exception {
		String tableName = getTableName(recordTypeCode);
		
		StringBuffer sql =  new StringBuffer();
		sql.append("SELECT DISTINCT pv.end_user_id, pv.end_user_name" + NEW_LINE);
		sql.append(" FROM " + tableName + " pv" + NEW_LINE);
		
		buildCustomerRestriction(conn, ic, customerOnly, both, sql);
			
		return sql;
	}
	
	private StringBuffer buildMainQuery(ConnectionWrapper conn, InvocationContext ic, String recordTypeCode, Set customerOnly, Set both) throws Exception {
		
		String tableName = getTableName(recordTypeCode);
		List columns = getColumnList(recordTypeCode);
		
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT ");
		for (Iterator iter = columns.iterator(); iter.hasNext();) {
			String colName = (String) iter.next();
			sql.append(colName + NEW_LINE + ", ");
		}
		sql.setLength(sql.length() - 2);
		sql.append(" FROM " + tableName + " pv ");	
		
		buildCustomerRestriction(conn, ic, customerOnly, both, sql);
			
		return sql;
	}

	private void buildCustomerRestriction(ConnectionWrapper conn, InvocationContext ic, Set customerOnly, Set both, StringBuffer sql) throws Exception {
		if (customerOnly.size() > 0 && both.size() > 0) {
			StringBuffer sql2 = new StringBuffer(sql);
			sql2.append(CUSTOMER_AND_END_USER + NEW_LINE);
			String whereClause2 = buildWhereClause(ic, conn, true, both);
			sql2.append(whereClause2);
			sql2.append(AND_END_USER);
			
			sql.append(CUSTOMER_ONLY + NEW_LINE);
			String whereClause = buildWhereClause(ic, conn, true, customerOnly);
			sql.append(whereClause);
			
			sql.append(" UNION " + NEW_LINE).append(sql2);
			
			sql.insert(0, "SELECT pv.* FROM (" + NEW_LINE);
			sql.append(") pv " + NEW_LINE);
		} else if (customerOnly.size() > 0) {
			sql.append(CUSTOMER_ONLY + NEW_LINE);
			String whereClause = buildWhereClause(ic, conn, true, customerOnly);
			sql.append(whereClause);
		} else if (both.size() > 0) {
			sql.append(CUSTOMER_AND_END_USER + NEW_LINE);
			String whereClause = buildWhereClause(ic, conn, true, both);
			sql.append(whereClause);
			sql.append(AND_END_USER);
		} else {
			sql.append(NEW_LINE);
			String whereClause = buildWhereClause(ic, conn, false, null);
			sql.append(whereClause);
		}
	}
	
	private String buildWhereClause(InvocationContext ic, ConnectionWrapper conn, boolean restrictByCustomer, Set ids) throws Exception {
		String recordTypeCode = ic.getRequiredParameter("record_type_code");
		String orgId = (String) ic.getRequiredSessionDatum("org_id");
		String extDirectDealerId = (String) ic.getRequiredSessionDatum("ext_direct_dealer_id");
		User user = (User)ic.getSessionDatum("user");
		String extDealerId = (String) user.extDealerID;
		boolean hasMultiDealerRight = hasMultiDealerRight(ic);
		boolean hasNonAMDealerRight = hasNonAMDealerRight(ic);

		StringBuffer query = new StringBuffer();
		if (recordTypeCode.equals(PROJECT_FOLDER)) {
			query.append(" WHERE pv.organization_id = " + StringUtil.toPStmtInt(orgId) + NEW_LINE);
			query.append(" AND pv.project_status_code <> " + conn.toSQLString("folder_closed") + NEW_LINE);
		} else {
			query.append(" WHERE pv.organization_id = " + StringUtil.toPStmtInt(orgId) + NEW_LINE);
		} 
		
		if (restrictByCustomer)	{
			InClause selectedClause = new InClause();
			for (Iterator iter = ids.iterator(); iter.hasNext(); ) {
				selectedClause.add((String) iter.next());
			}
			query.append(" AND " + selectedClause.getInClause("uc.user_customer_id") + NEW_LINE);
		} 

		/**
		 * This is the logic we are attempting to reproduce
		 * 
		 * 		/*
		 * 	AND (r.ext_dealer_id like <?s:user.extDealerID.isNull('%').toPStmtString()?> 
		 *   OR 'true'=<?s:rights.enet/proj/multidealer.view.toPStmtString()?>
		     OR ('true'=<?s:rights.enet/proj/non_a_m_dealers.view.toPStmtString()?> AND r.ext_dealer_id <> <?s:ext_direct_dealer_id.toPStmtString()?>)
				)
		 */
		
		if (hasMultiDealerRight) {
			//nothing to do, no restriction
		} else if (hasNonAMDealerRight)	{
			//restrict by ext_direct_dealer_id from session
			query.append(" AND pv.ext_dealer_id <> " + StringUtil.toPStmtString(extDirectDealerId) + NEW_LINE);
		} else if (extDealerId != null)	{
			//restrict by ext_dealer_id
			query.append(" AND pv.ext_dealer_id = " + StringUtil.toPStmtString(extDealerId) + NEW_LINE);
		} else {
			//throw an error here?
		}		
		
		return query.toString();
	}
	
	private List getColumnList(String recordTypeCode) {
		return (List) recordTypeColumnsMap.get(recordTypeCode);
	}
	
	private boolean hasMultiDealerRight(InvocationContext ic) {
		return hasRight(ic, "enet/proj/multidealer");
	}
	
	private boolean hasNonAMDealerRight(InvocationContext ic) {
		return hasRight(ic, "enet/proj/non_a_m_dealers");
	}
	
	private boolean hasRight(InvocationContext ic, String rightCode) {
		User currentUser = (User) ic.getSessionDatum("user");
		Map rights = currentUser.getRights();		
		Function function = (Function) rights.get(rightCode);
		return function != null && function.view;	
	}
	
}
