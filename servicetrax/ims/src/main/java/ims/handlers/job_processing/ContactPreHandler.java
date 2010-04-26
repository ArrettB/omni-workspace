package ims.handlers.job_processing;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * ContactPreHandler insures at least one contact_type was selected
 * 
 * @version $Id: ContactPostHandler, 1, 5/7/2004 2:09:07 PM, Lee A. Gunderson$
 */

public class ContactPreHandler extends BaseHandler
{ 
	public void setUpHandler()
	{
		Diagnostics.debug2("ContactPreHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("ContactPreHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.trace("ContactPreHandler.handleEnvironment()");
		boolean result = true;

		String button = ic.getParameter(SmartFormComponent.BUTTON);

		if( StringUtil.hasAValue(button) )
		{
			if( button.equals(SmartFormComponent.Save) )
			{
				String contact_groups[] = ic.getParameterValues("contact_group_id");
				if( !(contact_groups != null && StringUtil.hasAValue(contact_groups[0])) )
				{
					SmartFormHandler.addSmartFormError(ic, "Please select at least one Contact Group..."); 
					ic.setTransientDatum("err@contact_group_id","true");
					result = false;
				}
			}
			else if( button.equals(SmartFormComponent.Delete) )
			{//test to make sure contact is not being used first.
				String contact_id = ic.getParameter("contact_id");
				ConnectionWrapper conn = null;
				if( StringUtil.hasAValue(contact_id ) )
				{
					conn = (ConnectionWrapper) ic.getTransientDatum(SmartFormHandler.CONNECTION);
					try
					{
						conn.updateEx("DELETE FROM contacts WHERE contact_id = " + conn.toSQLString(contact_id));	
					}
					catch(Exception e)
					{
						Diagnostics.error("<><><><><><>delete contact: " + conn.getWarnings() + e.toString());
						SmartFormHandler.addSmartFormError(ic, "Unable to delete Contact, it is being used on another document.<br>You may inactivate the contact which will remove it from the droplists.");
						result = false;
					}
				}
			}
		}
		
		return result;
	}

}
