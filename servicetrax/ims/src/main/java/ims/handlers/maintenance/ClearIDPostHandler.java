package ims.handlers.maintenance;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;


public class ClearIDPostHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("ClearIDPostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("ClearIDPostHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("ClearIDPostHandler.handleEnvironment()");
		boolean result = true;
		String action = ic.getParameter("clear_action");
		String clear_id = ic.getParameter("clear_id");		
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		boolean clear = false;
		
		/*
		Note:
		Because this is PostHandler with SmartFormHandler, we do NOT
		catch the exception or release the resource ourselves
		*/

		//if there is a clear_action of "on_delete" clear only on delete, else clear always.
		if( StringUtil.hasAValue(action) && action.equalsIgnoreCase("on_delete") )
		{
			if( button.equalsIgnoreCase(SmartFormComponent.Delete) )
				clear = true;
		}
		else if( clear_id != null )
			clear = true;
		
		if( clear )
		{
			ic.setTransientDatum(clear_id,""); //clear parameter so user can enter new record after this save.
			ic.setParameter(clear_id,""); //clear parameter so user can enter new record after this save.
		}

		return result;
	}
}
