/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2003, Dynamic Information Systems, LLC
* $Header: C:\work\ims\src\ims\handlers\query\DealerCustomerQueryHandler.java, 1, 9/19/2006 11:21:43 AM, Greg Case$

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
package ims.handlers.query;

import ims.dataobjects.Function;
import ims.dataobjects.User;
import ims.helpers.IMSUtil;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.parser.Sql;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase
 *
 * @version $Id: DealerCustomerQueryHandler.java 1373 2008-10-15 17:57:23Z dzhao $
 */
public class DealerCustomerQueryHandler extends BaseHandler {

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#setUpHandler()
	 */
	public void setUpHandler() throws Exception {}
	
	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#handleEnvironment(dynamic.intraframe.engine.InvocationContext)
	 */
	public boolean handleEnvironment(InvocationContext ic) throws Exception {
		Diagnostics.debug2("DealerCustomerQueryHandler.handleEnvironment()");
		boolean result = true;
		ConnectionWrapper conn = null;	
		try {
			conn = (ConnectionWrapper) ic.getResource();
			String query = ic.getParameter("query");
			String alias = ic.getParameter("alias");
			String var = ic.getParameter("var");
			User user = (User)ic.getSessionDatum("user");
			String extDealerId = (String) user.extDealerID;
			int userId = user.userID;
			String extDirectDealerId = (String) ic.getRequiredSessionDatum("ext_direct_dealer_id");
		
			Sql sql = Sql.fetchSql(query);

			Map userCustomerMap = IMSUtil.getUserCustomer(conn, ic, user.userID);
			Set hasEndUserSet = (Set) userCustomerMap.get(IMSUtil.CUSTOMER_WITH_END_USER);
			Set noEndUserSet = (Set) userCustomerMap.get(IMSUtil.CUSTOMER_WITHOUT_END_USER);
			
			if (noEndUserSet.size() > 0 && hasEndUserSet.size() > 0) {
				Sql sql2 = Sql.fetchSql(query);
				String orderBy = sql.getOrderBy();
				InClause selectedClause = null;
				
				sql2.setOrderBy("");
				sql2.addFromTable("user_customers", "uc");
				sql2.addFromTable("user_customer_end_users", "uceu");
				sql2.addWhereAndClause(alias + ".customer_id = uc.customer_id");
				sql2.addWhereAndClause(alias + ".end_user_id = uceu.customer_id");
				sql2.addWhereAndClause("uc.user_customer_id = uceu.user_customer_id");
				sql2.addWhereAndClause("uc.user_id = " + StringUtil.toPStmtInt(userId));
				selectedClause = new InClause();
				for (Iterator iter = hasEndUserSet.iterator(); iter.hasNext(); ) {
					selectedClause.add((String) iter.next());
				}
				sql2.addWhereAndClause(selectedClause.getInClause("uc.user_customer_id"));
				
				sql.setOrderBy("");
				sql.addFromTable("user_customers", "uc");
				sql.addWhereAndClause(alias + ".customer_id = uc.customer_id");
				sql.addWhereAndClause("uc.user_id = " + StringUtil.toPStmtInt(userId));
				selectedClause = new InClause();
				for (Iterator iter = noEndUserSet.iterator(); iter.hasNext(); ) {
					selectedClause.add((String) iter.next());
				}
				sql.addWhereAndClause(selectedClause.getInClause("uc.user_customer_id"));
				
				query = "SELECT " + alias + ".* FROM (" + RecordListQueryHandler.NEW_LINE
				      + sql.getQuery() + RecordListQueryHandler.NEW_LINE
				      + " UNION " + RecordListQueryHandler.NEW_LINE
				      + sql2.getQuery() + ") " + alias + " " + RecordListQueryHandler.NEW_LINE
				      + orderBy;
			} else if (noEndUserSet.size() > 0) {
				sql.addFromTable("user_customers", "uc");
				sql.addWhereAndClause(alias + ".customer_id = uc.customer_id");
				sql.addWhereAndClause("uc.user_id = " + StringUtil.toPStmtInt(userId));
				query = sql.getQuery();
			} else if (hasEndUserSet.size() > 0) {
				sql.addFromTable("user_customers", "uc");
				sql.addFromTable("user_customer_end_users", "uceu");
				sql.addWhereAndClause(alias + ".customer_id = uc.customer_id");
				sql.addWhereAndClause(alias + ".end_user_id = uceu.customer_id");
				sql.addWhereAndClause("uc.user_customer_id = uceu.user_customer_id");
				sql.addWhereAndClause("uc.user_id = " + StringUtil.toPStmtInt(userId));
				query = sql.getQuery();
			} 

			if (hasMultiDealerRight(ic)) {
				//nothing to do, no restriction
			} else if (hasNonAMDealerRight(ic)) {
				//restrict by ext_direct_dealer_id from session
				sql.addWhereAndClause(alias + ".ext_dealer_id <> " +  StringUtil.toPStmtString(extDirectDealerId));
			} else if (extDealerId != null) {
				//restrict by ext_dealer_id
				sql.addWhereAndClause(alias + ".ext_dealer_id = " +  StringUtil.toPStmtString(extDealerId) );
			}			
			query = sql.getQuery();
			
			Diagnostics.debug("New query = " + query);		
			ic.setTransientDatum(var, query);
			
		} catch(Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in DealerCustomerQueryHandler");
			result = false;
		} finally {
			if (conn != null)
				conn.release();
		}
		return result;
	
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
	
	
	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#destroy()
	 */
	public void destroy() {}
}
