/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2003,2006, Dynamic Information Systems, LLC
 * $Header: SaveVendorWOsPostHandler.java, 6, 1/27/2006 1:58:10 PM, Blake Von Haden$
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
package ims.handlers.proj;

import java.util.Enumeration;
import java.util.Hashtable;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: SaveVendorWOsPostHandler.java, 6, 1/27/2006 1:58:10 PM, Blake Von Haden$
 */
public class SaveVendorWOsPostHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.trace("SaveVendorWOsPostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.trace("SaveVendorWOsPostHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("SaveVendorWOsPostHandler.handleEnvironment()");
		boolean result = true;
		boolean prePostHandler = false;
		ConnectionWrapper conn = null;

		/*
		 * Note: Because this is PostHandler with SmartFormHandler, we do NOT catch the exception or release the resource ourselves
		 */

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

		try
		{
			result = handleEmail(ic, conn);
		}
		catch (Exception e)
		{
			SmartFormHandler.handleException(ic, e, conn, "Save");
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
	 * For each vendor request updated, send an email notifying the customer contact
	 * 
	 * @param ic
	 * @param conn
	 * @return
	 */
	private boolean handleEmail(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("SaveVendorWOsPostHandler.handleEmail()");
		boolean result = true;

		int counter = 1;
		String index = "";
		if (StringUtil.hasAValue(ic.getParameter("request_vendor_id_1")))
			index = "_" + counter;

		while ((ic.getParameter("request_vendor_id" + index)) != null)
		{
			// see if user updated vendor schedule dates, if so email customer contact
			String sch_start_date = ic.getParameter("sch_start_date" + index);
			String old_sch_start_date = ic.getParameter("old_sch_start_date" + index);
			String record_id = (String) ic.getTransientDatum("record_id" + index);

			if (StringUtil.hasAValue(record_id) && StringUtil.hasAValue(sch_start_date)
					&& !sch_start_date.equals(old_sch_start_date))
			{// remove the index to run email handler
				ic.setTransientDatum("record_id", record_id);
				ic.setTransientDatum("record_type_code", (String) ic.getTransientDatum("record_type_code" + index));
				ic.setTransientDatum("request_vendor_id", (String) ic.getTransientDatum("request_vendor_id" + index));
				ic.setTransientDatum("vendor_contact_name", (String) ic.getTransientDatum("vendor_contact_name" + index));
				ic.setTransientDatum("sch_start_date", sch_start_date);
				ic.dispatchHandler("ims.handlers.proj.PDSEmailHandler");
			}

			counter++;
			index = "_" + counter;
		}

		Hashtable request_vendor_ids = (Hashtable) ic.getTransientDatum("request_vendor_ids");

		updateReqs(conn, request_vendor_ids);

		sendSurveys(ic, conn, request_vendor_ids);

		return result; // case when smartform is called with this
	}

	private boolean updateReqs(ConnectionWrapper conn, Hashtable request_vendor_ids) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.updateReq()");
		boolean result = true;

		StringBuffer query = new StringBuffer();
		query.append("UPDATE services	SET ");
		query.append(" sch_start_date = rv.sch_start_date, sch_start_time = rv.sch_start_time, sch_end_date = rv.sch_end_date,");
		query.append(" act_start_date = rv.act_start_date, act_start_time = rv.act_start_time, act_end_date = rv.act_end_date");
		query.append(" FROM request_vendors_v rv, requests r, customers c");
		query
				.append(" WHERE services.request_id = rv.request_id AND rv.request_id = r.request_id AND rv.customer_id = c.customer_id ");
		query.append(" AND rv.vendor_contact_id = c.a_m_furniture1_contact_id AND rv.request_vendor_id in (");
		Enumeration ids = request_vendor_ids.keys();
		boolean first_value = true;
		while (ids.hasMoreElements())
		{// build inclause
			if (!first_value)
				query.append(",");
			query.append((String) ids.nextElement());
			first_value = false;
		}
		query.append(")");
		if (!first_value)
		{// insure there is at least one value in the clause
			conn.updateEx(query);
		}
		return result;
	}

	private boolean sendSurveys(InvocationContext ic, ConnectionWrapper conn, Hashtable request_vendor_ids) throws Exception
	{
		Diagnostics.trace("PDSPostHandler.sendSurveys()");
		boolean result = true;

		StringBuffer query = new StringBuffer();
		query.append("SELECT project_id, request_id, request_type_code, s.survey_last_count, s.survey_frequency, s.sum_complete, s.survey_location, is_surveyed");
		query.append(" FROM survey_v s ");
		query.append(" WHERE survey_last_count + survey_frequency <= sum_complete ");
		query.append("   AND survey_frequency > 0");
		query.append("   AND LEN(survey_location) > 0");
		query.append("   AND isnull(is_surveyed,'N') = 'N'");
		query.append("   AND request_id in (SELECT DISTINCT request_id FROM survey_request_vendors_v WHERE request_vendor_id in (");

		Enumeration ids = request_vendor_ids.keys();
		boolean first_value = true;
		while (ids.hasMoreElements())
		{// build inclause
			if (!first_value)
				query.append(",");
			query.append((String) ids.nextElement());
			first_value = false;
		}
		query.append(")) ORDER BY project_id, request_id");
		QueryResults rs = null;
		if (!first_value)
		{// insure there is at least one value in the clause before taking action

			String last_project_id = null;
			String project_id = null;
			int survey_last_count = 0;
			int survey_frequency = 0;
			int sum_complete = 0; // count of all eligible requests
			int unsent_count = 0; // used for sending multiple surveys if needed
			rs = conn.resultsQueryEx(query);
			while (rs.next())
			{// this request is to be surveyed

				project_id = rs.getString("project_id"); // send 1 or more surveys per project
				if (StringUtil.hasAValue(project_id) && !project_id.equalsIgnoreCase(last_project_id))
				{
					survey_last_count = rs.getInt("survey_last_count");
					survey_frequency = rs.getInt("survey_frequency");
					sum_complete = rs.getInt("sum_complete");
					unsent_count = 0;
				}

				if ((survey_last_count + unsent_count) + survey_frequency <= sum_complete)
				{
					ic.setTransientDatum("survey", "true");
					ic.setTransientDatum("record_id", rs.getString("request_id"));
					ic.setTransientDatum("record_type_code", rs.getString("request_type_code"));
					result = ic.dispatchHandler("ims.handlers.proj.PDSEmailHandler");
					if (result)
					{
						survey_last_count += survey_frequency;
						conn.updateEx("UPDATE requests SET is_surveyed='Y' WHERE request_id = "
								+ conn.toSQLString(rs.getString("request_id")));
						conn.updateEx(
										"UPDATE customers SET survey_last_count = "
												+ survey_last_count
												+ " FROM projects p, requests r WHERE customers.customer_id = p.customer_id AND p.project_id = r.project_id AND r.request_id = "
												+ conn.toSQLString(rs.getString("request_id")));

					}
				}
				unsent_count++;
				last_project_id = project_id;
			}
		}
		return result;
	}

}
