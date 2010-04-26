/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2003,2006, Dynamic Information Systems, LLC
 * $Header: PocketTimeCapturePreHandler.java, 2, 1/26/2006 5:35:03 PM, Blake Von Haden$
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

import ims.listeners.IMSApplicationContextListener;

import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: PocketTimeCapturePreHandler.java, 2, 1/26/2006 5:35:03 PM, Blake Von Haden$
 */
public class PocketTimeCapturePreHandler extends BaseHandler
{
	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("PocketTimeCapturePreHandler.handleEnvironment()");
		boolean result = true;

		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

		/*
		 * Note: Because this is PostHandler with SmartFormHandler, we do NOT catch the exception or release the resource ourselves
		 */

		// make sure that we are actually supposed to be saving.
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		String mode = ic.getParameter(SmartFormComponent.MODE);
		String itemTypeCode = "hours";

		if (button != null && button.equals(SmartFormComponent.Save))
		{
			if (mode != null && mode.equalsIgnoreCase(SmartFormComponent.Insert))
			{
				ic.setParameter("entered_by", (String) ic.getSessionDatum("user_id"));
				ic.setParameter("entered_date", "getDate()");
				ic.setParameter("entry_method", "PDA");
				ic.setParameter("status_id", getNewStatusID(ic));
			}

			result = result && checkRequiredStringField(ic, "resource_id", "Resource");
			result = result && checkRequiredStringField(ic, "item_id", "Item");
			String serviceLineDate = ic.getParameter("service_line_date");
			if (!StringUtil.hasAValue(serviceLineDate))
			{
				ic.setParameter("serviceLineDate", "getDate()");

			}

			Diagnostics.debug2("Done with required fields, imtermediate result is " + result);

			if (itemTypeCode.equalsIgnoreCase("hours"))
			{
				result = result && checkRequiredDoubleField(ic, "tc_qty", "Quantity");
				result = result && checkRequiredStringField(ic, "tc_job_id", "Job");
				result = result && checkRequiredStringField(ic, "tc_service_id", "Requisition");

				String itemID = ic.getParameter("item_id");
				String payCode = getPayCodeForItem(itemID, ic, conn);
				ic.setParameter("ext_pay_code", payCode);

			}
			else if (itemTypeCode.equalsIgnoreCase("expense"))
			{
				result = result && checkRequiredDoubleField(ic, "tc_qty", "Quantity");
				result = result && checkRequiredDoubleField(ic, "tc_rate", "Rate");
				result = result && checkRequiredStringField(ic, "tc_job_id", "Job");
				result = result && checkRequiredStringField(ic, "tc_service_id", "Requisition");
			}
		}
		else if (button != null && button.equals(SmartFormComponent.Cancel))
		{
		}

		Diagnostics.debug2("PDATimeCapturePreHandler.handleEnvironment() is returning " + result);
		return result;

	}

	private boolean checkRequiredStringField(InvocationContext ic, String fieldName, String actualName)
	{
		Diagnostics.trace("PDATimeCapturePreHandler.checkRequiredStringField()");
		boolean result = true;
		String value = null;

		value = ic.getParameter(fieldName);
		if (value == null || value.trim().length() == 0)
		{
			Diagnostics.warning("Mandatory string field " + fieldName + " is not present");
			SmartFormHandler.addSmartFormError(ic, actualName + " is a required field.  Please enter it before continuing on.");
			result = false;
		}

		return result;
	}

	private boolean checkRequiredDoubleField(InvocationContext ic, String fieldName, String actualName)
	{
		Diagnostics.trace("PDATimeCapturePreHandler.checkRequiredDoubleField()");
		boolean result = true;
		String value = null;

		value = ic.getParameter(fieldName);
		if (value == null || value.length() == 0)
		{
			Diagnostics.warning("Mandatory double field " + fieldName + " is not present");
			SmartFormHandler.addSmartFormError(ic, actualName + " is a required field.  Please enter it before continuing on.");
			result = false;
		}
		else
		{
			try
			{
				Double.parseDouble(value);
			}
			catch (NumberFormatException e)
			{
				Diagnostics.warning("Mandatory double field " + fieldName + " could not be parsed, value is " + value);
				SmartFormHandler.addSmartFormError(ic, "The value entered for " + actualName + " could not be understood.");
				result = false;
			}
		}
		return result;
	}

	public static String getPayCodeForItem(String itemID, InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		String orgID = (String) ic.getRequiredSessionDatum("org_id");

		String viewName = conn.queryEx("SELECT pda_item_paycodes_table FROM organizations WHERE organization_id = " + orgID);
		String payCode = conn.queryEx("SELECT pay_code FROM " + viewName + " WHERE item_id = " + itemID);

		return payCode;
	}

	public static String getNewStatusID(InvocationContext ic) throws SQLException {
		return (String) ic.getAppGlobalDatum(IMSApplicationContextListener.SERVICE_LINE_STATUS_MAP + ":new");
	}

}
