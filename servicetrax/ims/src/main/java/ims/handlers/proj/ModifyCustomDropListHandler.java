/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2003, Dynamic Information Systems, LLC
* $Header: ModifyCustomDropListHandler.java, 3, 10/30/2003 9:58:46 AM, Greg Case$

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



import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase
 * @version $Id: ModifyCustomDropListHandler.java 1100 2008-03-06 17:36:02Z dzhao $
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class ModifyCustomDropListHandler extends BaseHandler
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
	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug("ModifyCustomDropListHandler.handleEnvironment()");
		boolean result = true;
		boolean prePostHandler = false;
		ConnectionWrapper conn = null;
		String button = null;
		try
		{
			conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
			if (conn == null)
			{
				conn = (ConnectionWrapper) ic.getResource();
				prePostHandler = false;
			}
			else
			{
				prePostHandler = true;
			}

			result = handleSave(ic, conn);
		}
		catch (Exception e)
		{
			SmartFormHandler.handleException(ic, e, conn, button);
			result = false;
		}
		finally
		{
			if (!prePostHandler && conn != null)
				conn.release();
		}

		return result;
	}

	/**
	 * @param ic
	 * @param conn
	 * @return
	 */
	private boolean handleSave(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		boolean result = true;

		StringBuffer insert = null;
		StringBuffer update = null;
		Hashtable old_ids = null;
		String customCustColID = ic.getRequiredParameter("custom_cust_col_id");
		String new_ids = ic.getParameter("ids");
		String new_values = ic.getParameter("values");
		String id = null;
		String value = null;
		
		List idList = StringUtil.stringToVector(new_ids);
		if (idList != null)
		{
			//get list of old ids for comparison (may need to delete)
			old_ids = getHashtable(conn, "SELECT custom_col_list_id, list_value FROM custom_col_lists WHERE custom_cust_col_id = " + customCustColID);
			
			int i = 0;
			Iterator values = (StringUtil.stringToVector(new_values)).iterator();
			for (Iterator ids = idList.iterator(); ids.hasNext();)
			{//walk through ids

				id = (String) ids.next();
				value = (String) values.next();

				if( id.equals("-1") )
				{//new value 

					insert = new StringBuffer();
					insert.append("INSERT INTO custom_col_lists (custom_cust_col_id, sequence, list_value)");
					insert.append(" VALUES (").append(customCustColID);
					insert.append(", ").append(i++);
					insert.append(", ").append(conn.toSQLString(value));
					insert.append(")");
					old_ids.remove(id);
					conn.updateExactlyEx(insert, 1);
				}									
				else
				{//updating existing value
					
					update = new StringBuffer();
					update.append("UPDATE custom_col_lists SET sequence=" + (i++));
					update.append(", list_value="+conn.toSQLString(value));
					update.append(" WHERE custom_col_list_id = " + id);
					old_ids.remove(id);
					conn.updateExactlyEx(update, 1);					
				}	
			}
		
			//we handled inserts and updates, now handle deletes
			//have to be careful we do not delete a value that is used on a workorder or requisition
			String column_seq = conn.queryEx("SELECT col_sequence FROM custom_cust_columns WHERE custom_cust_col_id = " + conn.toSQLString(customCustColID));
			String rows = null;
			Enumeration keys = old_ids.keys();
			boolean delete = false;
			while( keys.hasMoreElements() )
			{
				id = (String)keys.nextElement();

				rows = conn.queryEx("SELECT count(*) FROM requests WHERE cust_col_" + column_seq + " = " + conn.toSQLString(id) );
				if( rows.equals("0") )
				{
					rows = conn.queryEx("SELECT count(*) FROM services WHERE cust_col_" + column_seq + " = " + conn.toSQLString(id) );
					if( rows.equals("0") )
						delete = true;
				}

				if( delete )
					conn.updateEx("DELETE FROM custom_col_lists WHERE custom_col_list_id = " + conn.toSQLString(id) );
				else
					conn.updateEx("UPDATE custom_col_lists SET active_flag = " + conn.toSQLString("N") + " WHERE custom_col_list_id = " + conn.toSQLString(id) );
			}
		}

		ic.setParameter("close_only", "true");
		ic.setHTMLTemplateName("pop_close_refresh.html");
		
		return result;
	}
	
	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#destroy()
	 */
	public void destroy()
	{
	}

	public Hashtable getHashtable(ConnectionWrapper conn, String query) throws Exception
	{
		QueryResults rs = conn.resultsQueryEx(query);
		String key = null;
		String value = null;
		Hashtable<String,String> result = new Hashtable<String,String>();
			
		while( rs.next() )
		{
			key = rs.getString(1);
			value = rs.getString(2);
			if( key != null )
			{
				if( value == null )
					value = "";
				result.put(key, value);
			}
		}
		return result;
	}

	public String getKeysAsString(Hashtable theHash)
	{
		String result = "";
		if( theHash != null )
		{
			Enumeration keys = theHash.keys();
			boolean first_element = true;
			while( keys.hasMoreElements() )
			{
				if( !first_element )
					result += "," + (String)keys.nextElement();
				else
					result += (String)keys.nextElement();
			}
		}
		return result;
	}
}
