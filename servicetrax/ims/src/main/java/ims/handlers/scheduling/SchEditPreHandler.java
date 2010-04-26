package ims.handlers.scheduling;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * SchEditPreHandler is used to set create the res_sch_id, the key to the view sch_resources_all_v
 * used in sch_res_edit.html
 */
public class SchEditPreHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("SchEditPreHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("SchEditPreHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.trace("SchEditPreHandler.handleEnvironment()");

		boolean bRet = true;
		String resource_id = null;
		String sch_resource_id = null;
		String weekend_flag = null;
		String res_sch_id = null;
		String weekend_key = null;
		
		try
		{
			resource_id = ic.getParameter("resource_id");
			sch_resource_id = ic.getParameter("sch_resource_id");
			weekend_flag = ic.getParameter("weekend_flag");

			if( StringUtil.hasAValue(resource_id) )
			{
				res_sch_id = resource_id + ":";
				if( StringUtil.hasAValue(sch_resource_id) )
					res_sch_id += sch_resource_id;
			}
			if( StringUtil.hasAValue(weekend_flag) && weekend_flag.equalsIgnoreCase("Y") )
			{
				if( StringUtil.hasAValue(sch_resource_id) )
					weekend_key = sch_resource_id;
				else
					Diagnostics.error("SchEditPreHandler.handleEnvironment() Missing the expected sch_resource_id");
			}
			else
				weekend_key = resource_id;

			ic.setParameter("weekend_key",weekend_key);
			ic.setParameter("res_sch_id",res_sch_id);
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Problem in SchEditPreHandler resource_id='"+resource_id+"' sch_resource_id='"+sch_resource_id+"' res_sch_id='"+res_sch_id+"'");
			bRet = false;
		}

		return bRet;
	}

}
