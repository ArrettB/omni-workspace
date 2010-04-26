/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001-2006, Dynamic Information Systems, LLC
 * $Header: EnetSearchHandler.java, 14, 9/19/2006 11:22:15 AM, Greg Case$
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
package ims.handlers.nav;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 *
 * @version $Id: EnetSearchHandler.java 1199 2008-04-24 19:15:15Z john.freier $
 */
public class EnetSearchHandler extends BaseHandler
{
	private final static String ENET_NAV_QUERY = "enetNavQuery";

	public void setUpHandler(){}

	public void destroy(){}

	private void addSearchCriteria(StringBuffer query, InvocationContext ic, ConnectionWrapper conn, String column, boolean doLike)
	{
		String value = ic.getParameter(column);
		if (value != null && value.trim().length() > 0)
		{
			if (doLike)
			{
				value = addWildCards(value);
				query.append(" AND r.").append(column).append(" LIKE ").append(StringUtil.toPStmtString(value));

			}
			else
			{
				query.append(" AND r.").append(column).append(" = ").append(StringUtil.toPStmtString(value));
			}
		}
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("EnetSearchHandler.handleEnvironment()");
		boolean result = true;

		ConnectionWrapper conn = null;

		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			ic.removeSessionDatum("contacts_table"); // don't want that causing
			// a cross join monster
			// query

			String contactType = ic.getParameter("contact_type");
			String contactName = ic.getParameter("contact_name");
			String resultType = ic.getParameter("result_type");
			boolean currentVersion = StringUtil.hasAValue(ic.getParameter("current_version"));
			boolean searchContacts = StringUtil.hasAValue(contactName);
			boolean validData = true;
			// validate search criteria...none at the moment.

			StringBuffer query = new StringBuffer();

			if (validData)
			{
				addSearchCriteria(query, ic, conn, "customer_name", true);
				addSearchCriteria(query, ic, conn, "end_user_name", true);
				addSearchCriteria(query, ic, conn, "project_no", true);
				addSearchCriteria(query, ic, conn, "request_no", false);
				addSearchCriteria(query, ic, conn, "version_no", false);
				addSearchCriteria(query, ic, conn, "job_name", true);
//				addSearchCriteria(query, ic, conn, "dealer_project_no", true);
				addSearchCriteria(query, ic, conn, "dealer_po_no", true);
				addSearchCriteria(query, ic, conn, "customer_po_no", true);
//				addSearchCriteria(query, ic, conn, "design_project_no", true);
				addSearchCriteria(query, ic, conn, "record_status_type_name", false);

				if (searchContacts)
				{
					ic.setSessionDatum("contacts_table", ", contacts c");
					if (contactType.equalsIgnoreCase("all"))
					{
						query.append(" AND (");
						query.append(" c.contact_id = r.customer_contact_id");
						query.append(" OR c.contact_id = r.d_sales_rep_contact_id");
						query.append(" OR c.contact_id = r.d_sales_sup_contact_id");
						query.append(" OR c.contact_id = r.d_designer_contact_id");
						query.append(" OR c.contact_id = r.d_proj_mgr_contact_id");
						query.append(" OR c.contact_id = r.a_m_contact_id");
						query.append(" OR c.contact_id = r.a_m_install_sup_contact_id");
						query.append(" OR c.contact_id = r.furniture1_contact_id");
						query.append(" OR c.contact_id = r.furniture2_contact_id");
						query.append(" OR c.contact_id = r.a_d_designer_contact_id");
						query.append(" OR c.contact_id = r.gen_contractor_contact_id");
						query.append(" OR c.contact_id = r.electrician_contact_id");
						query.append(" OR c.contact_id = r.data_phone_contact_id");
						query.append(" OR c.contact_id = r.phone_contact_id");
						query.append(" OR c.contact_id = r.carpet_layer_contact_id");
						query.append(" OR c.contact_id = r.other_contact_id");
						query.append(")");
						query.append(" AND c.contact_name LIKE " + StringUtil.toPStmtString(addWildCards(contactName)));
					}
					else
					{
						query.append(" AND r.").append(contactType).append(" =  c.contact_id");
						query.append(" AND c.contact_name LIKE " + StringUtil.toPStmtString(addWildCards(contactName)));
					}
				}

				if (currentVersion)
					query.append(" AND r.version_no = r.max_version_no");

				Diagnostics.debug(ENET_NAV_QUERY + " = " + query);

				ic.setSessionDatum(ENET_NAV_QUERY, query.toString());
				ic.setSessionDatum("result_type", resultType);
				ic.setSessionDatum("archive", ic.getParameter("record_status_type_name"));
				ic.setTransientDatum("queryGood", "true");
				SmartFormHandler.copyParametersToTransient(ic);

				// special case for vendor view to show only and all status of
				// workorders
				ic.setTransientDatum("status", "ignore");
				ic.setTransientDatum("status_seq_no", "0");


				ic.setHTMLTemplateName("enet/search_form.html");
			}
			else
			{
				ic.setTransientDatum("queryGood", "false");
				SmartFormHandler.copyParametersToTransient(ic);
				ic.setHTMLTemplateName("enet/search_form.html");
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in EnetSearchHandler");
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
		return "%" + value.trim() + "%";
	}

}
