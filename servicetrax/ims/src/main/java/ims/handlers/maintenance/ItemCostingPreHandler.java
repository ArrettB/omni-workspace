/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Header: ItemCostingPreHandler.java, 3, 6/29/2005 1:36:24 PM, Blake Von Haden$
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
package ims.handlers.maintenance;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;


/**
 * Set the modified information.
 *
 * @version $Header: ItemCostingPreHandler.java, 3, 6/29/2005 1:36:24 PM, Blake Von Haden$
 */
public class ItemCostingPreHandler extends BaseHandler
{
	public void setUpHandler() throws Exception {}

	public void destroy() {}

	/* (non-Javadoc)
	 * @see dynamic.intraframe.handlers.BaseHandler#handleEnvironment(dynamic.intraframe.engine.InvocationContext)
	 */
	public boolean handleEnvironment(InvocationContext ic)
		throws Exception
	{
		String button = ic.getParameter("button");
		boolean result = true;

		if ("Save".equals(button))
		{
			result = SmartFormHandler.validate(ic);

			String mode = ic.getParameter("mode");
			if ("Update".equalsIgnoreCase(mode))
			{
				ic.setParameter("modified_by", (String) ic.getSessionDatum("user_id"));
				ic.setParameter("date_modified", "getDate()");
			}
		}

		return result;
	}
}
