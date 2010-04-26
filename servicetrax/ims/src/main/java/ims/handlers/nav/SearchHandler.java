/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001-2003,2006, Dynamic Information Systems, LLC
 * $Header: SearchHandler.java, 13, 1/26/2006 5:39:52 PM, Blake Von Haden$
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
 */package ims.handlers.nav;

import java.text.ParseException;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: SearchHandler.java, 13, 1/26/2006 5:39:52 PM, Blake Von Haden$
 */
public class SearchHandler extends BaseHandler
{

	private final static String NAV_QUERY = "navQuery";

	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("SearchHandler.handleEnvironment()");
		boolean result = true;

		ConnectionWrapper conn = null;

		try
		{
			conn = (ConnectionWrapper) ic.getResource();

			boolean validData = true;
			String searchPage = ic.getRequiredParameter("search_page");
			String displayTable = ic.getRequiredParameter("display_table");
			String jobNo = ic.getParameter("job_no");
			String jobName = ic.getParameter("job_name");
			String customer = ic.getParameter("customer");
			String jobStatusID = ic.getParameter("job_status_id");
			String jobTypeID = ic.getParameter("job_type_id");
			String workSite = ic.getParameter("work_site");
			String invoiceNo = ic.getParameter("invoice_no");

			StdDate startDate = null;
			StdDate endDate = null;

			// data validation
			if (ic.getParameter("begin_create_date").length() > 0)
			{
				try
				{
					startDate = new StdDate(ic.getParameter("begin_create_date"));
				}
				catch (ParseException e)
				{
					validData = false;
					ic.setTransientDatum("err@dates", "Please enter a valid start date.");
				}
			}
			if (ic.getParameter("end_create_date").length() > 0)
			{
				try
				{
					endDate = new StdDate(ic.getParameter("end_create_date"));
				}
				catch (ParseException e)
				{
					validData = false;
					ic.setTransientDatum("err@dates", "Please enter a valid end date.");
				}
			}
			if (startDate != null && endDate != null && startDate.after(endDate))
			{
				validData = false;
				ic.setTransientDatum("err@dates", "Please make sure the start date is before the end date");
			}

			// Advanced search only
			String serviceNoDescription = ic.getParameter("description");
			String serviceNo = ic.getParameter("service_no");
			String servStatusTypeName = ic.getParameter("serv_status");

			if (serviceNo != null && serviceNo.length() > 0)
			{
				try
				{
					Integer.parseInt(serviceNo);
				}
				catch (NumberFormatException e)
				{
					validData = false;
					ic.setTransientDatum("err@service_no", "Please enter a numerical requisiton number.");
				}
			}

			StringBuffer query = new StringBuffer();
			boolean has_criteria = false;

			if (validData)
			{
				query.append("SELECT job_service_id");
				query.append(" FROM job_services_v");
				query.append(" WHERE ( organization_id=").append(conn.toSQLString((String) ic.getRequiredSessionDatum("org_id")));

				if (StringUtil.hasAValue(jobNo))
				{
					query.append(" AND job_no LIKE ").append(conn.toSQLString(jobNo));
					has_criteria = true;
				}
				if (StringUtil.hasAValue(jobName))
				{
					query.append(" AND job_name LIKE ").append(conn.toSQLString(addWildCards(jobName)));
					has_criteria = true;
				}
				if (StringUtil.hasAValue(customer))
				{
					query.append(" AND customer_name LIKE ").append(conn.toSQLString(addWildCards(customer)));
					has_criteria = true;
				}
				if (StringUtil.hasAValue(workSite))
				{
					query.append(" AND job_location_name LIKE ").append(conn.toSQLString(addWildCards(workSite)));
					has_criteria = true;
				}
				if (StringUtil.hasAValue(jobStatusID))
				{
					query.append(" AND job_status_type_id = ").append(jobStatusID);
					has_criteria = true;
				}
				if (StringUtil.hasAValue(jobTypeID))
				{
					query.append(" AND job_type_id = ").append(jobTypeID);
					has_criteria = true;
				}
				if (startDate != null)
				{
					if (displayTable.equalsIgnoreCase("jobs"))
						query.append(" AND job_date_created >= ").append(conn.toSQLString(startDate));
					else
						query.append(" AND serv_date_created >= ").append(conn.toSQLString(startDate));
					has_criteria = true;
				}
				if (endDate != null)
				{
					if (displayTable.equalsIgnoreCase("jobs"))
						query.append(" AND job_date_created - 1 <= ").append(conn.toSQLString(endDate));
					else
						query.append(" AND serv_date_created - 1 <= ").append(conn.toSQLString(endDate));
					has_criteria = true;
				}
				if (StringUtil.hasAValue(invoiceNo))
				{
					String invoiceQuery = "SELECT TOP 1 job_id FROM job_services_v WHERE job_id in (SELECT job_id FROM invoices WHERE invoice_id like "
							+ conn.toSQLString(invoiceNo) + ")";
					QueryResults rs = conn.resultsQueryEx(invoiceQuery);
					InClause jobs = new InClause();
					while (rs.next())
					{
						jobs.add(rs.getString("job_id"));
					}
					query.append(" AND " + jobs.getInClause("job_id"));
					has_criteria = true;
				}

				// Advanced only
				if (StringUtil.hasAValue(serviceNoDescription))
				{
					query.append(" AND description LIKE ").append(conn.toSQLString(addWildCards(serviceNoDescription)));
					has_criteria = true;
				}
				if (StringUtil.hasAValue(serviceNo))
				{
					query.append(" AND service_no = ").append(conn.toSQLString(serviceNo));
					has_criteria = true;
				}
				if (StringUtil.hasAValue(servStatusTypeName))
				{
					query.append(" AND serv_status_type_name LIKE ").append(conn.toSQLString(addWildCards(servStatusTypeName)));
					has_criteria = true;
				}

				if (!has_criteria)
					query.append(" OR SERVICE_ID is null ");
				query.append(")");

				Diagnostics.debug(NAV_QUERY + " = " + query);
				ic.setSessionDatum(NAV_QUERY, query.toString());
				ic.setSessionDatum("display_table", displayTable);
				ic.setTransientDatum("queryGood", "true");
				SmartFormHandler.copyParametersToTransient(ic);
				ic.setHTMLTemplateName(searchPage);
			}
			else
			{
				ic.setTransientDatum("queryGood", "false");
				SmartFormHandler.copyParametersToTransient(ic);
				ic.setHTMLTemplateName(searchPage);
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in SearchHandler");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
		return result;
	}

	private static String addWildCards(String value)
	{
		return "%" + value + "%";
	}

}
