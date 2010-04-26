/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2003-2006, Dynamic Information Systems, LLC
 * $Header: PocketMACSearchHandler.java, 3, 1/26/2006 5:32:54 PM, Blake Von Haden$
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
 */package ims.handlers.pocket;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase
 * 
 * @version $Header: PocketMACSearchHandler.java, 3, 1/26/2006 5:32:54 PM, Blake Von Haden$
 */
public class PocketReqSearchHandler extends BaseHandler
{
	public static final String PARAM_PREFIX = "reqSearch_";
	public void setUpHandler() throws Exception
	{
	}

	public void destroy()
	{
	}

	public String getParameterAndPersist(InvocationContext ic, String paramName)
	{
		if (paramName == null)
			return null;
		
		paramName = PARAM_PREFIX + paramName;
		String result = ic.getParameter(paramName);
		if (result != null && result.length() > 0)
			ic.setSessionDatum(paramName, result);
		else
			ic.removeSessionDatum(paramName);
		return result;
	}
	
	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		boolean result = true;
		ConnectionWrapper conn = null;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			String serviceNo = getParameterAndPersist(ic, "number");
			String location = getParameterAndPersist(ic, "location");
			String startDate = getParameterAndPersist(ic, "start_date");
			String customer = getParameterAndPersist(ic, "customer");
			String priority = getParameterAndPersist(ic, "priority");
			String description = getParameterAndPersist(ic, "description");
			
			StdDate parsed = null;
			try
			{
				parsed = new StdDate(startDate); 	
			}
			catch (ParseException pe)
			{
				Diagnostics.warning("Could not parse date value of " + startDate +  ", skipping");
			}

			
			ClauseObj clause = new ClauseObj();
			clause.addContainsQuery("service_no", serviceNo);
			clause.addContainsQuery("job_location_name", location);
			clause.addContainsQuery("customer_name", customer);
			clause.addContainsQuery("priority", priority);
			clause.addContainsQuery("service_description", description);
			clause.addDateQuery("sch_start_date", parsed, conn);
				
			ic.setTransientDatum("searchCriteria", clause.evaluate());
			ic.setHTMLTemplateName("pocket/project_list.html");
			
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in PDAPreFlightHandler");
			result = false;			
		}
		finally
		{
			if (conn != null)
				conn.release();
		}
		return result;
	}

	private static class ClauseObj
	{
		private List parts;
		
		ClauseObj()
		{
			this.parts = new ArrayList();
		}
		
		public void addContainsQuery(String column, String criteria)
		{
			if (criteria == null || criteria.length() == 0)
				return;
			
			
			criteria = criteria.trim();
			criteria = StringUtil.toSQLString("%" + criteria + "%");
			parts.add("LOWER(" + column + ") LIKE " + criteria);
			
		}
		
		public void addDateQuery(String column, StdDate date, ConnectionWrapper conn)
		{
			if (date == null)
				return;
			
			parts.add(column + " = " + conn.toSQLString(date));
		}
		
		
		public String evaluate()
		{
			StringBuffer result = new StringBuffer();
			if (!parts.isEmpty())
			{
				result.append("( ").append(parts.get(0));
				for (int i = 1, n = parts.size(); i < n; i++)
				{
					result.append(" AND ").append(parts.get(i));
				}
				result.append(")");
			}
			else
			{
				result.append("(1=1)");
			}
			return result.toString();
		}
		
		public String toString()
		{
			return evaluate();
		}
		
	}
	
	
}
