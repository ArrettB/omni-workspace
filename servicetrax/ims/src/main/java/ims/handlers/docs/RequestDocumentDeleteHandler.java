/*
 *                 Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC
 * $Revision: 119 $Date: 5/17/2005 10:13:25 AM$
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
import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.BaseHandler;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.util.diagnostics.Diagnostics;


/**
 * Delete a request document.
 *
 * @author bvonhaden
 *
 * @version $Header: RequestDocumentDeleteHandler.java, 1, 5/17/2005 10:13:25 AM, Blake Von Haden$
 */
public class RequestDocumentDeleteHandler extends BaseHandler
{
	public void setUpHandler() {}

	public void destroy() {}

	public boolean handleEnvironment(InvocationContext ic)
	{
		ConnectionWrapper conn = null;
		boolean result = true;

		try
		{
			Diagnostics.trace("RequestDocumentDeleteHandler.handleEnvironment()");
			conn = (ConnectionWrapper) ic.getResource();

			String reqDocID = ic.getParameter("request_document_id");
			String projectID = ic.getSessionDatum("request_id").toString();

			String where = " WHERE request_document_id = " + conn.toSQLString(reqDocID)
			             +   " AND request_id = " + conn.toSQLString(projectID);

			String query = "SELECT name"
			             +  " FROM request_documents" + where;

			String name = conn.queryEx(query);

			query = "DELETE FROM request_documents" + where;
			conn.setAutoCommit(false);

			int count = conn.updateEx(query);

			if (count > 0)
			{
				File file = new File((String) ic.getAppGlobalDatum("requestDocumentDir"));
				file = new File(file, projectID);
				file = new File(file, name);

				if (!file.delete())
					Diagnostics.warning("File " + file.getAbsolutePath() + " was not deleted.");
			}

			conn.commit();
		}
		catch (Exception e)
		{
			try
			{
				if (conn != null)
					conn.rollback();
			}
			catch (SQLException ignore) {}

			result = false;
			ErrorHandler.handleException(ic, e, "Exception in RequestDocumentDeleteHandler");
		}
		finally
		{
			if (conn != null)
			{
				try
				{
					conn.setAutoCommit(true);
				}
				catch (SQLException ignore) {}
				finally
				{
					conn.release();
				}
			}
		}

		return result;
	}
}
