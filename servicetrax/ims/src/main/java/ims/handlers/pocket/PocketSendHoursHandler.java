/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2003, Dynamic Information Systems, LLC
 * $Header: PocketApproveHoursHandler.java, 2, 1/27/2004 10:48:01 AM, Greg Case$

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
package ims.handlers.pocket;

import ims.listeners.IMSApplicationContextListener;

import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;

/**
 * @author gcase
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class PocketSendHoursHandler extends BaseHandler
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
		Diagnostics.debug("PocketSendHoursHandler.handleEnvironment()");
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

			if (button.equalsIgnoreCase("send"))
			{
				result = handleSend(ic, conn);
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
	private boolean handleSend(InvocationContext ic, ConnectionWrapper conn) throws SQLException
	{
		boolean result = false;
		String approvedStatusID = getSubmittedStatusId(ic);
		String[] serviceLineIDs = ic.getParameterValues("send_cb");

		if (serviceLineIDs != null)
		{

			StringBuffer update = null;
			for (int i = 0; i < serviceLineIDs.length; i++)
			{
				String serviceLineID = serviceLineIDs[i];
				update = new StringBuffer();
				update.append("UPDATE service_lines");
				update.append(" SET status_id = ").append(approvedStatusID);
				update.append(" WHERE service_line_id = ").append(serviceLineID);

				conn.updateEx(update);
			}

		}
		else
		{
			ic.setTransientDatum("error", "Please select at least one line to approve.");
		}

		result = true;
		return result;
	}

	private static String getSubmittedStatusId(InvocationContext ic) {
		return (String) ic.getAppGlobalDatum(IMSApplicationContextListener.SERVICE_LINE_STATUS_MAP + ":submitted");
	}

	/**
	 * @see dynamic.intraframe.handlers.BaseHandler#destroy()
	 */
	public void destroy()
	{
	}

}
