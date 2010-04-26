/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001,2003,2006, Dynamic Information Systems, LLC
 * $Header: QuoteHandler.java, 9, 1/27/2006 1:58:10 PM, Blake Von Haden$
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
package ims.handlers.job_processing;

import ims.dataobjects.User;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Id: QuoteHandler.java, 1098, 3/6/2008 9:28:04 AM, David Zhao$
 */
public class QuoteHandler extends BaseHandler
{
	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("QuoteHandler.handleEnvironment()");
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{

			String quote_id = (String) ic.getParameter("quote_id");
			User user = (User) ic.getSessionDatum("user");
			int user_id = user.getUserID();
			String template_name = (String) ic.getParameter("template");
			ic.setHTMLTemplateName(template_name);
			// Diagnostics.debug2("template='"+template_name+"'");

			if (!StringUtil.hasAValue(quote_id))
			{
				ErrorHandler.handleError(ic, "Missing quote_id in QuoteHandler",
						"Cannot update conditions in QuoteHandler action=condition failed.");
			}
			else if (user_id == 0)
			{
				ErrorHandler.handleError(ic, "Missing user_id in QuoteHandler",
						"Cannot update conditions in QuoteHandler action=condition failed.");
			}
			else
			{
				// Diagnostics.debug2("Attempting to update conditions for quote_id = "+quote_id+"...");

				String conditions[] = (String[]) ic.getParameterValues("statusCheckBox");

				conn = (ConnectionWrapper) ic.getResource("SQLServer");
				StringBuffer query = new StringBuffer();
				query.append("DELETE FROM quote_conditions where quote_id=" + quote_id);

				// Diagnostics.debug2("Delete from quote_conditions Query = '"+query.toString() +"'");
				conn.updateEx(query);
				// Diagnostics.debug2("Deleted ("+rows+") rows from quote_conditions table.");
				if (conditions == null) // handle case when updating to have no conditions selected
					conditions = new String[0];
				// Diagnostics.debug2("# of Conditions on quote = '"+conditions.length+"'");

				String insert = "INSERT INTO quote_conditions VALUES (" + quote_id + ",";
				for (int i = 0; i < conditions.length; i++)
				{
					Diagnostics.debug2("inserted condition_id='" + (conditions[i]).substring((conditions[i]).indexOf(":") + 1)
							+ "'");
					// note need to pull off Y:1, y indicates that it was previously selected, used on template
					conn.updateEx(insert + (conditions[i]).substring((conditions[i]).indexOf(":") + 1) + ",'Y',getDate(),"
							+ user_id + ",null,null)");
				}
				// set audit trail, update quote since we updated its conditions
				conn.updateEx("UPDATE quotes set date_modified=getDate(), modified_by=" + user_id + " where quote_id=" + quote_id);

			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in QuoteHandler action=condition failed.");
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}
		return result;
		// Diagnostics.debug2("QuoteHandler completed the condition update.");
	}
}
