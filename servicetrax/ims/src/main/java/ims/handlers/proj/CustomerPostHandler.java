/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2003,2006, Dynamic Information Systems, LLC
 * $Header: CustomerPostHandler.java, 8, 3/6/2006 3:46:54 PM, Blake Von Haden$

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
package ims.handlers.proj;

import ims.dataobjects.User;
import ims.helpers.IMSUtil;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase
 * @version $Header: CustomerPostHandler.java, 8, 3/6/2006 3:46:54 PM, Blake Von Haden$
 */
public class CustomerPostHandler extends BaseHandler
{

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#setUpHandler()
	 */
	public void setUpHandler() throws Exception
	{
	}

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#handleEnvironment(dynamic.intraframe.engine.InvocationContext)
	 */
	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug("CustomerPostHandler.handleEnvironment()");
		boolean result = false;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
			result = loadCustomCustCols(conn, ic);
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e, "Exception in CustomerPostHandler");

			result = true;
		}
		return result;
	}

	public boolean loadCustomCustCols(ConnectionWrapper ims_conn, InvocationContext ic) throws Exception
	{
		Diagnostics.trace("CustomerPostHandler.loadCustomCustCols()");
		boolean bRet = true;

		String customer_id = (String) ic.getParameter("customer_id"); // parameter may be set by PDSPostHandler
		if (!StringUtil.hasAValue(customer_id))
		{// did not find customer id
			SmartFormHandler.addSmartFormError(
							ic,
							"Failed to load Customer's Customer Columns for this Service Account Job.  Null customer_id.  Please notify the System Admin.  Have a Pleasant Day :-)");
			Diagnostics.error("ItemHandler.loadCustomCustCols() Failed to find customer_id in order to load customer_columns.");
		}
		else
		{// yes load custom customer columns
			String queryStr = "SELECT distinct customer_id FROM custom_cust_columns WHERE customer_id = ?";

			QueryResults rs = ims_conn.select(queryStr, customer_id);
			if (rs.next())
			{
				// customer already has customer columns, do nothing
			}
			else
			{// customer is not in the custom columns table, so generate custom columns
				User user = (User) ic.getRequiredSessionDatum("user");
				String insert_query = "INSERT INTO custom_cust_columns(customer_id, column_desc, col_sequence, active_flag, is_mandatory, is_droplist, created_by, date_created) values(";
				for (int i = 1; i < 11; i++)
				{
					StringBuffer query = new StringBuffer();
					query.append(insert_query).append(ims_conn.toSQLString(customer_id)).append(",'Field").append(i).append("',").append(i).append(",'N','N','N',").append(user.getUserID()).append(",getDate())");
					Diagnostics.debug2("insert query='" + query.toString() + "'");
					ims_conn.updateEx(query);
				}
				ims_conn.commit();
			}
			IMSUtil.closeQueryResultSet(rs);
		}
		return bRet;
	}

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#destroy()
	 */
	public void destroy()
	{
	}

}
