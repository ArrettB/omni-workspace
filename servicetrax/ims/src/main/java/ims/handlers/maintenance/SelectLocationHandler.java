/*
 *                Apex IT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of Apex IT, Inc. All rights reserved.
 *
 * Copyright 2006 Apex IT, Inc.
 * $Header: C:\work\ims\src\ims\handlers\maintenance\SelectLocationHandler.java, 2, 4/6/2006 11:22:09 AM, Blake Von Haden$
 *
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
package ims.handlers.maintenance;

import ims.dataobjects.Organization;

import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * Set up the selected organization in session for the user, but 
 * validate that the user actually has permission for the organization first.
 * 
 * @version $Header: C:\work\ims\src\ims\handlers\maintenance\SelectLocationHandler.java, 2, 4/6/2006 11:22:09 AM, Blake Von Haden$
 */
public class SelectLocationHandler extends BaseHandler
{
	public void setUpHandler(){}

	public void destroy(){}

	public boolean handleEnvironment(InvocationContext ic)
	{
		boolean bRet = true;

		try
		{
			Diagnostics.debug2("SelectLocationHandler.handleEnvironment()");

			String orgID = ic.getParameter("org_id");
			if (orgID == null || orgID.length() == 0)
			{
				ic.setTransientDatum("message", "You must pick an organization to continue."
						+ "<script type=\"text/javascript\">"
						+ "   document.loginform.org_id.focus() "
						+ "</script>");
				bRet = false;
			}
			else
			{
				// validate the organization is valid for the user
				if (validOrg(orgID, ic))
				{
					Organization myOrg = Organization.fetch(orgID, ic);

					Diagnostics.debug("myOrg = " + myOrg.toString());

					ic.setSessionDatum("org_id", Integer.toString(myOrg.getOrganizationID()));
					ic.setSessionDatum("org_name", myOrg.getName());
					ic.setSessionDatum("org_code", myOrg.getCode());
					ic.setSessionDatum("org_resource", myOrg.getResourceName());
					ic.setSessionDatum("ext_direct_dealer_id", myOrg.getExtDirectDealerID().trim());
					ic.setSessionDatum("org_db", myOrg.getDbPrefix());
					ic.setSessionDatum("pay_code_table", myOrg.getPayCodeTable());
				}
				else
				{
					bRet = false;
				}
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in UserAccessHandler");
		}

		if (!bRet)
		{
			ic.setTransientDatum("user_name", ic.getParameter("username"));
			ic.setHTMLTemplateName(ic.getParameter("locationTemplate"));
		}

		return bRet;
	}

	/**
     * 
     * @param orgID
     * @param ic
     * @return true if this is a valid organization for the user.
     * @throws Exception
     */
	private boolean validOrg(String orgID, InvocationContext ic) throws Exception
	{
		// now check the organization
		// we do this step separately so we can give a better
		// error message
		// if they picked the wrong org
		QueryResults rs_org = null;
		ConnectionWrapper conn = null;
		boolean valid_org = false;
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			String userID = (String) ic.getSessionDatum("user_id");
			rs_org = conn.select("SELECT organization_id FROM user_organizations WHERE user_id = ?", userID);
			String org_id = null;
			while (rs_org.next())
			{
				org_id = rs_org.getString(1);
				if (org_id != null && org_id.equals(orgID))
					valid_org = true;
			}
		}
		finally
		{
			try
			{
				if (rs_org != null)
					rs_org.close();
			}
			catch (SQLException ignore)
			{}
			if (conn != null)
				conn.release();
		}

		if (!valid_org)
		{
			// they typed in a user name and password
			ic.setTransientDatum("message",
					"Login failed.  You do not have access to that Location, <BR><BR>Please choose another Location...<BR><BR>"
							+ "<script type=\"text/javascript\">"
							+ "   document.loginform.org_id.focus() "
							+ "</script>");
		}
		return valid_org;
	}

}
