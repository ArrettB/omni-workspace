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
import ims.handlers.docs.DocumentDownloadHandler;
import ims.helpers.EstimatorConfig;

import java.io.File;
import java.sql.SQLException;

import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.util.diagnostics.Diagnostics;

/**
 * Estimator processes.
 *
 * @version $Id$
 */
public class QuoteDownloadHandler extends DocumentDownloadHandler
{

	public static final String HAS_QUOTE = "SELECT COUNT(*) cnt FROM quotes WHERE request_id = ?";

	public static final String SET_REQUEST_QUOTED
	= "UPDATE requests"
	+   " SET is_quoted = 'Y'"
	+       " ,date_modified = getDate()"
	+       " ,modified_by = ?"
	+ " WHERE request_id = ?";

	public static final String SET_QUOTE_SENT
	= "UPDATE quotes"
	+   " SET is_sent = 'Y'"
	+       " , date_quoted = getDate()"
	+       " , quoted_by_user_id = ?"
	+       " , date_modified = getDate()"
	+       " , modified_by = ?"
	+       " , quote_status_type_id = (SELECT l.lookup_id"
	+       " FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id"  
	+		" WHERE lt.code='quote_status_type' AND l.code='sent')"
	+ " WHERE request_id = ?";

	private EstimatorConfig estimatorConfig;

	public boolean handleEnvironment(InvocationContext ic)
	{
		Diagnostics.debug2("QuoteDownloadHandler.handleEnvironment()");
		boolean result = true;

		// get the parameters passed
		String requestId = ic.getParameter("requestid");
		String action = ic.getParameter("action");
		String estimate_id = ic.getParameter("estimator");
		String user_id = ic.getSessionDatum(Constants.SESSION_USER_ID).toString();
		String query = "";
		String create_file = "";
		File create_path = null;
		String version = "";
		String sub_version = "";

		Diagnostics.debug2("ESTIMATOR:START BUILDING PROCESS - 1");

		ConnectionWrapper conn = null;

		try
		{
			conn = (ConnectionWrapper)ic.getResource();
			conn.setAutoCommit(false);

			Diagnostics.debug2("ESTIMATOR:CREATE PATH:" + estimatorConfig.getEstimatorDir() + " - 2");

			create_path = estimatorConfig.getEstimatorDir(requestId);
			// check if the directory exists if it does not create it
			dynamic.util.file.FileUtil.directoryExists(create_path.getCanonicalPath(), true);
			Diagnostics.debug2("ESTIMATOR:DIRECTORY CHECK AND CREATE - 3");

			//create new quote
			if(action.compareTo("1")==0)
			{
				// get the version number
				version = ic.getParameter("version_no");

				// set the global variables
				String orgId = (String)ic.getSessionDatum("org_id");

				// create the file name
				create_file = "estimator_" + requestId + "_" + version + "-1.xls";

				// build the new xml file
				QuoteExcelHandler excel = new QuoteExcelHandler(new File(create_path, create_file));
				excel.setRequestId(requestId);
				excel.setFileTemplate(estimatorConfig.getExcelTemplate(orgId));

				String server = ic.getHttpServletRequest().getServerName() + ":" + ic.getHttpServletRequest().getServerPort() + ic.getSessionDatum("showPage").toString();
				excel.setProjectDir(server);
				excel.setDatabaseGetValues(estimatorConfig.getEstimatorExcelSet(), conn);

				if (!hasQuote(conn, requestId)) {
					// after document is created insert record into database
					query = "sp_estimator 6, " + requestId + ", " + user_id + ", " + version + ", 1, NULL, NULL";
					conn.updateEx(query);
				}
				result = setQuoted(conn, requestId, user_id);
			}
			// create new sub version
			else if(action.compareTo("2")==0)
			{
				// get the select version, sub version, and the next available sub_version
				query = "sp_estimator 3, NULL, " + estimate_id + ", NULL, NULL, NULL, NULL";
				QueryResults rs = null;
				String sub_version_new = null;
				boolean versionFound = false;
				try
				{
					rs = conn.resultsQueryEx(query);
					if (rs.next())
					{
						version = rs.getString("version");
						sub_version = rs.getString("sub_version");
						sub_version_new = rs.getString("next_sub_version");
						versionFound = true;
					}
				}
				finally
				{
					if (rs != null)
						rs.close();
				}

				if (versionFound)
				{
					// setup the file names for the new version
					File org_file = new File(create_path, "estimator_" + requestId + "_" + version + "-" + sub_version + ".xls");
					create_file = "estimator_" + requestId + "_" + version + "-" + sub_version_new + ".xls";
					File new_file = new File(create_path, create_file);

					// copy file
					dynamic.util.file.FileUtil.copyFile(org_file, new_file);

					// create a record for the new file in the database
					query = "sp_estimator 6, " + requestId + ", NULL, " + version + ", " + sub_version_new + ", NULL, NULL";
					conn.updateEx(query);
				}
			}
			// get existing version
			else if(action.compareTo("3")==0)
			{
				// get the version and sub version of the selected file.
				query = "sp_estimator 4, NULL, " + estimate_id + ", NULL, NULL, NULL, NULL";
				QueryResults rs = null;
				try
				{
					rs = conn.select(query);
					if (rs.next())
					{
						version = rs.getString("version");
						sub_version = rs.getString("sub_version");

						// build the file name for the link
						create_file = "estimator_" + requestId + "_" + version + "-" + sub_version + ".xls";
					}
					Diagnostics.debug2("SHOW FILE:" + create_file);
				}
				finally
				{
					if (rs != null) rs.close();
				}
			}
			// send the data from the
			else if(action.compareTo("4")==0)
			{
				result = setQuoteSent(conn, requestId, user_id);

				ic.setTransientDatum("record_id", estimate_id);
				ic.setTransientDatum("record_type_code", "quote");
				boolean email_result = ic.dispatchHandler("ims.handlers.proj.PDSEmailHandler");
				if (!email_result)
				{
					Diagnostics.error("PDSPostHandler.handleEnvironment() emailing failed.");
					ic.setTransientDatum("email_failed", "true");
				}

				ic.sendRedirect("/ims/action/setProjectDatum/enet/req/quote_request.html?request_id=" + requestId);
			}
			conn.commit();
		}
		catch(SQLException e)
		{
			Diagnostics.error("There was a sql error trying to build estimator tool. ", e);
			result = false;
			try { conn.rollback(); } catch (Exception ex) {} // Throw exception away
		}
		catch(Exception e)
		{
			Diagnostics.error("There was a error trying to build estimator tool. ", e);
			result = false;
			try { conn.rollback(); } catch (Exception ex) {} // Throw exception away
		}
		finally
		{
			// Close the connection to the database.
			try
			{
				if (conn != null)
				{
					conn.setAutoCommit(true);
					conn.release();
				}
			}
			catch (Exception e){}
		}


		try
		{
			File downloadFile = new File(estimatorConfig.getEstimatorDir(requestId), create_file);
			Diagnostics.debug2("File Location: " + downloadFile);
			returnFile(ic, downloadFile);
		}
		catch(Exception e)
		{
			Diagnostics.error("There was an error in downloading quote." + e);
			result = false;
		}
		return result;
	}

	/**
	 * Mark that the quote has been sent.
	 * 
	 * @param conn
	 * @param requestId
	 * @param userId
	 * @return
	 */
	private boolean setQuoted(ConnectionWrapper conn, String requestId, String userId)
	{
		boolean result = true;
		try
		{
			conn.update(SET_REQUEST_QUOTED, new String[] {userId, requestId});
		}
		catch (Exception e)
		{
			Diagnostics.debug2("Exception setting quoted for request (" + requestId + "): " + e);
			result = false;
		}

		return result;
	}

	/**
	 * Mark that the quote has been sent.
	 * 
	 * @param conn
	 * @param requestId
	 * @param userId
	 * @return
	 */
	private boolean setQuoteSent(ConnectionWrapper conn, String requestId, String userId)
	{
		boolean result = true;
		try
		{
			conn.update(SET_QUOTE_SENT, new String[] {userId, userId, requestId});
		}
		catch (Exception e)
		{
			Diagnostics.debug2("Exception setting quote sent for request (" + requestId + "): " + e);
			result = false;
		}

		return result;
	}

	private boolean hasQuote(ConnectionWrapper conn, String requestId) throws SQLException
	{
		boolean result = false;
		QueryResults rs = null;
		try
		{
			rs = conn.select(HAS_QUOTE, requestId);

			if (rs.next())
			{
				int quotes = rs.getInt("cnt");
				result = quotes == 0 ? false : true;
			}
		}
		catch (Exception e)
		{
			Diagnostics.error("Exception retrieving quote existence: ", e);
		}
		finally
		{
			if (rs != null)
				rs.close();
		}

		return result;
	}

	public void setUpHandler() throws Exception
	{
		estimatorConfig = new EstimatorConfig(getConfigDocument());
	}

	public void destroy()
	{

	}

}
