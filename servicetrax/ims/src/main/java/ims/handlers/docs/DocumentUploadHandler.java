package ims.handlers.docs;

import java.io.File;
import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;


/**
 * Handler to upload files to the server, create thier directory structure, and rename them
 *
 * @version $Header: DocumentUploadHandler.java, 6, 7/11/2006 10:50:22 AM, Greg Case$
 */

public class DocumentUploadHandler extends BaseHandler
{

	public void setUpHandler()
	{
		Diagnostics.debug2("DocumentUploadHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("DocumentUploadHandler.destroy()");
	}


	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.trace("DocumentUploadHandler.handleEnvironment()");
		ConnectionWrapper conn = null;
		int maxFileSize = 0;

		boolean result = false;
		try
		{
			String tempDirectory = (String)ic.getRequiredAppGlobalDatum("tempDir");
			maxFileSize = Integer.parseInt((String)ic.getRequiredAppGlobalDatum("maxFileSize"));

			File theTempDirectory = new File(tempDirectory);
			if (!theTempDirectory.exists())
			{
				theTempDirectory.mkdir();
			}

			Diagnostics.debug2("upload directory: " + tempDirectory);//debug the directory
			HttpServletRequest req = ic.getHttpServletRequest();

			//Max 2 megs file size
			//MultipartRequest multi = new MultipartRequest(req, tempDirectory, maxFileSize);
			MultipartRequest multi = new MultipartRequest(req, tempDirectory, 40*1000000);//set to 40 megs and check after upload

			String filename = null;
			String type = null;

			java.util.Enumeration files = multi.getFileNames();
			while (files.hasMoreElements())
			{
				String name = (String)files.nextElement();
				filename = multi.getFilesystemName(name);
				type = multi.getContentType(name);
				Diagnostics.debug2("filename=" + filename + ",type=" + type);//debug the file
				ic.setParameter("filename", filename);
			}

			Enumeration paramNames = multi.getParameterNames();
			String paramName;
			String paramValue;
			while (paramNames.hasMoreElements())
			{
				paramName = paramNames.nextElement().toString();
				paramValue = multi.getParameter(paramName);
				Diagnostics.debug2(paramName + "=" + paramValue);
				ic.setParameter(paramName, paramValue);
			}

			if( !StringUtil.hasAValue(filename) )
			{//no filename, to avoid exception do this
				ic.setTransientDatum("error_message", "You must select a file name before uploading...");
				ic.setHTMLTemplateName("enet/docs/doc_upload.html");
			}
			else
			{
				File theTempFile = new File(tempDirectory, filename);

				//Temporary hack until MultiPartRequest class can be fixed to handle this logic
				if (theTempFile.length() > maxFileSize)
				{
					theTempFile.delete();
					throw new IOException("Maximum File size (" + maxFileSize + ") exceeded on upload");
				}
	
				conn = (ConnectionWrapper)ic.getResource();
				conn.setAutoCommit(false);
	
	/*			String root = (String)ic.getRequiredAppGlobalDatum("root");
				String document_id = ic.getRequiredParameter("document_id");
				String edition_id = ic.getRequiredParameter("edition_id");
				String format_type_id = ic.getRequiredParameter("format_type_id");
	
				String formatExtension = conn.queryEx("SELECT code FROM format_types WHERE format_type_id =" + conn.toSQLString(format_type_id));
				String editionCode = conn.queryEx("SELECT code FROM editions WHERE edition_id =" + conn.toSQLString(edition_id));
				String newFileName = editionCode + formatExtension;
				Document document = Document.fetch(conn, document_id);
				File newFile = document.getDocumentDirectory(conn, root);
				newFile = new File(newFile,newFileName);
				if (newFile.exists())
				{
					newFile.delete();
				}
				Diagnostics.debug2("File will be copied to " + newFile);
	
				result = true;
				//Copys the new file from the temp directory to the document directory
				result = theTempFile.renameTo(newFile);
				String query = "DELETE FROM formats WHERE format_type_id=" + conn.toSQLString(format_type_id) + " AND edition_id=" + conn.toSQLString(edition_id);
				conn.updateEx(query, false);
	
				User user = (User)ic.getSessionDatum("user");
	
				//Pull one date and use it to update formats, editions, and documents so that the date_modified/created will match
				String currDate = conn.queryEx("SELECT DISTINCT " + conn.now() + " FROM DOCUMENTS");
	
				query = "INSERT INTO formats (format_type_id, edition_id, date_created, created_by) VALUES (" + conn.toSQLString(format_type_id) + ", " + conn.toSQLString(edition_id) + ", " + conn.toSQLString(currDate) + ", " + conn.toSQLString(user.id) + ")";
				conn.updateEx(query, false);
				query = "UPDATE editions SET modified_by = " + conn.toSQLString(user.id) + ", date_modified = " + conn.toSQLString(currDate) + " WHERE edition_id = " + conn.toSQLString(edition_id);
				conn.updateEx(query, false);
				query = "UPDATE documents SET modified_by = " + conn.toSQLString(user.id) + ", date_modified = " + conn.toSQLString(currDate) + " WHERE document_id = " + conn.toSQLString(document_id);
				conn.updateEx(query, false);
	*/
				ic.setHTMLTemplateName("enet/docs/upload_good.html");
				conn.commit();
			}
		}
		catch (IOException e)
		{
			String message = "Max file size (" + maxFileSize + ") exceeded on upload. Please choose a different file.";
			ic.setTransientDatum("error_message",message);
			Diagnostics.error(message,e);
			ic.setHTMLTemplateName("enet/docs/doc_upload.html");
			try { conn.rollback(); } catch (Exception ex) {} // Throw exception away
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "A problem occurred while uploading the file");
			try { conn.rollback(); } catch (Exception ex) {} // Throw exception away
		}
		finally
		{
			if (conn != null)
			{
				try { conn.setAutoCommit(true); } catch (Exception e) {} // Throw exception away
				conn.release();
			}
		}
		return result;

	}
}

