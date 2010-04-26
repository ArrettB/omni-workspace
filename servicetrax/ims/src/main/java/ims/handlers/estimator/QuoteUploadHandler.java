/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id$
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
package ims.handlers.estimator;

import ims.Constants;
import ims.helpers.EstimatorConfig;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
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
 * Receive the updated XLS Estimator spreadsheet and load the values into the database.
 * 
 * @version $Id$
 */
public class QuoteUploadHandler extends BaseHandler {
	
	private static final String SET_UPDATED
		= "UPDATE requests"
		+   " SET date_modified = getDate()"
		+       " ,modified_by = ?"
		+ " WHERE request_id = ?";
	
	private static final String CHECK_IS_SENT
		= "SELECT top 1 'x' FROM quotes"
        + " WHERE request_id = ?"
        + " AND is_sent = 'Y'";
	
	public static final String SELECT_QUOTE_ID
		= "SELECT quote_id FROM quotes WHERE request_id = ?";

	private EstimatorConfig estimatorConfig;


	public void setUpHandler() throws Exception
	{
		estimatorConfig = new EstimatorConfig(getConfigDocument());
	}

	public void destroy(){}
	
	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.trace("QuoteUploadHandler.handleEnvironment()");
		ConnectionWrapper conn = null;
		int maxFileSize = 0;

		boolean result = false;
		try
		{
			String tempDirectory = estimatorConfig.getEstimatorDir();
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

			Enumeration files = multi.getFileNames();
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
			{
				//no filename, to avoid exception do this
				ic.setTransientDatum("error_message", "You must select a file name before uploading...");
				ic.setHTMLTemplateName("enet/docs/doc_upload.html");
			}
			else
			{
				String requestId = multi.getParameter("quoteid");
				conn = (ConnectionWrapper)ic.getResource();
				conn.setAutoCommit(false);
				if (!isSent(requestId, conn))
				{
    
    				File theTempFile = new File(tempDirectory, filename);
    				System.out.println("FILENAME:" + theTempFile.getCanonicalPath());
    
    				//Temporary hack until MultiPartRequest class can be fixed to handle this logic
    				if (theTempFile.length() > maxFileSize)
    				{
    					theTempFile.delete();
    					throw new IOException("Maximum File size (" + maxFileSize + ") exceeded on upload");
    				}
    
    				// rename the file
    				String version = multi.getParameter("version");
    				String sub_version = multi.getParameter("subversion");
    
    				String build_name = "estimator_" + requestId + "_" + version + "-" + sub_version + ".xls";
    
    				File estimatorQuoteFolder = estimatorConfig.getEstimatorDir(requestId);
    				File newFile = new File(estimatorQuoteFolder, build_name);
    				newFile.delete();
    
    				theTempFile.renameTo(newFile);
    				//theTempFile.delete();
    
    
    				String userId = ic.getSessionDatum(Constants.SESSION_USER_ID).toString();
    				// get the values from excel sheet and insert into databases
    				File xml_file = estimatorConfig.getEstimatorExcelGet();
    				Diagnostics.debug2("Excel xml file location:" + xml_file.getCanonicalPath());
    				QuoteExcelHandler excel = new QuoteExcelHandler(new File(estimatorQuoteFolder, build_name));
    				excel.setRequestId(requestId);
    				excel.setVersion(version);
    				excel.setSubVersion(sub_version);
    				excel.setUserId(userId);
    				String quoteId = getQuoteId(conn, requestId);
    				excel.getValuesSetDatabase(xml_file, quoteId, conn);
    
    
    				ic.setHTMLTemplateName("enet/docs/upload_good.html");
    				conn.commit();
				}
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
	
	private boolean setUpdated(ConnectionWrapper conn, String requestId, String userId)
	{
		boolean result = true;
		try
		{
			conn.update(SET_UPDATED, new String[] {userId, requestId});
		}
		catch (SQLException e)
		{
			Diagnostics.error("Exception setting updated for request (" + requestId + "): ", e);
			result = false;
		}

		return result;
	}
	
	private String getQuoteId(ConnectionWrapper conn, String requestId)
	{
		String result = null;
		try
		{
			result = conn.selectFirst(SELECT_QUOTE_ID, requestId);
		}
		catch (SQLException e)
		{
			Diagnostics.error("Exception getQuoteId for request (" + requestId + "): ", e);
		}
		return result;
	}

	private boolean isSent(String requestId, ConnectionWrapper conn)
	{
		boolean result = true;
		
		try
		{
			result = conn.selectFirst(CHECK_IS_SENT, requestId) != null;
		}
		catch (SQLException e)
		{
			Diagnostics.error("Exception isSent for request (" + requestId + "): ", e);
		}
		
		return result;
	}
	
}
