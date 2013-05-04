/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2008 ApexIT, Inc.
 * $Id: SetComponent.java 1431 2008-11-07 19:40:52Z bvonhaden $
 *
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

package dynamic.intraframe.templates.components;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.templates.TemplateComponent;
import dynamic.util.diagnostics.Diagnostics;

/**
 * Set a value in the appropriate scope.
 * 
 * @version $Id: SetComponent.java 1431 2008-11-07 19:40:52Z bvonhaden $
 */
public class SetComponent extends TemplateComponent
{
	public static final String SCOPE_TRANSIENT = "transient";
	public static final String SCOPE_PARAMETER = "parameter";

	public SetComponent() throws Exception
	{
       registerRequiredAttribute("name");
       registerAttribute("value", null);
       registerAttribute("scope", SCOPE_TRANSIENT);
	}
	
	/* (non-Javadoc)
	 * @see dynamic.intraframe.templates.TemplateComponent#includeInternal(dynamic.intraframe.engine.InvocationContext)
	 */
	@Override
	public String includeInternal(InvocationContext ic) throws Exception
	{
		String name = getString(ic, "name");
		String value = getString(ic, "value");
		String scope = getScope(ic);
		
		if (SCOPE_TRANSIENT.equals(scope))
		{
			if (value == null)
			{
				ic.removeTransientDatum(name);
			}
			else
			{
				ic.setTransientDatum(name, value);
			}
		}
		else if (SCOPE_PARAMETER.equals(scope))
		{
			if (value == null)
			{
				ic.removeParameter(name);
			}
			else
			{
				ic.setParameter(name, value.toString());
			}
		}
		
		Diagnostics.debug("scope:" + scope + ",name:" + name + ",value:" + value);
		
		return "";
	}

	private String getScope(InvocationContext ic) throws Exception
	{
		String scope = getString(ic, "scope");
		
		if (!SCOPE_TRANSIENT.equals(scope) && !SCOPE_PARAMETER.equals(scope))
			throw new Exception("Scope not valid " + scope);
		
		return scope;
	}

}
