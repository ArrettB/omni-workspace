package ims.handlers.job_processing;

import ims.handlers.proj.PDSPreHandler;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

public class UnArchiveHandler extends BaseHandler
{

	public void setUpHandler() throws Exception
	{
		Diagnostics.debug2("UnArchiveHandler.setUpHandler()");
	}

	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{

		Diagnostics.debug2("UnArchiveHandler.handleEnvironment()");
		ConnectionWrapper conn = null;
		int idx = 0;

		try
		{
			conn = (ConnectionWrapper)ic.getResource();
			String[] archiveCheckBoxes = StringUtil.stringToArray(ic.getParameter("archiveIds"), ',');
			String recordTypeCode = ic.getParameter("record_type");

			String recordId;
			if (archiveCheckBoxes !=  null)
			{
				for (int i = 0; i < archiveCheckBoxes.length; i++)
				{
					idx = archiveCheckBoxes[i].indexOf(",");
					recordId = archiveCheckBoxes[i].substring(idx+1);
					PDSPreHandler.unarchive(ic, conn, recordTypeCode, recordId);
				}
			}
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "Problem in ArchiveHandler");
			return false;
		}
		finally
		{
			if (conn != null)
			{
				conn.release();
			}
		}

		return false;
	}

	public void destroy()
	{
		Diagnostics.debug2("UnArchiveHandler.destroy()");
	}

}
