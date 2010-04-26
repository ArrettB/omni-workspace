package ims.handlers.docs;

import ims.helpers.Version;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;

public class DocumentPostHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("DocumentPostHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("DocumentPostHandler.destroy()");
	}

  	public boolean handleEnvironment(InvocationContext ic) throws Exception
	{
		Diagnostics.debug2("DocumentPostHandler.handleEnvironment()");
		boolean result = true;

		/*
		Note:
		Because this is PostHandler with SmartFormHandler, we do NOT
		catch the exception or release the resource ourselves
		*/

		//make sure that we are actually supposed to be saving.
		String button = ic.getParameter(SmartFormComponent.BUTTON);
		if (button != null && button.equals(SmartFormComponent.Save))
		{
			ConnectionWrapper conn = (ConnectionWrapper)ic.getTransientDatum(SmartFormHandler.CONNECTION);

			String docID = ic.getParameter("document_id");
			String projectID = ic.getParameter("project_id");
			String formatID = ic.getParameter("format_id");
			String comments = ic.getParameter("comments");
			String code = "1";
			String userID = ic.getSessionDatum("user_id").toString();
			String filename = ic.getParameter("filename");
			String extension = conn.queryEx("SELECT extension FROM formats WHERE format_id = " + formatID);

			Version.addVersion(ic, conn, projectID, docID, userID, code, comments, filename, extension);
		}

		return result;


	}
}
