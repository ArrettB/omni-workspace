/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001-2006, Dynamic Information Systems, LLC
 * $Header: C:\work\ims\src\ims\handlers\proj\QuotePreHandler.java, 10, 3/21/2006 6:22:22 PM, Blake Von Haden$
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
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Header: C:\work\ims\src\ims\handlers\proj\QuotePreHandler.java, 10, 3/21/2006 6:22:22 PM, Blake Von Haden$
 */
public class QuotePreHandler extends BaseHandler
{

	public void setUpHandler(){}

	public void destroy(){}

	/**
	 * Handle Environment for Projects and Requests of the Extranet
	 */

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("QuotePreHandler.HandleEnvironment()");
		boolean success = true;

		ConnectionWrapper conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);

		String button = ic.getParameter("req_button");

		if (StringUtil.hasAValue(button) && (button.equalsIgnoreCase("Save") || button.equalsIgnoreCase("Send")))
		{
			// handle quoted_by_user_id
			ic.setParameter("quoted_by_user_id", (String) ic.getSessionDatum("user_id"));

			// handle quoted_date, only when sending
			if (button.equalsIgnoreCase("Send"))
			{
				ic.setParameter("date_quoted", "getDate()");
			}

			// handle request_type_id, used for merging quotes with requests in one table for pf_list.html
			Map request_types = MapUtil.getTypeMap(conn, "request_type");
			ic.setParameter("request_type_id", (String) request_types.get("quote"));

			// make certain description is uppercase.
			String description = ic.getParameter("description");
			if (description != null)
				ic.setParameter("description", StringUtil.toUpperCase(description));

			// handle quote_status
			Map quote_statuses = MapUtil.getTypeMap(conn, "quote_status_type");
			String quote_status_type_id = null;

			if (button.equalsIgnoreCase("Save"))
			{
				quote_status_type_id = (String) quote_statuses.get("saved");
				ic.setParameter("quote_status_type_id", quote_status_type_id);
			}
			else if (button.equalsIgnoreCase("Send"))
			{
				quote_status_type_id = (String) quote_statuses.get("sent");
				ic.setParameter("quote_status_type_id", quote_status_type_id);
				ic.setParameter("is_sent", "Y");
			}
			else
			{
				SmartFormHandler.addSmartFormError(ic, "Failed to determine status for quote.  Please notify your System Admin.");
				Diagnostics.error("Failed to determine quote_status_type_id");
				success = false;
			}
		}
		else if (StringUtil.hasAValue(button) && button.equalsIgnoreCase("archive"))
		{
			String quote_id = ic.getParameter("quote_id");
			success = PDSPreHandler.archive(ic, conn, "quote", quote_id);
		}

		return success;
	}

}
