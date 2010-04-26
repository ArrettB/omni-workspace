/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2003, Dynamic Information Systems, LLC
* $Header: CustomerPreHandler.java, 10, 3/6/2006 3:46:54 PM, Blake Von Haden$

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

import ims.helpers.IMSUtil;

import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: CustomerPreHandler.java, 10, 3/6/2006 3:46:54 PM, Blake Von Haden$
 */
public class CustomerPreHandler extends BaseHandler
{

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#setUpHandler()
	 */
	public void setUpHandler() throws Exception
	{
	}

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#destroy()
	 */
	public void destroy()
	{
	}

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#handleEnvironment(dynamic.intraframe.engine.InvocationContext)
	 */
	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug("CustomerPreHandler.handleEnvironment()");
		boolean result = true;
		ConnectionWrapper conn = null;
		String button = null;
		try
		{
			button = ic.getRequiredParameter("customer_button");
			conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

			if( StringUtil.hasAValue(button))
			{
				if( button.equalsIgnoreCase("Update Column"))
				{
					result = handleColumnUpdate(ic, conn);
				}
				else if( button.equalsIgnoreCase("Prepare Column Edit"))
				{
					result = prepareColumnEdit(ic, conn);
				}
			}

		}
		catch (Exception e)
		{
			SmartFormHandler.handleException(ic, e, conn, button);
			result = false;
		}

		return result;
	}

	/**
	 * @param ic
	 * @param conn
	 * @return
	 */
	private boolean handleColumnUpdate(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("CustomerPreHandler.handleColumnUpdate()");
		boolean result = false; //only want to update columns not customer so return false to redisplay
		String customColID = ic.getParameter("custom_cust_col_id");
		String colSequence = ic.getParameter("col_sequence");
		String columnDesc = ic.getParameter("column_desc");
		String active_flag = ic.getParameter("column_active_flag");
		String dropList = ic.getParameter("is_droplist");
		String mandatory = ic.getParameter("is_mandatory");

		StringBuffer update = new StringBuffer();
		update.append("UPDATE custom_cust_columns");
		update.append(" SET col_sequence = " + conn.toSQLString(colSequence));
		update.append(", column_desc = " + conn.toSQLString(columnDesc));
		update.append(", active_flag = " + conn.toSQLString(active_flag));
		update.append(", is_droplist = " + conn.toSQLString(dropList));
		update.append(", is_mandatory = " + conn.toSQLString(mandatory));
		update.append(" WHERE custom_cust_col_id = " + customColID);

		conn.updateExactlyEx(update, 1);
		ic.setParameter("custom_cust_col_id","");
		conn.commit();	// force the commit because we are returning false and change would roll back.

		return result;
	}

	private boolean prepareColumnEdit(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("CustomerPreHandler.prepareColumnEdit()");
		boolean result = false; //want to redisplay with column data displayed
		String customColID = ic.getParameter("custom_cust_col_id");

		StringBuffer query = new StringBuffer();
		query.append("SELECT custom_cust_col_id, col_sequence, column_desc, active_flag column_active_flag, is_mandatory, is_droplist"); //customer also has active_flag
		query.append(" FROM custom_cust_columns");
		query.append(" WHERE custom_cust_col_id = " + conn.toSQLString(customColID));

		copyResultsToTransient(ic, conn.resultsQueryEx(query));

		return result;
	}

	private void copyResultsToTransient(InvocationContext ic, QueryResults rs) throws SQLException
	{
		ResultSetMetaData meta = rs.getMetaData();
		if (rs.next())
		{
			for (int i = 1, n = meta.getColumnCount(); i <= n; i++)
			{
				String colName = meta.getColumnName(i);
				ic.setParameter(colName.toLowerCase(), rs.getString(colName));
			}
		}
		IMSUtil.closeQueryResultSet(rs);		
	}

}
