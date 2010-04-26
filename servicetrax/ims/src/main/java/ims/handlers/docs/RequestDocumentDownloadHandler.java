/*
 *                 Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Revision: 837 $Date: 5/17/2005 10:13:25 AM$
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
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;


/**
 * Return the request document.
 *
 * @author bvonhaden
 *
 * @version $Header: RequestDocumentDownloadHandler.java, 1, 5/17/2005 10:13:25 AM, Blake Von Haden$
 */
public class RequestDocumentDownloadHandler extends DocumentDownloadHandler {
	
	public static final String SELECT
		= "SELECT request_id, name "
        + "  FROM request_documents "
        + " WHERE request_document_id = ?"; 
	
	public boolean handleEnvironment(InvocationContext ic) {
		ConnectionWrapper conn = null;
		boolean result = false;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try
		{
			Diagnostics.trace("RequestDocumentDownloadHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();
			String requestDocumentId = ic.getRequiredParameter("request_document_id");

			stmt = conn.prepareStatement(SELECT);
			stmt.setString(1, requestDocumentId);	
			rs = stmt.executeQuery();
			
			if (rs.next()) {
				String requestId = rs.getString("request_id");
				String name = rs.getString("name");
				
				String docDirPath = (String) ic.getRequiredAppGlobalDatum("requestDocumentDir");

				File documentDir = new File(docDirPath);
				File requestDir = new File(documentDir, requestId);

				File downloadFile = new File(requestDir, name);
				Diagnostics.debug("File to download is " + downloadFile);

				//ic.getHttpServletResponse().setHeader("HTTP_FILENAME", "foo.zip");
				//ic.getHttpServletResponse().setHeader("Content-Name", "foo.zip");
				returnFile(ic, downloadFile);
			}
			else
			{
				Diagnostics.error("Could not find a document for request_document_id = " + requestDocumentId);
			}
		}
		catch (Exception e)
		{
			result = false;
			ErrorHandler.handleException(ic, e, "Exception in RequestDocumentDownloadHandler");
		}
		finally
		{
			try {
				if (rs != null) rs.close();
				if (stmt != null) stmt.close();
			} catch (Exception e) {
				Diagnostics.trace("Exception closing resultSet/Statement" + e);
			} finally {
				if (conn != null) conn.release();
			}	
		}

		return result;
	}
}
