/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2001,2003,2006 Dynamic Information Systems, LLC
 * $Header: SmartFormPreHandler.java, 4, 1/26/2006 4:43:09 PM, Blake Von Haden$
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
 * 
 */
package ims.handlers.job_processing;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.util.diagnostics.Diagnostics;

/**
 * @version $Id: SmartFormPreHandler.java, 4, 1/26/2006 4:43:09 PM, Blake Von Haden$
 */
public class SmartFormPreHandler extends BaseHandler
{
	public void setUpHandler()
	{
	}

	public void destroy()
	{
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		boolean bRet = false;

		Diagnostics.debug2("SmartFormPreHandler.handleEnvironment()");

		String mode = ic.getParameter("mode");
		if (mode.equalsIgnoreCase("Update"))
		{
			// updating a database row, add audit data
			ic.setParameter("modified_by", (String) ic.getSessionDatum("user_id"));
			ic.setParameter("date_modified", "getDate()");
			bRet = true;
		}
		else if (mode.equalsIgnoreCase("Insert"))
		{
			// updating a database row, add audit data
			ic.setParameter("created_by", (String) ic.getSessionDatum("user_id"));
			ic.setParameter("date_created", "getDate()");
			bRet = true;
		}

		return bRet;
	}

}
