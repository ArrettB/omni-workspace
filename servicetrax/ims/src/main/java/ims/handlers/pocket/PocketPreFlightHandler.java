/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2003, Dynamic Information Systems, LLC
* $Header: PocketPreFlightHandler.java, 2, 12/22/2004 9:12:58 AM, Greg Case$

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

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.date.StdDate;
import dynamic.util.diagnostics.Diagnostics;

/**
 * @author gcase
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class PocketPreFlightHandler extends BaseHandler
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
	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		boolean result = true;
		ConnectionWrapper conn = null;
		
		try
		{
			conn = (ConnectionWrapper) ic.getResource();
			StdDate currentDay = null;
			Diagnostics.debug2("PocketPreFlightHandler.handleEnvironment()");
			String serviceLineID = ic.getParameter("service_line_id");
			if (serviceLineID != null && serviceLineID.length() > 0)
			{
				String dateQuery = "SELECT service_line_date FROM service_lines WHERE service_line_id = " + serviceLineID;
				String temp = conn.queryEx(dateQuery);
				if (temp != null)
					currentDay = new StdDate(temp);			
			}
			else
			{
				String serviceLineDate = ic.getParameter("service_line_date");
				if (serviceLineDate == null)
				{			
					currentDay = new StdDate();	
				}
				else
				{
					currentDay = new StdDate(serviceLineDate);
				}
			}
			currentDay.setHour(0).setMinute(0).setSecond(0);
			StdDate nextDay = new StdDate(currentDay).addDays(1);
			StdDate prevDay = new StdDate(currentDay).addDays(-1);

			ic.setTransientDatum("service_line_date", currentDay);		
			ic.setTransientDatum("next_service_line_date", nextDay);		
			ic.setTransientDatum("prev_service_line_date", prevDay);		
		}
		catch(Exception e)
		{
			ErrorHandler.handleException(ic, e, "Exception in PocketPreFlightHandler");
			result = false;
		}
		finally
		{
			if (conn != null)
				conn.release();
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
