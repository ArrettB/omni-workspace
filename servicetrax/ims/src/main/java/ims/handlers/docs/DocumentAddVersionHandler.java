package ims.handlers.docs;

import ims.helpers.Version;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;

public class DocumentAddVersionHandler extends BaseHandler
{
	public void setUpHandler()
	{
		Diagnostics.debug2("DocumentAddVersionHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("DocumentAddVersionHandler.destroy()");
	}


	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{
			Diagnostics.trace("DocumentAddVersionHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();

			String docID = ic.getParameter("document_id");
			String projectID = ic.getSessionDatum("project_id").toString();
			String comments = ic.getParameter("comments");
			String code = ic.getParameter("version_label");
			String userID = ic.getSessionDatum("user_id").toString();
			String filename = ic.getParameter("filename");
			String extension = conn.queryEx("SELECT extension FROM documents_v WHERE document_id = " + docID);

			Version.addVersion(ic, conn, projectID, docID, userID, code, comments, filename, extension);

			ic.setParameter("filename", "");
			ic.setParameter("comments", "");
			ic.setParameter("version_label", "");
			Diagnostics.debug("Removed params");

			ic.setHTMLTemplateName("enet/docs/doc_edit.html");
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in DocumentAddVersionHandler");
		}
		finally
		{
			if (conn != null) conn.release();
		}

		return result;
	}

}
