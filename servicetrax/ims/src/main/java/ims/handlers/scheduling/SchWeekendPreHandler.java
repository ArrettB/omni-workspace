package ims.handlers.scheduling;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * SchWeekendPreHandler determines whether selected resource_id has a weekend_flag='N'
 * if true, then remove the sch_resource_id from parameter data
 */

public class SchWeekendPreHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("SchWeekendPreHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("SchWeekendPreHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.trace("SchWeekendPreHandler.handleEnvironment()");

		boolean bRet = true;
		String weekend_flag = null;
		
		try
		{
			weekend_flag = ic.getParameter("weekend_flag");
			if( StringUtil.hasAValue(weekend_flag) && weekend_flag.equalsIgnoreCase("N") )
			{
				Diagnostics.debug2("SchWeekendPreHandler.handleEnvironment() found weekend_flag='N', so resetting sch_resource_id to null.");
				ic.setParameter("sch_resource_id","");
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Problem in SchWeekendPreHandler weekend_flag='"+weekend_flag+"'");
			bRet = false;
		}

		return bRet;
	}

}
