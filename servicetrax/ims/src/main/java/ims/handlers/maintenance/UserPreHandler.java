package ims.handlers.maintenance;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;


public class UserPreHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("UserPreHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("UserPreHandler.destroy()");
	}

	/**
	This handler grabs the password value from the form, which has already been
	verified against password2 via javascript. It then passes that parameter onto the
	SmartForm.  We can not pass it on directly, because we may be getting our dummy value
	by accident.  The dummy value is in there so that noone can determine how long someones
	password is by counting the *'s
	*/
  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		//because this is PreHandler with SmartFormHandler, we do NOT
		//catch the exception or release the resource ourselves

		boolean result = true;
		Diagnostics.debug2("UserPreHandler.handleEnvironment()");

		// TODO this is where we need to hash the password.
		//make sure that we are actually supposed to be saving.
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		if (button != null && button.equals(SmartFormComponent.Save))
		{
			String password1 = ic.getParameter("password1");
			if (password1 != null && !password1.equals("IGNORE"))
			{
				ic.setParameter("password", password1);
			}
		}

		String mode = ic.getParameter("mode");
		if( mode.equalsIgnoreCase("Update") )
		{
			ic.setParameter( "modified_by", (String)ic.getSessionDatum("user_id") );
			ic.setParameter( "date_modified", "getDate()");
		}
		else if( mode.equalsIgnoreCase("Insert") )
		{
			ic.setParameter( "created_by", (String)ic.getSessionDatum("user_id") );
			ic.setParameter( "date_created", "getDate()");
		}

		return result;
	}
}
