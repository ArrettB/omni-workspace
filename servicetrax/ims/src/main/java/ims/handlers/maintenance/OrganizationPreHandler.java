/*
 *               Apex IT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of Apex IT, Inc. All rights reserved.
 *
 * Copyright 2006, Apex IT, Inc.
 * $Header: OrganizationPreHandler.java, 1, 3/30/2006 4:05:49 PM, Blake Von Haden$
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
import dynamic.util.string.StringUtil;

/**
 * Validate mandatory fields when saving an organization
 * 
 * @version $Header: OrganizationPreHandler.java, 1, 3/30/2006 4:05:49 PM, Blake Von Haden$
 */
public class OrganizationPreHandler extends BaseHandler
{
	public void setUpHandler() throws Exception
	{}

	public void destroy()
	{}

	/*
     * (non-Javadoc)
     * 
     * @see dynamic.intraframe.handlers.BaseHandler#handleEnvironment(dynamic.intraframe.engine.InvocationContext)
     */
	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		String button = ic.getParameter("button");
		boolean result = true;

		if ("Save".equals(button))
		{
			result = SmartFormHandler.validate(ic);
			result &= mandatory("default_site", ic);
			result &= mandatory("invoice_suffix", ic);
			result &= mandatory("comment_id", ic);
		}

		return result;
	}

	private boolean mandatory(String field, InvocationContext ic)
	{
		boolean result = true;

		if (!StringUtil.hasAValue(ic.getParameter(field)))
		{
			ic.setParameter("err@" + field, "Missing required value");
			result = false;
		}

		return result;
	}
}
