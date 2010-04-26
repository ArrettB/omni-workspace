/*
 * Dynamic Information Systems, LLC This software can only be used with the
 * expressed written consent of Dynamic Information Systems. All rights
 * reserved. Copyright 2003, Dynamic Information Systems, LLC 
 * $Revision: 1100 $Date: 12/12/2005 5:01:17 PM$
 * THIS
 * SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DYNAMIC
 * INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */
package ims.handlers.maintenance;

import ims.helpers.MergeTableUtil;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @author gcase To change the template for this generated type comment go to
 *         Window>Preferences>Java>Code Generation>Code and Comments
 *         
 * @version $Id: UserJobTypeHandler.java 1100 2008-03-06 17:36:02Z dzhao $
 */
public class UserJobTypeHandler extends BaseHandler
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
		Diagnostics.debug("UserVendorHandler.handleEnvironment()");
		boolean result = true;
		boolean prePostHandler = false;
		ConnectionWrapper conn = null;
		String button = null;
		try
		{
			button = ic.getRequiredParameter(SmartFormComponent.BUTTON);
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

			if (button.equalsIgnoreCase("save"))
			{
				result = handleVendorSave(ic, conn);
			}

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
	private boolean handleVendorSave(InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		boolean result = true;
		try
		{
			String jobTypeIDs = ic.getParameter("job_type_id_list");
			String userID = ic.getRequiredParameter("user_id");
			List jobTypeIDList = null;
			if (jobTypeIDs != null && jobTypeIDs.length() > 0)
			{
				jobTypeIDList = StringUtil.stringToVector(jobTypeIDs);
			}
			else
			{
				jobTypeIDList = new ArrayList();
			}
			ArrayList<String> auditColumns = new ArrayList<String>();
			auditColumns.add("created_by");
			
			ArrayList<String> auditValues = new ArrayList<String>();
			auditValues.add((String) ic.getSessionDatum("user_id"));
			MergeTableUtil.updateJoinTable("user_id", "lookup_id", userID, jobTypeIDList, "user_job_types", "lookups", auditColumns, auditValues, conn);
			ic.setHTMLTemplateName("close_refresh_parent.html");
		}
		catch (Exception e)
		{
			ic.setHTMLTemplateName("mnt/user_job_types.html");
			ic.setTransientDatum("error", "An unknown error occured: " + e.getMessage());
		}
		return result;
	}

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#destroy()
	 */
	public void destroy()
	{
	}

}
