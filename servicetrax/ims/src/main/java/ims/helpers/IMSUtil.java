/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.
 *
 * Copyright 2004,2005,2006, Dynamic Information Systems, LLC
 * $Header: IMSUtil.java, 8, 3/6/2006 3:46:54 PM, Blake Von Haden$
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */
package ims.helpers;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import dynamic.dbtk.InClause;
import dynamic.dbtk.connection.ConnectionWrapper;
import dynamic.dbtk.connection.QueryResults;
import dynamic.intraframe.engine.InvocationContext;
import dynamic.intraframe.handlers.ErrorHandler;
import dynamic.intraframe.handlers.SmartFormHandler;
import dynamic.intraframe.templates.components.SmartFormComponent;
import dynamic.util.diagnostics.Diagnostics;
import dynamic.util.mail.MailSender;
import dynamic.util.string.StringUtil;

/**
 * @version $Id: IMSUtil.java 1600 2009-05-06 20:41:20Z bvonhaden $
 */
public class IMSUtil
{
	public static int OBJECT_TYPE_JOB = 1;
	public static int OBJECT_TYPE_REQ = 2;
	public static int OBJECT_TYPE_PUNCHLIST_ISSUE = 3;

	public static final String PSTMT_TAG_START = "'<#?";
	public static final String PSTMT_TAG_END = "?#>'";
	public static final int PSTMT_TAG_SIZE = 4;

	public static final String PSTMT_TYPE_INT = "I";
	public static final String PSTMT_TYPE_STRING = "S";
	public static final String PSTMT_TYPE_FORCE_STRING = "F";
	public static final int PSTMT_TYPE_SIZE = 1;
	
	public static final String CUSTOMER_WITH_END_USER = "customer_with_end_user";
	public static final String CUSTOMER_WITHOUT_END_USER = "customer_without_end_user";	
	
	public static final String SELECT_USER_CUSTOMER
		= "SELECT uc.user_customer_id, uceu.customer_id end_user_id "
		+ "  FROM user_customers uc LEFT OUTER JOIN "
		+ "       user_customer_end_users uceu ON uc.user_customer_id = uceu.user_customer_id "
		+ " WHERE uc.user_id = ? ";
	
	public static final String INSERT_PROJECT
		= "INSERT INTO projects(project_no,"
		+ "                     project_type_id,"
		+ "                     project_status_type_id,"
		+ "                     customer_id,"
		+ "                     end_user_id,"
		+ "                     job_name,"
		+ "                     date_created,"
		+ "                     created_by) "
		+ " VALUES (?, ?, ?, ?, ?, ?, getdate(), ?)";

	public static final String NEXT_PROJECT_NO
		= "SELECT MIN(new_no) + 1 new_no "
		+ "  FROM (SELECT o.new_no "
		+ "          FROM (SELECT project_no new_no FROM projects "
		+ "               UNION "
		+ "                SELECT job_no new_no FROM jobs ) o "
		+ "                 WHERE NOT EXISTS (SELECT 'x' FROM projects i WHERE i.project_no=o.new_no + 1) "
		+ "                   AND NOT EXISTS (SELECT 'x' FROM jobs i2 WHERE i2.job_no=o.new_no + 1) "
		+ "                     created_by)) sub";

	public synchronized static String generateJobNo(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("IMSUtil.generateJobNo()");
		String job_no = null;
		boolean valid = false;

		CallableStatement cstmt = conn.prepareCall("{call getNextVal(?,?)}");
		cstmt.registerOutParameter(2, java.sql.Types.INTEGER);
		cstmt.setString(1, "job");
		cstmt.execute();
		job_no = String.valueOf(cstmt.getInt(2));

		boolean not_done = true;
		while (not_done)
		{
			if (job_no != null)
			{
				// found next job_no to test
				valid = IMSUtil.validateJobNo(ic, conn, job_no, false);

				if (valid)
				{
					not_done = false; // found good job no so exit loop
					// job_no = rs.getString(1);
					Diagnostics.debug2("generated new job number successfully = '" + job_no + "'");
				}
				else
				{
					Diagnostics.debug2("generated job number '" + job_no + "' is a duplicate, trying again...");
					cstmt.execute();
					job_no = String.valueOf(cstmt.getInt(2));
				}
			}
			else
			{
				// failed to generate a job number!
				SmartFormHandler.addSmartFormError(
								ic,
								"Error while attempting to generate new job number.  Stored Procedure 'getNextVal' failed to get next job number. Notify system admin.");
				ic.setTransientDatum("err@job_no", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG, "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG, "false");
				not_done = false; // exit loop so error can be sent to user
			}
		}

		cstmt.close();
		return job_no;
	}
	
	public synchronized static String generateProjectNo(InvocationContext ic, ConnectionWrapper conn) throws Exception
	{
		Diagnostics.trace("IMSUtil.generateProjectNo()");
		String result = null;

		QueryResults rs = conn.resultsQueryEx(NEXT_PROJECT_NO);
		if (rs.next()) 	{
			result = rs.getString("new_no");
		}
		
		return result;
	}
	
	static public boolean validateJobNo(InvocationContext ic, ConnectionWrapper conn, String jobNo, boolean showError) throws Exception
	{
		Diagnostics.trace("IMSUtil.validateJobNo()");
		boolean result = true;
		try
		{
			new Double(jobNo);
		}
		catch (Exception e)
		{
			SmartFormHandler.addSmartFormError(ic, "Invalid Job#.  Job# must be a number, it cannot contain characters.  Leave blank if you want to autogenerate.");
			ic.setTransientDatum("err@job_no", "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG, "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG, "false");
			result = false;
		}
		
		if (result)
		{// no error so continue
			// search for existing job_no
			String query = "SELECT job_id FROM jobs WHERE job_no = ?";
			QueryResults rs = conn.select(query, jobNo);

			if (rs.next())
			{
				result = false;
				if (showError)
				{
					Diagnostics.debug2("Found existing job_id='" + rs.getString(1) + "' where job_no = '" + jobNo + "'");
					SmartFormHandler.addSmartFormError(ic,
							"Job# has already been used. Please choose another Job# or leave blank to autogenerate.");
					ic.setTransientDatum("err@job_no", "false");
					ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG, "false");
				}
			}
			else
			{
				Diagnostics.debug2("Job No '" + jobNo + "' is valid.");
			}
			rs.close();
		}
		return result;
	}


	public static boolean validateProjectNo(InvocationContext ic, ConnectionWrapper conn, String projectNo, boolean showError) throws Exception {
		Diagnostics.trace("IMSUtil.validateProjectNo()");
		boolean result = true;
		try {
			new Double(projectNo);
		} catch (Exception e) {
			SmartFormHandler.addSmartFormError(ic, "Invalid Project#.  Project# must be a number, it cannot contain characters.  Leave blank if you want to autogenerate.");
			ic.setTransientDatum("err@project_no", "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FIELD_ERR_MSG, "false");
			ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG, "false");
			result = false;
		}

		if (result) {
			StringBuffer query = new StringBuffer();
			query.append("SELECT project_id FROM projects WHERE project_no=" + conn.toSQLString(projectNo));
			Diagnostics.debug3("project_no already exists? query= " + query.toString());
			QueryResults rs = conn.resultsQueryEx(query);

			if (rs.next() && showError) {
				Diagnostics.debug2("Found existing project_id='" + rs.getString(1) + "' where project_no = '" + projectNo + "'");
				SmartFormHandler.addSmartFormError(ic,
						"Project# has already been used. Please choose another Project# or leave blank to autogenerate.");
				ic.setTransientDatum("err@project_no", "false");
				ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG, "false");
				result = false;
			} else {
				query = new StringBuffer();
				query.append("SELECT job_id FROM jobs WHERE job_no=" + conn.toSQLString(projectNo));
				Diagnostics.debug3("job_no already exists? query= " + query.toString());	
				rs = conn.resultsQueryEx(query);
			
				if (rs.next() && showError) {
					Diagnostics.debug2("Found existing job_id='" + rs.getString(1) + "' where job_no = '" + projectNo + "'");
					SmartFormHandler.addSmartFormError(ic,
							"Job# has already been used. Please choose another Project# or leave blank to autogenerate.");
					ic.setTransientDatum("err@project_no", "false");
					ic.setTransientDatum(SmartFormComponent.MAND_FORM_ERR_MSG, "false");
					result = false;
				} else {
					Diagnostics.debug2("Project No '" + projectNo + "' is valid.");
				}
			}
			
			rs.close();
		}
		
		return result;
	}
	
	public static synchronized boolean createProject(InvocationContext ic, ConnectionWrapper conn, String endUserId) throws Exception {
		Diagnostics.trace("IMSUtil.createProject()");
		boolean result = false;
		PreparedStatement stmt = null;
		QueryResults rs = null;
		int insertedRows = 0;

		String projectTypeId = ic.getParameter("project_type_id");
		String projectNo = ic.getParameter("project_no");
		String customerId = ic.getParameter("customer_id");
		String jobName = StringUtil.toUpperCase(ic.getParameter("job_name"));
		
		if (StringUtil.hasAValue(jobName) && jobName.length() > 50) {
			jobName = jobName.substring(0, 50);
		}

		//determine project#
		if (StringUtil.hasAValue(projectNo))
		{//has job_no, so validate job_no, search for duplicates, and update quote if necessary
			result = IMSUtil.validateProjectNo(ic, conn, projectNo, true);
			
			if (!result) {
				return result;
			}
		}
		else
		{//missing job, autogenerate job_no, implicitely there is no quote if job_no is blank
			projectNo = IMSUtil.generateJobNo(ic, conn);
		}
		


		//get new projects status
		Map projectStatuses = MapUtil.getTypeMap(conn, "project_status_type");
		String projectStatusTypeId = (String) projectStatuses.get("folder_created");

		String logonUserId = (String) ic.getRequiredSessionDatum("user_id");
		
		try {
			stmt = conn.prepareStatement(INSERT_PROJECT);
			
			stmt.setString(1, projectNo);
			stmt.setString(2, projectTypeId);
			stmt.setString(3, projectStatusTypeId);
			stmt.setString(4, customerId);
			stmt.setString(5, endUserId);
			stmt.setString(6, jobName);
			stmt.setString(7, logonUserId);
			
			insertedRows = stmt.executeUpdate();
		} catch (Exception e) {
			Diagnostics.error("************Exception inserting project for (projectNo=" + projectNo 
								                                       + ", projectTypeId=" + projectTypeId
								                                       + ", projectStatusTypeId=" + projectStatusTypeId
								                                       + ", customerId=" + customerId 
								                                       + ", endUserId=" + endUserId
								                                       + ", jobName=" + jobName
								                                       + ", created_by=" + logonUserId + "): "
								                                       + e);	
			result = false;
		} finally {
			if (stmt != null) stmt.close();
		}

		if (insertedRows != 1) {
			Diagnostics.error("Failed to create project.");
			SmartFormHandler.addSmartFormError(ic, "Exception in IMSUtil.createProject(), failed to create Project record.");
			result = false;
		} else {//retrieve new project_id
			try {
				rs = conn.resultsQueryEx("SELECT @@IDENTITY");
				if (rs.next()) {
					Diagnostics.debug3("New project_id = '" + rs.getString(1) + "'");
					ic.setSessionDatum("project_id", rs.getString(1)); //need for application
					ic.setParameter("project_id", rs.getString(1)); //need for smartform to save request
					result = true;
				} else	{
					Diagnostics.error("Failed to retrieve new project_id, no rows returned from query.");
					SmartFormHandler.addSmartFormError(ic, "Exception in IMSUtil.createProject(), failed to create Project record.");
				}
			} catch (Exception e) {
				Diagnostics.error("Exception selecting project_id :" + e);
				result = false;
			} finally {
				if (rs != null) rs.close();
			}
		}

		return result;
	}

	public static boolean changeStatus(InvocationContext ic, ConnectionWrapper conn, String objectType, String newStatus,
			String[] object_ids) throws Exception
	{
		Diagnostics.trace("IMSUtil.changeStatus()");
		boolean result = true;
		String object_id = null;

		if (object_ids != null)

			object_id = StringUtil.arrayToString(object_ids, ',');

		if (!StringUtil.hasAValue(newStatus) || !StringUtil.hasAValue(objectType) || !StringUtil.hasAValue(object_id))
		{
			// missing data cannot update
			Diagnostics.error("StatusHandler.changeStatus() Missing data, must have new_status ('" + newStatus
					+ "'), object_type ('" + objectType + "'), and object_id ('" + object_id + "').");
			result = false;
		}
		else
		{
			// update object_type set objec_status = new_status where id_column
			// =
			// object_id

			String userID = ic.getParameter("user_id");
			String table = null;
			String idColumn = null;
			String statusColumn = null;
			Map statuses = null;
			String statusTypeID = null;
			boolean closeAllReqs = false;

			if (objectType.equalsIgnoreCase("job"))
			{
				table = "jobs";
				idColumn = "job_id";
				statusColumn = "job_status_type_id";
				// get status
				statuses = MapUtil.getTypeMap(conn, "job_status_type");
				statusTypeID = (String) statuses.get(newStatus);
				if (newStatus != null && newStatus.equalsIgnoreCase("closed"))
					closeAllReqs = true;
			}
			else if (objectType.equalsIgnoreCase("req"))
			{
				table = "services";
				idColumn = "service_id";
				statusColumn = "serv_status_type_id";
				// get status
				statuses = MapUtil.getTypeMap(conn, "service_status_type");
				statusTypeID = (String) statuses.get(newStatus);
			}
			else if (objectType.equalsIgnoreCase("punchlist_issue"))

			{
				table = "punchlist_issues";
				idColumn = "punchlist_issue_id";
				statusColumn = "status_id";
				// get status
				statuses = MapUtil.getTypeMap(conn, "punchlist_issue_status");
				statusTypeID = (String) statuses.get(newStatus);
			}
			else
			{
				Diagnostics.error("IMSUtil.changeStatus() Unhandled object_type '" + objectType
						+ "'.  Examples would be job, req, etc.");
				result = false;
			}

			if (statusTypeID == null)
			{
				Diagnostics.error("IMSUtil.changeStatus() Invalid new_status = '" + newStatus
						+ "', unable to update status for object_type = '" + objectType + "'");
				result = false;
			}

			if (result)
			{
				// found pieces of query so now perform the query
				InClause clause = new InClause(idColumn);
				clause.add(object_ids);

				StringBuffer query = new StringBuffer();
				query.append("UPDATE " + table);
				query.append(" SET " + statusColumn + "=" + conn.toSQLString(statusTypeID));
				query.append(" , modified_by = " + conn.toSQLString(userID));
				query.append(", date_modified = getDate()");
				query.append(" WHERE " + clause.getInClause());

				Diagnostics.debug2("Change Status query = " + query);

				int rows = conn.updateEx(query);

				if (rows < 1)
				{
					Diagnostics.error("Failed to update any rows.");
					result = false;
				}
				else
				{
					Diagnostics.debug2("Updated (" + rows + ") row(s) to status '" + newStatus + "' in table '" + table + "'");

					if (closeAllReqs)
					{

						String closedStatusID = (String) MapUtil.getTypeMap(conn, "service_status_type").get("closed");

						query = new StringBuffer();
						query.append("UPDATE services");
						query.append(" SET serv_status_type_id = " + closedStatusID);
						query.append(" WHERE " + clause.getInClause());

						conn.updateEx(query);
					}
					Diagnostics.debug2("Closed all reqs for job_id = '" + object_id + "'");
				}
			}
		}

		return result;
	}

	public static PreparedStatement queryToPreparedStatement(ConnectionWrapper conn, String query) throws SQLException
	{
		return queryToPreparedStatement(conn, new StringBuffer(query));
	}

	public static PreparedStatement queryToPreparedStatement(ConnectionWrapper conn, StringBuffer query) throws SQLException
	{
		Map params = new HashMap();
		String pStmtType;
		int bIdx;
		int eIdx;
		String value;
		for (int i = 1; query.indexOf(PSTMT_TAG_START) > 0; i++)
		{
			bIdx = query.indexOf(PSTMT_TAG_START);
			eIdx = query.indexOf(PSTMT_TAG_END);
			value = query.substring(bIdx + PSTMT_TAG_SIZE, eIdx);
			params.put(Integer.toString(i), value);
			query.replace(bIdx, eIdx + PSTMT_TAG_SIZE, "?");
		}

		PreparedStatement pstmt = conn.prepareStatement(query.toString());
		for (int i = 1; i <= params.size(); i++)
		{
			value = (String) params.get(Integer.toString(i));
			pStmtType = value.substring(0, PSTMT_TYPE_SIZE);
			String param = value.substring(PSTMT_TYPE_SIZE);

			if (pStmtType.equals(PSTMT_TYPE_INT))
			{
				if (param.length() > 0)
					pstmt.setInt(i, Integer.parseInt(param.trim()));
				else
					pstmt.setNull(i, java.sql.Types.INTEGER);
			}
			else if (pStmtType.equals(PSTMT_TYPE_STRING))
			{
                if (param.length() > 0)
				{
					pstmt.setString(i, param);
				}
				else
				{
					pstmt.setNull(i, java.sql.Types.VARCHAR);
				}
			}
			else if (pStmtType.equals(PSTMT_TYPE_FORCE_STRING))
			{
				if (param.length() > 0)
				{
					pstmt.setString(i, param);
				}
				else
				{
					pstmt.setNull(i, java.sql.Types.VARCHAR);
				}
			}
			else
			{
				// TODO: raise error
			}
			Diagnostics.debug("IMSUtil.queryToPreparedStatement() param" + i + ": " + param);
		}
		return pstmt;
	}

    /**
     * Format email subject line per CR #11
     */
    public static String formatEmailSubject(String customer_name, String job_name) {
        String subject = "";
        if(customer_name == null && job_name == null) {
            subject = "ServiceTRAX Alert";
        } else if(customer_name == null && job_name != null) {
            subject = "ServiceTRAX Alert for job " + job_name;
        } else if(customer_name != null && job_name == null) {
            subject = "ServiceTRAX Alert for customer " + customer_name;
        } else {
            subject = "ServiceTRAX Alert for " + customer_name + ", " + job_name;
        }
        return subject;
    }

	/**
	 * Tests to see if a string is composed of all digits, appearing to be an integer
	 * 
	 * @param testMe
	 *            The string to test
	 * @return
	 */
	public static boolean isInteger(String testMe)
	{
		if (testMe == null || testMe.length() == 0)
			return false;
		char[] chars = testMe.trim().toCharArray();
		for (int i = 0; i < chars.length; i++)
		{
			if (!Character.isDigit(chars[i]))
				return false;
		}
		return true;
	}
	
	/**
	 * Close a query result set.
	 * Also make certain the resultset has been fully iterated.
	 * 
	 * @param rs
	 * @throws SQLException 
	 */
	public static void closeQueryResultSet(QueryResults rs) throws SQLException
	{
		if (rs != null)
		{
			int i = 0;
			try
			{
    			while (rs.next())
    				i++;
				if (i > 10)
				{
					try
					{
						throw new Exception("Result set not fully iterated");
					}
					catch (Exception e)
					{
						Diagnostics.error("Bad query handling", e);
					}
				}
			}
			finally
			{
				rs.close();
			}
		}
	}
	
	/**
	 * Find the database isolation level.
	 * 
	 * @param conn
	 * @return
	 */
	public static String getTransactionIsolationLevel(ConnectionWrapper conn)
	{
		String val = null;
		QueryResults rs = null;
		try
		{
			rs = conn.select("DBCC USEROPTIONS");
			while (rs.next())
			{
				String setOption = rs.getString("Set Option");
				if ("isolation level".equals(setOption))
					val = rs.getString("Value");
			}
			rs.close();
		}
		catch (SQLException e)
		{
			Diagnostics.warning("Unable to get the isolation level", e);
		}
		finally
		{
			if (rs != null)
			{
				try
				{
					rs.close();
				}
				catch (SQLException ignore) {}
			}
		}

		return val;
	}
	
	public static Map getUserCustomer(ConnectionWrapper conn, InvocationContext ic, int userId) throws SQLException {
		Map<String,Set> result = new HashMap<String,Set>();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		Set<String> withEndUsers = new HashSet<String>();
		Set<String> withoutEndUsers = new HashSet<String>();
		
		try {
			
			stmt = conn.prepareStatement(SELECT_USER_CUSTOMER);
			stmt.setInt(1, userId);
			rs = stmt.executeQuery();
			
			while (rs.next()) {
				if (StringUtil.hasAValue(rs.getString("end_user_id"))) {
					withEndUsers.add(rs.getString("user_customer_id"));
				} else {
					withoutEndUsers.add(rs.getString("user_customer_id"));
				}
			}
			result.put(CUSTOMER_WITH_END_USER, withEndUsers);
			result.put(CUSTOMER_WITHOUT_END_USER, withoutEndUsers);
			
		} catch (Exception e) {
			ErrorHandler.handleException(ic, e, "Exception in IMSUtil.getUserCustomer()");
		} finally {
			if (stmt != null) stmt.close();
		}
		
		return result;
	}
	
	public static boolean sendEmail(String host, int port, String to, String from, String subject, String message) {
//		String recipients, String from, String subj, Date sentDate, String message
		boolean result = true;
		try {
			MailSender ms = new MailSender(to, from, subject, new java.util.Date(), message);
			ms.setServerInfo(host, port);
			ms.send();
		} catch ( Exception e) {
			 result = false;
		}
		return result;
	}
	
}