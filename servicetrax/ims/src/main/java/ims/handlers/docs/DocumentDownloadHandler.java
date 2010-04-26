/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: DocumentDownloadHandler.java 1563 2009-03-27 19:07:01Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC
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
import java.io.FileInputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.BaseInvocationContext;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.string.StringUtil;

/**
 * 
 * @version $Id: DocumentDownloadHandler.java 1563 2009-03-27 19:07:01Z bvonhaden $
 */
public class DocumentDownloadHandler extends BaseHandler
{
	public static final String INLINE = "inline";

	public void setUpHandler() throws Exception
	{
		Diagnostics.debug2("DocumentDownloadHandler.setUpHandler()");
	}

	public void destroy()
	{
		Diagnostics.debug2("DocumentDownloadHandler.destroy()");
	}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = true;
		try
		{
			Diagnostics.trace("DocumentDownloadHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();
			String docID = ic.getRequiredParameter("document_id");
			String versionID = ic.getRequiredParameter("version_id");
			String docDirPath = (String)ic.getRequiredAppGlobalDatum("documentDir");
			QueryResults rs = conn.resultsQueryEx("SELECT project_id, extension FROM documents_v WHERE document_id = " + docID);
			if (rs.next())
			{
				String projectID = 	rs.getString(1);
				String extension = rs.getString(2);

				String versionCode = conn.queryEx("SELECT code FROM versions WHERE version_id = " + versionID);

				File documentDir = new File(docDirPath);
				File projectDir = new File(documentDir, projectID);

				String downloadFileName = docID + "_" + versionCode + extension;
				File downloadFile = new File(projectDir, downloadFileName);
				Diagnostics.debug("File to download is " + downloadFile);

				//ic.getHttpServletResponse().setHeader("HTTP_FILENAME", "foo.zip");
				//ic.getHttpServletResponse().setHeader("Content-Name", "foo.zip");

				returnFile(ic, downloadFile);
			}
			else
			{
				Diagnostics.error("Could not find a document for document_id = " + docID);
			}
			rs.close();


		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e,  "Exception in DocumentDownloadHandler");
		}
		finally
		{
			if (conn != null) conn.release();
		}

		return result;
	}

	/**
	 * Send a file back with the appropriate name
	 */
	public void returnFile(InvocationContext ic, String fqnFile) throws Exception
	{
		returnFile(ic, new File(fqnFile));
	}

	/**
	 * Send a file back with the appropriate name
	 */
	public void returnFile(InvocationContext ic, File dFile) throws Exception
	{
		returnFile(ic, dFile, null);
	}

	/**
	 * Send a file back with the appropriate name
	 */
	public void returnFile(InvocationContext ic, File dFile, String mimeType) throws Exception
	{
		Diagnostics.debug("ic = " + ic);
		Diagnostics.debug("dFile = " + dFile);
		Diagnostics.debug("mimeType = " + mimeType);


		HttpServletResponse res =ic.getHttpServletResponse();
		Diagnostics.debug("Got response");

		if (!dFile.exists())
			throw new Exception("The file does not exist.");
		else if (!dFile.isFile())
			throw new Exception("The file is not valid.");
		else if (!dFile.canRead())
			throw new Exception("The file is not readable.");

		Diagnostics.debug("File is good");
		FileInputStream fis = null;

		try
		{
			Diagnostics.debug("In Try: filepath='"+dFile.getAbsolutePath()+"'");

			ServletOutputStream out = res.getOutputStream();
			String contentType = ((BaseInvocationContext)ic).getServlet().getServletContext().getMimeType(dFile.getAbsolutePath());

			Diagnostics.debug("Got content:" + contentType);


			System.out.println(contentType);
			if (mimeType == null)
			{
				if (contentType != null)
				{
					res.setContentType(contentType);
				}
				else 
				{
				    // .xls files content type is not known
					res.setContentType("application/octet-stream");
				}
			}
			else
			{
				res.setContentType(mimeType);
			}
			if (!StringUtil.hasAValue(ic.getParameter(INLINE)))
			{
				res.setHeader("Content-Disposition", "attachment; filename=" + dFile.getName() + ";");
			}
			fis = new FileInputStream(dFile.getPath());
			if( fis != null )
				Diagnostics.debug("Created f input stream");
			else
				Diagnostics.debug("failed to create file input stream");
			byte[] buf = new byte[4 * 1024]; // 4K buffer
			int bytesRead;
			while ((bytesRead = fis.read(buf)) != -1)
			{
				out.write(buf, 0, bytesRead);
Diagnostics.debug("writing bytes: "+bytesRead);
			}
		}
		catch (Exception e)
		{
			throw new Exception(e.getMessage());
		}
		finally
		{
			try
			{
				if (fis != null)
					fis.close();
			}
			catch (Exception e)
			{
				throw new Exception(e.getMessage());
			}
		}
	}

	/**
	 * Prepare the response for the given file type and return the outputstream for writing.
	 * @param filename the name of the file to figure out the mime type and set the download name
	 */
	public ServletOutputStream getOutputStream(InvocationContext ic, String filename, String mimeType, boolean inline) throws Exception
	{
		HttpServletResponse res =ic.getHttpServletResponse();
		ServletOutputStream out = res.getOutputStream();
		try
		{
			String contentType = ((BaseInvocationContext)ic).getServlet().getServletContext().getMimeType(filename);

			Diagnostics.debug("Got content:" + contentType);

			if (mimeType == null)
			{
				if (contentType != null)
				{
					res.setContentType(contentType);
				}
				else 
				{
				    // .xls files content type is not known
					res.setContentType("application/octet-stream");
				}
			}
			else
			{
				res.setContentType(mimeType);
			}
			if (!inline)
			{
				res.setHeader("Content-Disposition", "attachment; filename=" + filename + ";");
			}
		}
		catch (Exception e)
		{
			throw new Exception(e.getMessage());
		}
		return out;
	}


}
