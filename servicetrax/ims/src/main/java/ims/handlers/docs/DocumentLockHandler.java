package ims.handlers.docs;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class DocumentLockHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("DocumentLockHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("DocumentLockHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{
			Diagnostics.trace("DocumentLockHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();
			String userID = ic.getSessionDatum("user_id").toString();
			String docID = ic.getRequiredParameter("document_id");
			String mode = ic.getRequiredParameter("mode");

			if (mode.equalsIgnoreCase("lock"))
			{
				StringBuffer update = new StringBuffer();
				update.append("UPDATE documents ");
				update.append("SET locked_by = ").append(userID);
				update.append(", date_locked = ").append("getDate()");
				update.append(" WHERE document_id = " ).append(docID);

				conn.updateExactlyEx(update, 1);
			}
			else if (mode.equalsIgnoreCase("unlock"))
			{
				StringBuffer update = new StringBuffer();
				update.append("UPDATE documents ");
				update.append("SET locked_by = ").append("NULL");
				update.append(", date_locked = ").append("NULL");
				update.append(" WHERE document_id = " ).append(docID);

				conn.updateExactlyEx(update, 1);
			}
			else
			{
				Diagnostics.warning("Unrecognized mode in DocumentLockHandler, mode=" + mode);
			}

			ic.setHTMLTemplateName("enet/docs/doc_edit.html");
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in DocumentLockHandler");
		}
		finally
		{
			if (conn != null) conn.release();
		}

		return result;
	}
}
