/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001-2006, Dynamic Information Systems, LLC
 * $Header: QuotePostHandler.java, 12, 1/27/2006 1:58:10 PM, Blake Von Haden$
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
 */package ims.handlers.proj;

import ims.helpers.MapUtil;

import java.util.Map;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: QuotePostHandler.java, 12, 1/27/2006 1:58:10 PM, Blake Von Haden$
 */
public class QuotePostHandler extends BaseHandler
{
	public static final String OLD_QUOTE_STYLE = "oldQuoteStyle";

	public void setUpHandler(){}

	public void destroy(){}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("QuotePostHandler.handleEnvironment()");
		boolean result = true;

		/*
		 * Note: Because this is PostHandler with SmartFormHandler, we do NOT catch the exception or release the resource ourselves
		 */

		// set data for acknowledgement popup window: note ack_email_info was set by PDSEmailHandler
		String button = ic.getParameter("req_button");
		String mode = ic.getParameter(SmartFormComponent.MODE);
		String project_id = (String) ic.getSessionDatum("project_id");
		String request_type_code = ic.getParameter("request_type_code");
		String quote_id = ic.getParameter("quote_id");
		String quote_no = ic.getParameter("quote_no");

		if (StringUtil.hasAValue(button))
		{
			if (button.equals(SmartFormComponent.Save) || button.equalsIgnoreCase("Send"))
			{
				if (!(button.equals(SmartFormComponent.Save) && mode.equals(SmartFormComponent.Update)))
				{// if saving while in update, don't wan't to show acknowledge window.
					Diagnostics.debug2("Set parameter 'acknowledgement' = true");
					ic.setTransientDatum("acknowledgement", "true"); // clear parameter so user can enter new record after this
																		// save.
					ic.setTransientDatum("is_sent", ic.getParameter("is_sent"));
					ic.setTransientDatum("request_type_code", request_type_code);
					ic.setTransientDatum("request_id", quote_id);
					ic.setTransientDatum("request_no", quote_no);
				}
			}

			if (button.equalsIgnoreCase("Send"))
			{
				ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

				StringBuffer query = new StringBuffer();
				query.append("UPDATE requests SET is_quoted='Y' WHERE request_id = (");
				query.append(" SELECT request_id FROM request_max_version_v ");
				query.append(" WHERE project_id = " + conn.toSQLString(project_id));
				query.append("   AND request_no = " + conn.toSQLString(quote_no));
				query.append(")");

				int rows = conn.updateEx(query);
				if (rows == 1)
				{// found, that means we were converting a project_folder request to another request
				}
				else
				{
					Diagnostics.debug2("Error, failed to set is_quoted='Y' for quote_id ='" + quote_id + "'");
					result = false;
				}

				// handle case when updating workorder, need to change status
				Map statuses = MapUtil.getTypeMap(conn, "workorder_status_type");
				String request_status_type_id = (String) statuses.get("unapproved");
				query = new StringBuffer();
				query.append("UPDATE requests_v SET request_status_type_id=").append(conn.toSQLString(request_status_type_id));
				query.append(" WHERE ");
				query.append(" request_type_code = 'workorder' ");
				query.append(" AND request_id = (");
				query.append(" SELECT request_id FROM request_max_version_v ");
				query.append(" WHERE project_id = ").append(conn.toSQLString(project_id));
				query.append("   AND request_no = ").append(conn.toSQLString(quote_no));
				query.append(")");

				rows = conn.updateEx(query);
				if (rows == 1)
				{// found, that means we were converting a project_folder request to another request
					Diagnostics.debug2("Updated request for quote_id '" + quote_id + "', set status to unapproved.");
				}

			}

			// if made it this far and we are sending, then email contacts;
			if (result && button.equalsIgnoreCase("Send"))
			{
				ic.setTransientDatum(OLD_QUOTE_STYLE, true);
				ic.setTransientDatum("record_id", ic.getParameter("quote_id"));
				ic.setTransientDatum("record_type_code", request_type_code);
				boolean email_result = ic.dispatchHandler("ims.handlers.proj.PDSEmailHandler");
				if (!email_result)
				{
					Diagnostics.error("PDSPostHandler.handleEnvironment() emailing failed.");
					ic.setTransientDatum("email_failed", "true");
				}
			}

			if (result == true)
				ic.setHTMLTemplateName("enet/req/q_list.html");

		}
		return result;
	}
}
