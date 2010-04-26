package ims.handlers.job_processing;

import ims.handlers.proj.PDSPreHandler;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;


/**
 * @version $Id: ArchiveHandler.java 1112 2008-03-10 17:27:30Z dzhao $
 */
public class ArchiveHandler extends BaseHandler {
	
	public void setUpHandler() {
		Diagnostics.debug2("ArchiveHandler.setUpHandler()");
	}

	public boolean handleEnvironment(InvocationContext ic) {
		Diagnostics.debug2("ArchiveHandler.handleEnvironment()");
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
					PDSPreHandler.archive(ic, conn, recordTypeCode, recordId);
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
		return true;
	}

	public void destroy()
	{
		Diagnostics.debug2("ArchiveHandler.destroy()");
	}

}