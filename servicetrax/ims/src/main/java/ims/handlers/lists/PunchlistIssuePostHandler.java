package ims.handlers.lists;

import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.util.diagnostics.Diagnostics;

public class PunchlistIssuePostHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("PunchlistIssuePostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("PunchlistIssuePostHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("PunchlistIssuePostHandler.handleEnvironment()");
		boolean result = true;

		/*
		Note:
		Because this is PostHandler with SmartFormHandler, we do NOT
		catch the exception or release the resource ourselves
		*/

		String button = ic.getParameter("button");
		if (button != null && button.equalsIgnoreCase("Mark as Complete") )
		{
			String[] punchlist_issue_ids = ic.getParameterValues("completed");
			StringBuffer ids = new StringBuffer();
			if( punchlist_issue_ids != null )
			{
				boolean more_then_one = false;
				for( int i=0; i < punchlist_issue_ids.length; i++ )
				{
					if( more_then_one )
						ids.append(",");
					else more_then_one = true;

					ids.append(punchlist_issue_ids[i]);
					Diagnostics.error("current issue = '"+punchlist_issue_ids[i]+"'");
				}
				ic.setParameter("object_id",ids.toString());
				result = ic.dispatchHandler("ims.handlers.job_processing.StatusHandler");
			}
			else
				Diagnostics.debug2("NO items");

			Diagnostics.debug2("Updating status of punchlist issues id(s) = '"+ids.toString()+"' to closed.");
			ic.setHTMLTemplateName("enet/lists/punchlist.html");
		}
		else if (button != null && !button.equalsIgnoreCase("Cancel") )
		{//make sure that we are actually supposed to be saving.

			boolean nextPrev = false;
			String nextID = ic.getParameter("nextID");
			String previousID = ic.getParameter("previousID");
			String npMode = ic.getParameter("npMode");
			Diagnostics.debug("nextID =  " + nextID);
			Diagnostics.debug("previousID =  " + previousID);
			Diagnostics.debug("npMode =  " + npMode);
			if (npMode != null)
			{
				if (npMode.equalsIgnoreCase("next") && nextID != null && nextID.length() > 0)
				{
					Diagnostics.debug("Next - Setting punchlist_issue_id to " + nextID);
					ic.setParameter("punchlist_issue_id", nextID);
					nextPrev = true;
				}
				if (npMode.equalsIgnoreCase("previous") && previousID != null && previousID.length() > 0)
				{
					Diagnostics.debug("Previous - Setting punchlist_issue_id to " + previousID);
					ic.setParameter("punchlist_issue_id", previousID);
					nextPrev = true;
				}
			}
			if (nextPrev)
			{
				ic.setHTMLTemplateName("enet/lists/issue_edit.html");
			}
			else
			{
				ic.setHTMLTemplateName("enet/lists/punchlist.html");
			}
		}
		Diagnostics.debug2("result = '"+result + "' button='"+button+"'");
		return result;

	}
}
