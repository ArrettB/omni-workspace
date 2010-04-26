/*
 *                 Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Revision: 119 $Date: 9/19/2006 11:22:15 AM$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */
package ims.handlers.docs;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;

import dynamic.dbtk.MetaDataColumn;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.file.FileUtil;
import dynamic.util.string.StringUtil;


/**
 * Handler to upload request document to the server and store in the request document
 * folder under the request id.
 *
 * @version $Header: RequestDocumentUploadHandler.java, 4, 9/19/2006 11:22:15 AM, Greg Case$
 */
public class RequestDocumentUploadHandler extends BaseHandler
{
	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.trace("RequestDocumentUploadHandler.handleEnvironment()");

		ConnectionWrapper conn = null;
		int maxFileSize = 0;

		boolean result = false;

		try
		{
			String tempDirectory = (String) ic.getRequiredAppGlobalDatum("tempDir");
			maxFileSize = Integer.parseInt((String) ic.getRequiredAppGlobalDatum("maxFileSize"));

			File theTempDirectory = new File(tempDirectory);

			if (!theTempDirectory.exists())
			{
				theTempDirectory.mkdir();
			}

			Diagnostics.debug2("upload directory: " + tempDirectory); //debug the directory

			HttpServletRequest req = ic.getHttpServletRequest();

			//Max 2 megs file size
			//MultipartRequest multi = new MultipartRequest(req, tempDirectory, maxFileSize);
			MultipartRequest multi = new MultipartRequest(req, tempDirectory, 40 * 1000000); //set to 40 megs and check after upload
			
			String filename = null;
			String type = null;

			java.util.Enumeration files = multi.getFileNames();

			while (files.hasMoreElements())
			{
				String name = (String) files.nextElement();
				filename = multi.getFilesystemName(name);
				type = multi.getContentType(name);
				Diagnostics.debug2("filename=" + filename + ",type=" + type); //debug the file
				ic.setParameter(name, filename);
			}
			
			MetaDataColumn nameMeta = (MetaDataColumn)ic.getRequiredAppGlobalDatum("request_documents:name");

			if (!StringUtil.hasAValue(filename))
			{ //no filename, to avoid exception do this
				ic.setTransientDatum("error_message", "You must select a document before uploading...");
			}
			else if (filename.length() > nameMeta.getColumnDisplaySize())
			{
				ic.setTransientDatum("error_message", "Please shorten the file name and re-upload");
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

				conn = (ConnectionWrapper) ic.getResource();
				conn.setAutoCommit(false);

				String requestID = (String) ic.getSessionDatum("request_id");
				String userID = (String) ic.getSessionDatum("user_id");

				String insert = "INSERT INTO request_documents" 
				              + "(request_id, name, created_by, date_created)"
							  + "VALUES"
							  + "(" + requestID
							  + "," + conn.toSQLString(filename)
							  + "," + userID
							  + ", CURRENT_TIMESTAMP)";

				try
				{
					conn.updateEx(insert);

					// Move the file
					String docDirPath = (String) ic.getRequiredAppGlobalDatum("requestDocumentDir");
					File file = new File(docDirPath);
					file = new File(file, requestID);

					if (!file.exists())
						file.mkdirs();

					file = new File(file, filename);
					FileUtil.moveFile(theTempFile, file);

					conn.commit();
				}
				catch (SQLException e)
				{
					if (e.getErrorCode() == 2627)
					{
						String message = "The request already has a document with this name.  Rename the document and upload again.";
						ic.setTransientDatum("error_message", message);
						conn.rollback();
					}
					else
					{
						throw e;
					}
				}
			}
		}
		catch (IOException e)
		{
			String message = "The system experienced a miscellaneous error when saving the file.  Root Cause:" + e.getMessage();
			ic.setTransientDatum("error_message", message);
			Diagnostics.error(message, e);

			try
			{
				conn.rollback();
			}
			catch (Exception ex) {} // Throw exception away
		}
		catch (Exception e)
		{
			ErrorHandler.handleException(ic, e, "A problem occurred while uploading the file");

			try
			{
				conn.rollback();
			}
			catch (Exception ex) {} // Throw exception away
		}
		finally
		{
			if (conn != null)
			{
				try
				{
					conn.setAutoCommit(true);
				}
				catch (Exception e) {} // Throw exception away

				conn.release();
			}
		}

		return result;
	}
}
