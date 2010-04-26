/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2006 Dynamic Information Systems, LLC
 * $Header: CustomLinePreHandler.java, 1, 3/10/2006 12:37:55 PM, Blake Von Haden$
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
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Id: CustomLinePreHandler.java, 1, 3/10/2006 12:37:55 PM, Blake Von Haden$
 */
public class CustomLinePreHandler extends BaseHandler
{
	public void setUpHandler()
	{}

	public void destroy()
	{}

	public boolean handleEnvironment(InvocationContext ic)
	{
		boolean bRet = true;

		Diagnostics.debug2("CustomLinePreHandler.handleEnvironment()");

		String mode = ic.getParameter("mode");
		String button = ic.getParameter(SmartFormComponent.BUTTON);

		if (mode.equalsIgnoreCase("Update") || mode.equalsIgnoreCase("Insert") && button.equals(SmartFormComponent.Save))
		{
			// updating a database row, add audit data
			if (!StringUtil.hasAValue(ic.getParameter("item_id")))
			{
				Diagnostics.warning("Mandatory string field Item is not present");
				SmartFormHandler.addSmartFormError(ic, "Item is a required field.  Please enter it before continuing on.");
				ic.setParameter("err@item_id", "Mandatory value missing");
				bRet = false;
			}
		}

		return bRet;
	}

}
