/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: TimeCapturePreHandler.java, 15, 12/21/2005 4:49:17 PM, Blake Von Haden$
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
package ims.handlers.time_capture;

import java.text.ParseException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * @version $Header: TimeCapturePreHandler.java, 15, 12/21/2005 4:49:17 PM, Blake Von Haden$
 */
public class TimeCapturePreHandler extends BaseHandler
{
	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("TimeCapturePreHandler.handleEnvironment()");
		boolean result = true;

		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

		/*
		 * Note: Because this is PostHandler with SmartFormHandler, we do NOT catch the exception or release the resource ourselves
		 */

		// make sure that we are actually supposed to be saving.
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		Diagnostics.debug2("button = " + button);
		if (button != null && button.equals(SmartFormComponent.Save))
		{
			Diagnostics.debug2("Saving");
			String mode = ic.getParameter("mode");
			if (mode != null && mode.equalsIgnoreCase("Insert"))
			{
				ic.setParameter("entered_by", (String) ic.getSessionDatum("user_id"));
				ic.setParameter("entered_date", "getDate()");
				ic.setParameter("entry_method", "WEB");
			}

			String itemTypeCode = ic.getRequiredParameter("item_type_code");

			String module = ic.getRequiredParameter("module");
			boolean billing = false;
			if (module != null && module.equalsIgnoreCase("bill"))
				billing = true;

			if (!billing)
				result = result && checkRequiredStringField(ic, "resource_id", "Resource");
			result = result && checkRequiredStringField(ic, "item_id", "Item");
			result = result && checkRequiredDateField(ic, "service_line_date", "Date");

			Diagnostics.debug2("Done with required fields, imtermediate result is " + result);
			Diagnostics.debug2("itemTypeCode = " + itemTypeCode + ", module = '" + module + "'");

			if (itemTypeCode.equalsIgnoreCase("hours"))
			{
				// need to call the qty field "Hours"
				if (!billing)
				{
					result = result && checkRequiredDoubleField(ic, "tc_qty", "Quantity");
					result = result && checkRequiredStringField(ic, "tc_job_id", "Job");
					result = result && checkRequiredStringField(ic, "tc_service_id", "Requisition");
					// we also need to check the paycode
					result = result && checkRequiredStringField(ic, "ext_pay_code", "Pay Code");

					// and then verify the paycode against the item
					String itemID = ic.getParameter("item_id");
					String payCode = ic.getParameter("ext_pay_code");
					if (payCode != null)
						payCode = payCode.trim();

					if (result)
					{
						if (!validPayCodeForItem(itemID, payCode, conn, ic))
						{
							ic.setTransientDatum("PayCodeWarning", "true");
						}
					}
				}
				else
				// must be bill
				{
					result = result && checkRequiredDoubleField(ic, "bill_qty", "Quantity");
					result = result && checkRequiredDoubleField(ic, "bill_rate", "Rate");
					result = result && checkRequiredStringField(ic, "bill_job_id", "Job");
					result = result && checkRequiredStringField(ic, "bill_service_id", "Requisition");
				}
			}
			else if (itemTypeCode.equalsIgnoreCase("expense"))
			{
				// need to call the qty "Amount" and "Quantity" fields
				if (!billing)
				{
					result = result && checkRequiredDoubleField(ic, "tc_qty", "Quantity");
					result = result && checkRequiredDoubleField(ic, "tc_rate", "Rate");
					result = result && checkRequiredStringField(ic, "tc_job_id", "Job");
					result = result && checkRequiredStringField(ic, "tc_service_id", "Requisition");
				}
				else
				// must be bill
				{
					result = result && checkRequiredDoubleField(ic, "bill_qty", "Quantity");
					result = result && checkRequiredDoubleField(ic, "bill_rate", "Rate");
					result = result && checkRequiredStringField(ic, "bill_job_id", "Job");
					result = result && checkRequiredStringField(ic, "bill_service_id", "Requisition");
				}

			}
		}
		else if (button != null && button.equals(SmartFormComponent.Cancel))
		{// if line from invoice's billable section, then invoice_id got saved on line auto assigning to invoice
			// didn't want that so passed p_invoice_id instead. Problem, had to pass back invoice_id when done so we set that here.
			String p_invoice_id = ic.getParameter("p_invoice_id");
			if (StringUtil.hasAValue(p_invoice_id))
				ic.setParameter("invoice_id", p_invoice_id);
		}
		Diagnostics.debug2("TimeCapturePreHandler.handleEnvironment() is returning " + result);
		return result;

	}

	private boolean checkRequiredStringField(InvocationContext ic, String fieldName, String actualName)
	{
		Diagnostics.trace("TimeCapturePreHandler.checkRequiredStringField()");
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
		Diagnostics.trace("TimeCapturePreHandler.checkRequiredDoubleField()");
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

	private boolean checkRequiredDateField(InvocationContext ic, String fieldName, String actualName)
	{
		Diagnostics.trace("TimeCapturePreHandler.checkRequiredDateField()");
		boolean result = true;
		String value = null;

		value = ic.getParameter(fieldName);
		if (value == null || value.length() == 0)
		{
			Diagnostics.warning("Mandatory date field " + fieldName + " is not present");
			SmartFormHandler.addSmartFormError(ic, actualName + " is a required field.  Please enter it before continuing on.");
			result = false;
		}
		else
		{
			try
			{
				new StdDate(value);
			}
			catch (ParseException e)
			{
				Diagnostics.warning("Mandatory date field " + fieldName + " could not be parsed, value is " + value);
				SmartFormHandler.addSmartFormError(ic, "The value entered for " + actualName + " could not be understood.");
				result = false;
			}
		}
		return result;
	}

	public static boolean validPayCodeForItem(String itemID, String payCodeID, ConnectionWrapper conn, InvocationContext ic)
			throws Exception
	{
		boolean result = true;

		Diagnostics.debug("TimeCapturePreHandler.validPayCodeForItem()");
		Diagnostics.debug("payCodeID = " + payCodeID);
		Diagnostics.debug("itemID = " + itemID);
		String tableName = (String) ic.getSessionDatum("pay_code_table");
		if (tableName != null)
		{
			String itemName = conn.queryEx("SELECT name FROM items WHERE item_id = " + itemID);
			String payCodeName = conn.queryEx("SELECT dscriptn FROM " + tableName 
					+ " WHERE payrcord = " + conn.toSQLString(payCodeID));

			Diagnostics.debug("itemName = " + itemName);
			Diagnostics.debug("payCodeName = " + payCodeName);

			// check to see if the itemname has a qualifer to it, such as "Installer Time - Reg");
			int index = itemName.lastIndexOf("-");
			if (index > 0)
			{
				String itemQualif = itemName.substring(index + 1).trim();
				Diagnostics.debug("itemQualif = " + itemQualif);

				// now check the paycodename also for a qualifier
				index = payCodeName.lastIndexOf("-");
				if (index > 0)
				{
					String payCodeQualif = payCodeName.substring(index + 1).trim();
					Diagnostics.debug("payCodeQualif = " + payCodeQualif);

					if (!(itemQualif.equalsIgnoreCase(payCodeQualif)))
					{
						result = false;
						Diagnostics.warning("Paycode '" + payCodeName + "' not allowed for this item:" + itemName);
					}
				}
				else
				{
					Diagnostics.debug("No qualifier on paycode name, allowing paycode");
				}
			}
			else
			{
				Diagnostics.debug("No qualifier on item name, allowing paycode");
			}
		}
		else
		{
			Diagnostics.error("No value set in session datum for pay_code_table");
		}
		return result;
	}

}
