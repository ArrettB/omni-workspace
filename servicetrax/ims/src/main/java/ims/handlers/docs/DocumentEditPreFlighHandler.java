package ims.handlers.docs;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class DocumentEditPreFlighHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("DocumentEditPreFlighHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("DocumentEditPreFlighHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{
			Diagnostics.trace("DocumentEditPreFlighHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();
			String userID = ic.getSessionDatum("user_id").toString();
			String docID = ic.getRequiredParameter("document_id");
			QueryResults rs = conn.resultsQueryEx("SELECT DISTINCT locked_by, locked_by_name FROM documents_v WHERE document_id = " + docID);
			if (rs.next())
			{
				String lockedBy = rs.getString(1);
				String lockedByName = rs.getString(2);
				if (lockedBy != null && lockedBy.equals(userID))
				{
					Diagnostics.debug("Setting lockedByCurrentUser to true");
					ic.setTransientDatum("lockedByCurrentUser", "true");
				}
				if (lockedByName != null && lockedByName.length() > 0)
				{
					ic.setTransientDatum("lockedByName", lockedByName);
				}
			}
			rs.close();

		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in DocumentUploadHandler");
		}
		finally
		{
			if (conn != null) conn.release();
		}

		return result;
	}
}
