package ims.handlers.security;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;

public class CheckLoginHandler extends BaseHandler {

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean handleEnvironment(InvocationContext ic) throws Exception {
		
		
		if (ic.getSessionDatum("user") == null) //session probably expired
		{
			ic.setHTMLTemplateName(ic.getProvider("user").getId());
			return false;
		}
		else 
		{
			return true;
		}
	}

	@Override
	public void setUpHandler() throws Exception {
		// TODO Auto-generated method stub
		
	}

}
